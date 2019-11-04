$(function() {
    $("#tabs2").tabs();
    //$( document ).tooltip();


    // to get current mouse position on the screen
    var currentMousePos = {
        x: -1,
        y: -1
    };
    $(document).mousemove(function(event) {
        currentMousePos.x = event.pageX;
        currentMousePos.y = event.pageY;
    });

    // showing help
    $(document).on("mousemove", ".help-button, .help-button-small", function() {
        $("body").append("<div class='my-help'></div>");
        $(".my-help").stop(true, true).css({
            top: currentMousePos.y + 20,
            left: currentMousePos.x + 20
        }).html($(this).attr("value"));

        $(".my-help").stop(true, true).animate({
            opacity: 1
        }, 500, function() {});
    });
    $(document).on("mouseout", ".help-button, .help-button-small", function() {
        $(".my-help").stop(true, true).animate({
            opacity: 0
        }, 200, function() {
            $(".my-help").remove();
        });
    });

    // showing help for loads
    $(document).on("mousemove", ".help-button-load", function() {
        var loadNumbers = $(this).attr("value").substr(1, $(this).attr("value").length - 2).split(/,/);
        $("body").append("<div class='my-help'></div>");
        $(".my-help").stop(true, true).css({
            top: currentMousePos.y + 20,
            left: currentMousePos.x + 20
        }).html('Annual Average Load: <span class="load-numbers">' + loadNumbers[0] +
            '</span> kW<br/>Annual Maximum Load: <span class="load-numbers">' + loadNumbers[1] +
            '</span> kW<br/>Annual Minimum Load: <span class="load-numbers">' + loadNumbers[2] +
            '</span> kW<br/>Maximum to Average Ratio: <span class="load-numbers">' + loadNumbers[3] + '</span>');
        $(".my-help").stop(true, true).animate({
            opacity: 1
        }, 500, function() {});
    });
    $(document).on("mouseout", ".help-button, .help-button-load", function() {
        $(".my-help").stop(true, true).animate({
            opacity: 0
        }, 200, function() {
            $(".my-help").remove();
        });
    });
    
    // showing tooltip
    $(document).on("mousemove", ".tariff-label, .tariff-selector", function() {
        $("body").append("<div class='my-tooltip'></div>");
        $(".my-tooltip").stop(true, true).css({
            top: currentMousePos.y + 20,
            left: currentMousePos.x + 20
        }).html($(this).attr("mytitle"));
        $(".my-tooltip").stop(true, true).animate({
            opacity: 1
        }, 500, function() {});
    });
    $(document).on("mouseout", ".tariff-label, .tariff-selector", function() {
        $(".my-tooltip").stop(true, true).animate({
            opacity: 0
        }, 200, function() {
            $(".my-tooltip").remove();
        });
    });
});