$(document).ready(function() {
	var BROWSER_KEY = "AIzaSyAyajrY-zfFIp0le6OmZFObmiOed9dY11U";
	var mapsBaseUrl = "https://maps.googleapis.com/maps/api/staticmap?zoom=16&maptype=roadmap&key=" + BROWSER_KEY;
	var gmapElements = $(".gmaps-background");
	
	$(gmapElements).each(function(e, i) {
		var position = $(this).data("latlon");
		var backgroundWidth = $(this).width();
		var backgroundHeight = $(this).height();
		var backgroundUrl = mapsBaseUrl + "&size=" + backgroundWidth + "x" + backgroundHeight + "&center=" + position + "&markers=" + position;
		$(this).css("backgroundImage", "url(" + backgroundUrl + ")");
	});
});