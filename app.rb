require 'sinatra'
require 'rubygems'
require 'bcrypt'
require 'yaml/store'

get '/' do
  if login?
    @titulo = 'Que pedo raza, que hay pa la cena?'
    erb :index
  else
    @titulo = 'Inicia Secion morro'
    erb :inicia
  end
end

Choices = {
  'ATU' => 'Atun',
  'ARR' => 'Arroz',
  'NA' => 'Nada',
  'SO' => 'Soy Foreano',
}

post '/cast' do
  if login?
    @titulo = 'Gracias por votar morrito'
    @vote  = params['vote']
    @store = YAML::Store.new 'votes.yml'
    @store.transaction do
      @store['votes'] ||= {}
      @store['votes'][@vote] ||= 0
      @store['votes'][@vote] += 1
    end
    erb :cast
  else
    @titulo = 'Inicia Secion morro'
    erb :inicia
  end
end

get '/results' do
  if login?
    @titulo = 'Los resultados morro'
    @store = YAML::Store.new 'votes.yml'
    @votes = @store.transaction { @store['votes'] }
    erb :results
  else
    @titulo = 'Inicia Secion morro'
    erb :inicia
  end
end


enable :sessions

userTable = {}

helpers do

  def login?
    if session[:username].nil?
      erb :login
      return false
    else
      return true
    end
  end

  def username
    return session[:username]
  end

end

get "/signup" do
  @titulo = 'Pon la contra y el usuario morro'
  erb :signup
end

post "/signup" do
  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  password_check = BCrypt::Engine.hash_secret(params[:checkpassword], password_salt)

  #ideally this would be saved into a database, hash used just for sample
  if :password == :checkpassword
    userTable[params[:username]] = {
      :salt => password_salt,
      :passwordhash => password_hash
    }

    session[:username] = params[:username]
    redirect "/"
  else
    @titulo = 'escribe bien la contra morro'
    erb :signup
  end
end

get '/login' do
  @titulo = 'Dame los datos morro'
  erb :login
end

post "/login" do
  if userTable.has_key?(params[:username])
    user = userTable[params[:username]]
    if user[:passwordhash] == BCrypt::Engine.hash_secret(params[:password], user[:salt])
      session[:username] = params[:username]
      redirect "/"
    end
  end
  @titulo = 'Datos mal morro, ponte vergas'
  erb :login
end

get "/logout" do
  session[:username] = nil
  redirect "/"
end

#post '/cast' do
#  @titulo = 'Gracias por votar morrito'
#  @vote  = params['vote']
#  erb :cast
#end

#get '/results' do
#  @votes = { 'ATU' => 7, 'ARR' => 5, 'NA' => 3 }
#  erb :results
#end
