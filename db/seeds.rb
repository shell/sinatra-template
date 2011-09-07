5.times {|i|
  Category.create(:name => "Category #{i}")
}

10.times {|i|
  Product.create(:title => "Product #{i}", :link => "http://example.com/#{i}", :image_url => "http://placekitten.com/g/96/139", :category_id => rand(5)+1)
}