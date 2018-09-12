window.ctrlGoogleMap = new google.maps.Map(document.getElementById("controlAddIn"),
    {
        center: new google.maps.LatLng(59.21900119999999,10.2917958),
        zoom: 1,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });
 Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ControlReady', []); 
//document.getElementById("controlAddIn").innerHTML = '<SPAN>HELLO</SPAN>';
