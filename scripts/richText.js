function addText(text,style) {
    var htmlText = '<div id="TextElement1" style="' + style + '">' + text + '</div>';
    document.getElementById('controlAddIn').style = style;
    document.getElementById('controlAddIn').insertAdjacentHTML("beforeend",htmlText);
}