require "sinatra"
require "sinatra/reloader"
require "sinatra/activerecord"
require "sinatra/base"
require "active_record"
require "uri"
require "haml"
require "bundler/setup"
require "logger"

# App
require "./helpers.rb"
require "./models.rb"

dbconfig = YAML.load(File.read("config/database.yml"))
RACK_ENV ||= ENV["RACK_ENV"] || "development"
PER_PAGE = 6
ActiveRecord::Base.establish_connection dbconfig[RACK_ENV]
Dir.mkdir('log') if !File.exists?('log') || !File.directory?('log')
ActiveRecord::Base.logger = Logger.new(File.open("log/#{RACK_ENV}.log", "a+"))


## actions ##
  get "/" do
    @products = Product.all(:limit => PER_PAGE * 3)
    haml :products_index
  end

  ## products ##
  get "/products" do
    @products = Product.all(:limit => PER_PAGE * 3)
    haml :products_index
  end

  get '/products/next/:index' do
    @products = Product.all(:limit => PER_PAGE, :offset => params[:index].to_i * PER_PAGE)
    haml :products_next, :layout => false
  end

  get "/products/new" do
    protected!
    @product = Product.new
    haml :products_new
  end

  get "/products/admin" do
    protected!
    @products = Product.all
    haml :products_admin
  end

  get "/products/:id/edit" do
    protected!
    @product = Product.find(params[:id])

    haml :products_new
  end

  post "/products/:id" do
    protected!
    @product = Product.find(params[:id])
    @product.update_attributes(params[:product])
    if @product.save
      redirect '/products/admin'
    else
      @errors = true
      haml :products_new
    end
  end

  post "/products" do
    protected!
    @product = Product.new(params[:product])
    if @product.save
      redirect "/products"
    else
      @errors = true
      haml :products_new
    end
  end


  ## categories ##
  get "/categories" do
    protected!
    @categories = Category.all
    haml :categories_index
  end

  get "/categories/new" do
    protected!
    @category = Category.new
    haml :categories_new
  end

  post "/categories" do
    protected!
    @category = Category.new(params[:category])
    if @category.save
      redirect "/categories"
    else
      @errors = true
      haml :categories_new
    end
  end

  get "/categories/:id/edit" do
    protected!
    @category = Category.find(params[:id])

    haml :categories_new
  end

  post "/categories/:id" do
    protected!
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect '/categories'
    else
      @errors = true
      haml :categories_new
    end
  end