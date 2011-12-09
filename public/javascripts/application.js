$(document).ready(function(){
	
	var height = $(document).height() - 310;
	$("div.logged_in").css('height', height + "px")
	
	$("li#profile").hover(function () {
		if ($("ul#subnav").is(":hidden")) {
			$("ul#subnav").show();
		} else {
			$("ul#subnav").hide();
		}
		return false;
	});

	if ($("#profile").width() > 175) {
		$("#subnav").css("padding", "60px 15px 10px 60px");
	}
	
	if ($('.promo').length == 3) {
		$(".promo:first").addClass("first");
	} else if ($('.promo').length == 2) {
		$(".promo:first").addClass("second");
	} else if ($('.promo').length == 1) {
		$(".promo:first").addClass("third");
	}
	
	$("nav#user a#left-link").live("click", function(e) {
		if ($("ul#photos").is(":hidden")) {
			$("ul#photos").show();
			$("div#about").hide();
			$("div.logged_in").css('height', "0")
			var height = $(document).height() - 310;
			$("div.logged_in").css('height', height + "px")
			$("nav#user a#left-link").addClass("current");
			$("nav#user a#right-link").removeClass("current");
		}
		return false;
	});
	
	$("nav#user a#right-link").live("click", function(e) {
		if ($("div#about").is(":hidden")) {
			$("div#about").show();
			$("ul#photos").hide();
			$("div.logged_in").css('height', "0")
			var height = $(document).height() - 310;
			$("div.logged_in").css('height', height + "px")
			$("nav#user a#right-link").addClass("current");
			$("nav#user a#left-link").removeClass("current");
		}
		return false;
	});
	
	if ($(".flash").length > 0) {
		$('.flash').delay(2000).slideUp('fast');
	}
	
	$("nav#account_settings ul li a").live("click", function() {
		newContent = "#" + $(this).attr('name')
		oldContent = "#" + $('.current').attr('name')
		$(oldContent).hide();
		$('.current').removeClass("current");
		$(newContent).show();
		$(this).addClass("current");
		return false
	});

});

$(window).resize(function(){
	$("div.logged_in").css('height', "0")
	var height = $(document).height() - 310;
	$("div.logged_in").css('height', height + "px")
});