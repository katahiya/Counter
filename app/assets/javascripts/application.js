// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require cocoon
//= require bootstrap
//= require turbolinks
//= require_tree .

$(function() {

  //checkbox
  $('.check_all').click(function(){
    $('input[name="ids[]"]').prop('checked', true);
    generate_buttons();
  });

  $(document).on('click', '.uncheck_all', function(){
    $('input[name="ids[]"]').prop('checked', false);
    remove_buttons();
  });

  $('input[name="ids[]"]').change(function(){
    checked_any();
  });

  //popover
  $('.hover_popover').popover({
    trigger: 'hover', // click,hover,focus,manualを選択出来る
  });

  //private
  var uncheck_all_button = '<button name="button" type="button" class="uncheck_all">全選択解除</button>'
  var generate_buttons = function() {
    if($('.uncheck_all').length > 0) return;
    $('.appear_checked').append(uncheck_all_button);
    $('.plural_action_button').removeAttr('disabled');
  };
  var remove_buttons = function() {
    $('.appear_checked').empty();
    $('.plural_action_button').attr('disabled', 'disabled');
  };
  var checked_any = function() {
    if($('input[name="ids[]"]:checked').length > 0){
      generate_buttons();
    }
    else{
      remove_buttons();
    }
  };
});
