$(document).ready(function() {
    if ($("#map").length > 0) initMap();
});


function initMap() {

    var POS_VIENNA = [48.2091477000000, 16.3729087000004];

    $.getScript("http://app.pl8.cc/web/dailycious/list", function onMapDataLoaded() {

        var map = L.map('map', {
            center: POS_VIENNA,
            zoom: 14
        });

        L.tileLayer('http://{s}.{base}.maps.cit.api.here.com/maptile/2.1/maptile/{mapID}/terrain.day/{z}/{x}/{y}/256/png8?app_id={app_id}&app_code={app_code}', {
            attribution: 'Map &copy; 1987-2014 <a href="http://developer.here.com">HERE</a>',
            subdomains: '1234',
            mapID: 'newest',
            app_id: 'hHpP1qoYgHHkHOvkZkHm',
            app_code: '_eOS4Wz6tkek27HoFF6gUg',
            base: 'aerial',
            minZoom: 0,
            maxZoom: 20,
            detectRetina: true
        }).addTo(map);



        var markers = L.markerClusterGroup({
            showCoverageOnHover: false
        });


        for (var i = 0; i < locations.length; i++) {

            var _icon = L.divIcon({
                html: '<img src="' + locations[i][7] +'">',
                iconSize:     [40, 48],
                iconAnchor:   [20, 48],
                popupAnchor:  [0, -48]
            });

            var title = locations[i][0];

            var marker = L.marker(new L.LatLng(locations[i][3], locations[i][4]), {
                title: title,
                icon: _icon
            });

            markers.addLayer(marker);
        }

        map.addLayer(markers);

        $('.geo-location').on("click", function() {
            $('#map').addClass('fade-map');
            map.locate({
                setView : true
            });
        });

        map.on('locationfound', function onLocationFound(){
            $('#map').removeClass('fade-map');
        });

        map.on('locationerror', function onLocationError(e){
            $('#map').removeClass('fade-map');
            console.log(e);
        });

        $('body').addClass('loaded');

        setTimeout(function() {
            $('body').removeClass('has-fullscreen-map');
        }, 1000);

        $('#map').removeClass('fade-map');


    });
}