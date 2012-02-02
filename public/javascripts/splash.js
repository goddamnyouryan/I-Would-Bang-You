$(document).ready(function(){

	$("#new_user_signup input[type=text]").focus(function() {
		resizeInfinity();
		$(this).next().slideDown();
	});
	$("#new_user_signup input[type=email]").focus(function() {
		$(this).next().slideDown();
		resizeInfinity();
	});
	$("#new_user_signup input[type=password]").focus(function() {
		$(this).next().slideDown();
		resizeInfinity();
	});
	
	$('#user_birthday').val($('#user_birthday_2i').val() +'/'+ $('#user_birthday_3i').val() +'/'+ $('#user_birthday_1i').val());
	
	$('#user_birthday_3i,#user_birthday_2i,#user_birthday_1i').change(function() {  
	  $('#user_birthday').val($('#user_birthday_2i').val()+'/'+ $('#user_birthday_3i').val()+'/'+ $('#user_birthday_1i').val());
	});
	
	$.validator.addMethod("noSpace", function(value, element) { 
		return value.indexOf(" ") < 0 && value != ""; 
	}, "No space please and don't leave it empty");
	
	$.validator.addMethod("ofAge", function(value, element) { 
		return Date.parse($("#user_birthday").val()) < (18).years().ago();
	}, "You must be 18 years old to join.");
	
	$.validator.addMethod("roles", function(value, elem, param) {
	    if($(".looking_for:checkbox:checked").length > 0){
	       return true;
	   }else {
	       return false;
	   }
	},"You must select at least one!");
	
	$.validator.addMethod("characters", function(value, element) {
	    return this.optional(element) || !(/:|\?|\\|\.|\*|\"|<|>|\||%/g.test(value));
	},
	    "Usernames can't have special characters.");
	
	
  $("#new_user_signup").validate({
		rules: {
			looking_for: {
				required: true,
				minlength: 1
			},
			"user[zip]": {required: true },
			"user[login]": {required: true, remote:"/users/check_login", minlength: 3, maxlength: 15, noSpace: true, characters: true },
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
	
	$("#contact_form").validate({
		rules: {
			name: "required",
			email: {
				required: true,
				email: true
			},
			message: "required"
		}
	})
	
	//if ($(".flash").length > 0) {
	//	$('.flash').delay(2000).slideUp('fast');
	//}
	
	resizeInfinity();
	
});

function resizeInfinity() {
	//if ($('.infinity-box-left').length > 0) {
	//	$('body').prepend("<div class='infinity-left'>&nbsp</div>");
	//	$('body').prepend("<div class='infinity-left-corner'>&nbsp</div>");
	//	var width = Math.round(($(window).width() - 1140)/2) + "px";
	//	var height = $(".infinity-box-left").outerHeight() + "px";
	//	var top = Math.round($('.infinity-box-left').offset().top) + "px";
	//	var left = Math.round(($(window).width() - 1140)/2) + $(".infinity-box-left").outerWidth() - 197 + "px";
	//	var cornerButt = ($(".infinity-box-left").outerHeight() + Math.round($('.infinity-box-left').offset().top))  + "px";
	//	$('.infinity-left').css('width', width);
	//	$('.infinity-left').css('height', height);
	//	$('.infinity-left').css('top', top);
	//	$('.infinity-left-corner').css('top', cornerButt);
	//	$('.infinity-left-corner').css('left', left);
	//}
	if ($('.infinity-box-right').length > 0) {
		$('body').prepend("<div class='infinity-right'>&nbsp</div>");
		$('.infinity-box-right').after("<div class='infinity-right-corner'>&nbsp</div>");
		var width = Math.round(($(window).width() - 1140)/2) + "px";
		var height = $(".infinity-box-right").outerHeight() + "px";
		var top = Math.round($('.infinity-box-right').offset().top) + "px";
		var right = Math.round(($(window).width() - 1140)/2) + $(".infinity-box-right").outerWidth() - 197 + "px"
		var cornerTop = Math.round($('.infinity-box-right').offset().top) + $(".infinity-box-right").outerHeight() + "px";
		$('.infinity-right-corner').css('margin-right', right);
		$('.infinity-right-corner').css('margin-top', cornerTop);
		$('.infinity-right').css('width', width);
		$('.infinity-right').css('height', height);
		$('.infinity-right').css('top', top);
	}
}