# Homeland Regalia Dashboard — Setup Guide
**GitHub:** `DME77/homeland-regalia-dashboard`

---

## Part 1 — Run Locally (Live in Browser)

### Option A: Double-click (easiest)
1. Open the folder `Homeland ED tracker` on your Desktop
2. Double-click **`start.command`**
3. If macOS asks "Allow terminal to run", click Allow
4. The dashboard opens automatically at **http://localhost:8080**
5. To stop: press **Ctrl + C** in the Terminal window

### Option B: Terminal
```bash
cd "/Users/himanshuchaudhary/Desktop/Homeland ED tracker"
python3 -m http.server 8080
```
Then open http://localhost:8080 in your browser.

> **Why not just open index.html directly?**  
> Some browsers block cross-origin requests from `file://` URLs. Running a local
> server avoids this and mirrors exactly how the Vercel deployment will behave.

---

## Part 2 — Push to GitHub

### Step 1: Create the repository on GitHub
1. Go to https://github.com/new
2. Fill in:
   - **Repository name:** `homeland-regalia-dashboard`
   - **Visibility:** Private (recommended) or Public
   - **Do NOT** tick "Add README", "Add .gitignore", or "Choose a license" — the repo must be empty
3. Click **Create repository**

### Step 2: Push your code
Open Terminal and run these commands one by one:

```bash
cd "/Users/himanshuchaudhary/Desktop/Homeland ED tracker"

# Configure your identity (only needed once per machine)
git config user.email "dme@homelandgroup.org"
git config user.name "Vivek"

# Stage and commit the new start.command file
git add start.command DEPLOY.md
git commit -m "Add local server launcher and deployment guide"

# Push to GitHub (you'll be asked for your GitHub password/token)
git push -u origin main
```

> **GitHub now requires a Personal Access Token instead of your password.**  
> If prompted for a password, use a token instead:  
> → https://github.com/settings/tokens → Generate new token (classic) → tick `repo` → copy it → paste as the password.

---

## Part 3 — Deploy to Vercel (Public URL)

### Step 1: Import the project
1. Go to https://vercel.com/dashboard
2. Click **Add New → Project**
3. Under "Import Git Repository", find `DME77/homeland-regalia-dashboard` and click **Import**

### Step 2: Configure (takes 10 seconds)
| Setting | Value |
|---|---|
| Framework Preset | **Other** |
| Root Directory | `.` (leave as is) |
| Build Command | *(leave blank)* |
| Output Directory | *(leave blank)* |

4. Click **Deploy**

### Step 3: Get your public URL
Vercel builds in ~30 seconds and gives you a URL like:
```
https://homeland-regalia-dashboard.vercel.app
```
Share this link with anyone — they can view the dashboard without logging in.

### Step 4: Future updates (automatic)
Whenever you change `index.html` and push to GitHub:
```bash
cd "/Users/himanshuchaudhary/Desktop/Homeland ED tracker"
git add index.html
git commit -m "Update dashboard"
git push
```
Vercel automatically re-deploys within ~30 seconds. No manual steps needed.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `start.command` won't open | Right-click → Open → Open anyway (macOS Gatekeeper) |
| Browser shows CORS error on localhost | Use the local server (start.command), not file:// |
| GitHub push asks for password | Use a Personal Access Token, not your GitHub password |
| Vercel build fails | Check that the repo has `index.html` at the root — it does |
| Dashboard tab shows error | Make sure the Google Sheet is shared "Anyone with link → Viewer" |

---

## Your Google Sheets — Sharing Checklist

For each sheet in `FILES {}` in `index.html`, ensure it is shared:
- Open the sheet → Share → General access → **Anyone with the link** → **Viewer**

Sheets that are "Restricted" or "Organisation only" will fail to load on the public Vercel URL.
