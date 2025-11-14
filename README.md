# NGROK Installation and Configuration Guide

> [Türkçe versiyon için tıklayın](README.tr.md) | **English**

Automatic ngrok installation script for Ubuntu and Termux environments.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [NGROK Configuration](#ngrok-configuration)
- [Usage Examples](#usage-examples)
- [Troubleshooting](#troubleshooting)
- [Advanced Configuration](#advanced-configuration)

## Features

- Automatic sudo detection (works on systems with or without sudo)
- Automatic architecture detection (amd64, arm64, arm, 386)
- Termux and Ubuntu support
- Smart installation directory selection
- Error handling and informative messages
- Cleanup and verification steps

## Requirements

### Ubuntu/Debian Systems
- Bash shell
- Internet connection
- (Optional) sudo access

### Termux
- Internet connection
- Termux app (Android)

## One-Line Automatic Installation

```bash
sudo apt install -y wget && wget -O - https://raw.githubusercontent.com/ozbilgic/install-ngrok-on-ubuntu-in-termux/main/ngrok-installer.sh | bash
```

## Manual Installation

### Step 1: Download the Script

```bash
# Using git (recommended)
git clone https://github.com/ozbilgic/install-ngrok-on-ubuntu-in-termux.git
cd install-ngrok-on-ubuntu-in-termux

# or using wget
wget https://raw.githubusercontent.com/ozbilgic/install-ngrok-on-ubuntu-in-termux/main/ngrok-installer.sh
chmod +x ngrok-installer.sh
```

### Step 2: Run the Script

```bash
bash ngrok-installer.sh
```

The script will automatically:
1. Detect your system architecture
2. Check for sudo requirements
3. Select the appropriate installation directory
4. Download and install ngrok
5. Verify the installation

### Installation Directories

The script selects the installation directory in the following order:

1. **Termux**: `$PREFIX/bin` (typically `/data/data/com.termux/files/usr/bin`)
2. **With sudo**: `/usr/local/bin`
3. **Without sudo**: `~/.local/bin`
4. **Fallback**: `~/bin`

## NGROK Configuration

### 1. Create an Account

To use ngrok, you need to create a free account:

1. Go to [ngrok.com/signup](https://dashboard.ngrok.com/signup)
2. Create an account (free)
3. Verify your email address

### 2. Get Your Authtoken

Get your authtoken from the dashboard:

```
https://dashboard.ngrok.com/get-started/your-authtoken
```

### 3. Configure Authtoken

Add your authtoken to ngrok:

```bash
ngrok config add-authtoken YOUR_AUTHTOKEN_HERE
```

Example:
```bash
ngrok config add-authtoken 2abc3def4ghi5jkl6mno7pqr8stu9vwx
```

This command saves the authtoken to:
- **Linux/Termux**: `~/.config/ngrok/ngrok.yml`
- **MacOS**: `~/Library/Application Support/ngrok/ngrok.yml`

### 4. Edit Configuration File

For advanced configuration, you can edit the `ngrok.yml` file:

```bash
# Check configuration file location
ngrok config check

# Edit the file
nano ~/.config/ngrok/ngrok.yml
```

Basic configuration example:

```yaml
version: "2"
authtoken: YOUR_AUTHTOKEN_HERE
region: us  # us, eu, ap, au, sa, jp, in
tunnels:
  web:
    proto: http
    addr: 8080
  ssh:
    proto: tcp
    addr: 22
```

## Usage Examples

### Basic HTTP Tunnel

Expose your local web server to the internet:

```bash
# For a server running on port 8080
ngrok http 8080

# For a React/Node.js server on port 3000
ngrok http 3000

# With HTTPS
ngrok http https://localhost:8080
```

### Custom Domain

```bash
ngrok http --domain=yoursubdomain.ngrok.io 8080
```

### TCP Tunnel

For SSH or other TCP services:

```bash
# For SSH
ngrok tcp 22

# For databases
ngrok tcp 5432  # PostgreSQL
ngrok tcp 3306  # MySQL
```

### Start Tunnel from Configuration File

```bash
# Start a defined tunnel
ngrok start web

# Start multiple tunnels simultaneously
ngrok start web ssh

# Start all tunnels
ngrok start --all
```

### Add Authentication

Add password protection to your tunnel:

```bash
ngrok http 8080 --basic-auth "username:password"
```

### IP Restriction

Allow access from specific IP addresses:

```bash
ngrok http 8080 --cidr-allow 192.168.1.0/24
```

### Request Inspection

Inspect requests with the web interface:
```
http://127.0.0.1:4040
```

## Troubleshooting

### ngrok command not found

Add to PATH:

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"

# Apply changes
source ~/.bashrc  # or source ~/.zshrc
```

### Authtoken error

Re-configure the authtoken:

```bash
ngrok config add-authtoken YOUR_NEW_TOKEN
```

### Connection error

1. Check your internet connection
2. Check firewall settings
3. Make sure ngrok is up to date:

```bash
ngrok update
```

### Port already in use

Use a different port or stop the existing service:

```bash
# Find which process is using the port
lsof -i :8080  # Linux/MacOS
netstat -ano | findstr :8080  # Windows

# Terminate the process
kill -9 PID
```

### Permission issues in Termux

Grant storage permission:

```bash
termux-setup-storage
```

## Advanced Configuration

### Region Selection

Reduce latency by selecting the nearest region:

```bash
ngrok config add-region eu  # Europe
ngrok config add-region us  # Americas
ngrok config add-region ap  # Asia-Pacific
ngrok config add-region au  # Australia
ngrok config add-region sa  # South America
ngrok config add-region jp  # Japan
ngrok config add-region in  # India
```

### Custom Configuration File

Use a different configuration file:

```bash
ngrok http 8080 --config=/path/to/custom-config.yml
```

### Logging

For detailed logs:

```bash
ngrok http 8080 --log=stdout --log-level=debug
```

### Reserved Domain (Paid)

Use custom subdomain with paid accounts:

```yaml
tunnels:
  myapp:
    proto: http
    addr: 8080
    subdomain: myapp  # accessible at myapp.ngrok.io
```

### TLS Certificate Verification

```bash
# Skip TLS verification (for development)
ngrok http https://localhost:8080 --verify=false
```

### Modify Request/Response Headers

```yaml
tunnels:
  myapp:
    proto: http
    addr: 8080
    request_header:
      add:
        - "X-Custom-Header: value"
      remove:
        - "X-Remove-This"
    response_header:
      add:
        - "X-Response-Header: value"
```

## Security Recommendations

1. **Don't Share Your Authtoken**: Never share your token in public places
2. **Use Authentication**: Use `--basic-auth` for sensitive applications
3. **IP Restriction**: Apply IP restrictions with `--cidr-allow` when possible
4. **Use HTTPS**: Always use HTTPS for production environments
5. **Close the Tunnel**: Close the tunnel when not in use (Ctrl+C)

## Useful Commands

```bash
# Check version
ngrok version

# View current status
ngrok api tunnels list

# Check configuration
ngrok config check

# Help
ngrok help

# Help for a specific command
ngrok http --help
```

## Resources

- [Official Documentation](https://ngrok.com/docs)
- [ngrok Dashboard](https://dashboard.ngrok.com)
- [API Reference](https://ngrok.com/docs/api)
- [Pricing](https://ngrok.com/pricing)

## License

This installation script is provided under the MIT license. ngrok has its own license terms.

## Contributing

Bug reports and pull requests are welcome.

---

**Note**: ngrok's free plan has some limitations:
- Limited number of connections
- Random subdomain (no custom subdomain)
- Limited region options

Consider paid plans for more features.
