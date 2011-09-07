require File.dirname(__FILE__) + "/spec_helper"

describe Product do
  it "should validates_presence_of :image_url, :title, :link " do
    p = Product.new
    p.should_not be_valid
    v = Product.new(:image_url => '2', :title => '2', :link => '2')
    v.should be_valid
  end

  it "should have all necessary fields" do
    p = Product.new
    [:title, :link, :image_url].each do |field|
      p.respond_to?(field).should be_true
    end
  end
  
  it "should have methods" do
    p = Product.new
    [:hello].each do |meth|
      p.respond_to?(meth).should be_true
    end
  end
  
  ## methods ##
  context "hello" do
    it "should return world" do 
      Product.new.hello.should == "world"
    end
  end
end

describe "Product Actions" do
  def app
    @app ||= Sinatra::Application
  end
  
  let(:form_attributes) {
    Product.new.attributes.keys - ['created_at', 'updated_at']
  }

  context "acceptance" do
    before(:each) do
      authorize "frank", "sinatra"
    end

    it "should have form fields for each attribute" do
      get '/products/new'
      form_attributes.each{|attr, _|
        last_response.body.should =~ /product\[#{attr}\]/m
      }
    end
  end

  context "get" do
    before(:all) do
      Product.delete_all
      @prod = Product.create(:image_url => 'http://google.com/google.png', :title => "google", :link => 'link')
    end

    before(:each) do
      authorize "frank", "sinatra"
    end

    ["/products", "/products/next/:index", "/products/new", "/products/admin"].each do |url|
      it "should render page #{url}" do
        get url
        last_response.should be_ok
      end
    end

    it "should render page /products/1/edit" do
      get "/products/#{@prod.id}/edit"
      last_response.should be_ok
    end

    it "/products/next/2 should return collection with offset" do
      Product.delete_all
      10.times {|i|
        Product.create(:image_url => 'http://google.com/google.png', :title => "p#{i}", :link => "link#{i}")
      }
      get "products/next/1"
      last_response.should be_ok
      last_response.body.should =~ /p3/m # watch out of default scope!
    end
  end

  context "post" do
    before(:each) do
      authorize "frank", "sinatra"
      Product.delete_all
    end

    context "invalid" do
      it "should return errors when new product is invalid" do
        expect {
          post "/products", :product => {:title => "lala"}
        }.to_not change{Product.count}
      end

      it "should return errors while trying to edit unknown product" do
        expect {
          post "/products/999", :product => {:title => "lala"}
        }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should return errors when trying to update product with invalid data" do
        prod = Product.create(:title => "lala", :link => "http://link.com", :image_url => "http://something.jpg")
        
        post "/products/#{prod.id}", :product => {:link => ''}
        last_response.status.should_not == 302
        last_response.headers["location"].should_not == "http://example.org/products/admin"
                
        up = Product.find(prod.id)
        up.link.should == "http://link.com"
      end
    end

    context "valid" do
      it "should create valid product" do
        expect {
          post "/products", :product => {:title => "lala", :link => "http://link.com", :image_url => "http://something.jpg"}
        }.to change{Product.count}

        last_response.status.should == 302
        last_response.headers["location"].should == "http://example.org/products"
      end

      it "should update valid product" do
        p = Product.create(:image_url => 'http://google.com/google.png', :title => "something", :link => 'link')
        post "/products/#{p.id}", :product => {:title => 'something new'}
        last_response.status.should == 302
        last_response.headers["location"].should == "http://example.org/products/admin"

        p2 = Product.find(p.id)
        p2.title.should == 'something new'
      end
    end

  end
end