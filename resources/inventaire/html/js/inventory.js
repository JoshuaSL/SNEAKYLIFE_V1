var type = "normal";
var disabled = false;

window.addEventListener("message", function(event) {
    if (event.data.action == "display") {
        type = event.data.type
        disabled = false;

        if (type === "normal") { $(".info-div").hide(); } else if (type === "trunk") { $(".info-div").show(); } else if (type === "property") { $(".info-div").hide(); } else if (type === "vault") { $(".info-div").hide(); } else if (type === "player") { $(".info-div").show(); }

        $(".ui").fadeIn();
    } else if (event.data.action == "hide") {
        $("#dialog").dialog("close");
        $(".ui").fadeOut();
        $(".item").remove();
        $("#otherInventory").html("<div id=\"noSecondInventoryMessage\"></div>");
        $("#noSecondInventoryMessage").html(invLocale.secondInventoryNotAvailable);
    } else if (event.data.action == "setItems") {
        inventorySetup(event.data.itemList, event.data.fastItems, event.data.crMenu, event.data.weight);

        $('.item').draggable({
            helper: 'clone',
            appendTo: 'body',
            zIndex: 99999,
            revert: 'invalid',
            start: function(event, ui) {
                if (disabled) {
                    return false;
                }

                $(this).css('background-image', 'none');
                itemData = $(this).data("item");

                if (!itemData.canRemove) {
                    $("#drop").addClass("disabled");
                    $("#give").addClass("disabled");
                }



                if (!itemData.rename) {
                    $("#rename").addClass("disabled");
                }

                if (!itemData.information) {
                    $("#information").addClass("disabled");
                }

                $("#use").addClass("disabled");
            },
            stop: function() {
                itemData = $(this).data("item");

                if (itemData !== undefined && itemData.name !== undefined) {
                    $(this).css('background-image', 'url(\'img/items/' + itemData.name + '.png\'');
                    $("#drop").removeClass("disabled");
                    $("#use").removeClass("disabled");

                    $("#rename").removeClass("disabled");
                    $("#information").removeClass("disabled");
                    $("#give").removeClass("disabled");
                }
            }
        });
    } else if (event.data.action == "setSecondInventoryItems") {
        secondInventorySetup(event.data.itemList);
    } else if (event.data.action == "setInfoText") {
        $(".info-div").html(event.data.text);
    } else if (event.data.action == "nearPlayers") {
        console.log(event.data.players)
            $.post("http://inventaire/GiveItem", JSON.stringify({
                player: event.data.players,
                item: event.data.item,
                number: parseInt($("#count").val())
            }));
       
    }
});

function closeInventory() {
    $.post("http://inventaire/NUIFocusOff", JSON.stringify({}));
}





function inventorySetup(items, fastItems, crMenu, wData) {
    $("#playerInventory").html("");
    $.each(items, function(index, item) {
    
        count = setCount(item);
 
        $(".weight").html("");
        $(".weight").append(`<div class="currentWeight">${wData.currentWeight}/${wData.maxWeight}</div>`);

        $("#playerInventory").append('<div class="slot"><div id="item-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' + '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
 
   
             
            

       




        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', "main");
    });
 
    $("#playerInventoryFastItems").html("");
    if (crMenu == 'weapon') { 
        $("#rename").fadeOut();
        $("#drop").html(invLocale.dropItem);
        var i;
        for (i = 1; i < 4; i++) {
            $("#playerInventoryFastItems").append('<div class="slotFast"><div id="itemFast-' + i + '" class="item" >' + '<div class="keybind">' + i + '</div><div class="item-count"></div> <div class="item-name"></div> </div ><div class="item-name-bg"></div></div>');
        }
        $.each(fastItems, function(index, item) {
            count = setCount(item);
            console.log(item.name)
            $('#itemFast-' + item.slot).css("background-image", 'url(\'img/items/' + item.name + '.png\')');
            $('#itemFast-' + item.slot).html('<div class="keybind">' + item.slot + '</div><div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> <div class="item-name-bg"></div>');
            $('#itemFast-' + item.slot).data('item', item);
            $('#itemFast-' + item.slot).data('inventory', "fast");
        });
    }

    if (crMenu == 'clothe'){
        $("#rename").fadeIn();
        $("#drop").html('Effacer');
    }
    makeDraggables()
    if (crMenu == 'item'){
        $("#rename").fadeOut();
        $("#drop").html(invLocale.dropItem);
    }
  
}

function makeDraggables() {
    $('#itemFast-1').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast") && itemData.type === "item_weapon") {
                disableInventory(500);
                $.post("http://inventaire/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot: 1
                }));
            }
        }
    });
    $('#itemFast-2').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast") && itemData.type === "item_weapon") {
                disableInventory(500);
                $.post("http://inventaire/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot: 2
                }));
            }
        }
    });
    $('#itemFast-3').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast") && itemData.type === "item_weapon") {
                disableInventory(500);
                $.post("http://inventaire/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot: 3
                }));
            }
        }
    });
}



function secondInventorySetup(items) {
    $("#otherInventory").html('<div class="raccours1Other">Items</div>' + '<div class="sepOther">|</div>' +'<div class="raccours2Other">Armes</div>');



    $(function () {
  
        $(".raccours1Other").click(function() {
            $(".ui").fadeIn();
            setTimeout(function() {
                $.post("https://inventaire/Sneaky:changeTheCurrentTruckMenu", JSON.stringify({
                    type: 'item',
                    item: type
                }));
            }, 100);
        })
    
        $(".raccours2Other").click(function() {
            $(".ui").fadeIn();
            setTimeout(function() {
                $.post("https://inventaire/Sneaky:changeTheCurrentTruckMenu", JSON.stringify({
                    type: 'weapon',
                    item: type
                }));
            }, 100);
        })
    
    })

    $.each(items, function(index, item) {
        count = setCount(item);        
        $("#otherInventory").append('<div class="slot"><div id="itemOther-' + index + '" class="item" style = "background-image: url(\'img/items/' + item.name + '.png\')">' +
            '<div class="item-count">' + count + '</div> <div class="item-name">' + item.label + '</div> </div ><div class="item-name-bg"></div></div>');
        $('#itemOther-' + index).data('item', item);
        $('#itemOther-' + index).data('inventory', "second");
    });
}


$(function () {

    
  

    $(".weight").click(function() {
        $(".ui").fadeIn();
        setTimeout(function() {
            $.post("https://inventaire/weightHelp", JSON.stringify({
            
            }));
        }, 100); 
    }) 

    $(".raccours1").click(function() {
        $(".ui").fadeIn();
        setTimeout(function() {
            $.post("https://inventaire/dsqds", JSON.stringify({
                type: 'item'
            }));
        }, 100);
    })

    $(".raccours2").click(function() {
        $(".ui").fadeIn();
        setTimeout(function() {
            $.post("https://inventaire/dsqds", JSON.stringify({
                type: 'clothe'
            }));
        }, 100);
    })

    $(".raccours3").click(function() {
        $(".ui").fadeIn();
        setTimeout(function() {
            
  
            $.post("https://inventaire/dsqds", JSON.stringify({
                type: 'weapon'
            }));
        }, 100);
    })
})


function disableInventory(ms) {
    disabled = true;

    setInterval(function() {
        disabled = false;
    }, ms);
}

function setCount(item) {
    count = item.count

    if (item.limit > 0) {
        count = item.count
    }

    if (item.type === "item_weapon") {
        if (count == 0) {
            count = "";
        } else {
        }
    }

    if (item.type === "item_standard") {
        if (item.limit == -1) {
            count = item.count;
        }
    }

    if (item.type === "item_account") {
        if (count == 0) {
            count = "";
        } else {
            count = item.count;
        }
    }

    if (item.type === "item_account" || item.type === "item_money") {
        count = formatMoney(item.count);
    }

    return count;
}

function formatMoney(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
        j = (j = i.length) > 3 ? j % 3 : 0;

    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t);
};

$(document).mousedown(function(event) {
    if (event.which != 3) return
    itemData = $(event.target).data("item");

    if (itemData == undefined) {
        return;
    }
    itemInventory = $(event.target).data("inventory");
    $(event.target).fadeIn(50)
    setTimeout(function() {
        $.post("https://inventaire/UseItem", JSON.stringify({
            item: itemData
        }));
    }, 100);
});




$(document).ready(function() {
    $("#count").focus(function() {
        $(this).val("")
    }).blur(function() {
        if ($(this).val() == "") {
            $(this).val("1")
        }
    });

    $("body").on("keyup", function(key) {
        if (Config.closeKeys.includes(key.which)) {
            closeInventory();
        }
    });

    $('#use').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            $.post("http://inventaire/UseItem", JSON.stringify({
                item: itemData
            }));
        }
    });

    $('#give').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData.canRemove) {
                $.post("http://inventaire/GetNearPlayers", JSON.stringify({
                    item: itemData
                }));
            }
        }
    });

    $('#drop').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData.canRemove) {
                $.post("http://inventaire/DropItem", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });

    $('#rename').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData.canRemove) {
                $.post("http://inventaire/RenameItem", JSON.stringify({
                    item: itemData
                }));
            }
        }
    });

    $('#information').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            if (itemData.canRemove) {
                $.post("http://inventaire/InformationItem", JSON.stringify({
                    item: itemData
                }));
            }
        }
    });

    $('#playerInventory').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "trunk" && itemInventory === "second") {
            
                disableInventory(500);
                $.post("http://inventaire/TakeFromTrunk", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "property" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://inventaire/TakeFromProperty", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "normal" && itemInventory === "fast") {
                disableInventory(500);
                $.post("http://inventaire/TakeFromFast", JSON.stringify({
                    item: itemData
                }));
            } else if (type === "storage" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://inventaire/TakeFromStorage", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "player" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://inventaire/TakeFromPlayer", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });


  

    $('#otherInventory').droppable({
        drop: function(event, ui) {
          
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "trunk" && itemInventory === "main") {
          
                disableInventory(500);
                $.post("http://inventaire/PutIntoTrunk", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "property" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://inventaire/PutIntoProperty", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "storage" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://inventaire/PutIntoStorage", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            } else if (type === "player" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://inventaire/PutIntoPlayer", JSON.stringify({
                    item: itemData,
                    number: parseInt($("#count").val())
                }));
            }
        }
    });

    $("#count").on("keypress keyup blur", function(event) {
        $(this).val($(this).val().replace(/[^\d].+/, ""));
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    });
});

$.widget('ui.dialog', $.ui.dialog, {
    options: {
        // Determine if clicking outside the dialog shall close it
        clickOutside: false,
        // Element (id or class) that triggers the dialog opening 
        clickOutsideTrigger: ''
    },
    open: function() {
        var clickOutsideTriggerEl = $(this.options.clickOutsideTrigger),
            that = this;
        if (this.options.clickOutside) {
            // Add document wide click handler for the current dialog namespace
            $(document).on('click.ui.dialogClickOutside' + that.eventNamespace, function(event) {
                var $target = $(event.target);
                if ($target.closest($(clickOutsideTriggerEl)).length === 0 &&
                    $target.closest($(that.uiDialog)).length === 0) {
                    that.close();
                }
            });
        }
        // Invoke parent open method
        this._super();
    },
    close: function() {
        // Remove document wide click handler for the current dialog
        $(document).off('click.ui.dialogClickOutside' + this.eventNamespace);
        // Invoke parent close method 
        this._super();
    },
});