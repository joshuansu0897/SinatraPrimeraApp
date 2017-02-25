require 'sinatra'

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
  erb :cast
end

get '/results' do
  "Hello World"
end
