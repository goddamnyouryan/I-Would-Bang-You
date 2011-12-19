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
	
	//if ($(".flash").length > 0) {
	//	$('.flash').delay(2000).slideUp('fast');
	//}
	
	$("nav#account_settings ul li a").live("click", function() {
		newContent = "#" + $(this).attr('name')
		oldContent = "#" + $('.current').attr('name')
		$(oldContent).hide();
		$('.current').removeClass("current");
		$(newContent).show();
		$(this).addClass("current");
		return false
	});
	
	$('.disable').live("ajax:beforeSend", function(){
		var height = $(".disable").height() + "px";
		$(this).attr("href", "/")
		$(this).html("<img alt='Disable' src='/images/disable.gif' />");
		$(this).css("height", height);
	})

});

$(window).load(function(){
	infinityBoxSize();
});

$(window).resize(function(){
	$("div.logged_in").css('height', "0")
	var height = $(document).height() - 310;
	$("div.logged_in").css('height', height + "px")
});

function infinityBoxSize() {

	if ($('.profile-infinity-box-left').length > 0) {
		$('body').prepend("<div class='infinity-left'>&nbsp</div>");
		$('.profile-infinity-box-left').after("<div class='infinity-left-corner'>&nbsp</div>");
		var width = Math.round(($(window).width() - 1140)/2) + "px";
		var height = $(".profile-infinity-box-left").outerHeight() + "px";
		var top = Math.round($('.profile-infinity-box-left').offset().top) + "px";
		var left = $(".profile-infinity-box-left").outerWidth() - 197 + "px";
		$('.infinity-left').css('width', width);
		$('.infinity-left').css('height', height);
		$('.infinity-left').css('top', top);
		$('.infinity-left-corner').css('margin-top', height);
		$('.infinity-left-corner').css('margin-left', left);
		if ($('.profile-infinity-box-left').hasClass("fixed")) {
			$('.infinity-left').addClass('fixed');
			$('.infinity-left-corner').addClass('fixed');
		}
	}
	
}