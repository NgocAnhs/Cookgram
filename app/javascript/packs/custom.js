var changeNavbar = function () {
  if ($(window).scrollTop()) {
    $('nav').addClass('nav-positive');
    $('div.nav-search').removeClass('d-none');
    $('div.search-area').addClass('d-none');
    $('a.btn-icon').css('color','white')
    $('div.vertical-line').css('border-color','white')
  }
  else {
    $('div.search-area').removeClass('d-none');
    $('div.nav-search').addClass('d-none');
    $('nav').removeClass('nav-positive')
    $('a.btn-icon').css('color', 'green')
    $('div.vertical-line').css('border-color','green')
  }
};

window.addEventListener('scroll', changeNavbar);

