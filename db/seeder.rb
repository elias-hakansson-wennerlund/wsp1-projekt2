require 'sqlite3'

class Seeder

  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS users')
    db.execute('DROP TABLE IF EXISTS contacts')
    db.execute('DROP TABLE IF EXISTS media')
  end

  def create_tables
    db.execute('CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                first_name TEXT NOT NULL,
                last_name TEXT,
                phone TEXT NOT NULL,
                email TEXT,
                picture_id INTEGER REFERENCES media(id),
                created_at DATETIME NOT NULL,
                updated_at DATETIME NOT NULL)')

    db.execute('CREATE TABLE IF NOT EXISTS contacts (
                id INTEGER PRIMARY KEY,
                user_id INTEGER REFERENCES users(id),
                picture_id INTEGER REFERENCES media(id),
                first_name TEXT NOT NULL,
                last_name TEXT,
                company TEXT,
                phone_number TEXT,
                email TEXT,
                birthday DATE,
                note TEXT,
                created_at DATETIME NOT NULL,
                updated_at DATETIME NOT NULL)')

    db.execute('CREATE TABLE IF NOT EXISTS media (
                id INTEGER PRIMARY KEY,
                url TEXT NOT NULL,
                file_type TEXT NOT NULL,
                file_name TEXT NOT NULL,
                created_at DATETIME NOT NULL,
                updated_at DATETIME NOT NULL)')
  end

  def self.populate_tables
    db.execute('INSERT INTO users (first_name, last_name, phone_number, email) VALUES ("Elias", "Wennerlund", "+46709886107", "elias06wennerlund@gmail.com")')

    # db.execute('INSERT INTO contacts ()')
  end

  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/db.sqlite')
    @db
  end
end

Seeder.seed!
