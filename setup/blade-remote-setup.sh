#!/usr/bin/env bash
# One-time setup to make this Ubuntu machine reachable remotely (from your
# other devices and from Claude Code cloud sessions) via Tailscale.
#
# Run ON the Blade laptop's Ubuntu side:
#   curl -fsSL https://raw.githubusercontent.com/noob789/Claude-Code/claude/blade-laptop-ubuntu-remote-s634zb/setup/blade-remote-setup.sh | sudo bash
# or clone the repo and: sudo bash setup/blade-remote-setup.sh

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Please run with sudo: sudo bash $0" >&2
  exit 1
fi

echo "==> Installing OpenSSH server..."
apt-get update -qq
apt-get install -y -qq openssh-server curl
systemctl enable --now ssh

echo "==> Installing Tailscale..."
if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

echo "==> Bringing Tailscale up with Tailscale SSH enabled..."
# --ssh lets any device on your tailnet ssh in using tailnet identity,
# no key management needed. This prints a login URL the first time —
# open it and sign in (Google/GitHub/etc.) to attach this machine.
tailscale up --ssh

echo "==> Keeping the laptop awake while on AC power..."
# A laptop that suspends is unreachable. This stops suspend on lid close
# when plugged in (battery behavior unchanged).
mkdir -p /etc/systemd/logind.conf.d
cat > /etc/systemd/logind.conf.d/50-remote-access.conf <<'EOF'
[Login]
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF
systemctl restart systemd-logind || true

echo
echo "==> Done. This machine on your tailnet:"
tailscale status --self
echo
echo "Its Tailscale address:"
tailscale ip -4
echo
echo "From any other device signed into the same tailnet:"
echo "  ssh $(logname 2>/dev/null || echo YOUR_USER)@$(tailscale ip -4 | head -1)"
