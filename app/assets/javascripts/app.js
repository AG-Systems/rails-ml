/* Set the width of the side navigation to 250px and the left margin of the page content to 250px */
$(document).ready(function () {
    if(window.screen.width >= 765)
    {
        $(".glyphicon-chevron-left").attr('class', '')
    }
});

function openNav() {
    document.getElementById("mySidenav").style.width = "250px";
    document.getElementById("main").style.marginLeft = "250px";
    $("#main2").css("margin-left", "250px");
    $("#sidenavbtn").attr('class', '')
    if(window.screen.width < 766)
    {
        $("p").hide();
        $("h2").hide();
        $("h3").hide();
        $(".container-images").css("color", "transparent");
        $(".btn-file").css("color", "transparent");
        $(".btn-success").css("color", "transparent");
        $(".card-images").css("color", "transparent");
        $(".btn-warning").css("color", "transparent");
        $("#examplepic").css("color", "transparent");
        $(".row").css("pointer-events", "none");
        $("#exampletext").hide();
    }
    if(window.screen.width <= 440)
    {
        $(".btn-warning").css("display", "none");
        $(".btn-success").css("display", "none");
        $(".btn-file").css("display", "none");
        $(".progress").css("display", "none");
    }
}

/* Set the width of the side navigation to 0 and the left margin of the page content to 0 */
function closeNav() {
    document.getElementById("mySidenav").style.width = "0";
    document.getElementById("main").style.marginLeft = "0";
    $("#main2").css("margin-left", "0px");
    $("#sidenavbtn").attr('class', 'glyphicon glyphicon-chevron-left')
    if(window.screen.width < 766)
    {
        $("p").show();
        $("h2").show();
        $("h3").show();
        $(".container-images").css("color", "black");
        $(".btn-file").css("color", "white");
        $(".btn-success").css("color", "white");
        $(".card-images").css("color", "black");
        $(".alert-success").css("color", "#3c763d")
        $(".btn-warning").css("color", "white");
        $("#examplepic").css("color", "white");
        $(".row").css("pointer-events", "auto");
        $("#exampletext").show();
    }
    if(window.screen.width <= 440)
    {
        $(".btn-warning").css("display", "inline");
        $(".btn-success").css("display", "inline");
        $(".btn-file").css("display", "inline-block");
        $(".progress").css("display", "block");
    }
}
