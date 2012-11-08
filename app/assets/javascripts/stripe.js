$(document).ready(function() {
  $("#payment-form").submit(function(event) {
    $('.submit-button').attr("disabled", "disabled");

	if (checkForm()) {
	    Stripe.createToken({
	        number: $('.card-number').val(),
	        cvc: $('.card-cvc').val(),
	        exp_month: $('.card-expiry-month').val(),
	        exp_year: $('.card-expiry-year').val(),
			name: $('.card-name').val(),
			address_line1: $('.card-address-1').val(),
			address_line2: $('.card-address-2').val(),
			address_state: $('.card-state').val(),
			address_zip: $('.card-zip').val()
	    }, stripeResponseHandler);
	} else {
		$(".submit-button").removeAttr("disabled");
	}

    return false;
  });
});

function stripeResponseHandler(status, response) {
    if (response.error) {
		$(".payment-errors").html(response.error.message);
		$(".payment-errors").show();
        $(".submit-button").removeAttr("disabled");
    } else {
        var form$ = $("#payment-form");
        var token = response['id'];
        form$.append("<input type='hidden' name='stripeToken' value='" + token + "'/>");
        form$.get(0).submit();
    }
}