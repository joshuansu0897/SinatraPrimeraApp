require 'sinatra'
require 'yaml/store'

get '/' do
  @titulo = 'Que pedo raza, que hay pa la cena?'
  erb :index
end

Choices = {
  'ATU' => 'Atun',
  'ARR' => 'Arroz',
  'NA' => 'Nada',
  'SO' => 'Soy Foreano',
}

post '/cast' do
  @titulo = 'Gracias por votar morrito'
  @vote  = params['vote']
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
    @store['votes'] ||= {}
    @store['votes'][@vote] ||= 0
    @store['votes'][@vote] += 1
  end
  erb :cast
end

get '/results' do
  @titulo = 'Los resultados morro'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
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
