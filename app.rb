require 'sinatra'
require 'rubygems'
require 'bcrypt'
require 'pony'
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

get "/signup" do
  @titulo = 'Pon la contra y el usuario morro'
  erb :signup
end

post "/signup" do
  if !true
  else
    @titulo = 'escribe bien la contra morro o el correo'
    erb :signup
  end
end

get '/login' do
  @titulo = 'Dame los datos morro'
  erb :login
end

post "/login" do
  @titulo = 'Datos mal morro, ponte vergas'
  erb :login
end

get "/logout" do
  session[:username] = nil
  redirect "/"
end

get "/perfil" do
  @titulo = "Hola #{username}"
  erb :perfil
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
