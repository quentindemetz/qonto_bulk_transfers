# README

To replicate the sample data into the database, use the following queries:
```SQL
INSERT INTO bank_accounts (id, organization_name, balance_cents, iban, bic) VALUES (1, 'ACME Corp', 10000000, 'FR10474608000002006107XXXXX', 'OIVUSCLQXXX');
INSERT INTO transfers (id, counterparty_name, counterparty_iban, counterparty_bic, amount_cents, description, bank_account_id) VALUES (1, 'ACME Corp. Main Account', 'EE382200221020145685', 'CCOPFRPPXXX', 11000000, 'Treasury management', 1), (2, 'Bip Bip', 'EE383680981021245685', 'CRLYFRPPTOU', 1000000, 'Bip Bip Salary', 1);
```


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


- no authentication
- not validations for request payload
