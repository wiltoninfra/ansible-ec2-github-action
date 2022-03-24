#!/usr/bin/env bash
#
#  Author		: Wilton Guilherme
#  Manteiner 	: CodeView Consultoria
#
#  Kube DevOps CI Tools
#  Copyright © 2021 CodeView Consultoria, All Rights Reserved
#

set -o errexit

AWS_REGION=$AWS_REGION
AWS_ACCESS_KEY=$AWS_ACCESS_KEY
AWS_SECRET_KEY=$AWS_SECRET_KEY
AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN


verify_files () {
    echo "🐧 Checking if auth files exist" >&2
    if [ ! -d /root/.aws ]
    then mkdir -p /root/.aws
    fi
}

aws_config () {
    echo "👍 Configure awscli auth " >&2
    sed -e "s;%AWS_REGION%;$AWS_REGION;g" /srv/aws-config.tmpl > /root/.aws/config
    sed -e "s;%AWS_ACCESS_KEY%;$AWS_ACCESS_KEY;g" -e "s;%AWS_SECRET_KEY%;$AWS_SECRET_KEY;g" -e "s;%AWS_SESSION_TOKEN%;$AWS_SESSION_TOKEN;g" /srv/aws-credentials.tmpl > /root/.aws/credentials
}

echo ''
verify_files
echo ''
aws_config
echo ''
echo "🚀 Authentication configured 🚀" >&2
echo ''