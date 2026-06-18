#!/usr/bin/env bash
set -euo pipefail

echo "Form4Checker Vigolium audit placeholder"
echo "Dev/CI only. Do not run on real questionnaires or candidate documents."
echo "Use only source code and synthetic test data."

if ! command -v vigolium >/dev/null 2>&1; then
  echo "Vigolium CLI not found. Install it only on a developer/CI machine if approved."
  exit 0
fi

vigolium audit \
  --input src \
  --input rules \
  --input testdata/synthetic \
  --no-real-data

