#!/bin/bash

# Script to install ngrok on Ubuntu/Termux
# Supports both sudo and non-sudo environments

set -e  # Exit on error

echo "================================================"
echo "  NGROK Installation Script"
echo "  For Ubuntu/Termux Environments"
echo "================================================"
echo ""

# Function to detect if sudo is available and needed
check_sudo() {
    if command -v sudo &> /dev/null && [ "$EUID" -ne 0 ]; then
        echo "[INFO] sudo detected - using sudo for package management"
        SUDO_CMD="sudo"
    else
        echo "[INFO] Running without sudo (root or Termux environment)"
        SUDO_CMD=""
    fi
}

# Function to detect architecture
detect_arch() {
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            NGROK_ARCH="amd64"
            ;;
        aarch64|arm64)
            NGROK_ARCH="arm64"
            ;;
        armv7l|armhf)
            NGROK_ARCH="arm"
            ;;
        i386|i686)
            NGROK_ARCH="386"
            ;;
        *)
            echo "[ERROR] Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac
    echo "[INFO] Detected architecture: $ARCH -> ngrok-$NGROK_ARCH"
}

# Function to detect install directory
detect_install_dir() {
    if [ -n "$PREFIX" ]; then
        # Termux environment
        INSTALL_DIR="$PREFIX/bin"
        echo "[INFO] Termux detected - installing to $INSTALL_DIR"
    elif [ -w "/usr/local/bin" ] || [ -n "$SUDO_CMD" ]; then
        INSTALL_DIR="/usr/local/bin"
        echo "[INFO] Installing to $INSTALL_DIR"
    elif [ -w "$HOME/.local/bin" ]; then
        INSTALL_DIR="$HOME/.local/bin"
        mkdir -p "$INSTALL_DIR"
        echo "[INFO] Installing to $INSTALL_DIR"
    else
        INSTALL_DIR="$HOME/bin"
        mkdir -p "$INSTALL_DIR"
        echo "[INFO] Installing to $INSTALL_DIR"
        echo "[WARN] Make sure $INSTALL_DIR is in your PATH"
    fi
}

# Main installation process
main() {
    echo "[1/6] Checking environment..."
    check_sudo
    detect_arch
    detect_install_dir

    echo ""
    echo "[2/6] Updating package lists..."
    if ! $SUDO_CMD apt update; then
        echo "[WARN] apt update failed, continuing anyway..."
    fi

    echo ""
    echo "[3/6] Installing dependencies..."
    if ! $SUDO_CMD apt install -y wget curl tar; then
        echo "[WARN] Some dependencies may not have installed correctly"
    fi

    echo ""
    echo "[4/6] Downloading ngrok..."
    NGROK_URL="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-${NGROK_ARCH}.tgz"
    echo "[INFO] Downloading from: $NGROK_URL"

    if [ -f "ngrok-v3-stable-linux-${NGROK_ARCH}.tgz" ]; then
        echo "[INFO] Removing old download..."
        rm -f "ngrok-v3-stable-linux-${NGROK_ARCH}.tgz"
    fi

    if ! wget "$NGROK_URL"; then
        echo "[ERROR] Failed to download ngrok"
        exit 1
    fi

    echo ""
    echo "[5/6] Extracting ngrok..."
    if ! tar -xvzf "ngrok-v3-stable-linux-${NGROK_ARCH}.tgz"; then
        echo "[ERROR] Failed to extract ngrok"
        exit 1
    fi

    echo ""
    echo "[6/6] Installing ngrok..."
    chmod +x ngrok

    if [ -n "$SUDO_CMD" ] && [ "$INSTALL_DIR" != "$HOME/.local/bin" ] && [ "$INSTALL_DIR" != "$HOME/bin" ]; then
        $SUDO_CMD mv ngrok "$INSTALL_DIR/"
    else
        mv ngrok "$INSTALL_DIR/"
    fi

    # Cleanup
    rm -f "ngrok-v3-stable-linux-${NGROK_ARCH}.tgz"

    echo ""
    echo "================================================"
    echo "  Installation Complete!"
    echo "================================================"
    echo ""
    echo "ngrok has been installed to: $INSTALL_DIR/ngrok"
    echo ""
    echo "Next steps:"
    echo "1. Sign up for a free account at: https://dashboard.ngrok.com/signup"
    echo "2. Get your authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken"
    echo "3. Configure ngrok with: ngrok config add-authtoken YOUR_TOKEN"
    echo "4. Test ngrok with: ngrok http 8080"
    echo ""
    echo "For more information, see README.md"
    echo ""

    # Verify installation
    if command -v ngrok &> /dev/null; then
        echo "[SUCCESS] ngrok is ready to use!"
        ngrok version
    else
        echo "[WARN] ngrok installed but not found in PATH"
        echo "[WARN] You may need to add $INSTALL_DIR to your PATH"
        echo "[WARN] Add this line to your ~/.bashrc or ~/.zshrc:"
        echo "       export PATH=\"$INSTALL_DIR:\$PATH\""
    fi
}

# Run main function
main
