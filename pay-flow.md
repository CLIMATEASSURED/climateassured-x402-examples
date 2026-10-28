# Conceptual paid flow (do not spend without owner OK)

This is documentation only. It does **not** run a payment.

1. **Unpaid request** → HTTP `402` + header `PAYMENT-REQUIRED` (Base64 JSON) and JSON body with `x402` terms (`accepts`, `resource`, `extensions.bazaar`).
2. **Buyer client** selects `accepts[0]` (exact USDC on Base / `eip155:8453`), signs a payment payload to `payTo`.
3. **Echo discovery** — copy `extensions.bazaar` and the full `resource` object into the payment payload (required for CDP / PayAI Bazaar indexing).
4. **Retry** same POST with header `PAYMENT-SIGNATURE` (Base64 of payment payload, or raw JSON per client).
5. **Success** → HTTP `200` + coverage/phase JSON + `PAYMENT-RESPONSE`. Facilitator name may appear in the paid response body.

## Suggested libraries (external)

- Coinbase CDP x402 buyer quickstart / `pay-for-service` skill  
- `@x402/core` + EVM exact scheme packages (x402 v2)  
- PayAI client docs: https://docs.payai.network/x402/clients/introduction  

## Cost

Exactly **$0.05 USDC** per successful paid call (+ tiny Base gas on the buyer). ClimateAssured receive wallet should show +$0.05.

## Smoke body (US)

```json
{
  "company": "Bazaar index smoke",
  "us": "y",
  "ex": "n",
  "dom": "n",
  "sales": "y",
  "rev": "3"
}
```
