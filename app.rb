require "sinatra"
require "dotenv/load"
require_relative "models/user.rb"
require_relative "models/contact.rb"
require_relative "models/media.rb"
require_relative "lib/is_valid_image_mime.rb"

class App < Sinatra::Base
  use Rack::Session::Cookie, key: "rack.session",
                             path: "/",
                             secret: ENV["SESSION_SECRET"]

  helpers do
    def protected!
      @is_signed_in = authorized?
      redirect "/login" unless @is_signed_in
    end

    def authorized?
      !!session[:user_id]
    end
  end

  get "/" do
    protected!
    redirect "/contacts"
  end

  get "/contacts" do
    protected!

    @contacts = DB.execute("
      SELECT
        contacts.*,
        media.file_name,
        media.mime_type
      FROM contacts
      LEFT JOIN media
        ON contacts.picture_id = media.id
      WHERE user_id = ?",
                           [session[:user_id]])

    erb(:"contacts")
  end

  get "/contacts/new" do
    protected!

    erb(:"new_contact")
  end

  post "/contacts" do
    protected!

    user = User.select_one(id: session[:user_id])

    picture_id = nil

    if params[:picture] && params[:picture][:tempfile]
      halt 401, "Invalid file" unless is_valid_image_mime(params[:picture][:type])

      picture_id = Media.upload({
        mime_type: params[:picture][:type],
        file_name: params[:picture][:filename],
        tempfile: params[:picture][:tempfile],
      })
    end

    new_contact_id = Contact.insert({
      user_id: user["id"],
      picture_id: picture_id,
      first_name: params[:first_name],
      last_name: params[:last_name],
      company: params[:company],
      phone_number: params[:phone_number],
      email: params[:email],
      birthday: params[:birthday],
      note: params[:note],
    })

    redirect "/contacts/#{new_contact_id}"
  end

  get "/contacts/:id/edit" do |id|
    protected!

    @contact = DB.execute("
      SELECT
        contacts.*,
        media.file_name,
        media.mime_type
      FROM contacts
      LEFT JOIN media
        ON contacts.picture_id = media.id
      WHERE contacts.id = ? AND contacts.user_id = ?
      LIMIT 1", [id, session[:user_id]]).first

    halt 404, "Contact not found" if @contact.nil?

    erb :edit_contact
  end

  post "/contacts/:id/update" do |id|
    protected!

    user = User.select_one(id: session[:user_id])
    contact = Contact.select_one(id: id)

    halt 404, "Contact not found" if contact.nil?

    picture_id = nil

    if params[:picture] && params[:picture][:tempfile]
      halt 401, "Invalid file" unless is_valid_image_mime(params[:picture][:type])

      if contact["picture_id"]
        Media.delete!(contact["picture_id"])
      end

      picture_id = Media.upload({
        mime_type: params[:picture][:type],
        file_name: params[:picture][:filename],
        tempfile: params[:picture][:tempfile],
      })
    end

    Contact.update(id.to_i, {
      picture_id: picture_id,
      first_name: params[:first_name],
      last_name: params[:last_name],
      company: params[:company],
      phone_number: params[:phone_number],
      email: params[:email],
      birthday: params[:birthday],
      note: params[:note],
    })

    redirect "/contacts/#{id}"
  end

  post "/contacts/:id/delete" do |id|
    protected!

    contact = Contact.select_one(id: id)

    if contact["picture_id"]
      Media.delete!(contact["picture_id"])
    end

    Contact.delete!(id)

    status 200
    redirect "/contacts"
  end

  get "/contacts/:id" do |id|
    protected!

    @contact = DB.execute("
      SELECT
        contacts.*,
        media.file_name,
        media.mime_type
      FROM contacts
      LEFT JOIN media
        ON contacts.picture_id = media.id
      WHERE contacts.id = ? AND contacts.user_id = ?
      LIMIT 1", [id, session[:user_id]]).first

    halt 404, "Contact not found" if @contact.nil?

    erb :"contact"
  end

  get "/login" do
    erb(:"login")
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  post "/login" do
    email = params[:email]
    user = User.select_one(email: email)

    if user.nil?
      status 401
      redirect "/login?error=invalidEmailOrPassword"
      return
    end

    hashed_password = user["password"].to_s
    bcrypt_db_pass = BCrypt::Password.new(hashed_password)

    if bcrypt_db_pass == params[:password]
      session[:user_id] = user["id"]
      redirect "/contacts"
    else
      status 401
      redirect "/login?error=invalidEmailOrPassword"
    end
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params[:email]
      existing_user = User.select_one(email: params[:email])

      if existing_user
        status 400
        redirect "/signup?error=emailInUse"
      end
    end

    if !is_valid_password(params[:password])
      status 400
      redirect "/signup?error=invalidPassword"
    end

    new_user_id = User.insert({
      email: params[:email],
      password: params[:password],
      phone: params[:phone],
      first_name: params[:first_name],
      last_name: params[:last_name],
    })

    session[:user_id] = new_user_id

    redirect "/contacts"
  end
end
