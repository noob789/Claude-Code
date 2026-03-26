# Claude-Code

## Fix: Claude Code npm Install on NVIDIA Jetson

If you accidentally installed Claude Code on a Jetson device via `npm` instead of the native installer, follow these steps to fix it.

### The Problem

Claude Code has a native installer that bundles the correct binaries for your platform. Installing via `npm install -g @anthropic-ai/claude-code` on Jetson (ARM64/aarch64) bypasses this and can cause:

- A warning that Claude Code was installed via npm and not the native installer
- `EACCES` permission errors requiring `sudo` for every operation
- Native module errors or architecture mismatches

### Fix Steps

#### 1. Uninstall the npm version

If the original install used `sudo` (packages in `/usr/lib/node_modules`), you need `sudo` to remove it:

```bash
sudo npm uninstall -g @anthropic-ai/claude-code
```

#### 2. Clear the npm cache (optional)

```bash
sudo npm cache clean --force
```

#### 3. Install via the native installer

Use the official installer instead of npm:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

#### 4. Verify the installation

```bash
# Confirm claude is available
claude --version

# Confirm Node.js is native ARM64
node -p process.arch  # Should print "arm64"
```

### Troubleshooting

| Issue | Fix |
|---|---|
| `command not found: claude` after native install | Restart your terminal or run `source ~/.bashrc` |
| `EACCES` errors during npm uninstall | Use `sudo npm uninstall -g @anthropic-ai/claude-code` |
| `Syntax error: "(" unexpected` during install | Use `bash` not `sh`: `curl -fsSL https://claude.ai/install.sh \| bash` |
| Native installer fails | Ensure `curl` is installed: `sudo apt-get install -y curl` |
| Still seeing "installed via npm" warning | Make sure the npm version is fully removed: `which claude` should not point to a path under `/usr/lib/node_modules` |
