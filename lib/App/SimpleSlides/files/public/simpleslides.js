var current = 1;
var max;

function bindMousetrap(prev, next) {
  Mousetrap.bind(['left', 'up', 'pageup'], function(){
    if (current > 1) {
      current -= 1;
      refreshOverlays()
    } else {
      window.location = prev;
    }
  });
  Mousetrap.bind(['right', 'down', 'pagedown'], function(){
    if (current < max) {
      current += 1;
      refreshOverlays()
    } else {
      window.location = next;
    }
  });
}

function maxOverlay () {
  var all = $('[ssOverlay]').map(function(){ 
    return $(this).attr('ssOverlay').split('-');
  }).map(function(){
    return this.length ? parseInt(this) : null;
  }).toArray();
  return all.sort().reverse()[0];
}

function parseOverlaySpec (str) {
  var a = str.split('-');
  if (a.length == 1) {
    a[1] = a[0];
  }
  if (a[0] === '') {
    a[0] = 1;
  }
  if (a[1] === ''){
    a[1] = max;
  }
  a[0] = parseInt(a[0]);
  a[1] = parseInt(a[1]);
  return a;
}

function refreshOverlays () {
  $('[ssOverlay]').each(function(){
    spec = parseOverlaySpec($(this).attr('ssOverlay'));
    if ( current >= spec[0] && current <= spec[1] ) {
      $(this).show();
    } else {
      $(this).hide();
    }
  });
}

$(function(){
  max = maxOverlay();
  refreshOverlays();
});

