$(document).ready(function () {
	$('.toggle-expansion-button').click(function () {
		$(this).closest('.mui-panel').toggleClass('expanded-panel');
	});
});