window.alert('init');
document.getElementById("controlAddIn").innerHTML = '<SPAN>HELLO</SPAN>';
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ControlReady', []);
