$(document).ready(function() {
	$(".faq_answer").hide();

  $(".faq_question").click(function() {	

    $(this).children(".faq_answer").first().slideToggle();
  });
});