require 'sinatra'
require_relative './models/user.rb'
require_relative './models/contact.rb'
require 'dotenv/load'

class App < Sinatra::Base
  use Rack::Session::Cookie, key: 'rack.session',
                             path: '/',
                             secret: ENV['SESSION_SECRET']

  helpers do
    def protected!
      @is_signed_in = authorized?
      return if @is_signed_in
      redirect '/login'
    end

    def authorized?
      !!session[:user_id]
    end
  end

  get '/test' do
    @users = User.select_many({})
    erb(:"test")
  end

  get '/' do
    protected!
    redirect '/contacts'
  end

  get '/contacts' do
    protected!

    @contacts = Contact.select_many()

    erb(:"contacts")
  end

  get '/login' do
    if authorized?
      redirect '/contacts'
    else
      erb(:"login")
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  post '/login' do
    email = params[:email]
    user = User.select_one({ email: email })

    if user.nil?
      status 401
      redirect '/login?error=invalidEmailOrPassword'
      return
    end

    hashed_password = user['password'].to_s
    bcrypt_db_pass = BCrypt::Password.new(hashed_password)

    if bcrypt_db_pass == params[:password]
      session[:user_id] = user['id']
      redirect '/contacts'
    else
      status 401
      redirect '/login?error=invalidEmailOrPassword'
    end
  end
end
