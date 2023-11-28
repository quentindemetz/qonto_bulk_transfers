# Qonto - bulk transfer challenge

### Facts about the problem
The interesting part in this challenge is how to deal with several bulk transfer requests, which:
- when taken in isolation, would not deplete the account balance
- when taken sequentially, would bring the account balance below 0, which is forbidden

The point of the implementation is to ensure that, even in the case of CONCURRENT bulk transfer requests, the account balance never reaches below 0.

### Solution ideas
1. Lock the row in the database using `SELECT FOR UPDATE (NOWAIT)`
2. Use a SQL check constraint in a database transaction + use rails `decrement!` <-- this is what I picked

### Setup

Install [asdf](https://asdf-vm.com/) and install the proper ruby version locally with `asdf install`

In order to have a easy-to-set-up, easy-to-tear-down test database, I re-implemented the two provided tables in database migrations, which means `rails db:create` will create empty SQLite databases.

Use the following queries to re-insert the sample data in the DB;
```SQL
INSERT INTO bank_accounts (id, organization_name, balance_cents, iban, bic) VALUES (1, 'ACME Corp', 10000000, 'FR10474608000002006107XXXXX', 'OIVUSCLQXXX');
INSERT INTO transfers (id, counterparty_name, counterparty_iban, counterparty_bic, amount_cents, description, bank_account_id) VALUES (1, 'ACME Corp. Main Account', 'EE382200221020145685', 'CCOPFRPPXXX', 11000000, 'Treasury management', 1), (2, 'Bip Bip', 'EE383680981021245685', 'CRLYFRPPTOU', 1000000, 'Bip Bip Salary', 1);
```

### Running specs

Run `bundle exec rspec`

### Current limitations
- API calls are not authenticated
- API params are not significantly validated; I've only implemented checking the `amount_cents` field. It's possible to go further and validate at least the BIC and IBAN.
