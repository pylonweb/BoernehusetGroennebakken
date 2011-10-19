$(document).ready(function() {
	$(".faq_answer").hide();
	
//	$("#left_sidebar").height($("#right_contentbar").height());

  $(".faq_question").click(function() {	
  	if ($(this).children(".faq_answer").first().is(':hidden')) {
  		$(this).children("a").first().children("span").first().html("&#9660;");
  	}

		$(this).children(".faq_answer").first().slideToggle(function(){
			if ($(this).is(':hidden')){
				$(this).parents(".faq_question").children("a").first().children("span").first().html("&#9658;");
			}
		});

    
  });
});