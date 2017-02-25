$(document).on('ready page:load', function() {
  if ( $("#lamp").length ) new Lamp();
});

var Lamp = function() {
	var $button = $("#lamp_switcher"),
	    status = ($("#lamp").attr("data-status") == "ON" ? true : false);

	function displayStatus() {
      var $display = $button.find("span");
      if (status && !$display.hasClass("active")) $display.addClass("active");
      else if (!status) $display.removeClass("active");
	}

	function changeStatus(new_status) {
      Requests.set_lamp_status(new_status,
      	function(response){
      		status = (response.status == "true" ? true : false);
      		displayStatus();
      		$button.attr("disabled", false);
      	},
      	function(response){ 
      		$button.attr("disabled", false);
      		console.log(response.message)
      	}
      );
	};

	$(document).on("click", "#lamp_switcher", function(){
		$button.attr("disabled", true);
        changeStatus(!status);
	});

}
