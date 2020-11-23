// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require( 'jquery' );
require( 'jszip' );
require( 'pdfmake' );
require( 'datatables.net-bs4' )();
require( 'datatables.net-autofill-bs4' )();
require( 'datatables.net-buttons-bs4' )();
require( 'datatables.net-buttons/js/buttons.colVis.js' )();
require( 'datatables.net-buttons/js/buttons.flash.js' )();
require( 'datatables.net-buttons/js/buttons.html5.js' )();
require( 'datatables.net-buttons/js/buttons.print.js' )();
require( 'datatables.net-colreorder-bs4' )();
require( 'datatables.net-fixedcolumns-bs4' )();
require( 'datatables.net-fixedheader-bs4' )();
require( 'datatables.net-keytable-bs4' )();
require( 'datatables.net-responsive-bs4' )();
require( 'datatables.net-rowgroup-bs4' )();
require( 'datatables.net-rowreorder-bs4' )();
require( 'datatables.net-scroller-bs4' )();
require( 'datatables.net-searchpanes-bs4' )();
require( 'datatables.net-select-bs4' )();

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
//= require jquery3
//= require popper
//= require bootstrap-sprockets


window.setTimeout(function() {
  $(".alert, .flash").fadeTo(500, 0).slideUp(500, function(){
      $(this).remove(); 
  });
}, 2000);
