/**
 * Fetch unpaid 402 from ClimateAssured APIs and print decoded terms.
 * Does NOT send PAYMENT-SIGNATURE. Safe. $0.
 */
const BASE = process.env.API_BASE || "https://api.climateassured.com";

async function show(path, body) {
  const res = await fetch(`${BASE}${path}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  const json = await res.json().catch(() => ({}));
  const hdr = res.headers.get("PAYMENT-REQUIRED");
  console.log("\n===", path, "HTTP", res.status, "===");
  console.log("priceUsd:", json.priceUsd, "docs:", json.docs);
  const x = json.x402 || {};
  console.log("resource.url:", x.resource?.url);
  console.log("tags:", x.resource?.tags);
  console.log("amount:", x.accepts?.[0]?.amount, "network:", x.accepts?.[0]?.network);
  console.log("payTo:", x.accepts?.[0]?.payTo);
  console.log("bazaar:", Boolean(x.extensions?.bazaar));
  if (hdr) console.log("PAYMENT-REQUIRED header length:", hdr.length);
  if (res.status !== 402) {
    console.warn("Expected 402 unpaid; got", res.status);
  }
}

await show("/v1/coverage-check", {
  company: "Example Corp",
  us: "y",
  ex: "n",
  dom: "n",
  sales: "y",
  rev: "3",
});

await show("/v1/au/climate-disclosure-check", {
  company: "Example AU Pty Ltd",
  entity: "y",
  reporting: "y",
  threshold: "y",
});

console.log("\nDone. No payment sent.");
