require File.dirname(__FILE__) + "/spec_helper"

describe "App" do
  def app
    @app ||= Sinatra::Application
  end

  context "basic http" do
    ["/products/admin", "/products/new", "/categories", "/categories/new"].each do |url|
      it "should require http_authentication #{url}" do
        get url
        last_response.status.should == 401
      end

      it "should not render with bad credentials #{url}" do
        authorize "bad", "boy"
        get url
        last_response.status.should == 401
      end

      it "should render well with good creds #{url}" do
        authorize "frank", "sinatra"
        get url
        last_response.should be_ok
      end
    end

    ["/", "/products", "/products/next/1"].each do |url|
      it "should respond to #{url} and not require http_authentication" do
        get url
        last_response.should be_ok
      end
    end
    
    it "should return the correct content-type" do
      get "/"
      last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
    end

    it "should return 404 status when page cannot be found" do
      get "/404"
      last_response.status.should == 404
    end
  end
end