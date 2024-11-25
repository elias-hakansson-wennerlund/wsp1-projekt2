require_relative "../db/db.rb"
require_relative "base_model"

class Contact < BaseModel
  @table_name = "contacts"

  def self.create_table!
    DB.execute("
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        picture_id INTEGER,
        first_name TEXT NOT NULL,
        last_name TEXT,
        company TEXT,
        phone_number TEXT,
        email TEXT,
        birthday DATE,
        note TEXT,
        created_at DATETIME NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (picture_id) REFERENCES media(id)
      )
    ")
  end
end
