# Qonto - bulk transfer challenge

## Facts about the problem
The interesting part in this challenge is how to deal with several bulk transfer requests, which:
- when taken in isolation, would not deplete the account balance
- when taken sequentially, would bring the account balance below 0, which is forbidden

The point of the implementation is to ensure that, even in the case of CONCURRENT bulk transfer requests, the data does not end up in an inconsistent state.

## Concurrency control brainstorming
1. Lock the row in the database using `SELECT FOR UPDATE NOWAIT` (using Rails pessimistic locking)
2. Take a lock somewhere else (Advisory locks with Postgres; or [Redis](https://redis.io/docs/manual/patterns/distributed-locks/))

## Setup

### Ruby
Install [asdf](https://asdf-vm.com/) and install the proper ruby version locally with `asdf install`

### Gems
Install the gems with `bundle install`

### SQLite Database
I scripted the creation of the provided `bank_accounts` and `transfers` tables in order to be able to easily re-initialize the database.

I also made a number of improvements to the schema:
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

## Running specs
Run `bundle exec rspec`

## Trying out `sample1.json` and `sample2.json`
Start the rails server in one terminal with `rails server`.
Run this in a second terminal:
```sh
curl -sw '%{http_code}' localhost:3000/transfers/bulk -H 'Content-Type: application/json' -d @spec/fixtures/files/sample1.json
curl -sw '%{http_code}' localhost:3000/transfers/bulk -H 'Content-Type: application/json' -d @spec/fixtures/files/sample2.json
```

Run `bin/rails db:seed` to reset the data in your development environment.

## Current limitations
Current limitations include but are not limited to:
- API calls are not authenticated
- API params are not thoroughly validated. I've only implemented checking the `amount_cents` field. It's possible to go further and validate at least the BIC and IBAN.
- Sensitive fields - IBAN, BIC(?) - should be encrypted at rest - with deterministic encryption.
- GitHub hasn't been set up with a CI pipeline
- The Dockerfile is the one from `rails new` and hasn't been tested / optimized
- Logging and error reporting (Sentry?) haven't been set up
