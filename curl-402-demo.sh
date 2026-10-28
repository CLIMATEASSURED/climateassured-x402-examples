#!/usr/bin/env bash
# Unpaid 402 demo — does NOT send PAYMENT-SIGNATURE. Safe. $0.
set -euo pipefail
BASE="${API_BASE:-https://api.climateassured.com}"

echo "=== US coverage (expect HTTP 402) ==="
curl -sS -D - -o /tmp/ca-us-402.json \
  -X POST "$BASE/v1/coverage-check" \
  -H "Content-Type: application/json" \
  -d '{"company":"Example Corp","us":"y","ex":"n","dom":"n","sales":"y","rev":"3"}' \
  | head -n 20
echo
python3 - <<'PY'
import json
d=json.load(open("/tmp/ca-us-402.json"))
print("error:", d.get("error"))
print("priceUsd:", d.get("priceUsd"))
print("docs:", d.get("docs"))
x=d.get("x402") or {}
r=x.get("resource") or {}
print("serviceName:", r.get("serviceName"), "tags:", r.get("tags"))
print("accepts[0] amount:", (x.get("accepts") or [{}])[0].get("amount"), "payTo:", (x.get("accepts") or [{}])[0].get("payTo"))
print("has bazaar extension:", "bazaar" in (x.get("extensions") or {}))
PY

echo
echo "=== AU coverage (expect HTTP 402) ==="
curl -sS -o /tmp/ca-au-402.json -w "HTTP %{http_code}\n" \
  -X POST "$BASE/v1/au/climate-disclosure-check" \
  -H "Content-Type: application/json" \
  -d '{"company":"Example Mining Pty Ltd","inc":"y","c2m":"y","kind":"c","rev":"3","ast":"2","emp":"2","aum":"x","nger":"b","fye":"l"}' || true
python3 - <<'PY'
import json
try:
  d=json.load(open("/tmp/ca-au-402.json"))
  print("error:", d.get("error"), "priceUsd:", d.get("priceUsd"), "docs:", d.get("docs"))
except Exception as e:
  print("parse note:", e)
PY

echo
echo "Done. No payment was sent."
