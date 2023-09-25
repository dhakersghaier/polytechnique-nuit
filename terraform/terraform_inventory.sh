#!/bin/bash

# Check if SSH username credential is provided as an argument
SSH_USERNAME="ec2-user"

# Path to your SSH private key
SSH_PRIVATE_KEY_PATH="/home/dhaker/.ssh/vue-js-app.pem"

# Replace with the EC2 instance IP from Terraform output
EC2_INSTANCE_IP='34.238.155.108'

# Create the Ansible inventory file with SSH username and private key
cat << EOF > inventory.ini
[targets]
target ansible_host=${EC2_INSTANCE_IP} ansible_user=${SSH_USERNAME} ansible_ssh_private_key_file=${SSH_PRIVATE_KEY_PATH}
EOF
