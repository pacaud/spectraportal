# Canada (BC) Sales Tax Defaults

This project assumes pricing and tax calculations use **Canada → British Columbia (BC)** by default.

## Defaults
- **Region:** Canada (CA), British Columbia (BC)
- **Currency:** **CAD ($)**
- **Tax model:** Canadian sales tax with **federal + provincial** components (e.g., GST + BC PST)
- **Rounding:** 2 decimal places (currency-style)

## Foreign currency handling
If a price is provided in a foreign currency, it should be **converted to CAD** before:
- comparisons,
- budgeting,
- totals,
- and any tax calculations.

### Supported conversions (default)
- **USD → CAD**
- **JPY (¥) → CAD**

### Display rule (recommended)
- Show the **CAD** amount as the primary value.
- Optionally show the original amount in parentheses with the exchange rate used, e.g.:
  - `CAD $123.45 (USD $89.00 @ 1.3876, 2026-02-14)`
  - `CAD $54.10 (JPY ¥5,800 @ 0.00933, 2026-02-14)`

## How to use this rule
When estimating or displaying prices:
1) Show **subtotal (pre-tax)** in CAD
2) Show **tax breakdown** (federal/provincial)
3) Show **total (after tax)** in CAD

## Notes / safety
- Sales tax rules can vary by item type (goods vs services, digital products, exemptions, etc.).
- If a specific workflow needs a different region, it must explicitly override this default.
- Always verify current tax rules/rates before final invoices (this file sets the *region*, not legal advice).
- Exchange rates change; record the **rate source + date** when converting.

## Machine-readable hint (optional)
tax_region: CA-BC
currency: CAD
tax_mode: GST_PST
rounding: 2dp
convert_usd_to_cad: true
convert_jpy_to_cad: true
