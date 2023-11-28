CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS "transfers" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "counterparty_name" text NOT NULL, "counterparty_iban" text NOT NULL, "counterparty_bic" text NOT NULL, "amount_cents" integer NOT NULL, "bank_account_id" integer NOT NULL, "description" text NOT NULL, CONSTRAINT "fk_rails_09d60ae02b"
FOREIGN KEY ("bank_account_id")
  REFERENCES "bank_accounts" ("id")
);
CREATE INDEX "index_transfers_on_bank_account_id" ON "transfers" ("bank_account_id");
CREATE TABLE IF NOT EXISTS "bank_accounts" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "organization_name" text NOT NULL, "balance_cents" integer NOT NULL, "iban" text NOT NULL, "bic" text NOT NULL, CONSTRAINT chk_rails_e59da4aaba CHECK (balance_cents >= 0));
CREATE UNIQUE INDEX "index_bank_accounts_on_bic_and_iban" ON "bank_accounts" ("bic", "iban");
INSERT INTO "schema_migrations" (version) VALUES
('20231128171400'),
('20231128163408'),
('20231128163106'),
('20231128150745'),
('20231128150248'),
('20231127161233'),
('20231126161245');
