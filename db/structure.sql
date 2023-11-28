CREATE TABLE bank_accounts (
id INTEGER PRIMARY KEY,
organization_name TEXT,
balance_cents INTEGER, iban TEXT, bic TEXT);
CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_bank_accounts_on_bic_and_iban" ON "bank_accounts" ("bic", "iban");
CREATE TABLE IF NOT EXISTS "transfers" ("id" integer NOT NULL PRIMARY KEY, "counterparty_name" text DEFAULT NULL, "counterparty_iban" text DEFAULT NULL, "counterparty_bic" text DEFAULT NULL, "amount_cents" integer DEFAULT NULL, "bank_account_id" integer DEFAULT NULL, "description" text DEFAULT NULL, CONSTRAINT "fk_rails_09d60ae02b"
FOREIGN KEY ("bank_account_id")
  REFERENCES "bank_accounts" ("id")
);
INSERT INTO "schema_migrations" (version) VALUES
('20231128150745'),
('20231128150248');
