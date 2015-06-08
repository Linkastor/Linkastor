function reloadLinks(){
	var url = $('#links').attr("data");

	$.ajax({
		url: url,
		dataType: "html",
		success: function (data) {
			$('#links').html(data);
			console.log(data);
		},
		error: function(error) {
			console.log("error ", error);
		}
	});
};

$(function () {

	$('#share_link').submit(function(event){
		event.preventDefault();

		var url = $(this).find('input#url').val();	
		var title = $(this).find('input#title').val();
		var token = $(this).find('input#token').val();

		var postData = {auth_token: token, link: {title: title, url: url}};

		var actionUrl = event.currentTarget.action;
		
		$.ajax({
	        url: actionUrl,
	        type: 'post',
	        data: postData,
	        success: function(data) {
	        	reloadLinks();
	        },
	        error: function(error) {
	        	alert("Error");
	        }
	    });
	});

	reloadLinks();
});