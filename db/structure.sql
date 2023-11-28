CREATE TABLE IF NOT EXISTS "transfers" (
id INTEGER PRIMARY KEY,
counterparty_name TEXT,
counterparty_iban TEXT,
counterparty_bic TEXT,
amount_cents INTEGER,
bank_account_id INTEGER, description TEXT);
CREATE TABLE bank_accounts (
id INTEGER PRIMARY KEY,
organization_name TEXT,
balance_cents INTEGER, iban TEXT, bic TEXT);
CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_bank_accounts_on_bic_and_iban" ON "bank_accounts" ("bic", "iban");
INSERT INTO "schema_migrations" (version) VALUES
('20231128150248');