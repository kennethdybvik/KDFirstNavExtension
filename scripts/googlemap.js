var ShowAddress = (function () {
    function geolocate(address, callback) {
        window.ctrlGoogleMap = new google.maps.Map(document.getElementById("controlAddIn"),
        {
          center: new google.maps.LatLng(59.21900119999999,10.2917958),
          zoom: 8,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        });
        var geocoder = new google.maps.Geocoder(),
            location = null;

        geocoder.geocode(
            { "address": address },
            function (results, status) {
                if (status === google.maps.GeocoderStatus.OK)
                    callback(new google.maps.LatLng(
                        latitude = results[0].geometry.location.lat(),
                        longitude = results[0].geometry.location.lng()));
            });
    };

    function showAddress(address) {
        geolocate(address, function (pos) {
            ctrlGoogleMap.panTo(pos);
        });
    };

    return showAddress;
})();