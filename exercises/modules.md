# Some Ansible modules

|Category|Module|Description|
|---------------|------|-----------|
|Files modules|copy|Copy a local file to the managed host|
||file|Set permissions and other properties of files|
||lineinfile|Ensure a particular line is or is not in a file|
||synchronize|Synchronize content using rsync|
|Package modules|package|Autodetected package manager|
||yum|YUM package manager|
||apt|APT package manager|
||dnf|DNF package manager|
||gem|Manage Ruby gems|
||pip|Manage Python packages from PyPI|
|System modules|firewalld|Ports and services management|
||reboot|Reboot a machine|
||service|Manage services|
||user|Add, remove, and manage user accounts|
|Net Tools modules|get_url|Download files over HTTP, HTTPS, or FTP|
||nmcli|Manage networking|
||uri|Interact with web services|
