$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var cursor = $('#cursorPointer');
  var cursorX = documentWidth / 2;
  var cursorY = documentHeight / 2;
  var idEnt = 0;

  function UpdateCursorPos() {
    $('#cursorPointer').css('left', cursorX);
    $('#cursorPointer').css('top', cursorY);
  }

  function triggerClick(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
    return true;
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    // Crosshair
    if(event.data.crosshair == true){
      $(".crosshair").addClass('fadeIn');
      // $("#cursorPointer").css("display","block");
    }
    if(event.data.crosshair == false){
      $(".crosshair").removeClass('fadeIn');
      // $("#cursorPointer").css("display","none");
    }

    // Menu
    if(event.data.menu == 'vehicle'){
      $(".close").show();
      $(".menu-car").addClass('fadeIn');
      idEnt = event.data.idEntity;
      // $("#cursorPointer").css("display","none");
    }
    if(event.data.menu == 'user'){
      $(".close").show();
      $(".menu-user").addClass('fadeIn');
      idEnt = event.data.idEntity;
      // $("#cursorPointer").css("display","none");
    }
    if((event.data.menu == false)){
      $(".close").removeClass('active');
      $(".menu").removeClass('fadeIn');
      idEnt = 0;
    }

    if (event.data.type == "click") {
      triggerClick(cursorX - 1, cursorY - 1);
    }
  });

  $(document).mousemove(function(event) {
    cursorX = event.pageX;
    cursorY = event.pageY;
    UpdateCursorPos();
  });


  $('.close').on('click', function(e){
    e.preventDefault();
    $.post('https://sContext/exit');
    $('.menu-car').removeClass('fadeIn');
    $('.menu-user').removeClass('fadeIn');
    $('.close').hide()
  });

  $('.openCoffre').on('click', function(e){
    e.preventDefault();
    $.post('https://sContext/togglecoffre', JSON.stringify({
      id: idEnt
    }));
    $.post('https://sContext/exit');
    $('.menu-car').removeClass('fadeIn');
    $('.close').hide()
  });

  $('.openCapot').on('click', function(e){
    e.preventDefault();
    $.post('https://sContext/togglecapot', JSON.stringify({
      id: idEnt
    }));
    $(this).find('.text').text($(this).find('.text').text() == 'Ouvrir le capot' ? 'Fermer le capot' : 'Ouvrir le capot');
    $.post('https://sContext/exit');
    $('.menu-car').removeClass('fadeIn');
    $('.close').hide()
  });

  $('.lock').on('click', function(e){
    e.preventDefault();
    $.post('https://sContext/togglelock', JSON.stringify({
      id: idEnt
    }));
    $(this).find('.text').text($(this).find('.text').text() == 'Déverouiller' ? 'Verrouiller' : 'Déverouiller');
    $.post('https://sContext/exit');
    $('.menu-car').removeClass('fadeIn');
    $('.close').hide()
  });

  $('.etat').on('click', function(e){
    e.preventDefault();
    $.post('https://sContext/etat', JSON.stringify({
      id: idEnt
    }));
    $.post('https://sContext/exit');
    $('.menu-car').removeClass('fadeIn');
    $('.close').hide()
  });

  $('.fouiller').on('click', function(e){
    e.preventDefault();
    $.post('https://sContext/fouiller', JSON.stringify({
      id: idEnt
    }));
    $.post('https://sContext/exit');
    $('.menu-user').removeClass('fadeIn');
    $('.close').hide()
  });

  $('.trainer').on('click', function(e){
    e.preventDefault();
    $.post('https://sContext/trainer', JSON.stringify({
      id: idEnt
    }));
    $.post('https://sContext/exit');
    $('.menu-user').removeClass('fadeIn');
    $('.close').hide()
  });

  $('.idpersonnage').on('click', function(e){
    e.preventDefault();
    $.post('https://sContext/PlayerIdPersonnage', JSON.stringify({
      id: idEnt
    }));
    $.post('https://sContext/exit');
    $('.menu-user').removeClass('fadeIn');
    $('.close').hide()
  });

  // Functions
  // User
  $('.cheer').on('click', function(e){
    e.preventDefault();
    $.post('https://sContext/cheer', JSON.stringify({
      id: idEnt
    }));
    $.post('https://sContext/exit');
  });


  // Click Crosshair
  $('.crosshair').on('click', function(e){
    e.preventDefault();
    $(".crosshair").removeClass('fadeIn').removeClass('active');
    $(".menu").removeClass('fadeIn');
    $.post('https://sContext/disablenuifocus', JSON.stringify({
      nuifocus: false
    }));
    $.post('https://sContext/exit');
  });
  $(document).keypress(function(e){
    if(e.which == 101){ // if "E" is pressed
      $(".crosshair").removeClass('fadeIn').removeClass('active');
      $(".menu").removeClass('fadeIn');
      $.post('https://sContext/disablenuifocus', JSON.stringify({
        nuifocus: false
      }));
      $.post('https://sContext/exit');
    }
  });

});
