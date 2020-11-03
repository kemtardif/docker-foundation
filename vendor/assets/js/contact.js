/**	CONTACT FORM
*************************************************** **/
var _hash = window.location.hash;

/**
	BROWSER HASH - from php/contact.php redirect!

	#alert_success 		= email sent
	#alert_failed		= email not sent - internal server error (404 error or SMTP problem)
	#alert_mandatory	= email not sent - required fields empty
**/	jQuery(_hash).show();

/* Jorge Contact form refresh after submit and success alert */
// $(document).ready(function(){
//   $("#cForm").submit(function(){
// 	  $("#cForm")[0].reset();
// 	  alert("Thank you for your message! We will get back to you ASAP!");
//   });
// })

	

