#!/usr/bin/env bash

set -u

REPORT_DIR="reports"
REPORT_FILE="$REPORT_DIR/aws-audit-report.txt"

FULL_NAME="${FULL_NAME:-Sarah W AMADI}"

mkdir -p "$REPORT_DIR"

: > "$REPORT_FILE"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

checks=(
  "check_s3_public_access"
  "check_ssh_open_to_world"
  "check_mysql_open_to_world"
  "check_rds_public_access"
  "check_ebs_encryption"
)

log() {
  echo "$1" | tee -a "$REPORT_FILE"
}

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  log "PASS: $1"
}

warn() {
  WARN_COUNT=$((WARN_COUNT + 1))
  log "WARN: $1"
}

fail() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  log "FAIL: $1"
}

check_s3_public_access() {
  log ""
  log "CHECK: S3 Public Access"

  BUCKETS=$(aws s3api list-buckets \
    --query 'Buckets[].Name' \
    --output text)

  if [ -z "$BUCKETS" ]; then
    warn "No S3 buckets found."
    return
  fi

  local finding=0

  for bucket in $BUCKETS; do
    PUBLIC=$(aws s3api get-public-access-block \
      --bucket "$bucket" \
      --query '[PublicAcls,IgnorePublicAcls,BlockPublicPolicy,RestrictPublicBuckets]' \
      --output text 2>/dev/null || echo "NO_BLOCK")

    if [ "$PUBLIC" = "NO_BLOCK" ]; then
      warn "S3 bucket $bucket does not have a Public Access Block configuration."
      finding=1
    else
      log "S3 bucket $bucket: Public Access Block = $PUBLIC"
    fi
  done

  if [ "$finding" -eq 0 ]; then
    pass "S3 public-access checks completed."
  fi
}

check_ssh_open_to_world() {
  log ""
  log "CHECK: SSH Open to Internet"

  RESULT=$(aws ec2 describe-security-groups \
    --region us-east-1 \
    --group-ids sg-05ca0ce5910994592 \
    --query 'SecurityGroups[0].IpPermissions[?FromPort==`22` && ToPort==`22`].IpRanges[].CidrIp' \
    --output text)

  if echo "$RESULT" | grep -q "0.0.0.0/0"; then
    fail "SSH port 22 is open to 0.0.0.0/0."
  else
    pass "No SSH rule allowing 0.0.0.0/0 was detected."
  fi
}

check_mysql_open_to_world() {
  log ""
  log "CHECK: MySQL Open to Internet"

  RESULT=$(aws ec2 describe-security-groups \
    --query 'SecurityGroups[].IpPermissions[?FromPort==`3306` && ToPort==`3306`].IpRanges[].CidrIp' \
    --output text)

  if echo "$RESULT" | grep -q "0.0.0.0/0"; then
    fail "MySQL port 3306 is open to 0.0.0.0/0."
  else
    pass "No MySQL rule allowing 0.0.0.0/0 was detected."
  fi
}

check_rds_public_access() {
  log ""
  log "CHECK: RDS Public Accessibility"

  RESULT=$(aws rds describe-db-instances \
    --query 'DBInstances[].[DBInstanceIdentifier,PubliclyAccessible]' \
    --output text)

  if echo "$RESULT" | grep -q $'\tTrue\| True'; then
    warn "One or more RDS instances are publicly accessible."
    log "$RESULT"
  else
    pass "RDS instances are not publicly accessible."
  fi
}

check_ebs_encryption() {
  log ""
  log "CHECK: EBS Encryption"

  RESULT=$(aws ec2 describe-volumes \
    --query 'Volumes[].[VolumeId,Encrypted]' \
    --output text)

  if echo "$RESULT" | grep -q $'\tFalse\| False'; then
    warn "One or more EBS volumes are not encrypted."
    log "$RESULT"
  else
    pass "All discovered EBS volumes are encrypted."
  fi
}

log "========================================"
log "AWS SECURITY AND COST AUDIT"
log "========================================"
log "Auditor: $FULL_NAME"
log "Date: $(date)"
log ""

for check in "${checks[@]}"; do
  "$check"
done

log ""
log "========================================"
log "FINAL SUMMARY"
log "========================================"
log "PASS: $PASS_COUNT"
log "WARN: $WARN_COUNT"
log "FAIL: $FAIL_COUNT"

if [ "$FAIL_COUNT" -gt 0 ]; then
  log "OVERALL STATUS: FAIL"
  exit 2
elif [ "$WARN_COUNT" -gt 0 ]; then
  log "OVERALL STATUS: WARN"
  exit 1
else
  log "OVERALL STATUS: HEALTHY"
  exit 0
fi
