enable :sessions

get '/' do
  # La siguiente linea hace render de la vista 
  # que esta en app/views/index.erb
  session["user"] ||= nil
  erb :index
end

get '/register' do
  #codigo nuevo usuario
  erb :register
end

post '/login' do
  email = params[:user]
  pwd = params[:pwd]
  puts "user: #{email} pwd: #{pwd}"
  user = User.where("email = ?", email).first
  if user == nil
    result = "User does not exist"
  else
    if pwd == user.pwd
      puts "This is user email #{user.email}"
      puts "This is user id #{user.id}"
      session[:user] ||= user.email
      session[:id] ||= user.id
      puts "SESSION USER #{session['user']} SESSION ID #{session['id']}"
      erb :generator
    else
      result = "Password incorrect"
    end
  end
end

post '/save_user' do
  name = params[:name]
  email = params[:email]
  pwd1 = params[:pwd1]
  pwd2 = params[:pwd2]
  email_exist = User.where("email = ?", email).first
  p email_exist
  if (pwd1 != pwd2)
    result = "Your passwords do not match, please retype."
  elsif email_exist != nil
    result = "Your email is already registered."
  else
    user = User.new(name: name, email: email, pwd: pwd1)
    # check = user.save
    # puts "CHECK IS #{check}"
    if user.save!
      session[:user] ||= user.email
      session[:id] ||= user.id
      erb :generator 
    end
  end
end

get '/generator' do
  #codigo checar usuario
  if  session["user"] == nil
    result = "Log in to access this page"
    erb :index
  else
    @user_id = session["id"]
    erb :generator
  end
end

get '/logout' do
  session.clear
  puts "SESSION USER #{session['user']} SESSION ID #{session['id']}"
  erb :index
end

post '/urls' do
  # crea una nueva Url
  original = params[:original_url]
  @user_id = session["id"]
  short = Url.new(url: original, user_id: @user_id)
  puts "VALOR DE SHORT #{short}"
  check = short.save
  puts "CHECK IS #{check}"
  if check == true
    short.save
    result = "<br>Your new shortened URL: <a href='http://localhost:9393/#{short.short_url}' target='_blank'>http://localhost:9393/#{short.short_url}</a>"
  else
    result = "<br>ERROR: #{short.errors.full_messages}"
  end
  result
end

get '/list/:id' do
  #PENDIENTE
  @user = User.find(params[:id])
  @user_urls = @user.urls
  puts @user_urls
  erb :list
end 

# e.g., /q6bda
get '/:short_url' do
  # redirige a la URL original
  short_url = params[:short_url]
  selected_url = Url.where("short_url = ?", short_url).first
  p selected_url
  id = selected_url.id
  puts id
  Url.increment_counter(:click_count, id)
  original_url = selected_url.url
  if original_url.start_with?("http://", "https://")
    redirect to ("#{original_url}")
  else
    redirect to ("http://#{original_url}")
  end
  
end


