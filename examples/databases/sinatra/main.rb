require 'sinatra'
# if development is optional
require 'sinatra/reloader' if development?
# gem is for postgres
require 'pg'
# for debugging
# require 'pry'
# for colors in our terminal
require 'rainbow'

helpers do
  def run_sql(sql)
    db = PG.connect(:dbname => 'address_book', :host => 'localhost')
    result = db.exec(sql)
    db.close
    return result
  end
end

get '/' do
  # this prints to sinatra's server logs in terminal
  puts "This is the index"
  erb :index
end

# shows all contacts
get '/contacts' do
  puts "we're connecting to the database"
  db = PG.connect(:dbname => 'address_book', :host => 'localhost')
  sql = "SELECT * FROM contacts"
  @contacts = db.exec("SELECT * FROM contacts")
  db.close
  puts "database is closed"
  erb :contacts
end

post '/contacts' do
  first = params[:first]
  last = params[:last]
  age = params[:age]
  sql = "INSERT INTO contacts (first, last, age) VALUES ('#{first}', '#{last}', #{age})"
  db = PG.connect(:dbname => 'address_book', :host => 'localhost')
  db.exec(sql)
  db.close
  redirect to '/contacts'
end

get '/contacts/:id/edit' do
  @id = params[:id]
  db = PG.connect(:dbname => 'address_book', :host => 'localhost')
  sql = "SELECT * FROM contacts WHERE id = #{@id}"
  @contact = db.exec(sql).first
  db.close

  erb :edit
end

# Make a new contact
get '/contacts/new' do
  erb :form
end

# show one specific contact
get '/contacts/:id' do
  @id = params[:id]
  db = PG.connect(:dbname => 'address_book', :host => 'localhost')
  sql = "SELECT * FROM contacts WHERE id = '#{@id}'"
  @contact = db.exec(sql).first
  db.close
  erb :contact
end

post '/contacts/:id' do
  id = params[:id]
  first = params[:first]
  last = params[:last]
  age = params[:age]
  db = PG.connect(:dbname => 'address_book', :host => 'localhost')
  sql = "UPDATE contacts SET (first, last, age) = ('#{first}', '#{last}', #{age}) WHERE id = #{id}"
  db.exec(sql)
  db.close
  redirect to '/contacts'
end
