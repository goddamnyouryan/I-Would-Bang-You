$(document).ready(function(){

	$("#new_user_signup input[type=text]").focus(function() {
		$(this).next().slideDown();
	});
	$("#new_user_signup input[type=email]").focus(function() {
		$(this).next().slideDown();
	});
	$("#new_user_signup input[type=password]").focus(function() {
		$(this).next().slideDown();
	});
	
	$('#user_birthday').val($('#user_birthday_3i').val()+'/'+ $('#user_birthday_2i').val()+'/'+ $('#user_birthday_1i').val());
	
	$('#user_birthday_3i,#user_birthday_2i,#user_birthday_1i').change(function() {  
	  $('#user_birthday').val($('#user_birthday_3i').val()+'/'+ $('#user_birthday_2i').val()+'/'+ $('#user_birthday_1i').val());
	});
	
	jQuery.validator.addMethod("noSpace", function(value, element) { 
		return value.indexOf(" ") < 0 && value != ""; 
	}, "No space please and don't leave it empty");
	
	jQuery.validator.addMethod("ofAge", function(value, element) { 
		return Date.parse($("#user_birthday").val()) < (18).years().ago();
	}, "You must be 18 years old to join.");
	
	$.validator.addMethod("roles", function(value, elem, param) {
	    if($(".looking_for:checkbox:checked").length > 0){
	       return true;
	   }else {
	       return false;
	   }
	},"You must select at least one!");
	
	
  $("#new_user_signup").validate({
		rules: {
			looking_for: {
				required: true,
				minlength: 1
			},
			"user[zip]": {required: true },
			"user[login]": {required: true, remote:"/users/check_login", minlength: 3, maxlength: 15, noSpace: true },
			"user[email]": {
				required: true,
				email: true
			},
			"user[sex]": "required",
			"user[password]": {
				required: true,
				minlength: 6
			},
			"user[birthday]": {
				required: true,
				date: true,
				ofAge: true
			},
			"user[terms]": "required"
		},
		messages: {
			"user[login]": {
				required: "You must create a username.",
				remote: "This username has already been chosen.",
				maxlength: "Must be at least 3 characters.",
				maxlength: "Username must be 15 characters max.",
				noSpace: "No spaces in usernames please."
			},
			looking_for: {
				required: "You have to select at least one!",
				minlength: "You have to select at least one!"
			},
			"user[birthday]": {
				required: "Please enter your birthday.",
				date: "Please enter your birthday."
			}
		},
		errorPlacement: function(error, element) {
			if (element.attr("name") == "user[birthday]")
				error.insertAfter("#birthday");
			else if (element.attr("name") == "looking_for")
				error.insertAfter("#looking_for");
			else if (element.attr("name") == "user[terms]")
				error.insertAfter("#terms");
			else
 				error.insertAfter(element);
		}
	});
	
	if ($(".flash").length > 0) {
		$('.flash').delay(2000).slideUp('fast');
	}
	
});
