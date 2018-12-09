$(document).ready(function(){
  var win           = 'start';
  var cCon          = 0;
  var pCon          = 0;
  var plate         = null;
  var signedInUser  = null;
  var wrong         = 0;
  var warned        = 0;

  // Error
  function error(text, duration, color, height) {
    $('#error').css('background', color);
    if (height != null) {
      $('#error').css('height', height);
    } else {
      $('#error').css('height', '');
    }
    $('#error').html('<i class="material-icons">error</i>'+text+'').slideDown('fast', function(){
      setTimeout(function(){
        $('#error').slideUp('fast');
      }, duration);
    });
  }

  // Get user info
  function getUser(type, input) {
    var lastdigits = input.substr(input.length - 4);
    $('#' + win).hide();
    $('#start').hide();
    $('#person').show();
    win = 'person';
    $.post('http://jsfour-mdc/fetch', JSON.stringify({type : 'person', lastdigits : lastdigits}), function(cb) {
      if (cb != 'error') {
        $('#person-brottsregister').html('<h4>Criminal record:</h4>');
        $('#person-personnummer').text(cb['result'][0].dateofbirth +'-'+ lastdigits);
        $('#person-name').text(cb['result'][0].firstname + ' ' + cb['result'][0].lastname);
        $('#person-height').text(cb['result'][0].height);
        $('#person-sex').text(cb['result'][0].sex);
        $('#person-phone').text(cb['result'][0].phone_number);
        $('#person-incident .remove').attr('dob', cb['result'][0].dateofbirth +'-'+ lastdigits);

        if (cb['efterlysningar'] != null) {
          $('#person-incident li').html(cb['efterlysningar'][0].crime + ' <a href="#!" class="inc-link" inc-numb="'+cb['efterlysningar'][0].incident+'">'+cb['efterlysningar'][0].incident+'</a>');
          $('#person-incident b').removeClass('no').addClass('yes').text('YES');
        } else {
          $('#person-incident li').html('');
          $('#person-incident b').removeClass('yes').addClass('no').text('NO');
        }

        if (cb['brottsregister'] != null) {
          Object.keys(cb['brottsregister']).forEach(function(k) {
            $('#person-brottsregister').append('<li class="remove" type="brottsregister" offense="'+cb['brottsregister'][k].offense+'" dob="'+cb['brottsregister'][k].dob+'">'+cb['brottsregister'][k].description+' ('+cb['brottsregister'][k].date+') '+'</li>');
          });
        }
      } else {
        $('#' + win).hide();
        $('#start').show();
        win = 'start';
        error("Couldn't find a person with that date of birth", 2000, '#7a2323');
      }
    });
  }

  // Get car info
  function getCar(input) {
    $('#' + win).hide();
    $('#start').hide();
    $('#car').show();
    $('#car-comments').html('');
    win = 'car';

    plate = input.toUpperCase();
    $.post('http://jsfour-mdc/fetch', JSON.stringify({type : 'car', plate : plate}), function(cb) {
      if ( cb != 'error' && cb != 'rerun' ) {
        $('#car-owner').text(cb['result'][0].firstname + ' ' + cb['result'][0].lastname).attr('dob', cb['result'][0].dateofbirth + '-'+ cb['result'][0].lastdigits);
        $('#car-inspected').text(cb['carDetails'][0].inspected);
        Object.keys(cb['carIncidents']).forEach(function(k) {
          $('#car-comments').append('<li class="remove" type="car" data="'+cb['carIncidents'][k]+'" plate="'+plate+'">'+cb['carIncidents'][k]+'</li>');
        });
      } else if ( cb == 'error' ) {
        $('#' + win).hide();
        $('#start').show();
        win = 'start';
        error("Couldn't find a car with that plate..", 2000, '#7a2323');
      } else if ( cb == 'rerun' ) {
        getCar(plate);
      }
    });
  }

  // Search
  function search(type, input) {
    if ( input ) {
      if (type == 'car') {
        getCar(input);

        cCon++;

        $('#car-content').prepend('<a href="#!" data="'+input+'">' +
        '<li>' +
          '<div class="column">' +
            '<h1>'+ input.substring(0,8) +'</h1>' +
            '<i class="material-icons">arrow_forward</i>' +
          '</div>'+
        '</li>'+
        '</a>');

        if ( cCon >= 7 ) {
          $('#car-content a:last-child').remove();
        }
      } else if (type == 'person') {
        getUser('search', input);

        pCon++;

        $('#person-content').prepend('<a href="#!" data="'+input+'">' +
        '<li>' +
          '<div class="column">' +
            '<h1>'+ input.substring(0,8) +'</h1>' +
            '<i class="material-icons">arrow_forward</i>' +
          '</div>'+
        '</li>'+
        '</a>');

        if ( pCon >= 7 ) {
          $('#person-content a:last-child').remove();
        }
      } else if (type == 'incident') {
        $.post('http://jsfour-mdc/fetch', JSON.stringify({type : 'incident', number : input}), function(cb) {
          if ( cb != 'error' ) {
            $('#incident-a').hide();
            $('#incidenter input').val(cb[0].number);
            $('#incident h4').text(cb[0].number+' | Uploaded by '+cb[0].uploader+' ('+cb[0].date+')');
            $('#incident a').attr('inc-numb', cb[0].number);
            $('#incident p').text(cb[0].text);
            $('#incident').show();
          } else {
            error("Couldn't find an incident with that number", 2000, '#7a2323');
          }
        });
      }
    }
  }

  // Search click
  $('.search').click(function() {
    search($(this).parent('.header').find('form').attr('type'), $(this).parent('.header').find('input').val());
  });

  // Incident search
  $('#incident-search').click(function() {
    search($(this).parent('#incidenter').find('form').attr('type'), $(this).parent('#incidenter').find('input').val());
  });

  // Incident add
  $('#incident-add').click(function() {
    if ($('#incident-text').val() != '') {
      $.post('http://jsfour-mdc/save', JSON.stringify({type : 'incident', text : $('#incident-text').val(), signedInUser : signedInUser}), function(cb) {
        $('#incident-text').val('');
        $('#' + win).hide();
        $('#start').show();
        win = 'start';
        error("Incident created! Incident number: " + cb, 6000, '#347a23');
      });
    }
  });

  // Car details add
  $('#add-car-info').click(function() {
    if ($('#new-car').val() != '') {
      $.post('http://jsfour-mdc/save', JSON.stringify({type : 'car', plate : plate, incident : $('#new-car').val(), signedInUser : signedInUser}), function(cb) {
        $('#new-car').val('');
        $('#' + win).hide();
        $('#start').show();
        win = 'start';
        getCar(plate);
        error("XX created!", 1000, '#347a23');
      });
    }
  });

  // Efterlys add
  $('#efterlys-submit').click(function() {
    if ($('#efterlys-firstname').val() != '' && $('#efterlys-lastname').val() != '' && $('#efterlys-personnummer').val() != '' && $('#efterlys-crime').val() != '' && $('#efterlys-incident').val() != '') {
      var val = $('#efterlys-personnummer').val();
      var lastdigits = val.substring(7,12);
      var dob = 'found';

      if ( val.toLowerCase() == 'unknown' || val.toLowerCase() == 'okänd' || val.toLowerCase() == 'okänt' ) {
        dob = 'Okänt';
      }

      $.post('http://jsfour-mdc/save', JSON.stringify({
        wanted : $('#efterlys-firstname').val() + ' ' + $('#efterlys-lastname').val(),
        dob : dob,
        crime : $('#efterlys-crime').val(),
        incident : $('#efterlys-incident').val(),
        type : 'efterlysning',
        lastdigits : lastdigits,
        signedInUser : signedInUser
      }));
      $('#incident-text').val('');

      $('#' + win).hide();
      $('#start').show();
      win = 'start';
      error("Uploaded!", 1000, '#347a23');
    }
  });

  // Car column click
  $("body").on("click", "#car-content a", function() {
    $('#start').hide();
    $('#car').show();
    win = 'car';
  });

  // Incident link click
  $("body").on("click", ".inc-link", function() {
    $('#'+win).hide();
    $('#incidenter').show();
    win = 'incidenter';
    var numb = $(this).attr('inc-numb');
    search('incident', numb);
  });

  // Person column click
  $("body").on("click", "#person-content a", function() {
    getUser('search', $(this).attr('data'));
  });

  // Car column click
  $("body").on("click", "#car-content a", function() {
    getCar($(this).attr('data'));
  });

  // Remove
  $("body").on("click", ".remove", function() {
    var type = $(this).attr('type');

    if ( type == 'user' ) {
      var personnummer = $(this).parent('li').find('.username').text().match(/\((.*)\)/)[1];
      $(this).parent('li').remove();
      $.post('http://jsfour-mdc/remove', JSON.stringify({type : 'efterlysning', dob : personnummer, signedin : signedInUser}), function(cb) {
        error('Removed!', 500, '#347a23');
      });
    } else if ( type == 'car' ) {
      $(this).remove();
      $.post('http://jsfour-mdc/remove', JSON.stringify({type : 'car', incident : $(this).attr('data'), plate : $(this).attr('plate'), signedin : signedInUser}), function(cb) {
        error('Removed!', 500, '#347a23');
      });
    } else if ( type == 'incident' ) {
      var incident = $(this).attr('inc-numb');
      $('#incident').hide();
      $('#incident-a').show();
      $(this).parent('li').remove();
      $.post('http://jsfour-mdc/remove', JSON.stringify({type : 'incident', incident : incident, signedin : signedInUser}), function(cb) {
        error('Removed!', 500, '#347a23');
      });
    } else if ( type == 'brottsregister' ) {
      $(this).remove();
      $.post('http://jsfour-mdc/remove', JSON.stringify({type : 'brottsregister', dob : $(this).attr('dob'), offense : $(this).attr('offense'), signedin : signedInUser}), function(cb) {
        error('Removed!', 500, '#347a23');
      });
    } else if ( type == 'efterlysning' ) {
      if ( $('#person-incident b').text() != 'NEJ') {
        var dob = $(this).attr('dob');
        $('#person-incident b').removeClass('yes').addClass('no').text('NO');
        $('#person-incident li').html('<a href="#!" class="inc-link"></a>');
        $.post('http://jsfour-mdc/remove', JSON.stringify({type : 'efterlysning', dob : dob, signedin : signedInUser}), function(cb) {
          error('Removed!', 500, '#347a23');
        });
      }
    }
  });

  // Menu
  $('.block-buttons a').click(function(){
    var page = $(this).attr('page');

    if ( page == 'efterlys' ) {
      $('#efterlys-content').html('');

      $.post('http://jsfour-mdc/fetch', JSON.stringify({type : 'efterlysning'}), function(cb) {
        if ( cb != 'error' ) {
          Object.keys(cb).forEach(function(key) {
            $('#efterlys-content').prepend('<a href="#!" class="user" dob="'+cb[key].dob+'">' +
              '<li>' +
                '<img src="assets/images/user.png" alt="IMG" draggable="false"/>' +
                '<p class="username">'+cb[key].wanted+' ('+cb[key].dob+')</p>' +
                '<a href="#!" class="remove" title="Remove" type="user"><i class="material-icons">remove_circle_outline</i></a>' +
                '<p>'+cb[key].crime+' ('+cb[key].date+') see incident <a href="#!" class="inc-link" inc-numb="'+cb[key].incident+'">'+cb[key].incident+'</a>. Uploaded by '+cb[key].uploader+'</p>' +
              '</li>' +
            '</a>');
          });
        }
      });
    } else if ( page == 'regelverk' ) {
      $('#regelverk ul').html('');
      Object.keys(regelverk).forEach(function(key) {
        $('#regelverk ul').append('<li>'+
          '<p class="paragraf">'+key+'</p>'+
          '<p>'+regelverk[key]+'</p>'+
        '</li>');
      });
    } else if ( page == 'admin' ) {
      $('#admin tbody').html('');
      $.post('http://jsfour-mdc/fetch', JSON.stringify({type : 'logs'}), function(cb) {
        Object.keys(cb).forEach(function(key) {
          $('#admin tbody').prepend('<tr>'+
            '<td>'+cb[key].type+'</td>'+
            '<td>'+cb[key].remover+'</td>'+
            '<td>'+cb[key].wanted+'</td>'+
          '</tr>');
        });
      });
    } else if ( page == 'dna' ) {
      $.post('http://jsfour-dna/upload', JSON.stringify({}), function(cb) {
        if ( cb == 'error') {
          error('You have no DNA..', 2000, '#7a2323');
        }
      });
    } else if ( page == 'incidenter' ) {
      $('#incidenter ul').html('');
      $.post('http://jsfour-mdc/fetch', JSON.stringify({type : 'incidenter'}), function(cb) {
        Object.keys(cb).forEach(function(key) {
          $('#incidenter ul').prepend('<li>'+
            '<a href="#!" inc-numb="'+cb[key].number+'" class="inc-link">'+cb[key].number+'</a>'+
            '<a href="#!" class="remove no" title="Remove" type="incident" inc-numb="'+cb[key].number+'"><i class="material-icons">remove_circle_outline</i></a>'+
            '<p>'+cb[key].text.substring(0,50)+'..<br> Uploaded by '+cb[key].uploader+' ('+cb[key].date+')</p>'+
          '</li>');
        });
      });
    }
    $('#start').hide();
    $('#' + page ).show();
    win = page;
  });

  // User click
  $("body").on("click", ".user", function() {
    getUser($(this).attr('type'), $(this).attr('dob'));
  });

  // Search form submit
  $("form").submit(function() {
    if ($(this).attr('type') != 'login') {
      search($(this).attr('type'), $(this).find('input').val());
    } else {
      var password = $(this).find('input').val();
      if ( !( wrong > 4 ) ) {
        Object.keys(passwords).forEach(function(key) {
          if ( password == key ) {
            signedInUser = passwords[key];
            Object.keys(admins).forEach(function(akey) {
              if ( signedInUser== admins[akey] ) {
                $('.admin').show();
              }
            });
            $('#login').hide();
            $('#start').show();
          }
          setTimeout(function(){
            if ( password != key && signedInUser == null ) {
              wrong++;
              error('Wrong password..', 1000, '#7a2323');
            }
          }, 100);
        });
      } else {
        if ( warned >= 2 ) {
          $.post('http://jsfour-mdc/alarm', JSON.stringify({}), function(cb) {
            if ( cb == 'done') {
              wrong  = 0;
              warned = 0;
            }
          });
        }
        error("BLOCKED! You've been blocked for 1 minute", 60000, '#7a2323', '334px');
        setTimeout(function(){
          wrong = 0;
          warned++;
        }, 60000);
      }
    }
  	return false;
  });

  // Disable space on the input
  $(".nospace").on({
	  keydown: function(e) {
	    if (e.which === 32)
	      return false;
	  },
	});

  // Close button
  $('.close').click(function(){
    if ( win == 'incidenter' ) {
      $('#incident').hide();
      $('#incident-a').show();
    }
    $('#' + win).hide();
    $('#start').show();
    win = 'start';
  });

  // LUA event listener
  window.addEventListener('message', function(event) {
      if (event.data.action == 'open') {
        $('#computer').show();
      } else if (event.data.action == 'close') {
        $('#computer').hide();
      }
  });

  // Close the NUI, ESC
  $(document).keyup(function(e) {
    if (e.keyCode == 27) {
      $('#computer').hide();
      if ( win == 'incidenter' ) {
        $('#incident').hide();
        $('#incident-a').show();
      }
      $('#' + win).hide();
      $('#start').show();
      win = 'start';
      $('#incident-text').val('');
      $('#new-car').val('');
      $('#efterlys-firstname').val('');
      $('#efterlys-lastname').val('');
      $('#efterlys-personnummer').val('');
      $('#efterlys-crime').val('');
      $('#efterlys-incident').val('');
      $.post('http://jsfour-mdc/escape', JSON.stringify({}));
    }
  });
});
