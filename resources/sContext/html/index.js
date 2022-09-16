$(function () {

    var objectType = null;
    var contextElement = document.getElementById("context-menu");


    function display(bool) {
        if (bool) {
            $(".menu").show();
            $("#close-div").show();
        } else {
            $(".menu").hide();
            $("#close-div").hide();
        }
    }

    display(false)
    //Called from "function SetDisplay(bool)" in lua .. sends the NUI status.
    //Called from "function SendObjectData()" in lua .. Sent the corrisponding data in this JS. 
    window.addEventListener('message', function(event) {
        var item = event.data;
        //Initial called to show NUI
        if (item.type === "ui") 
        {
            if (item.status == true) 
            {
                display(true)
            } 
            else 
            {
                display(false)
            }
        }
    })

    // if the person uses the escape or Z key, it will exit the resource
    //Does a Callback to the lua to CLOSE the NUI.
    //27 = ESC , 90 = Z
    document.onkeyup = function (data) {
        if (data.which == 27 || data.which == 90 || data.which == 222) 
        {
            document.getElementById("context-menu").classList.remove("active");
            clearObjectData();
            $.post('https://sContext/exit', JSON.stringify({}));
            return
        }
    };

    //Context menu -- right click
    window.addEventListener("contextmenu",function(event){
        event.preventDefault();
        $.post('https://sContext/rightclick', JSON.stringify({}));
        contextElement.style.top = event.offsetY + "px";
        contextElement.style.left = event.offsetX + "px";
    });

    //clears the object data on menu exit
    function clearObjectData()
    {
        objectType = null;
        doorIndex = null;
    }

})