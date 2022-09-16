var resourceName = "adminmodule"
$(document).ready(function() {
    const defaultTextInput = "Valider les informations";

    function formFunction(item) {
        if (item && item.input) {
            $(".formInput").fadeIn(400);
            $(".focus").fadeIn(600);
            $(".form-group").remove();
        } else {
            $(".formInput").fadeOut(400);
            $(".focus").fadeOut(600);
        }
        if (item && item.input != false && item.input != null) {
            $("#formTitle").text(item.inputName || "TV");
            for (let i = item.input.length - 1; i >= 0; i--) {
                let data = item.input[i];
                $("#form-content").prepend("<div class='form-group'><label>" + data.field + "</label><input type='" + (data.type || "text") + "' id='" + data.id + "' name='" + data.id + "' required='required'/></div>");
            }
            $("#form-content").append("<div class='form-group'><button id='fieldValidate'>" + (item.fieldValidate || defaultTextInput) + "</button></div>");

            $("#fieldValidate").mouseup(function() {
                var allInputs = {};
                for (let i = item.input.length - 1; i >= 0; i--) {
                    let data = item.input[i];
                    allInputs[data.id] = $("#" + data.id).val() || "";
                }

                $.post('http://cTV/onEntry', JSON.stringify({
                    id: 1,
                    inputs: allInputs
                }));
                formFunction();
            });
        }
    }

    $(document).keydown(function(event) {
        if (event.which == 27 && $(".formInput").is(":visible")) {
            $.post('http://cTV/onEntry', JSON.stringify({}));
            formFunction();
        }
    });

    window.addEventListener('message', function(event) {
        const item = event.data;
        if (item.input != null) {
            formFunction(item);
        }
    });

    $("#entry-validate").mouseup(function() {
        transitionToAnotherDiv('entrygouv', 'buttongouv');
    });
});