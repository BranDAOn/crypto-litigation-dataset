# U.S. Cryptocurrency Litigation Dataset (2013–2026)

A comprehensive dataset of U.S. cryptocurrency enforcement actions and litigation, drawn from the [Morrison Cohen Crypto Litigation Tracker](https://cryptotracker.morrisoncohen.com/).

## Dataset Overview

| Metric | Count |
|--------|-------|
| Total matters (source) | 1,157 |
| Adversarial matters (this dataset) | 938 |
| Excluded: Regulatory Guidance (non-adversarial) | 210 |
| Excluded: Non-categorizable (FINRA, private challenges to regulators, etc.) | 9 |
| Filings with extracted document text | 735 (78.4% of adversarial) |
| Cause-of-action relationships | 3,948 |
| Howey test analyses | 1,150 |
| Entity relationships | 3,333 |
| Topic classifications | 2,586 (multi-label) |

## Categories

| Category | Count | Description |
|----------|-------|-------------|
| Private | 414 | Class actions and private litigation |
| SEC | 204 | Securities and Exchange Commission enforcement |
| DOJ | 148 | Department of Justice, FTC, OFAC/FinCEN, civil forfeiture |
| State | 101 | State attorneys general, NYDFS, state regulators |
| CFTC | 58 | Commodity Futures Trading Commission enforcement |
| Bankruptcy | 13 | Crypto bankruptcy proceedings |

### Excluded Categories (in source data but not in adversarial dataset)
| Category | Count | Description |
|----------|-------|-------------|
| Regulatory Guidance | 210 | Commissioner speeches, no-action letters, investor bulletins, rulemaking (non-adversarial) |
| Excluded | 9 | Manhattan DA, FINRA, private parties challenging regulators (Coin Center v. Yellen, Custodia v. Fed, etc.) |

## Files

### SQLite Database
- `tracker.db` — Full SQLite database (~42MB). Query directly with any SQLite client. Contains all 1,157 source matters; filter with `WHERE category NOT IN ('Regulatory Guidance', 'Excluded')` for the 938 adversarial matters.

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
| `category` | SEC, DOJ, CFTC, Private, State, Bankruptcy (adversarial) or Regulatory Guidance, Excluded |
| `outcome` | ongoing, settled, dismissed, win, loss |
| `penalty_amount` | Court-ordered penalty/judgment (USD) |
| `settlement_amount` | Settlement amount (USD) |
| `alleged_amount` | Alleged scheme size / investor losses (USD) |
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
