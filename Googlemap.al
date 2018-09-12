controladdin ctrlGoogleMap
{
    Scripts = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyCP5e_DIRj_kImNXuWB8SyvELdtNFrzmVw','scripts/googlemap.js';
    StartupScript = 'scripts/start.js';
   
    RequestedHeight = 350;
    RequestedWidth = 350;
    MinimumHeight = 250;
    MinimumWidth = 250;
    MaximumHeight = 700;
    MaximumWidth = 700;
    VerticalShrink = true;
    HorizontalShrink = true;
    VerticalStretch = true;
    HorizontalStretch = true;
    event ControlReady();
    procedure ShowAddress(Address: Text);
}