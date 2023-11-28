# Qonto - bulk transfer challenge

The interesting part in this challenge is how to deal with several bulk transfer requests, which:
- when taken in isolation, would not deplete the account balance
- when taken sequentially, would bring the account balance below 0, which is forbidden

The point of the implementation is to ensure that, even in the case of CONCURRENT bulk transfer requests, the account balance never reaches below 0.

### Solutions

1. lock the row in the database?
2. use SQL check constraint and update with a SQL statement?


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
