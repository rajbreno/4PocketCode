<p align="center">
  <img src="logo.png" alt="$4 PocketCode" width="600">
</p>

# $4PocketCode

**Run AI coding agents (OpenCode, Claude Code, Gemini CLI) in just $4 entirely from your phone.**

**Why Cloud over Local?**
- **Enough Power** - 2 vCPU, 4GB RAM, 40GB SSD (way faster than phone)
- **Always On** - Server runs 24/7, keeps your dev environment ready
- **No Storage Worries** - Phone storage stays free
- **Private & Secure** - Tailscale VPN, no open ports

> Works with **OpenCode**, **Claude Code**, **Codex**, and **Gemini CLI**.  
> This guide uses [OpenCode](https://opencode.ai).

---

## What You Need

| App | Link | Purpose |
|-----|------|---------|
| **Termux** | [Play Store](https://play.google.com/store/apps/details?id=com.termux) | Terminal for SSH |
| **Tailscale** | [Play Store](https://play.google.com/store/apps/details?id=com.tailscale.ipn) | Secure VPN tunnel |
| **Acode** | [Play Store](https://play.google.com/store/apps/details?id=com.foxdebug.acodefree) | Code editor |
| **Hetzner** | [hetzner.cloud](https://hetzner.cloud/?ref=vou4fhxJ1W2D) | Server (~$4/month) |

> 💡 [Get €20 free credits from Hetzner](https://hetzner.cloud/?ref=vou4fhxJ1W2D) — *referral from [Dokploy docs](https://docs.dokploy.com/docs/core/installation), not mine - here to help you save!*

---

## 🚀 Complete Setup Guide

### Phase 1: Create Hetzner Server

1. Open **Chrome** → Go to [hetzner.cloud](https://hetzner.cloud/?ref=vou4fhxJ1W2D) (€20 free credits!)
2. Create account or login
3. Click **+ Add Server**

**Configure your server:**
| Setting | Value |
|---------|-------|
| Location | **Ashburn** (US) or **Falkenstein** (Germany) |
| Image | **Ubuntu 24.04** |
| Type | Shared vCPU → **CX22** |
| Networking | ✅ **Public IPv4** (required!) |
| SSH Keys | Skip for now |

4. Click **Create & Buy Now** (~$4/month)
5. Wait 1-2 minutes
6. Check your **email** for:
   - **IP Address** (like `123.45.67.89`)
   - **Root Password**

> ⚠️ **CRITICAL: SAVE YOUR PASSWORD!**  
> There is NO "forgot password" option for servers.  
> Screenshot it or save in a password manager immediately.

---

### Phase 2: Connect from Termux

**Open Termux and install SSH:**
```
pkg update && pkg install openssh -y
```

**Connect to your server:**
```
ssh root@YOUR_SERVER_IP
```
- Replace `YOUR_SERVER_IP` with IP from email (e.g., `ssh root@123.45.67.89`)
- Type `yes` when asked about fingerprint
- Paste password from email (it won't show as you type — that's normal)

✅ You're now on your server!

---

### Phase 3: Run Setup Script

> **Paste this single command:**

```
curl -sL https://raw.githubusercontent.com/rajbreno/4PocketCode/main/setup.sh | bash
```

**What it installs:**
- Docker, Git, Python, build tools
- Node.js (via NVM) + nodemon
- Tailscale VPN
- OpenCode AI

Wait ~5 minutes until you see "✅ Setup Complete!"

---

### Phase 4: Connect Tailscale VPN

**Still on server, run:**
```
tailscale up
```

A URL appears like:
```
https://login.tailscale.com/a/abc123...
```

1. **Long press** the URL → **Copy**
2. Open **Chrome** → Paste URL
3. **Login** with Google/GitHub/email
4. Click **Connect**

**Get your Tailscale IP:**
```
tailscale ip -4
```

You'll see something like `100.64.0.1` — **SAVE THIS!** This is your **Tailscale IP**.

> 💡 **Why Tailscale?**  
> Your Tailscale IP (100.x.x.x) creates a secure tunnel between your phone and server.  
> No one else can access it, even without a firewall.

---

### Phase 5: Setup Tailscale on Phone

1. Open **Tailscale app** on your phone
2. **Login with the SAME account** you just used
3. Toggle **Active** to ON
4. You should see your server listed

> ⚠️ **MUST use same account!** Different accounts = devices can't see each other.

---

### Phase 6: Connect from Termux

**Exit the server:**
```
exit
```

**Back in Termux (on phone), setup quick connect:**

#### Option A: Quick Connect (Recommended)

Create a shortcut so you only type `ssh dev`:
```
mkdir -p ~/.ssh && cat > ~/.ssh/config << EOF
Host dev
    HostName YOUR_TAILSCALE_IP
    User root
EOF
```
Replace `YOUR_TAILSCALE_IP` with your Tailscale IP (e.g., `100.64.0.1`).

**Connect:**
```
ssh dev
```

#### Option B: Manual (Use IP Directly)

If you prefer typing the full IP each time:
```
ssh root@YOUR_TAILSCALE_IP
```
Example: `ssh root@100.64.0.1`

✅ **Setup Complete!** You can now code from anywhere.

---

## 📱 Daily Workflow

### Starting Your Session

1. **Open Tailscale** → Make sure it says "Active"
2. **Open Termux** → Connect:
```
ssh dev
```

3. **Always use tmux** (keeps session alive even if Termux closes):
```
tmux new -s work
```
Returning later? Use: `tmux attach`

4. **Start coding:**
```
cd ~/projects
opencode
```

### Using Web Interface

```
opencode-web
```
Then open Chrome → `http://YOUR_TAILSCALE_IP:4096`

### When You're Done

**Turn off Tailscale** to save battery:
- Open Tailscale app → Toggle **Active** OFF

> 💡 Your server keeps running 24/7. Tailscale only needs to be ON when you want to connect from your phone.

---

## 📁 Edit Code with Acode

1. Open **Acode**
2. Tap **Files** (bottom bar) → **+** → **FTP/SFTP**
3. Fill in:

| Field | Value |
|-------|-------|
| Name | Dev Server |
| Protocol | **SFTP** |
| Host | Your Tailscale IP (`100.x.x.x`) |
| Port | 22 |
| User | root |
| Password | Your server password |
| Path | /root/projects |

4. Tap **Save** then **Connect**

✅ Now edit files on server directly!

---

## 🛠️ Creating Projects

**Make new project:**
```
cd ~/projects
mkdir my-app && cd my-app
npm init -y
```

**Preview your work:**

| Stack | Command | URL |
|-------|---------|-----|
| Static HTML | `npx serve` | http://TAILSCALE_IP:3000 |
| Vite / React | `npm run dev -- --host` | http://TAILSCALE_IP:5173 |
| Next.js | `npm run dev -- -H 0.0.0.0` | http://TAILSCALE_IP:3000 |
| Express | `nodemon server.js` | http://TAILSCALE_IP:3000 |

> Replace `TAILSCALE_IP` with your Tailscale IP (e.g., `100.64.0.1`)

---

## 💾 Saving to GitHub

**One-time SSH key setup:**
```
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519 && cat ~/.ssh/id_ed25519.pub
```
Copy the output → Add to [github.com/settings/keys](https://github.com/settings/keys)

**Push your project:**
```
cd ~/projects/my-app
git init
git add .
git commit -m "Initial commit"
git remote add origin git@github.com:YOUR_USERNAME/my-app.git
git push -u origin main
```

---

## 🔧 Troubleshooting

| Problem | Fix |
|---------|-----|
| `ssh dev` says "Connection refused" | Open Tailscale app → Toggle Active ON |
| Password not working | Use the password from email, not your Hetzner account password |
| Can't paste password in terminal | It's pasting, just not showing. Press Enter after pasting |
| `nvm: command not found` | Run: `source ~/.bashrc` then try again |
| Session lost after closing Termux | Use `tmux attach` to reconnect |
| "Address already in use" | Run: `pkill node` |
| Server not in Tailscale list | On server: `tailscale status` to check |

---

## 💰 Cost Breakdown

| Service | Cost |
|---------|------|
| Hetzner CX22 | ~$4/month |
| Tailscale | Free |
| Termux, Acode | Free |
| **Total** | **~$4/month** |

---

## 📋 Quick Reference

**Connect:**
```
ssh dev
```

**Start session:**
```
tmux attach || tmux new -s work
```

**Code:**
```
cd ~/projects/my-app && opencode
```

**Web UI:**
```
opencode-web
# Open: http://TAILSCALE_IP:4096
```

---

**Made with ❤️ for mobile developers who want real power.**
