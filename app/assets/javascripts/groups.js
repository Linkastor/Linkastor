function reloadLinks(){
	var url = $('#links').attr("data");
	var page = $('#links').attr("page");

	$.ajax({
		url: url + '?page=' + page,
		dataType: "html",
		success: function (data) {
			$('#links').html(data);
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
	        	$('#links').attr("page", 1);
	        	reloadLinks();
	        	$('#share_link')[0].reset();
	        },
	        error: function(error) {
	        	alert("Error");
	        }
	    });
	});

	reloadLinks();

	$('#older_link').click(function(event){
		event.preventDefault();

		var page = parseInt($('#links').attr("page"));

		$('#links').attr("page", (page+1));

		reloadLinks();
	})
});