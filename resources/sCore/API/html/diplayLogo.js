$(function() {

    window.addEventListener("message", function(event) {
        var mess = event.data;
        if (typeof mess.logo !== 'undefined') {
            $("#logo").fadeIn("slow", function() {
                setTimeout(function() {
                    $("#logo").fadeOut("slow", function() {});
                }, 5000);
            });
        }

        if (typeof mess.succes !== 'undefined') {
            $("#succes").fadeIn(200, function() {
                setTimeout(function() {
                    $("#succes").fadeOut("slow", function() {});
                }, 10000);
            });
        }

        if (typeof mess.mic !== 'undefined') {
            if (mess.mic == true) {
                $("#mic").fadeIn(500);
            } else {
                $("#mic").fadeOut(500);
            }

        }

        if (typeof mess.lspdNotif !== 'undefined') {
            var num = mess.length.toString();
            toastr.options = {
                "closeButton": false,
                "debug": false,
                "newestOnTop": true,
                "progressBar": true,
                "positionClass": "toast-bottom-right",
                "preventDuplicates": false,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": num,
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            }

            toastr.options.escapeHtml = true;
            //toastr["info"]("", "" + mess.info["code"] + " Info: " + mess.info["name"] + "\nZone: " + mess.info["loc"] + "");

            toastr.error('', 'Code: ' + mess.info["code"] + '<br> Info: ' + mess.info["name"] + '<br>Zone: ' + mess.info["loc"]);

        };

        if (typeof mess.sc !== 'undefined') {
            toastr.options = {
                "closeButton": false,
                "debug": false,
                "newestOnTop": true,
                "progressBar": true,
                "positionClass": "toast-bottom-right",
                "preventDuplicates": false,
                "onclick": null,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": "15000",
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            }

            toastr.options.escapeHtml = true;
            toastr.error("<br>De: " + mess.name + "<br>Message: " + mess.msg, "Chat administratif (/sc)")

        };

        if (typeof mess.report !== 'undefined') {
            toastr.options = {
                "closeButton": false,
                "debug": false,
                "newestOnTop": true,
                "progressBar": true,
                "positionClass": "toast-bottom-right",
                "preventDuplicates": true,
                "onclick": null,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": "15000",
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            }

            toastr.options.escapeHtml = true;
            toastr["info"]("Message: " + mess.msg, "TICKET SUPPORT ID [" + mess.id + "]")

        };

    });

});