from pathlib import Path
from datetime import datetime
import os, shutil, subprocess
if os.geteuid() != 0:
    raise SystemExit('Run with sudo.')
p = Path('/etc/sysctl.d/40-ipv6.conf')
q = Path('/etc/udev/rules.d/99-zram.rules')
a, b = p.read_text(), q.read_text()
new_a = ''.join(line for line in a.splitlines(keepends=True) if not (line.strip() == '...' or line.strip().startswith(('net.ipv6.conf.nic0.', 'net.ipv6.conf.nicN.'))))
new_b = b
if 'ATTR{initstate}' not in b:
    needle = 'KERNEL=="zram0", '
    if b.count(needle) != 1:
        raise SystemExit('Unexpected ZRAM rule; no files changed.')
    new_b = b.replace(needle, needle + 'ATTR{initstate}=="0", ', 1)
stamp = datetime.now().strftime('%Y%m%d-%H%M%S-%f')
for path, old, new in ((p, a, new_a), (q, b, new_b)):
    if old != new:
        backup = str(path) + '.bak-' + stamp
        shutil.copy2(path, backup)
        path.write_text(new)
        print('Updated:', path, '\nBackup:', backup)
subprocess.run(['udevadm', 'control', '--reload-rules'], check=True)
subprocess.run(['systemctl', 'restart', 'systemd-sysctl.service'], check=True)
subprocess.run(['systemctl', 'show', 'systemd-sysctl.service', '-p', 'Result', '-p', 'ExecMainStatus'], check=True)
print('Done. Active ZRAM swap was left running; the guard applies at next initialization.')
