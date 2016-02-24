$(document).ready(function() {

  function stringStartsWith (string, prefix) {
    return string.slice(0, prefix.length) == prefix;
  }

  $("#login_form").submit(function(event) {
    event.preventDefault();
    var form_data = $("#login_form").serialize();
    var url = "/generator"
    $.post("/login", form_data, function(data){
      if (data == "User does not exist") {
        $("#result").html(data);
      } else if (data == "Password incorrect"){
        $("#result").html(data);
      } else {
        window.location.href = url;
      }
    });
  });

  $("#register_form").submit(function(event) {
    event.preventDefault();
    var form_data = $("#register_form").serialize();
    var url = "/generator"
    $.post("/save_user", form_data, function(data){
      //console.log(data);
      if (data == "Your passwords do not match, please retype.") {
        $("#result").html(data);
      } else if (data == "Your email is already registered.") {
        $("#result").html(data);
      } else {
        window.location.href = url;
      }
    });
  });

  $("#bitly").submit(function(event) {
    event.preventDefault();
    var form_data = $("#bitly").serialize();
    $.post("/urls", form_data, function(data){
      $("#result").html(data);
    });
  });

});