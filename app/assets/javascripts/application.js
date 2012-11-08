// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function emailChange(email) {
	if (email.value.length > 0) {
		document.getElementById('information-text').style.display="block";
    	document.getElementById('information-text').innerHTML = 'A link to download the purchased gift card will be sent to the email <div style="font-weight:bold;">' + email.value + '.</div>';
	} else {
		document.getElementById('information-text').style.display="none";
	}
};

function checkForm() {
	$(".checkout-row").each(function(i) {
		$(this).find('.error-label').remove();
	});
	
	var didPass = true;
	
	var errorDiv = document.createElement('div');
	errorDiv.innerHTML = 'Required.';
	errorDiv.setAttribute("class", "error-label span1");
	
	if ($(".recipient-email").val().length == 0) {
		$(".recipient-email").parent().parent().append(errorDiv.cloneNode(true));
		didPass = false;
	}
	
	if(didPass) {
		if(!isValidEmailAddress($(".recipient-email").val())) {
			var invalidDiv = document.createElement('div');
			invalidDiv.innerHTML = 'Invalid.';
			invalidDiv.setAttribute("class", "error-label span1");
			$(".recipient-email").parent().parent().append(invalidDiv.cloneNode(true));
			didPass = false;
		}
	}
	
	if ($(".recipient-name").val().length == 0) {
		$(".recipient-name").parent().parent().append(errorDiv.cloneNode(true));
		didPass = false;
	}
	
	if ($(".card-name").val().length == 0) {
		$(".card-name").parent().parent().append(errorDiv.cloneNode(true));
		didPass = false;
	}
	
	if ($(".card-number").val().length == 0) {
		$(".card-number").parent().parent().append(errorDiv.cloneNode(true));
		didPass = false;
	}
	
	if ($(".card-cvc").val().length == 0) {
		$(".card-cvc").parent().parent().append(errorDiv.cloneNode(true));
		didPass = false;
	}
	
	if ($(".sender-email").val().length == 0) {
		$(".sender-email").parent().parent().append(errorDiv.cloneNode(true));
		didPass = false;
	}
	
	if ($(".card-address-1").val().length == 0) {
		$(".card-address-1").parent().parent().append(errorDiv.cloneNode(true));
		didPass = false;
	}
	
	if ($(".card-city").val().length == 0) {
		$(".card-city").parent().parent().append(errorDiv.cloneNode(true));
		didPass = false;
	}
	
	if ($(".card-state").val().length == 0) {
		$(".card-state").parent().parent().append(errorDiv.cloneNode(true));
		didPass = false;
	}
	
	if ($(".card-zip").val().length == 0) {
		$(".card-zip").parent().parent().append(errorDiv.cloneNode(true));
		didPass = false;
	}
	
	return didPass;
}

function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
    return pattern.test(emailAddress);
};


