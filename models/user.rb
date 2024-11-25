require "bcrypt"
require_relative "base_model"
require_relative '../db/db.rb'
require_relative "../lib/is_valid_password.rb"

class User < BaseModel
  @table_name = "users"

  def self.create_table!
    DB.execute("
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        password TEXT NOT NULL,
        first_name TEXT NOT NULL,
        middle_name TEXT,
        last_name TEXT,
        picture_id INTEGER REFERENCES media(id),
        created_at DATETIME NOT NULL DEFAULT current_timestamp
      );
    ")
  end

  def self.insert(params)
    email = params[:email]
    plain_password = params[:password]

    raise "Invalid password" unless is_valid_password(plain_password)

    hashed_password = BCrypt::Password.create(plain_password)

    DB.execute(
      "INSERT INTO users (email, phone, password, first_name, middle_name, last_name) VALUES (?,?,?,?,?,?)",
      [ params[:email], params[:phone], hashed_password, params[:first_name], params[:middle_name], params[:last_name] ]
    )

    return DB.last_insert_row_id
  end
end
