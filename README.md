# Qonto - bulk transfer challenge

### Facts about the problem
The interesting part in this challenge is how to deal with several bulk transfer requests, which:
- when taken in isolation, would not deplete the account balance
- when taken sequentially, would bring the account balance below 0, which is forbidden

The point of the implementation is to ensure that, even in the case of CONCURRENT bulk transfer requests, the data does not end up in an inconsistent state.

### Concurrency control brainstorming
1. Lock the row in the database using `SELECT FOR UPDATE (NOWAIT)` (via SQL, or Rails pessimistic locking)
2. Use a SQL check constraint in a database transaction + use rails `decrement!` <-- this is what I picked

### Setup

Install [asdf](https://asdf-vm.com/) and install the proper ruby version locally with `asdf install`

Install the gems with `bundle install`

In order to have a easy-to-set-up, easy-to-tear-down system, I re-implemented the two provided tables in database migrations, which means `bin/rails db:create` will create empty SQLite databases. I also made a number of improvements to the schema:
- foreign keys and relevant indexes
- NOT NULL constraints
- unique index on bank_accounts (iban, bic)

Use the following code to setup or reset your local environment:
```sh
bin/rake db:drop
bin/rake db:create
bin/rake db:migrate
bin/rake db:seed
```

### Running specs
Run `bundle exec rspec`

### Trying out `sample1.json` and `sample2.json`
Start the rails server in one terminal with `rails s`.
Run this in a second terminal:
```sh
curl -sw '%{http_code}' localhost:3000/transfers/bulk -H 'Content-Type: application/json' -d @spec/fixtures/files/sample1.json
curl -sw '%{http_code}' localhost:3000/transfers/bulk -H 'Content-Type: application/json' -d @spec/fixtures/files/sample2.json
```

`bin/rails db:seed` will reset just your data so you can try more things without having to reset everything.

### Current limitations
Current limitations include but are not limited to:
- API calls are not authenticated
- API params are not thoroughly validated. I've only implemented checking the `amount_cents` field. It's possible to go further and validate at least the BIC and IBAN.
- Sensitive fields - IBAN, BIC(?) - should be encrypted at rest - with deterministic encryption.
- GitHub hasn't been set up with a CI pipeline
- Logging and error reporting (Sentry?) hasn't been set up
