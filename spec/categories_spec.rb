require File.dirname(__FILE__) + "/spec_helper"

describe Category do
  it "should validates_presence_of :name" do
    s = Category.new
    s.should_not be_valid
    v = Category.new(:name => 'some')
    v.should be_valid
  end

  it 'should have all necessary fields' do
    p = Category.new
    [:name].each do |field|
      p.respond_to?(field).should be_true
    end
  end
  
  it "should have methods" do
    c = Category.new
    [:name].each do |meth|
      c.respond_to?(meth).should be_true
    end
  end
  
  ## methods ##
  context "to_s" do 
    it "should cast category to string properly" do 
      "#{Category.new(:name => 'cats')}".should == 'cats'
    end
  end
end

describe "Category Actions" do
  def app
    @app ||= Sinatra::Application
  end
  
  let(:form_attributes) {
    Category.new.attributes.keys - ['created_at', 'updated_at']
  }
  
  context "acceptance" do
    before(:each) do
      authorize "frank", "sinatra"
    end

    it "should have form fields for each attribute" do
      get '/categories/new'
      form_attributes.each{|attr, _|
        last_response.body.should =~ /category\[#{attr}\]/m
      }
    end
  end

  context "get" do
    before(:all) do
      Category.delete_all
      @cat = Category.create(:name => "google")
    end

    before(:each) do
      authorize "frank", "sinatra"
    end

    ["/categories", "/categories/new"].each do |url|
      it "should render page #{url}" do
        get url
        last_response.should be_ok
      end
    end

    it "should render page /categories/1/edit" do
      get "/categories/#{@cat.id}/edit"
      last_response.should be_ok
    end
  end

  context "post" do
    before(:each) do
      authorize "frank", "sinatra"
      Category.delete_all
    end

    context "invalid" do
      it "should return errors when new category is invalid" do
        expect {
          post "/categories", :category => {}
        }.to_not change{Category.count}
      end

      it "should return errors while trying to edit unknown category" do
        expect {
          post "/categories/999", :category => {:name => "lala"}
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
      
      it "should return errors when trying to update category with invalid data" do
        cat = Category.create(:name => "lala")
        
        post "/categories/#{cat.id}", :category => {:name => ''}
        last_response.status.should_not == 302
        last_response.headers["location"].should_not == "http://example.org/categories"
                
        uc = Category.find(cat.id)
        uc.name.should == "lala"
      end
    end

    context "valid" do
      it "should create valid category" do
        expect {
          post "/categories", :category => {:name => "lala"}
        }.to change{Category.count}

        last_response.status.should == 302
        last_response.headers["location"].should == "http://example.org/categories"
      end

      it "should update valid category" do
        c = Category.create(:name => "something")
        post "/categories/#{c.id}", :category => {:name => 'something new'}
        last_response.status.should == 302
        last_response.headers["location"].should == "http://example.org/categories"

        c2 = Category.find(c.id)
        c2.name.should == 'something new'
      end
    end

  end
end