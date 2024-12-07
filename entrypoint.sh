#!/bin/bash
# Function to verify whether configuration directories exist
check_config_dirs() {
    # Kubernetes config
    if [ -d "/config/.kube" ]; then
        cp -r /config/.kube/* ~/.kube/
    fi

    # Terraform config
    if [ -d "/config/.terraform.d" ]; then
        cp -r /config/.terraform.d/* ~/.terraform.d/
    fi

    # Ansible config
    if [ -d "/config/.ansible" ]; then
        cp -r /config/.ansible/* ~/.ansible/
    fi
}

# Run configuration check
check_config_dirs

# Run the command passed as argument
exec "$@"
