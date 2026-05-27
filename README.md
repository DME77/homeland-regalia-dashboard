# Homeland Regalia — Public Dashboard

A single-file static site that pulls live construction status from your Google Sheets and renders the Homeland Regalia dashboard. Deploys to Vercel (or GitHub Pages, Netlify, Cloudflare Pages) in under 10 minutes.

## What's in this folder

- `index.html` — the entire dashboard. No build step, no dependencies.
- `vercel.json` — Vercel configuration (caching headers).
- `README.md` — this file.

## How the data flow works

Every tab in the dashboard calls `fetch(...)` against Google Sheets' public CSV export endpoint:

```
https://docs.google.com/spreadsheets/d/<FILE_ID>/export?format=csv&gid=<TAB_GID>
```

The fetched CSV is converted to a pipe-table format and fed into the existing parsers. No API key, no server, no auth — just Google's standard "share with anyone who has the link" mechanism.

## Setup — make each sheet shareable

For every Google Sheet referenced in `index.html` (the `FILES` map near the top), do this once:

1. Open the sheet in Google Sheets
2. Click **Share** (top-right)
3. Under **General access**, choose **Anyone with the link**
4. Set the role to **Viewer**
5. Click **Done**

Anything more restrictive (e.g. "Restricted" or "Anyone in your organization") will give a 401/403 when the public site tries to fetch it.

If a sheet has multiple tabs and you need data from more than the default tab, add the tab GIDs to `SHEET_TABS` in `index.html`. To find a tab's GID, click the tab in Google Sheets — the URL fragment becomes `#gid=NNNNNNN`.

## Deploy to Vercel

### Path A — via GitHub (recommended)

```bash
cd /path/to/this/folder
git init
git add .
git commit -m "Initial commit: Homeland Regalia public dashboard"
git branch -M main
# Replace YOURNAME/YOURREPO with your GitHub repo:
git remote add origin https://github.com/YOURNAME/YOURREPO.git
git push -u origin main
```

Then on vercel.com:

1. Click **Add New → Project**
2. Import the GitHub repo you just created
3. Framework Preset: **Other** (Vercel auto-detects a static site)
4. Build Command: leave blank
5. Output Directory: leave blank (Vercel will serve from the root)
6. Click **Deploy**

Vercel will give you a URL like `https://homeland-regalia.vercel.app`. Anyone with that link can view the dashboard.

### Path B — direct upload via Vercel CLI

```bash
npm install -g vercel
cd /path/to/this/folder
vercel
```

Follow the prompts. Vercel will create a project, deploy, and give you a URL.

## Updating the dashboard

Whenever someone edits a Google Sheet, the dashboard reflects it on the next page reload — no redeploy needed.

If you change `index.html` itself (e.g. tweak styling, change Done rules, add a new tab), commit and push to GitHub; Vercel auto-rebuilds and re-deploys within ~30 seconds.

## Caveats

- **The site is public.** Anyone with the URL can see the data. If you need access control, see the section below.
- **Multi-tab sheets** require manual GID configuration in `SHEET_TABS`.
- **The Billing/ACC tab** depends on a large multi-tab workbook (one tab per day). The public CSV endpoint can only fetch one tab at a time, so this tab will show the first tab of the ACC sheet only. If you need full month aggregation, list each day's GID in `SHEET_TABS` for the ACC file ID.
- **Facade items dynamic listing** (in Work Execution → Facade) requires Drive folder listing, which isn't available via the public CSV endpoint. The hard-coded `FACADE_FILES` list still works.
- **"Sheet last edited" timestamps** show a synthetic "now" because the metadata endpoint isn't public. Cosmetic only.

## Adding password protection later

If you decide later that the site should require a login:

- **Vercel Password Protection** (Pro plan, ~$20/user/mo): Project Settings → General → Password Protection.
- **Cloudflare Access** (free for ≤50 users): put the Vercel URL behind a Cloudflare zone, add an Access Policy.
- **Basic Auth via Vercel Edge Middleware**: I can add a `middleware.js` if you want a simple username/password gate.

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| "HTTP 401" / "HTTP 403" in console | Sheet not shared "Anyone with link → Viewer" |
| Tab loads but shows "0 rows parsed" | Sheet header changed; check the parser's expected header regex |
| Watcon tab empty | Verify the PLANNER HLR sheet has both COMMON AREAS and WATCON tabs shared, and the WATCON GID in `SHEET_TABS` matches the URL fragment |
| Browser shows CORS error | Should not happen with public CSV; if it does, confirm the sheet is shared correctly |
