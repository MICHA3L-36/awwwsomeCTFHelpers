#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <subnet/cidr>"
  exit 1
fi

SUBNET="$1"

# User prompt
echo "Scanning please wait…"

# Runs nmap; captures output to variable
NMAP_OUT=$(nmap -p 21,445 --open -n -oG - "$SUBNET" 2>/dev/null)

# Extracts IP lists
readarray -t FTP_IPS < <(awk '/Ports:/ && /21\/open/ { split($2,a,"/"); print a[1] }' <<<"$NMAP_OUT" | sort -u)
readarray -t SMB_IPS < <(awk '/Ports:/ && /445\/open/ { split($2,a,"/"); print a[1] }' <<<"$NMAP_OUT" | sort -u)

# Checks anonymous FTP
for ip in "${FTP_IPS[@]:-}"; do
  if curl --silent --list-only --connect-timeout 3 "ftp://anonymous:@${ip}/" >/dev/null 2>&1; then
    echo "FTP anonymous access found on ${ip}"
  fi
done

# Checks SMB null auth using smbclient -L //IP -N
for ip in "${SMB_IPS[@]:-}"; do
  out=$(smbclient -L "//$ip" -N 2>&1 || true)
  if echo "$out" | grep -qE 'Sharename|Disk|IPC\$' && ! echo "$out" | grep -q "NT_STATUS_ACCESS_DENIED"; then
    echo "SMB anonymous access found on ${ip}"
  fi
done

exit 0
