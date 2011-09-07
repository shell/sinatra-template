$(function() {

  // initialize scrollable
  $(".scrollable").scrollable();
  
  $('a.next').live('click', function() {
    var api = $(".scrollable").data("scrollable");
    next_url = "/products/next/"+api.getIndex()
    next_url += "?category_id=" + $("#category_id").val()
    $.get(next_url, function(data) {
      api.addItem(data);
      $("#page_number").html(api.getIndex()+1);
      // $('.items').append(data);
      // $(".scrollable").scrollable();
      
      
    })
  })
  
  $('a.prev').live('click', function(){
    var api = $(".scrollable").data("scrollable");
    $("#page_number").html(api.getIndex()+1);
  })
});