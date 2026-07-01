#!/usr/bin/env bash
# Mac storage scan — outputs JSON to stdout, saves snapshot to state dir.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:-/Users/$(whoami)}"
STATE_DIR="${MAC_CLEANUP_STATE_DIR:-$SCRIPT_DIR/../state}"
SNAPSHOT="$STATE_DIR/last-scan.json"
PREV_SNAPSHOT="$STATE_DIR/previous-scan.json"

mkdir -p "$STATE_DIR"
[[ -f "$SNAPSHOT" ]] && cp "$SNAPSHOT" "$PREV_SNAPSHOT"

export HOME_DIR STATE_DIR
python3 << 'PY'
import json, os, subprocess, datetime
from pathlib import Path

HOME = Path(os.environ["HOME_DIR"])
STATE = Path(os.environ["STATE_DIR"])
SNAPSHOT = STATE / "last-scan.json"

def du_human(path):
    try:
        r = subprocess.run(["du", "-sh", str(path)], capture_output=True, text=True, timeout=120)
        return r.stdout.split()[0] if r.stdout else "0"
    except Exception:
        return "0"

def du_kb(path):
    try:
        r = subprocess.run(["du", "-sk", str(path)], capture_output=True, text=True, timeout=120)
        return int(r.stdout.split()[0]) if r.stdout else 0
    except Exception:
        return 0

def du_map(directory, limit=None, min_kb=0):
    d = Path(directory)
    if not d.is_dir():
        return {}
    try:
        r = subprocess.run(["du", "-sk"] + [str(p) for p in d.iterdir() if p.exists()],
                           capture_output=True, text=True, timeout=300)
    except Exception:
        return {}
    items = []
    for line in r.stdout.strip().splitlines():
        parts = line.split("\t", 1)
        if len(parts) != 2:
            continue
        kb, path = int(parts[0]), parts[1]
        if kb < min_kb:
            continue
        items.append((kb, Path(path).name, path))
    items.sort(reverse=True)
    if limit:
        items = items[:limit]
    return {name: {"human": du_human(p), "kb": kb, "path": p} for kb, name, p in items}

def disk_stats():
    try:
        r = subprocess.run(["df", "-h", "/System/Volumes/Data"], capture_output=True, text=True)
        line = r.stdout.strip().splitlines()[-1]
    except Exception:
        r = subprocess.run(["df", "-h", "/"], capture_output=True, text=True)
        line = r.stdout.strip().splitlines()[-1]
    parts = line.split()
    cap = parts[4].rstrip("%") if len(parts) > 4 else "0"
    return {
        "free_human": parts[3] if len(parts) > 3 else "?",
        "used_human": parts[2] if len(parts) > 2 else "?",
        "total_human": parts[1] if len(parts) > 1 else "?",
        "capacity_pct": int(cap) if cap.isdigit() else 0,
    }

def home_dirs():
    names = ["Library", "lab", ".cursor", ".npm", ".cache", ".local", ".rustup", ".cargo", ".bun", ".expo", "Downloads"]
    out = {}
    for n in names:
        p = HOME / n
        if p.exists():
            out[n] = {"human": du_human(p), "kb": du_kb(p), "path": str(p)}
    return out

def build_artifacts():
    out = {}
    lab = HOME / "lab"
    if not lab.is_dir():
        return out
    for pattern in ("node_modules", ".next", "target", "dist", ".turbo"):
        for p in lab.rglob(pattern):
            if not p.is_dir():
                continue
            kb = du_kb(p)
            if kb < 10240:
                continue
            key = str(p.relative_to(HOME))
            out[key] = {"human": du_human(p), "kb": kb, "path": str(p), "type": pattern}
    return dict(sorted(out.items(), key=lambda x: -x[1]["kb"]))

def known_targets():
    rels = [
        "Library/Application Support/Claude/vm_bundles",
        "Library/Application Support/Cursor/User/globalStorage/state.vscdb",
        "Library/Developer/CoreSimulator",
        "Library/Containers/com.docker.docker",
        "Library/Containers/com.tinyspeck.slackmacgap",
        ".cache/puppeteer",
        ".expo",
        ".codeium",
        ".sdkman",
        ".linkedin-mcp/patchright-browsers",
    ]
    out = {}
    for rel in rels:
        p = HOME / rel
        if p.exists():
            out[rel] = {"human": du_human(p), "kb": du_kb(p), "path": str(p), "exists": True}
    return out

def cursor_extensions():
    ext = HOME / ".cursor/extensions"
    out = {}
    if not ext.is_dir():
        return out
    for p in ext.iterdir():
        if not p.is_dir():
            continue
        kb = du_kb(p)
        if kb < 51200:
            continue
        out[p.name] = {"human": du_human(p), "kb": kb, "path": str(p)}
    return dict(sorted(out.items(), key=lambda x: -x[1]["kb"]))

def homebrew():
    out = {"formulae_count": 0, "casks_count": 0, "leaves": []}
    try:
        out["formulae_count"] = len(subprocess.run(["brew", "list", "--formula"], capture_output=True, text=True).stdout.splitlines())
        out["casks_count"] = len(subprocess.run(["brew", "list", "--cask"], capture_output=True, text=True).stdout.splitlines())
        leaves = subprocess.run(["brew", "leaves"], capture_output=True, text=True).stdout.strip()
        out["leaves"] = [l for l in leaves.splitlines() if l]
    except Exception:
        pass
    return out

data = {
    "scanned_at": datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
    "disk": disk_stats(),
    "home_dirs": home_dirs(),
    "application_support": du_map(HOME / "Library/Application Support", limit=15),
    "caches": du_map(HOME / "Library/Caches", limit=10),
    "lab_projects": du_map(HOME / "lab", min_kb=1024),
    "build_artifacts": build_artifacts(),
    "cursor_extensions_large": cursor_extensions(),
    "known_targets": known_targets(),
    "homebrew": homebrew(),
}

text = json.dumps(data, indent=2)
SNAPSHOT.write_text(text)
print(text)
PY
