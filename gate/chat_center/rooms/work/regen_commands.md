# Devices — Regen Commands (sanitized)

These are copy/paste commands to refresh the device reports **without** leaking personal info.

## Windows (local) — save into this folder
Run in PowerShell from your desired folder:

```powershell
# Example folder
cd "C:\Users\kevin\OneDrive\Documents\projects"

# Quick + safe-ish snapshot (no serials)
Get-ComputerInfo | Select-Object \
  WindowsProductName, WindowsVersion, OsBuildNumber, \
  CsSystemType, CsTotalPhysicalMemory, CsProcessors \
| Out-File -Encoding utf8 .\laptop_specs_sanitized.txt

# GPU + disk (no serial)
Get-CimInstance Win32_VideoController | Select-Object Name, AdapterRAM, DriverVersion \
| Out-File -Encoding utf8 -Append .\laptop_specs_sanitized.txt

Get-PhysicalDisk | Select-Object FriendlyName, MediaType, Size, HealthStatus \
| Out-File -Encoding utf8 -Append .\laptop_specs_sanitized.txt
```

## Remote (Linux over SSH) — print sanitized snapshot
Run on your laptop (PowerShell). Replace the user/host and output filename.

```powershell
cd "C:\Users\kevin\OneDrive\Documents\projects"
$REMOTE = "user@100.x.x.x"   # replace
$OUT    = ".\digitalocean_specs_sanitized.txt"  # or vivi_node_specs_sanitized.txt

$script = @'
echo "SANITIZED REMOTE SPECS REPORT"
echo "Generated: $(date -Is 2>/dev/null || date)"
echo "Note: excludes hostname, usernames, serial numbers, MAC addresses, and IP addresses."
echo

echo "== OS =="
if [ -r /etc/os-release ]; then
  . /etc/os-release
  echo "Name: ${NAME:-unknown}"
  echo "Version: ${VERSION:-unknown}"
else
  echo "os-release not available"
fi
echo "Kernel: $(uname -r)"
echo "Arch: $(uname -m)"
echo

echo "== CPU =="
command -v lscpu >/dev/null 2>&1 && lscpu | egrep -i 'Model name:|CPU\(s\):|Socket\(s\):|Core\(s\) per socket:|Thread\(s\) per core:|CPU MHz:' | sed 's/^[ \t]*//' || echo "lscpu not available"
echo

echo "== Memory =="
command -v free >/dev/null 2>&1 && free -h || echo "free not available"
echo

echo "== Storage (no mount paths) =="
command -v lsblk >/dev/null 2>&1 && lsblk -o NAME,TYPE,SIZE,MODEL,ROTA | sed 's/[ \t]*$//' || echo "lsblk not available"
echo

echo "== GPU =="
command -v lspci >/dev/null 2>&1 && lspci | egrep -i 'vga|3d|display' | sed 's/^[0-9a-f:.]* //' || echo "lspci not available"
echo

echo "== Network (no MAC/IP) =="
command -v ip >/dev/null 2>&1 && ip -br link | awk '{print $1" "$2}' || echo "ip not available"
'@

$script | ssh $REMOTE 'bash -s' | Out-File -Encoding utf8 $OUT
notepad $OUT
```

## Remote (Windows over SSH)
If the SSH target is Windows, you should be able to run PowerShell remotely.
If you see:

- `bash: powershell: command not found`

…you are **not** landing in Windows. You are landing in a Linux shell (or WSL) — use the Linux script above.
