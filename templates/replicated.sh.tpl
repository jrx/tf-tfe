#!/usr/bin/env bash
set -euo pipefail
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "INFO: Generating /etc/replicated.conf file."
cat <<EOF > /etc/replicated.conf
{
    "DaemonAuthenticationType":     "password",
    "DaemonAuthenticationPassword": "${tfe_admin_password}",
    "TlsBootstrapType":             "self-signed",
    "TlsBootstrapHostname":         "${tfe_hostname}",
    "BypassPreflightChecks":        true,
    "ReleaseSequence":              ${tfe_release_sequence},
    "ImportSettingsFrom":           "/opt/tfe-installer/settings.conf",
    "LicenseFileLocation":          "/opt/tfe-installer/license.rli"
}
EOF
