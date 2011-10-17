$(document).ready(function() {
	$(".faq_answer").hide();

  $(".faq_question").click(function() {	
  	if ($(this).children(".faq_answer").first().is(':hidden')) {
  		$(this).children("a").first().children("span").first().html("&#9660;");
  	}else{
  		$(this).children("a").first().children("span").first().html("&#9654;");
  	}

    $(this).children(".faq_answer").first().slideToggle();

    
  });
});