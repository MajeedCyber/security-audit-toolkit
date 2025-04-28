Security Audit Toolkit
A simple toolkit for port scanning on Linux and Windows systems.

Features
Port Scanner for Linux: Uses ss or netstat to scan for open ports.

Port Scanner for Windows: Uses PowerShell to scan for open ports.

Installation
Clone the repository:

git clone https://github.com/yourusername/security-audit-toolkit.git
cd security-audit-toolkit
Linux:

Make the script executable:

chmod +x linux/port_scanner.sh
Run the port scanner:

bash:
./linux/port_scanner.sh

Windows:

Open PowerShell in the windows folder.

Run the port scanner:

powershell
.\port_scanner.ps1

Port scan results are saved in the outputs/ folder.
