require "sqlite3"

DB = SQLite3::Database.new "db/contact_app.sqlite3"
DB.results_as_hash = true

