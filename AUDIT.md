# Master Audit Memo — Crypto Litigation Dataset

**Prepared for:** Brandon Ferrick & Shah  
**Date:** March 17, 2026  
**Auditor:** Momo (AI-assisted multi-agent pipeline)  
**Scope:** 938 adversarial cases in the crypto litigation dataset  
**Sources:** External Validation Report (March 16, 2026), SEC.gov, DOJ.gov, CFTC.gov, FinCEN.gov, OFAC.gov, CourtListener, Justia, Reuters, CoinDesk

---

## Executive Summary

A comprehensive audit of the 938-case adversarial crypto litigation dataset identified **~160 cases (17%) with at least one substantive error**, concentrated in two systemic issues:

1. **The `penalty_amount` field is fundamentally unreliable.** It conflates four distinct monetary concepts — actual fines, criminal forfeiture, restitution, and alleged scheme amounts — inflating apparent enforcement totals by an estimated **$16+ billion.**

2. **The `outcome` field is stale.** 42+ cases resolved between 2021–2025 still show "ongoing," understating enforcement success rates.

The dataset's case identification is strong (96.6% verification rate per the external validation report), and the Howey test analysis is robust (94.7% accuracy). The structural issues are fixable.

---

## Key Findings

### 1. Phantom Penalties: ~$3.96B in Non-Existent Penalties

**45 cases** have `penalty_amount` populated with alleged scheme amounts, not actual imposed penalties. These are amounts from DOJ press release headlines ("$300 million fraud scheme") copied into the penalty field before any judgment was entered.

**Worst offenders:**
| Case | Recorded Penalty | Actual | Overcounting |
|------|-----------------|--------|-------------|
| U.S. v. Goettsche (BitClub) | $722M | $0 (no sentencing) | $722M |
| U.S. v. Sungatov (LockBit) | $500M | $0 (ongoing) | $500M |
| U.S. v. Okhotnikov (Forsage DOJ) | $340M | $0 (ongoing) | $340M |
| SEC v. Sanchez (CryptoFX) | $300M | ~$68K | $300M |
| SEC v. Okhotnikov (Forsage SEC) | $300M | undetermined | ~$300M |
| SEC v. Braga (Trade Coin Club) | $295M | $0 (ongoing) | $295M |
| U.S. v. Chen (USFIA) | $147M | $1.9M | $145M |
| SEC v. Eisenberg (Mango) | $116M | $0 (vacated) | $116M |
| U.S. v. Eisenberg (DOJ) | $110M | $0 (vacated) | $110M |
| SEC v. Arbitrade | $43.6M | $0 (ongoing) | $43.6M |

**Detection heuristic:** `penalty_amount == alleged_amount` was a 100% error signal across all tested cases.

### 2. Forfeiture/Restitution Mislabeled: ~$12.1B

**27 DOJ cases** have criminal forfeiture or restitution orders recorded as "penalties." These are real monetary outcomes but not "penalties" in the regulatory/civil sense. The largest:
- U.S. v. SBF: $11B (criminal forfeiture)
- U.S. v. Yosef/Fowler: $740M (forfeiture)
- U.S. v. Sterlingov: $395.5M (forfeiture)
- U.S. v. Scott (OneCoin): $400M (forfeiture)

**This is a methodological decision for the paper authors** — whether to count criminal forfeiture as "enforcement penalties" or distinguish them.

### 3. DOJ Penalty Field: 89% Wrong

Of 63 DOJ cases with penalty amounts, **only 7 (11%) are verified actual fines.** The rest are alleged amounts (27) or forfeiture/restitution (27). DOJ recorded penalties drop from **~$14.45B → ~$653M** when corrected.

This **inverts the paper's enforcement ranking.** CFTC ($7.1B+ confirmed) and SEC ($4.5B+) are the dominant enforcers by verified penalty amount, not DOJ.

### 4. Outcome Staleness: 42+ Cases

Cases resolved between 2021–2025 still show `outcome = 'ongoing'`. Examples:
- U.S. v. Budovsky (Liberty Reserve): sentenced to 20 years, shows "ongoing"
- SEC v. Barksdale: $102.6M default judgment entered, shows "ongoing"
- Multiple DOJ guilty pleas and sentencings

### 5. Category Misclassifications: 14 Cases

| Count | Issue |
|-------|-------|
| 3 | Federal agencies (OFAC, FinCEN, FTC) classified as "State" |
| 8 | OFAC, FinCEN, FTC, NY AG classified as "DOJ" |
| 3 | Additional State/Federal confusion |

### 6. Duplicates: 6 True Duplicates + 3 Double-Count Risks

4 true duplicate case entries (remove IDs 1658, 369, 346, 405). 2 additional duplicate docket pairs (920/1016, 1117/1125) in DOJ category. 3 cases with potential penalty double-counting across parallel SEC/DOJ actions.

### 7. Howey Analysis: Solid (Minor Corrections)

- 13 false positives (5.3%): flagged but no Howey discussion in text
- 3 false negatives found (Howey discussed but not flagged)
- Prong coding accuracy: 85–95% (17/20 spot-checked correct)
- Key quotes: 90.3% populated, zero hallucinated quotes
- **Corrected count:** 247 → ~237 Howey-discussed filings
- **No material impact** on paper's Howey analysis conclusions

### 8. Landmark Discovery: Eisenberg/Mango Markets Convictions Vacated

ID 689: The first jury conviction for DeFi market manipulation was **vacated by the judge on May 23, 2025** (venue deficiencies + insufficient evidence of false representations to a smart contract). Dataset shows "loss" with $110M penalty — should be acquitted with $0. This is significant for any discussion of DeFi enforcement precedent.

---

## Audit Pipeline Statistics

| Agent | Batch | Cases | Runtime |
|-------|-------|-------|---------|
| Controller | Planning | 938 | ~5 min |
| Row Auditor 2A | Ongoing+penalty | 54 | ~5 min |
| Row Auditor 2BC | High-value+private | 32 | ~5 min |
| DOJ Auditor | All DOJ | 148 | ~7 min |
| State Auditor | All State | 103 | ~6 min |
| Duplicate Detector | Full scan | 938 | ~3 min |
| External Verifier | 12 priority cases | 12 | ~4 min |
| Howey Auditor | Howey analysis | 247 | ~5 min |
| Reconciler | All corrections | All | ~9 min |

**Total: ~49 min agent-time across 9 agents**

---

## Deliverables

| File | Contents |
|------|----------|
| `corrections-table.md` | All corrections grouped by issue type |
| `full-changelog.jsonl` | 153 machine-readable correction entries |
| `unresolved-issues.md` | 31 cases needing manual expert review |
| `paper-impact.md` | Aggregate statistics and paper impact analysis |
| `master-memo.md` | This document |

---

## Top Recommendations

### Critical (Required for Paper Integrity)

1. **Split `penalty_amount` into four fields:** fine, forfeiture, restitution, disgorgement
2. **Clear phantom penalties:** 45 cases where alleged amounts are recorded as penalties
3. **Update stale outcomes:** 42+ resolved cases still showing "ongoing"
4. **Fix the Eisenberg entry:** Convictions vacated — not a DeFi enforcement success story

### Important

5. **Add new enforcement categories:** FinCEN, FTC, OFAC/Treasury (12 misclassified cases)
6. **Add `crypto_relevance` field:** 12 DOJ cases are crypto-incidental
7. **Remove duplicates:** 6 confirmed, 3 more under review
8. **Add `last_verified_date`** to track data freshness

### For the Paper Specifically

9. **Revise DOJ enforcement totals** — current figures are 95% wrong
10. **Reframe enforcement ranking:** CFTC → SEC → DOJ (by verified penalties)
11. **Note Eisenberg as overturned** if discussing DeFi enforcement precedent
12. **Acknowledge penalty field limitations** in methodology section

---

*End of master audit memo.*

---

## Post-Audit Corrections (March 17, 2026)

| Change | Detail |
|--------|--------|
| **Ingersoll/Adamczyk excluded** | U.S. v. Ingersoll/Adamczyk (ID 849) reclassified as Excluded — real estate/wire fraud, not crypto-related |
| **OFAC/Exodus → DOJ** | Settlement Agreement between Treasury OFAC and Exodus Movement (ID 298) moved from OFAC to DOJ |
| **Ripple penalty updated** | SEC v. Ripple Labs (ID 933) — $125M August 2024 judgment → $50M May 2025 settlement (remainder returned under post-Gensler recalibration) |
| **Net effect** | Total adversarial: 934 → 933. DOJ resolved: 74 → 73. DOJ conviction rate: 91.9% → 93.2%. |
