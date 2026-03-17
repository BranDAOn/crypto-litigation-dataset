CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE entities (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      type TEXT NOT NULL DEFAULT 'company',
      filing_count INTEGER NOT NULL DEFAULT 0,
      total_penalties REAL NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    );
CREATE TABLE filing_entities (
      filing_id INTEGER NOT NULL,
      entity_id INTEGER NOT NULL,
      role TEXT NOT NULL DEFAULT 'defendant',
      PRIMARY KEY (filing_id, entity_id),
      FOREIGN KEY (filing_id) REFERENCES filings(id) ON DELETE CASCADE,
      FOREIGN KEY (entity_id) REFERENCES entities(id) ON DELETE CASCADE
    );
CREATE TABLE daily_stats (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      stat_date TEXT NOT NULL UNIQUE,
      total_filings INTEGER NOT NULL DEFAULT 0,
      new_filings INTEGER NOT NULL DEFAULT 0,
      total_penalties REAL NOT NULL DEFAULT 0,
      sec_count INTEGER NOT NULL DEFAULT 0,
      cftc_count INTEGER NOT NULL DEFAULT 0,
      doj_count INTEGER NOT NULL DEFAULT 0,
      bankruptcy_count INTEGER NOT NULL DEFAULT 0,
      private_count INTEGER NOT NULL DEFAULT 0,
      state_count INTEGER NOT NULL DEFAULT 0,
      regulatory_count INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    );
CREATE TABLE sessions (
      id TEXT PRIMARY KEY,
      created_at TEXT NOT NULL DEFAULT (datetime('now')),
      expires_at TEXT NOT NULL
    );
CREATE INDEX idx_daily_stats_date ON daily_stats(stat_date);
CREATE TABLE document_texts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      filing_id INTEGER NOT NULL UNIQUE,
      source_url TEXT,
      document_url TEXT,
      source_text TEXT,
      document_text TEXT,
      source_length INTEGER DEFAULT 0,
      document_length INTEGER DEFAULT 0,
      ingested_at TEXT DEFAULT (datetime('now')),
      error TEXT,
      FOREIGN KEY (filing_id) REFERENCES filings(id)
    );
CREATE INDEX idx_document_texts_filing ON document_texts(filing_id);
CREATE TABLE dashboards (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      session_id TEXT,
      name TEXT NOT NULL DEFAULT 'My Dashboard',
      layout TEXT NOT NULL DEFAULT '{"widgets":[]}',
      created_at TEXT DEFAULT (datetime('now')),
      updated_at TEXT DEFAULT (datetime('now'))
    );
CREATE INDEX idx_dashboards_session ON dashboards(session_id);
CREATE TABLE howey_analysis (
    filing_id INTEGER PRIMARY KEY,
    investment_of_money TEXT DEFAULT 'not_discussed',
    common_enterprise TEXT DEFAULT 'not_discussed',
    expectation_of_profits TEXT DEFAULT 'not_discussed',
    efforts_of_others TEXT DEFAULT 'not_discussed',
    howey_discussed BOOLEAN DEFAULT 0,
    key_quotes TEXT DEFAULT '[]',
    FOREIGN KEY (filing_id) REFERENCES filings(id)
  );
CREATE TABLE judge_mentions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    filing_id INTEGER NOT NULL,
    judge_name TEXT NOT NULL,
    FOREIGN KEY (filing_id) REFERENCES filings(id)
  );
CREATE TABLE IF NOT EXISTS "filings" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  filing_date TEXT NOT NULL,
  court TEXT NOT NULL,
  docket_number TEXT,
  category TEXT NOT NULL,
  causes_of_action TEXT NOT NULL DEFAULT '[]',
  summary TEXT,
  source_url TEXT,
  document_url TEXT,
  tokens_mentioned TEXT NOT NULL DEFAULT '[]',
  entities_mentioned TEXT NOT NULL DEFAULT '[]',
  settlement_amount REAL,
  penalty_amount REAL,
  status TEXT NOT NULL DEFAULT 'filed' CHECK(status IN ('filed','settled','dismissed','ongoing')),
  outcome TEXT NOT NULL DEFAULT 'ongoing' CHECK(outcome IN ('win','loss','settled','dismissed','ongoing')),
  arguments_used TEXT NOT NULL DEFAULT '[]',
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  topic TEXT DEFAULT NULL
, alleged_amount REAL, forfeiture_amount REAL, restitution_amount REAL, disgorgement_amount REAL, crypto_relevance TEXT DEFAULT 'crypto_specific' CHECK(crypto_relevance IN ('crypto_specific', 'crypto_incidental', 'crypto_tangential')), last_verified_date TEXT);
CREATE INDEX idx_filings_category ON filings(category);
CREATE INDEX idx_filings_status ON filings(status);
CREATE INDEX idx_filings_date ON filings(filing_date);
CREATE INDEX idx_filings_court ON filings(court);
CREATE INDEX idx_filings_docket ON filings(docket_number, court);
CREATE UNIQUE INDEX idx_filings_title_date ON filings(title, filing_date);
CREATE TABLE filing_causes (
      filing_id INTEGER NOT NULL,
      cause TEXT NOT NULL,
      PRIMARY KEY (filing_id, cause),
      FOREIGN KEY (filing_id) REFERENCES filings(id) ON DELETE CASCADE
    );
CREATE INDEX idx_filing_causes_cause ON filing_causes(cause);
CREATE VIRTUAL TABLE filings_fts USING fts5(title, summary)
/* filings_fts(title,summary) */;
CREATE TABLE IF NOT EXISTS 'filings_fts_data'(id INTEGER PRIMARY KEY, block BLOB);
CREATE TABLE IF NOT EXISTS 'filings_fts_idx'(segid, term, pgno, PRIMARY KEY(segid, term)) WITHOUT ROWID;
CREATE TABLE IF NOT EXISTS 'filings_fts_content'(id INTEGER PRIMARY KEY, c0, c1);
CREATE TABLE IF NOT EXISTS 'filings_fts_docsize'(id INTEGER PRIMARY KEY, sz BLOB);
CREATE TABLE IF NOT EXISTS 'filings_fts_config'(k PRIMARY KEY, v) WITHOUT ROWID;
CREATE TRIGGER filings_ai AFTER INSERT ON filings BEGIN
  INSERT INTO filings_fts(rowid, title, summary) VALUES (new.id, new.title, new.summary);
END;
CREATE TRIGGER filings_ad AFTER DELETE ON filings BEGIN
  INSERT INTO filings_fts(filings_fts, rowid, title, summary) VALUES('delete', old.id, old.title, old.summary);
END;
CREATE TRIGGER filings_au AFTER UPDATE OF title, summary ON filings BEGIN
  INSERT INTO filings_fts(filings_fts, rowid, title, summary) VALUES('delete', old.id, old.title, old.summary);
  INSERT INTO filings_fts(rowid, title, summary) VALUES(new.id, new.title, new.summary);
END;
CREATE TABLE filing_topics (
    filing_id INTEGER NOT NULL,
    topic TEXT NOT NULL,
    PRIMARY KEY (filing_id, topic),
    FOREIGN KEY (filing_id) REFERENCES filings(id)
  );
