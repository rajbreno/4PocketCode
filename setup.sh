#!/bin/bash
# $4 PocketCode Cloud Setup Script
# One command to setup AI coding agents on Hetzner

set -e

echo ""
echo "\$4 PocketCode Setup Starting..."
echo ""

# Step 1: Update System
echo "Updating system..."
apt update -y > /dev/null 2>&1
apt upgrade -y > /dev/null 2>&1

# Step 2: Install essentials (Docker, Tmux, Git, Python, Compilers)
echo "Installing essentials..."
apt install -y tmux git curl build-essential python3-pip unzip docker.io > /dev/null 2>&1

# Step 3: Install Tailscale VPN
echo "Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh 2>/dev/null | sh > /dev/null 2>&1

# Step 4: Install NVM (Node Version Manager)
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh 2>/dev/null | bash > /dev/null 2>&1

# Step 5: Activate NVM immediately (critical fix - won't work without this!)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Step 6: Install Node.js LTS and global tools
echo "Installing Node.js..."
nvm install --lts > /dev/null 2>&1
npm install -g nodemon > /dev/null 2>&1

# Step 7: Install OpenCode
echo "Installing OpenCode..."
curl -fsSL https://opencode.ai/install 2>/dev/null | bash > /dev/null 2>&1

# Step 8: Create projects folder
echo "Creating projects folder..."
mkdir -p ~/projects

# Step 9: Add aliases to bashrc
echo "Creating shortcuts..."
cat >> ~/.bashrc << 'EOF'

# $4 PocketCode aliases
alias opencode-web="opencode web --hostname 0.0.0.0 --port 4096"

# Load NVM on login
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF

# Step 10: Source bashrc
source ~/.bashrc

echo ""
echo "✅ Setup Complete!"
echo ""
echo "NEXT STEPS:"
echo ""
echo "1. Connect Tailscale VPN:"
echo "   tailscale up"
echo ""
echo "2. Login via the link that appears"
echo ""
echo "3. Get your Tailscale IP (save this!):"
echo "   tailscale ip -4"
echo ""
echo "4. On your phone: Install Tailscale app"
echo "   Login with the SAME account"
echo ""
echo "Then start coding:"
echo "   cd ~/projects && opencode"
echo ""
echo "Or web interface:"
echo "   opencode-web"
echo "   Open: http://<tailscale-ip>:4096"
echo ""
