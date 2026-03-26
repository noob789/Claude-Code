# Claude-Code

## Fix: Claude Code npm Install on NVIDIA Jetson

If you accidentally installed Claude Code on a Jetson device via `npm` and it's not working correctly, follow these steps to fix it.

### The Problem

Claude Code installed via `npm install -g @anthropic-ai/claude-code` on NVIDIA Jetson (ARM64/aarch64) can fail due to native binary dependencies that aren't pre-built for the Jetson's architecture. Symptoms include:

- Segfaults or crashes on launch
- Missing native module errors (e.g., `Error: ... not a valid ELF executable`)
- Architecture mismatch warnings during install

### Fix Steps

#### 1. Uninstall the broken installation

If the original install was done with `sudo` (or the packages live under `/usr/lib/node_modules`), you must use `sudo` to uninstall:

```bash
sudo npm uninstall -g @anthropic-ai/claude-code
```

#### 2. Clear the npm cache

Old/corrupted cached packages can cause repeated failures:

```bash
sudo npm cache clean --force
```

#### 3. Remove leftover Claude Code data (optional)

If the previous install left behind corrupted config or cache files:

```bash
rm -rf ~/.claude
```

#### 4. Verify your Node.js environment

Make sure Node.js is version 18 or higher and is the correct architecture:

```bash
node -v           # Must be >= 18.0.0
node -p process.arch  # Should print "arm64"
```

If `process.arch` does not print `arm64`, your Node.js binary is emulated (e.g., x86_64 under qemu). Reinstall a native ARM64 Node.js build:

```bash
# Example using NodeSource
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### 5. Reinstall Claude Code

```bash
sudo npm install -g @anthropic-ai/claude-code
```

### Troubleshooting

| Issue | Fix |
|---|---|
| `EACCES` permission errors | Use `sudo npm install -g` or fix npm prefix: `npm config set prefix ~/.npm-global` and add `~/.npm-global/bin` to your `PATH` |
| Build failures for native modules | Install build tools: `sudo apt-get install -y build-essential python3` |
| Still getting architecture errors | Ensure you're not running x86 Node via emulation; check with `file $(which node)` — it should say `aarch64` |
