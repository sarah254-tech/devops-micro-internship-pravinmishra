# ==========================================
# AZURE SECURITY AUDIT
# DMI Cohort 3 - DevOps Micro Internship
# ==========================================

FULL_NAME="Sarah W AMADI"
RESOURCE_GROUP="bookreview-capstone-rg"

WARNINGS=0
FAILURES=0

echo "=========================================="
echo "AZURE SECURITY AUDIT"
echo "=========================================="
echo "Auditor: $FULL_NAME"
echo "Resource Group: $RESOURCE_GROUP"
echo "Date: $(date)"
echo

# ------------------------------------------
# CHECK 1: NSG PUBLIC SSH/RDP ACCESS
# ------------------------------------------

check_nsg() {
    echo "CHECK 1: NSG PUBLIC SSH/RDP ACCESS"
    echo "------------------------------------------"

    local findings
    findings=$(az network nsg list \
        --resource-group "$RESOURCE_GROUP" \
        --query "[].{NSG:name,Rules:securityRules}" \
        -o json)

    local exposed
    exposed=$(echo "$findings" | jq -r '
        .[] |
        .NSG as $nsg |
        .Rules[] |
        select(
            (.access == "Allow") and
            (.direction == "Inbound") and
            (.sourceAddressPrefix == "0.0.0.0/0") and
            (
                (.destinationPortRange == "22") or
                (.destinationPortRange == "3389")
            )
        ) |
        "\($nsg): \(.name) allows \(.destinationPortRange) from 0.0.0.0/0"
    ')

    if [ -n "$exposed" ]; then
        echo "FAIL: Public SSH/RDP access detected."
        echo "$exposed"
        ((FAILURES++))
    else
        echo "PASS: No SSH/RDP rule allowing 0.0.0.0/0 was detected."
    fi

    echo
}

# ------------------------------------------
# CHECK 2: STORAGE ACCOUNT PUBLIC ACCESS
# ------------------------------------------

check_storage() {
    echo "CHECK 2: STORAGE ACCOUNT PUBLIC BLOB ACCESS"
    echo "------------------------------------------"

    local accounts
    accounts=$(az storage account list \
        --resource-group "$RESOURCE_GROUP" \
        --query "[].name" \
        -o tsv)

    if [ -z "$accounts" ]; then
        echo "WARN: No Storage Account found in the resource group."
        ((WARNINGS++))
        echo
        return
    fi

    local finding=0

    while IFS= read -r account; do
        [ -z "$account" ] && continue

        local public_access
        public_access=$(az storage account show \
            --resource-group "$RESOURCE_GROUP" \
            --name "$account" \
            --query "allowBlobPublicAccess" \
            -o tsv)

        if [ "$public_access" = "true" ]; then
            echo "FAIL: $account allows public blob access."
            ((FAILURES++))
            finding=1
        else
            echo "PASS: $account does not allow public blob access."
        fi
    done <<< "$accounts"

    echo
}

# ------------------------------------------
# CHECK 3: VM OS DISK ENCRYPTION
# ------------------------------------------

check_vm_encryption() {
    echo "CHECK 3: VM OS DISK ENCRYPTION"
    echo "------------------------------------------"

    local vms
    vms=$(az vm list \
        --resource-group "$RESOURCE_GROUP" \
        --query "[].name" \
        -o tsv)

    if [ -z "$vms" ]; then
        echo "WARN: No VMs found."
        ((WARNINGS++))
        echo
        return
    fi

    while IFS= read -r vm; do
        [ -z "$vm" ] && continue

        local encryption
        encryption=$(az vm show \
            --resource-group "$RESOURCE_GROUP" \
            --name "$vm" \
            --query "storageProfile.osDisk.managedDisk.securityProfile.diskEncryptionSet.id" \
            -o tsv)

        if [ -n "$encryption" ] && [ "$encryption" != "None" ]; then
            echo "PASS: $vm has a Disk Encryption Set configured."
        else
            echo "WARN: $vm does not show a Disk Encryption Set."
            ((WARNINGS++))
        fi
    done <<< "$vms"

    echo
}

# ------------------------------------------
# CHECK 4: MYSQL PUBLIC NETWORK ACCESS
# ------------------------------------------

check_mysql() {
    echo "CHECK 4: MYSQL PUBLIC NETWORK ACCESS"
    echo "------------------------------------------"

    local servers
    servers=$(az mysql flexible-server list \
        --resource-group "$RESOURCE_GROUP" \
        --query "[].name" \
        -o tsv)

    if [ -z "$servers" ]; then
        echo "WARN: No Azure Database for MySQL server found."
        ((WARNINGS++))
        echo
        return
    fi

    while IFS= read -r server; do
        [ -z "$server" ] && continue

        local public_access
        public_access=$(az mysql flexible-server show \
            --resource-group "$RESOURCE_GROUP" \
            --name "$server" \
            --query "network.publicNetworkAccess" \
            -o tsv)

        if [ "$public_access" = "Disabled" ]; then
            echo "PASS: $server public network access is disabled."
        else
            echo "FAIL: $server public network access is $public_access."
            ((FAILURES++))
        fi
    done <<< "$servers"

    echo
}

# ==========================================
# RUN AUDIT
# ==========================================

check_nsg
check_storage
check_vm_encryption
check_mysql

# ==========================================
# SUMMARY
# ==========================================

echo "=========================================="
echo "AUDIT SUMMARY"
echo "=========================================="

if [ "$FAILURES" -gt 0 ]; then
    echo "RESULT: FAIL"
    echo "Failures: $FAILURES"
    echo "Warnings: $WARNINGS"
    exit 2
elif [ "$WARNINGS" -gt 0 ]; then
    echo "RESULT: WARN"
    echo "Failures: $FAILURES"
    echo "Warnings: $WARNINGS"
    exit 1
else
    echo "RESULT: PASS"
    echo "Failures: 0"
    echo "Warnings: 0"
    exit 0
fi
