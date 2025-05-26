# Enumeration & Scanner

```bash
#!/bin/bash

usage() {
  echo "Usage: $0 --host <target> --protocol <http|https>"
  exit 1
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -x|--host) TARGET="$2"; shift ;;
    -p|--protocol) PROTOCOL="$2"; shift ;;
    *) usage ;;
  esac
  shift
done

if [[ -z "$TARGET" || -z "$PROTOCOL" ]]; then
  usage
fi

FULL_URL="${PROTOCOL}://${TARGET}"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if command_exists nmap; then
  sudo nmap -sV -O -A --script=vuln "$TARGET"
fi

if command_exists nuclei; then
  nuclei -u "$FULL_URL"
fi

if command_exists dirsearch; then
  dirsearch -u "$FULL_URL"
fi

if command_exists nikto; then
  nikto -h "$TARGET"
fi
```
