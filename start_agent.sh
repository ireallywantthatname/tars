#!/bin/bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

: "${GROQ_API_KEY:?Set GROQ_API_KEY before launching the agent.}"

if ! ./venv/bin/python -c "import tkinter" >/dev/null 2>&1; then
  echo "The virtualenv is missing Tk support. Run ./setup.sh to rebuild it with /usr/bin/python3." >&2
  exit 1
fi

source venv/bin/activate
exec python agent.py
