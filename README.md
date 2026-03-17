# U.S. Cryptocurrency Litigation Dataset (2013–2026)

A comprehensive dataset of U.S. cryptocurrency enforcement actions and litigation, drawn from the [Morrison Cohen Crypto Litigation Tracker](https://cryptotracker.morrisoncohen.com/).

## Latest Update: March 2026 Audit

**Full-dataset audit completed March 17, 2026** using primary sources (SEC.gov, DOJ.gov, CFTC.gov, FinCEN.gov, CourtListener, Justia). Key corrections:

- **56 phantom penalties cleared** — alleged scheme/fundraise amounts incorrectly recorded as imposed penalties (total: ~$4.27B removed from penalty totals)
- **34 stale outcomes updated** — cases resolved in 2021–2025 that still showed `outcome = 'ongoing'`
- **4 true duplicates removed** — adversarial count: 938 → 933
- **14 category reclassifications** — federal actions (OFAC, FinCEN, FTC) previously miscategorized
- **Howey analysis validated** — 94.7% accuracy (13 false positives corrected, 3 false negatives identified)
- **Landmark case update**: U.S. v. Eisenberg (Mango Markets) — criminal convictions vacated May 2025

See `AUDIT.md` for full methodology, corrections table, and impact analysis.

### Known Limitation: `penalty_amount` Field

The `penalty_amount` field currently conflates four distinct monetary concepts:
1. **Civil monetary penalties / fines** — actual imposed penalties
2. **Criminal forfeiture orders** — return of ill-gotten gains (~$12.1B in DOJ cases)
3. **Restitution orders** — payments to victims
4. **Disgorgement** — return of profits (SEC/CFTC)

Users should exercise caution when aggregating penalty totals, particularly for DOJ cases. Separate `forfeiture_amount`, `restitution_amount`, and `disgorgement_amount` columns have been added to distinguish these from civil penalties.

## Dataset Overview

| Metric | Count |
|--------|-------|
| Total matters (source) | 1,157 |
| Adversarial matters (this dataset) | 933 |
| Excluded: Regulatory Guidance (non-adversarial) | 210 |
| Excluded: Non-categorizable / duplicates | 13 |
| Filings with extracted document text | 735 (78.7% of adversarial) |
| Cause-of-action relationships | 3,948 |
| Howey test analyses | 1,150 |
| Entity relationships | 3,333 |
| Topic classifications | 2,586 (multi-label) |

## Categories

| Category | Count | Description |
|----------|-------|-------------|
| Private | 411 | Class actions and private litigation |
| SEC | 203 | Securities and Exchange Commission enforcement |
| DOJ | 139 | Department of Justice criminal prosecutions |
| State | 100 | State attorneys general, NYDFS, state regulators |
| CFTC | 58 | Commodity Futures Trading Commission enforcement |
| Bankruptcy | 13 | Crypto bankruptcy proceedings |
| FTC | 4 | Federal Trade Commission enforcement |
| FinCEN | 3 | Financial Crimes Enforcement Network (Treasury) |
| OFAC | 3 | Office of Foreign Assets Control (Treasury) |

### Excluded Categories (in source data but not in adversarial dataset)
| Category | Count | Description |
|----------|-------|-------------|
| Regulatory Guidance | 210 | Commissioner speeches, no-action letters, investor bulletins, rulemaking (non-adversarial) |
| Excluded | 13 | Manhattan DA, FINRA, private parties challenging regulators (Coin Center v. Yellen, Custodia v. Fed, etc.) |

## Files

### SQLite Database
- `tracker.db` — Full SQLite database (~42MB). Query directly with any SQLite client. Contains all 1,157 source matters; filter with `WHERE category NOT IN ('Regulatory Guidance', 'Excluded')` for the 934 adversarial matters.

### CSV Exports
- `csv/filings.csv` — All 1,157 source matters (case name, court, docket, category, outcome, penalties, summary)
- `csv/filing_causes.csv` — 3,948 cause-of-action relationships (filing → legal theory)
- `csv/filing_topics.csv` — 2,586 multi-label topic classifications
- `csv/filing_entities.csv` — 3,333 entity-filing relationships with roles
- `csv/entities.csv` — 1,221 distinct entities (companies, individuals, agencies)
- `csv/howey_analysis.csv` — Prong-by-prong Howey test classification for 1,150 filings
- `csv/judge_mentions.csv` — 60 judicial assignments
- `csv/document_texts.csv` — Extracted text from 735+ filings (~35MB)

### Schema
- `schema.sql` — Database schema definitions

## Key Fields (filings.csv)

| Field | Description |
|-------|-------------|
| `id` | Unique filing ID |
| `title` | Case name (e.g., "SEC v. Ripple Labs, Inc.") |
| `filing_date` | Date filed |
| `court` | Court or authority |
| `docket_number` | Docket/case number |
| `category` | SEC, DOJ, CFTC, Private, State, Bankruptcy, FTC, FinCEN, OFAC (adversarial) or Regulatory Guidance, Excluded |
| `outcome` | ongoing, settled, dismissed, win, loss |
| `penalty_amount` | Civil monetary penalties / fines imposed by court or regulator (USD). Does NOT include forfeiture or restitution. |
| `forfeiture_amount` | Criminal forfeiture orders (USD). Primarily DOJ cases. |
| `restitution_amount` | Restitution orders to victims (USD). Primarily DOJ cases. |
| `disgorgement_amount` | Disgorgement of ill-gotten gains (USD). Primarily SEC/CFTC cases. |
| `settlement_amount` | Settlement amount (USD) |
| `alleged_amount` | Alleged scheme size / investor losses (USD) |
| `crypto_relevance` | `crypto_specific` (default), `crypto_incidental`, or `crypto_tangential` |
| `last_verified_date` | Date the case was last verified against primary sources (YYYY-MM-DD) |
| `summary` | Brief description of the matter |
| `source_url` | Morrison Cohen Tracker URL |
| `document_url` | Link to primary filing document |

## Howey Analysis Fields (howey_analysis.csv)

Each of the four Howey prongs classified as: `alleged`, `contested`, `satisfied`, `not_satisfied`, or `null`.

| Field | Description |
|-------|-------------|
| `howey_discussed` | Whether the filing discusses the Howey test (0/1) |
| `investment_of_money` | First prong classification |
| `common_enterprise` | Second prong classification |
| `expectation_of_profits` | Third prong classification |
| `efforts_of_others` | Fourth prong classification |
| `key_quotes` | Relevant Howey-related quotes from the filing |

## Topic Labels (filing_topics.csv)

Multi-label classification. A single filing can have multiple topics:

Exchange, Fraud/Ponzi, ICO/Token Sale, Money Laundering, Stablecoin, DAO, Lending, DeFi, Market Manipulation, Mining, NFT, Staking, Privacy/Mixer, Wallet/Custody, Insider Trading, Ransomware, Other

## Source

Data sourced from the [Morrison Cohen Digital Assets Litigation Tracker](https://cryptotracker.morrisoncohen.com/). Document text extracted from linked court filings, SEC.gov, DOJ press releases, CourtListener RECAP archive, and other public sources.

## License

This dataset is compiled from publicly available legal filings and regulatory actions. The compilation and analysis are provided for research purposes.
