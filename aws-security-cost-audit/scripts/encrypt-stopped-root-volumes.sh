#!/usr/bin/env bash

set -Eeuo pipefail

REGION="us-east-1"

# Four remaining stopped EC2 instances.
# React App EC2 was already remediated separately.

declare -a INSTANCES=(
  "i-0f30cc26dba5a7308|vol-0dcb3b1853d59cc75|react-app-health check-AI"
  "i-039f878158ffe5acc|vol-03583961e8d90f4b9|Mini Finance Server"
  "i-01d84a8320712d7ff|vol-0003810778a2dbee8|epicbook-web-server"
  "i-02c31e0aeec668605|vol-06b74215faa6c1565|Ha-webserver1"
)

log() {
    echo
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

fail() {
    echo "ERROR: $1" >&2
    exit 1
}

process_instance() {

    local instance_id="$1"
    local old_volume="$2"
    local name="$3"

    log "PROCESSING: $name"

    echo "Instance:     $instance_id"
    echo "Old root:     $old_volume"

    # ---------------------------------------------------------
    # 1. Confirm instance is stopped
    # ---------------------------------------------------------

    state=$(aws ec2 describe-instances \
        --region "$REGION" \
        --instance-ids "$instance_id" \
        --query 'Reservations[0].Instances[0].State.Name' \
        --output text)

    if [[ "$state" != "stopped" ]]; then
        fail "$name is not stopped. Current state: $state"
    fi

    echo "Instance state: stopped"

    # ---------------------------------------------------------
    # 2. Confirm current root volume is unencrypted
    # ---------------------------------------------------------

    encrypted=$(aws ec2 describe-volumes \
        --region "$REGION" \
        --volume-ids "$old_volume" \
        --query 'Volumes[0].Encrypted' \
        --output text)

    if [[ "$encrypted" != "False" ]]; then
        fail "$old_volume is not unencrypted. Encryption state: $encrypted"
    fi

    echo "Original encryption: False"

    # ---------------------------------------------------------
    # 3. Create DIRECT snapshot of current root volume
    # ---------------------------------------------------------

    echo "Creating direct root-volume snapshot..."

    snapshot_id=$(aws ec2 create-snapshot \
        --region "$REGION" \
        --volume-id "$old_volume" \
        --description "DMI Assignment 7 direct root snapshot - $name" \
        --query 'SnapshotId' \
        --output text)

    echo "Direct snapshot: $snapshot_id"

    # ---------------------------------------------------------
    # 4. Wait for snapshot
    # ---------------------------------------------------------

    echo "Waiting for snapshot..."

    aws ec2 wait snapshot-completed \
        --region "$REGION" \
        --snapshot-ids "$snapshot_id"

    echo "Snapshot completed."

    # ---------------------------------------------------------
    # 5. Verify snapshot is the correct root snapshot
    # ---------------------------------------------------------

    snapshot_volume=$(aws ec2 describe-snapshots \
        --region "$REGION" \
        --snapshot-ids "$snapshot_id" \
        --query 'Snapshots[0].VolumeId' \
        --output text)

    if [[ "$snapshot_volume" != "$old_volume" ]]; then
        fail "Snapshot $snapshot_id does not belong to $old_volume"
    fi

    echo "Snapshot source verified: $old_volume"

    # ---------------------------------------------------------
    # 6. Verify EBS encryption by default
    # ---------------------------------------------------------

    default_encryption=$(aws ec2 get-ebs-encryption-by-default \
        --region "$REGION" \
        --query 'EbsEncryptionByDefault' \
        --output text)

    if [[ "$default_encryption" != "True" ]]; then
        fail "EBS encryption by default is not enabled."
    fi

    echo "EBS encryption by default: True"

    # ---------------------------------------------------------
    # 7. Start instance
    # ---------------------------------------------------------

    echo "Starting instance..."

    aws ec2 start-instances \
        --region "$REGION" \
        --instance-ids "$instance_id" \
        >/dev/null

    aws ec2 wait instance-running \
        --region "$REGION" \
        --instance-ids "$instance_id"

    echo "Instance is running."

    # ---------------------------------------------------------
    # 8. Replace root volume using DIRECT snapshot
    # ---------------------------------------------------------

    echo "Starting root-volume replacement..."

    task_id=$(aws ec2 create-replace-root-volume-task \
        --region "$REGION" \
        --instance-id "$instance_id" \
        --snapshot-id "$snapshot_id" \
        --no-delete-replaced-root-volume \
        --query 'ReplaceRootVolumeTask.ReplaceRootVolumeTaskId' \
        --output text)

    echo "Replacement task: $task_id"

    # ---------------------------------------------------------
    # 9. Wait for replacement
    # ---------------------------------------------------------

    while true; do

        task_state=$(aws ec2 describe-replace-root-volume-tasks \
            --region "$REGION" \
            --replace-root-volume-task-ids "$task_id" \
            --query 'ReplaceRootVolumeTasks[0].TaskState' \
            --output text)

        echo "Replacement state: $task_state"

        case "$task_state" in

            succeeded)
                echo "Root-volume replacement succeeded."
                break
                ;;

            failed|failed-detached)
                fail "Root-volume replacement failed for $name"
                ;;

            pending|in-progress|failing)
                sleep 15
                ;;

            *)
                fail "Unexpected replacement state: $task_state"
                ;;

        esac

    done

    # ---------------------------------------------------------
    # 10. Find the new root volume
    # ---------------------------------------------------------

    new_root=$(aws ec2 describe-instances \
        --region "$REGION" \
        --instance-ids "$instance_id" \
        --query 'Reservations[0].Instances[0].BlockDeviceMappings[?DeviceName==`/dev/sda1`].Ebs.VolumeId' \
        --output text)

    echo "New root volume: $new_root"

    # ---------------------------------------------------------
    # 11. Verify new root is encrypted
    # ---------------------------------------------------------

    new_encrypted=$(aws ec2 describe-volumes \
        --region "$REGION" \
        --volume-ids "$new_root" \
        --query 'Volumes[0].Encrypted' \
        --output text)

    if [[ "$new_encrypted" != "True" ]]; then
        fail "New root volume $new_root is NOT encrypted."
    fi

    echo "New root encryption: True"

    # ---------------------------------------------------------
    # 12. Verify instance health
    # ---------------------------------------------------------

    echo "Checking EC2 instance health..."

    sleep 20

    health=$(aws ec2 describe-instance-status \
        --region "$REGION" \
        --instance-ids "$instance_id" \
        --include-all-instances \
        --query 'InstanceStatuses[0].[InstanceState.Name,SystemStatus.Status,InstanceStatus.Status]' \
        --output text)

    echo "$health"

    # ---------------------------------------------------------
    # 13. Stop instance again
    # ---------------------------------------------------------

    echo "Stopping instance..."

    aws ec2 stop-instances \
        --region "$REGION" \
        --instance-ids "$instance_id" \
        >/dev/null

    aws ec2 wait instance-stopped \
        --region "$REGION" \
        --instance-ids "$instance_id"

    echo "Instance stopped."

    # ---------------------------------------------------------
    # 14. Final verification
    # ---------------------------------------------------------

    final_state=$(aws ec2 describe-instances \
        --region "$REGION" \
        --instance-ids "$instance_id" \
        --query 'Reservations[0].Instances[0].State.Name' \
        --output text)

    final_encrypted=$(aws ec2 describe-volumes \
        --region "$REGION" \
        --volume-ids "$new_root" \
        --query 'Volumes[0].Encrypted' \
        --output text)

    echo
    echo "RESULT"
    echo "----------------------------------------"
    echo "Instance:          $instance_id"
    echo "Name:              $name"
    echo "Old root:          $old_volume"
    echo "Direct snapshot:   $snapshot_id"
    echo "New root:          $new_root"
    echo "Encrypted:         $final_encrypted"
    echo "Final state:       $final_state"
    echo "Status:            SUCCESS"
    echo "----------------------------------------"

}

# ============================================================
# MAIN
# ============================================================

log "DMI ASSIGNMENT 7 - EBS ENCRYPTION REMEDIATION"

echo "Region: $REGION"
echo
echo "Four stopped EC2 instances will be processed."
echo
echo "The original root volumes will NOT be deleted."
echo
echo "The script will:"
echo "  1. Create a direct snapshot."
echo "  2. Start the instance."
echo "  3. Replace the root using the direct snapshot."
echo "  4. Verify encryption."
echo "  5. Stop the instance again."
echo

read -r -p "Type YES to continue: " confirmation

if [[ "$confirmation" != "YES" ]]; then
    echo "Cancelled."
    exit 0
fi

# ============================================================
# Process each instance sequentially
# ============================================================

for item in "${INSTANCES[@]}"; do

    IFS='|' read -r instance_id old_volume name <<< "$item"

    process_instance "$instance_id" "$old_volume" "$name"

done

log "ALL FOUR INSTANCES COMPLETED"

echo "The four stopped EC2 instances have been processed."
echo "Original root volumes were preserved."
echo
echo "Run the AWS audit again to verify the result."
