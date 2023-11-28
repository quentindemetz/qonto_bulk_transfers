CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "bank_accounts" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "organization_name" text, "balance_cents" integer, "iban" text, "bic" text);
CREATE TABLE sqlite_sequence(name,seq);
CREATE UNIQUE INDEX "index_bank_accounts_on_bic_and_iban" ON "bank_accounts" ("bic", "iban");
CREATE TABLE IF NOT EXISTS "transfers" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "counterparty_name" text DEFAULT NULL, "counterparty_iban" text DEFAULT NULL, "counterparty_bic" text DEFAULT NULL, "amount_cents" integer DEFAULT NULL, "bank_account_id" integer DEFAULT NULL, "description" text DEFAULT NULL, CONSTRAINT "fk_rails_09d60ae02b"
FOREIGN KEY ("bank_account_id")
  REFERENCES "bank_accounts" ("id")
);
INSERT INTO "schema_migrations" (version) VALUES
('20231128150745'),
('20231128150248'),
('20231127161233'),
('20231126161245');
