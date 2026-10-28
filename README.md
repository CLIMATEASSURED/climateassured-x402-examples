# ClimateAssured x402 examples (local / draft)

Honest agent-paid climate coverage checks. **Informational only — not legal, tax, accounting, or assurance advice.** Always verify with the regulator (CARB / ASIC) and your advisors.

These files live on the ClimateAssured work box. They are **not** published to GitHub until the owner confirms (see [PUBLISH.md](./PUBLISH.md)).

## Live endpoints ($0.05 USDC on Base)

| Product | URL | Docs |
|---------|-----|------|
| US SB 253 / 261 coverage | `POST https://api.climateassured.com/v1/coverage-check` | https://climateassured.com/agent-api/ |
| AU AASB S2 / s292A coverage | `POST https://api.climateassured.com/v1/au/climate-disclosure-check` | https://climateassured.com/au/agent-api/ |
| AU phase calendar | `POST https://api.climateassured.com/v1/au/climate-disclosure-phase` | https://climateassured.com/au/agent-api/ |

Receive address (PAY_TO): `0x56E79118115920deB8310E8Cfaae460Ac650AA46`  
Free human checkers: https://climateassured.com/am-i-covered/ · https://climateassured.com/au/am-i-covered/

## What’s in this folder

| File | What it does | Spends USDC? |
|------|----------------|--------------|
| `curl-402-demo.sh` | Unpaid POSTs → shows HTTP **402** + payment terms | **No** |
| `pay-flow.md` | How a real x402 client pays and retries | Documents only |
| `package.json` + `show-402.mjs` | Tiny Node script that fetches a 402 and prints decoded terms | **No** |
| `PUBLISH.md` | What to confirm before pushing a public GitHub repo | — |

## Quick start (no payment)

```bash
cd examples
chmod +x curl-402-demo.sh
./curl-402-demo.sh
# or
node show-402.mjs
```

## Paying for real (do not run until owner OK)

Use any x402 v2 client (`@x402/*`, Coinbase CDP buyer skill, etc.) that:

1. POSTs JSON to an endpoint above  
2. Reads `PAYMENT-REQUIRED` / 402 body  
3. Signs exact USDC payment to PAY_TO on Base  
4. Retries with `PAYMENT-SIGNATURE`, **echoing `extensions.bazaar` and `resource`**

See `pay-flow.md`. Never use the ClimateAssured receive wallet as the buyer.
