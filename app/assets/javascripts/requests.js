var Requests = new function() {
  var error_message = "Something went wrong!";

  this.set_lamp_status = function(status, success_callback, error_callback) { 
    $.ajax({
      type: "post",
      url: '/lamp/set_status',
      data: { status: status },
      error: function(response) { error_callback(error_message) },
      success: function(response){
        if (response && response.success) success_callback(response);
        else error_callback(response);
      }
    });
  };
};