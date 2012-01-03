/**
 * MAIN стр с автооризацией
**/

$(document).ready(
function() {
    $("#game-area").gameLoad();
    $("body").mChSBanners();

    console.log($("#game-content"));
    console.log($("#game-content").get());
    
    console.log(document.getElementById("game-content"));
    console.log(document["game-content"]);
    
    function getMovie() {
        var M$ =  navigator.appName.indexOf("Microsoft")!=-1
        return (M$ ? window : document)["BridgeMovie"]
    }
 
    console.log("getMovie = ", getMovie());
    
});

