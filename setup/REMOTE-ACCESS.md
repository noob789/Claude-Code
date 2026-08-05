# Remote access to the Blade laptop (Ubuntu)

## Why nothing worked so far

Claude Code sessions started from the web/app run in **ephemeral cloud
containers at Anthropic** — not on any of your machines. Each session's
container is destroyed afterward, so anything "set up" inside one (SSH keys,
tunnels, installed tools) vanishes unless it's committed to this repo or
installed on the laptop itself. Nothing was ever installed on the laptop, so
there was nothing to connect to.

## The plan

Use [Tailscale](https://tailscale.com) — free for personal use, works behind
NAT/firewalls with zero port forwarding, and its **Tailscale SSH** feature
means no key management.

### Step 1 — on the laptop (one time, ~2 minutes)

```bash
sudo bash setup/blade-remote-setup.sh
```

It installs OpenSSH + Tailscale, enables Tailscale SSH, disables
suspend-on-lid-close while on AC, and prints the laptop's tailnet address.
The first run prints a login URL — open it and sign in to create/join your
tailnet.

### Step 2 — from your other devices (e.g. at work)

Install Tailscale on your work machine or phone, sign into the **same
account**, then:

```bash
ssh <your-ubuntu-username>@<laptop-tailscale-ip>
```

(or use the MagicDNS name, e.g. `ssh user@blade`.)

### Step 3 (optional) — let Claude cloud sessions reach the laptop

1. In the Tailscale admin console (login.tailscale.com → Settings → Keys),
   generate an **auth key** — mark it *Ephemeral* and *Reusable*.
2. In Claude Code on the web → your environment settings, add an environment
   variable `TS_AUTHKEY` with that key.
3. In a future session, ask Claude to connect; it can run Tailscale in
   userspace mode inside the container and SSH to the laptop:

   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
   tailscale up --authkey="$TS_AUTHKEY" --hostname=claude-session
   ssh -o ProxyCommand='nc -X 5 -x localhost:1055 %h %p' <user>@<laptop-ip>
   ```

   Each session joins the tailnet as a throwaway ephemeral node and is
   removed when it disconnects.

### Alternative: run Claude Code directly on the laptop

If the end goal is "Claude works on my laptop's files," the simplest path is
installing the Claude Code CLI on the Ubuntu side (`npm install -g
@anthropic-ai/claude-code` or the native installer) and running it there —
then no remote-access plumbing is needed at all. Combine with Step 2 and you
can SSH in from work and run `claude` on the laptop remotely.

## Requirements / gotchas

- The laptop must be **powered on, awake, and online**. The setup script
  handles lid-close suspend on AC power; if it runs on battery it will still
  suspend normally.
- If Ubuntu runs in WSL on that machine (Windows dual-boot vs WSL matters
  here), Tailscale should be installed in Windows instead, with WSL reached
  through it.
