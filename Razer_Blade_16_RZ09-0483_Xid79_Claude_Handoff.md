# Razer Blade 16 RTX 4090 / Xid 79 — Claude Code handoff

Prepared: 2026-11-09 (America/Anchorage). Purpose: review evidence, complete supported firmware updates, then retest Ubuntu. No firmware, driver, or system settings were changed, and no workload was run while preparing this file.

## What needs to happen first

1. Confirm the exact laptop SKU/edition and record installed firmware and Ubuntu configuration.
2. Boot the existing **native Windows installation**. Resolve pending Windows/Optional Updates and reboots; confirm Windows is stable enough to flash safely.
3. Review and apply applicable official Razer packages, one at a time: **BIOS → EC → GPU vBIOS → PD → keyboard**. Verify each result after its required reboots.
4. Return to Ubuntu, verify firmware and GPU detection, then stop for review before starting a workload.
5. Recover the original failing test details and perform the controlled retest below. Preserve logs on the first recurrence.

This is the earlier plan's order, not a documented vendor dependency order. Current vendor prerequisites take precedence. Installed versions remain unconfirmed.

## Machine, symptom, and evidence quality

- User identifies the machine as **Razer Blade 16 (2023), RZ09-0483, NVIDIA GeForce RTX 4090 Laptop GPU**, with Ubuntu and an existing Windows installation.
- Reported Ubuntu failure: **NVIDIA Xid 79, “GPU has fallen off the bus.”** This means the driver cannot access the GPU over PCIe. Hardware/link failure and driver issues are possible; the code alone does not prove a dead GPU. See [NVIDIA's Xid catalog](https://docs.nvidia.com/deploy/xid-errors/analyzing-xid-catalog.html).
- Firmware updates are **not a documented cure for this case**; keyboard/PD updates are not established GPU fixes.

### What has already been tested or discussed

| Item | What the available history actually establishes |
| --- | --- |
| Ubuntu GPU workload | Prior plan refers to a test causing Xid 79. Command, runtime, telemetry, and raw log are unavailable. Reproduction is reported, not independently verified. |
| Windows Update | Prior assistant mentions an earlier Windows crash. Underlying user report, stop code, and logs are unavailable; cause/reproducibility unknown. |
| Windows VM inside Ubuntu | Discussed and rejected for firmware flashing; no completed VM test established. |
| Firmware updates | BIOS/EC/vBIOS/PD/keyboard updates were recommended. Completion and before/after versions are unconfirmed. |

**History limitation:** only the final five conversation turns were retrievable; the earlier attachment was unavailable. Recover original logs or ask the user before claiming that drivers, kernels, ASPM, GSP, power limits, GPU modes, thermals, or hardware have been ruled out.

Source conversation: “NVIDIA GPU crash issue,” ID `6a7e0a84-c0fc-83e8-9d8c-f608c320adea` ([open in ChatGPT](https://chatgpt.com/c/6a7e0a84-c0fc-83e8-9d8c-f608c320adea)).

## Firmware targets and official download pages

The following targets match Razer's indexed support listings checked on 2026-11-09. Recheck the live pages before downloading; download only through their official links.

| Order | Component | Target from current plan | Official source |
| --- | --- | --- | --- |
| 1 | BIOS | **2.05** | [BIOS updater, 14222](https://mysupport.razer.com/app/answers/detail/a_id/14222) |
| 2 | Embedded controller (EC) | **2.01** | [EC and keyboard, 14883](https://mysupport.razer.com/app/answers/detail/a_id/14883) |
| 3 | RTX 4090 GPU vBIOS | **95.03.2B.40.9E** (package listed as v3) | [GPU vBIOS updater, 9739](https://mysupport.razer.com/app/answers/detail/a_id/9739) |
| 4 | Power delivery (PD) | **PD_00.09v4** (index: 09v4) | [PD updater, 14681](https://mysupport.razer.com/app/answers/detail/a_id/14681) |
| 5 | Keyboard | **1.06.00** | [EC and keyboard, 14883](https://mysupport.razer.com/app/answers/detail/a_id/14883) |

Cross-check the [model firmware index, 9743](https://mysupport.razer.com/app/answers/detail/a_id/9743). Package and component versions differ. **Confirm edition/full SKU:** the [Lamborghini Edition](https://mysupport.razer.com/app/answers/detail/a_id/14667) shares RZ09-0483x branding but has different BIOS/EC targets. Do not add the panel hotfix without an applicable display issue and vendor guidance.

## Safety constraints and Windows execution

- Back up both operating systems' important data. Keep recovery media/access, encryption passphrases, and Windows recovery key **outside the laptop**; never put keys in this file/chat.
- Record BIOS settings affecting dual boot: boot order, Secure Boot, storage controller, and hybrid/dGPU mode. Do not clear TPM, reset Secure Boot keys, change storage mode, or reset all BIOS settings as a routine update step.
- Check BitLocker/device encryption. If active, temporarily **suspend protection**, then verify it resumes after updates; do not decrypt. Follow [Microsoft's guidance](https://learn.microsoft.com/en-us/troubleshoot/windows-client/windows-security/suspend-bitlocker-protection-non-Microsoft-updates). Investigate updater errors before considering other security changes.
- Use native Windows, the correct Razer AC adapter, reliable wall power, and a charged battery meeting updater requirements. Keep the laptop ventilated and lid open. **No VM, Wine, raw NVFlash, third-party ROM, forced downgrade, or bypass of model/version checks.**
- Windows: Settings → Windows Update → Check for updates; then Advanced options → Optional updates. Review applicable updates, finish installation, and reboot as requested. Do not start a flash with pending updates/restarts or run Windows Update concurrently with an updater.
- If Windows still crashes during updates/idle use, **stop before flashing**. Save Reliability Monitor/Event Viewer evidence and resolve stability or consult Razer.
- For each package: read its instructions, confirm model/current/target versions, run the official updater with administrator approval, and follow its prompts. Save the displayed result. Complete all requested restarts and return fully to Windows before the next package.
- During an active flash, do not unplug power, close the lid, sleep, force shutdown, or force restart. Temporary loss of input and multiple restarts can be normal. If apparently stuck, follow vendor support guidance rather than guessing an interruption timeout.
- An “already current” result is acceptable if it matches the applicable target. A newer installed version is a reason to review compatibility, not force a downgrade. If an updater fails, reports the wrong model, or reboots without changing an older version, stop and retain the error/result.

## Verification and update record

Before/after: use Windows `msinfo32` for model/SKU and BIOS version/date, and `nvidia-smi --query-gpu=name,driver_version,vbios_version --format=csv` for GPU/vBIOS. Obtain EC/PD/keyboard versions from BIOS/updater where exposed; otherwise save its success/current screen and mark independent verification unavailable. Do not trigger another flash just to inspect status.

| Component | Before | After | Result/evidence |
| --- | --- | --- | --- |
| BIOS | **2.02** (09/19/2023) | pending | Ubuntu `dmidecode -s bios-version`, 2026-11-09. Target 2.05, so an update is due. |
| EC | unknown | pending | Not exposed by `fwupdmgr get-devices` on Ubuntu. Read from BIOS setup or the Razer updater. |
| RTX 4090 vBIOS | **95.03.2B.00.35** | pending | `nvidia-smi` on Ubuntu, driver 595.99.02, 2026-11-09. Target 95.03.2B.40.9E, so an update is due. |
| PD | unknown | pending | Not exposed on Ubuntu. Read from the Razer PD updater. |
| Keyboard | unknown | pending | Not exposed on Ubuntu. Read from the Razer EC/keyboard updater. |

Ubuntu baseline captured 2026-11-09: Product `Blade 16 - RZ09-0483`, SKU `RZ09-0483UEJ4`, board version 9.04. fwupd lists the BIOS as an Internal SPI Controller at 2.02 with no LVFS update offered, and a USB4 host controller at 40.02. None of the Razer updaters are available through fwupd, so every flash in this plan happens from native Windows.

Also record Windows build, update failures, any Windows NVIDIA driver change, and any security/BIOS settings changed. Verify encryption protection is restored and both operating systems still boot. **An updater restart alone is not proof of success.**

## Next Ubuntu retest procedure

### 1. Capture a baseline before changing anything else

Collect before firmware updates if possible and on the first Ubuntu boot afterward. These read-only diagnostics run on the actual laptop and save a separate folder per run:

```bash
run_dir="$HOME/razer-xid79-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$run_dir"
date -Is > "$run_dir/time.txt"
cat /etc/os-release > "$run_dir/os.txt"
uname -a > "$run_dir/kernel.txt"
cat /proc/cmdline > "$run_dir/kernel-command-line.txt"
sudo dmidecode -t bios > "$run_dir/bios.txt"
timeout 15s nvidia-smi -q > "$run_dir/nvidia-smi.txt" 2>&1
lspci -nnk > "$run_dir/pci.txt"
sudo journalctl -k -b --no-pager > "$run_dir/kernel-boot.txt"
```

Record module type/settings (`modinfo nvidia`, relevant `/etc/modprobe.d/`), PRIME/GPU mode, display session, displays/docks, charger, power profile, clocks/limits, cooling, and ambient conditions. Preserve and document existing workarounds.

Confirm BIOS and vBIOS targets, NVIDIA driver loaded, GPU visible in `lspci` and `nvidia-smi`, and no fresh Xid/PCIe errors. If detection fails, stop; do not stress-test. Review the baseline and update record with the user before proceeding to load.

### 2. Retest one known workload with logging

1. Recover the **original failing command/app, version, input, settings, GPU selection, time to failure, and recovery method**, plus prior driver/kernel/workaround outcomes. If unavailable, agree on a replacement workload and label it a new test.
2. Keep kernel/driver, GPU mode, power settings, and peripherals constant; record unavoidable differences. Do not combine driver/ASPM/GSP changes with this firmware retest.
3. On AC power with clear vents, observe idle behavior for a few minutes. Then run a short 30–60 second trial of the selected workload. Watch GPU temperatures, utilization, power, and responsiveness. Stop on artifacts, abnormal temperatures relative to reported device limits, or fresh errors.
4. If healthy, run the same workload for its previously failing duration. Record elapsed time and outcome; if it passes, repeat once after a normal reboot. Avoid overnight/unattended or combined CPU+GPU torture tests.

In separate terminals, using the same `run_dir` value/folder, capture live evidence:

```bash
sudo journalctl -kf -o short-iso | tee "$run_dir/kernel-live.txt"
```

```bash
nvidia-smi --query-gpu=timestamp,name,temperature.gpu,utilization.gpu,power.draw,power.limit --format=csv -l 1 | tee "$run_dir/gpu-live.csv"
```

Unsupported telemetry may show `N/A`; record that. End the loggers with Ctrl+C after the workload. Record workload output/exit status separately and confirm it actually used the RTX 4090.

### 3. On failure or completion

- On the first Xid 79/black screen/GPU loss, stop the workload and preserve full kernel logs plus preceding PCIe/AER/NVRM messages. Do not repeatedly restart the workload or attempt live GPU resets/module unloading on the display GPU.
- If the machine remains responsive, save `journalctl -k -b` and bounded `nvidia-smi` output before a normal reboot. If installed, `sudo timeout 60s nvidia-bug-report.sh` can collect a report from the evidence folder; it may be incomplete after GPU loss. Review reports for private information before sharing.
- After a crash/reboot, try `sudo journalctl -k -b -1 --no-pager` and save it. Previous-boot logs depend on journal retention; missing logs are not proof that no error occurred. Record any forced power-off and the recovery result.
- A pass means the documented workload completed without new Xid/PCIe faults and the GPU remained accessible. A short pass is provisional; it does not establish a permanent fix.
- If Xid 79 recurs, assemble versions, reproduction, telemetry, and logs for Razer/NVIDIA support. Correlated native Windows failures would strengthen a platform/hardware hypothesis but are unconfirmed. Change one variable at a time in further experiments.

## Claude's first response / completion report

Review facts, missing history, exact SKU, and installed versions before guiding the next step. Report package results (updated/current/failed/unverified), changed settings, retest command/duration/outcome, logs, and uncertainty. Neither Xid 79 nor an updater success message alone establishes a diagnosis or repair.
