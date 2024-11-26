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
        created_at DATETIME NOT NULL DEFAULT current_timestamp,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (picture_id) REFERENCES media(id)
      )
    ")
  end

  def self.insert(params)
    DB.execute(
      "INSERT INTO contacts
      (user_id, picture_id, first_name, last_name, company, phone_number, email, birthday, note)
      VALUES (?,?,?,?,?,?,?,?,?)",
      [ params[:user_id], params[:picture_id], params[:first_name], params[:last_name],
        params[:company], params[:phone_number], params[:email], params[:birthday], params[:note] ]
    )

    return DB.last_insert_row_id
  end
end
