#!/usr/bin/env bash
set -euo pipefail

EC2_PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "INFO: Detected IP Address $EC2_PRIVATE_IP."

echo "INFO: Starting the Replicated Installer."
cd /opt/tfe-installer/
bash ./install.sh \
  no-proxy \
  private-address=$EC2_PRIVATE_IP \
  public-address=$EC2_PRIVATE_IP
  # disable-replicated-ui \

echo "INFO: Sleeping for a minute while TFE initializes..."
sleep 60

echo "INFO: Beginning to poll TFE health check endpoint."
while ! curl -ksfS --connect-timeout 5 https://$EC2_PRIVATE_IP/_health_check; do
  sleep 5
done
