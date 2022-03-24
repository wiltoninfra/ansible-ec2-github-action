#!/usr/bin/env bash
set -e
set -o pipefail

sh /auth.sh

echo "👉 Executed command $@ <<<"
echo ""

echo "👉 Get secrets <<<"
aws secretsmanager get-secret-value --secret-id $_AWS_SECRET_MANAGER --query 'SecretString' --output text > /ansible/inventory/instance.pem
echo ""

echo "👉 Get list hosts <<<"
aws ec2 describe-instances --filters "Name=tag:$AWS_TAG_KEY,Values=$AWS_TAG_VALUE" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[][PrivateIpAddress]" --output text > /ansible/inventory/hosts
echo "👉 Hosts encontrados <<<"
cat /ansible/inventory/hosts

echo "👉 Start Command playbook <<<"
ANSIBLE_CONFIG=/ansible/ansible.cfg ansible-playbook /ansible/playbooks/playbook-$ANSIBLE_ROLE.yml -i /ansible/inventory/hosts

