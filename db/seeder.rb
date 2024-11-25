require "bcrypt"
require_relative "./db.rb"
require_relative "../models/user.rb"
require_relative "../models/contact.rb"
require_relative "../models/media.rb"

class Seeder

  def self.seed!
    drop_tables!
    create_tables!
    populate_tables!
  end

  def self.drop_tables!
    User.drop_table!
    Contact.drop_table!
    Media.drop_table!
  end

  def self.create_tables!
    User.create_table!
    Contact.create_table!
    Media.create_table!
 end

  def self.populate_tables!
    User.insert({
      first_name: "Elias",
      last_name: "Wennerlund",
      phone: "+46701234567",
      email: "admin@example.com",
      password: "Qko6%nIz"
    })
  end
end

Seeder.seed!
