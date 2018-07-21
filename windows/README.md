# Windows

## 0. Install fundamental Apps

- Install [Chrome](https://www.google.com/chrome/)

## 1. Install Bash on Windows

- To enable the "Windows Subsystem for Linux", open PowerShell as Administrator and run:

```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

- Restart your computer when prompted.
- Install [Ubuntu via Microsoft Store](https://www.microsoft.com/store/productId/9NBLGGH4MSV6)
- Launch it and run its initilization tasks.

See more detail here:
https://msdn.microsoft.com/en-us/commandline/wsl/install-win10

## 2. Install Hyper

- Install [Hyper via their website](https://hyper.is/#installation)
- Add a line below to "Preferences":

```json
shell: 'C:\\Windows\\System32\\bash.exe',
```

- Open another window, then you'll see Ubuntu there.

## 3. Setup Linux environment

Run [init.sh](init.sh) script on Hyper:

```bash
$ https://raw.githubusercontent.com/cognitom/personal-env/master/windows/init.sh | sh
```

## 4. VPN

Setup VPN. Then, change the Windows policy a little bit. Open PowerShell as Administrator and run:

```
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent /v AssumeUDPEncapsulationContextOnSendRule /t REG_DWORD /d 0x2 /f
```

Restart the Windows.

That's it!
