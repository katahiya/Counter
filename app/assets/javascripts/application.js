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
  console.log("ready");

  //checkbox
  $(document).on('click', '.check_all', function(){
    $('input[name="ids[]"]').prop('checked', true);
    generate_buttons();
  });

  $(document).on('click', '.uncheck_all', function(){
    $('input[name="ids[]"]').prop('checked', false);
    remove_buttons();
  });

  $(document).on('change', 'input[name="ids[]"]', function(){
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

$(document).on('turbolinks:load', function(){
  //resize section by window height
  filter("recorders", "show", resize_windowful);
  filter("recorders", "edit", size_options_list);
  size_modal_window();
});

$(window).resize(function() {
  console.log("window");
  filter("recorders", "show", resize_windowful);
  filter("recorders", "edit", size_options_list);
  size_modal_window();
  hide_less_than_min_modal();
});

//コントローラーとアクションで呼び出しに制限をかける
var filter = function(controller, action, callback) {
  selector = `body[data-controller='${controller}'][data-action='${action}']`;
  if($(selector).length > 0)
    callback();
};

var window_height_without_header = function() {
  var window_height = $(window).height();
  var header_height = $('.navbar-fixed-top').height();
  return window_height - header_height;
};

//resize windowful by window height
var resize_windowful = function() {
  var resize = window_height_without_header() - 50;
  $('.windowful').css("max-height", resize + "px");
  resize_option_bar(resize);
  resize_records_table(resize + 30);
};
var resize_option_bar = function(base) {
  if($('.option-bar').width() < 125){
    $('.options-col').css("visibility", "hidden");
    return;
  }
  $('.options-col').css("visibility", "visible");
  var side_height = $('.option-bar-head').height();
  $('.record_form').css("max-height", base-side_height + "px");
}
var resize_records_table = function(base) {
  var head_height = $('.records-head').height();
  var buttons_height = $('.records-buttons').height();
  var thead_height = $('.records-thead').height();
  var table_width = $('.records-tbody').width();
  $('.records-tbody').css("max-height", base-head_height-buttons_height-thead_height + "px");
  $('td.record-select').css("width", table_width*0.1 + "px");
  $('td.record-action').css("width", table_width*0.1 + "px");
  $('td.record-no').css("width", table_width*0.1 + "px");
  $('td.record-data').css("width", table_width*0.6 + "px");
  $('td.record-count').css("width", table_width*0.1 + "px");
  table_width -= 20;
  $('th.record-select').css("width", table_width*0.1 + "px");
  $('th.record-action').css("width", table_width*0.1 + "px");
  $('th.record-no').css("width", table_width*0.1 + "px");
  $('th.record-data').css("width", table_width*0.6 + "px");
  $('th.record-count').css("width", table_width*0.1 + "px");
}

var size_modal_window = function() {
  if('.modal-container'.length == 0) return;
  if('.scroll-window'.length == 0) return;
  var window_height = $(window).height();
  var header_height = 41;
  var buttons_height = 50;
  var margin = window_height * 0.1;
  var scroll_height = window_height_without_header()*0.8 - header_height - buttons_height - margin*2
  console.log(scroll_height);
  $('.modal-form').css("margin-top", margin + "px");
  $('.scroll-window').css("max-height", scroll_height + "px");
};

var size_options_list = function() {
  var body_height = window_height_without_header();
  var header_height = $('.options-head').height();
  var buttons_height = $('.options-buttons').height();
  console.log(body_height);
  console.log(header_height);
  console.log(buttons_height);
  var scroll_height = body_height - header_height - buttons_height - 50
  $('.options-list').css("max-height", scroll_height + "px");
};

var hide_less_than_min_modal = function() {
  if('.modal-container'.length == 0) return;
  var window_width = $(window).width();
  if(window_width < 480){
    $('.modal-container').modal("hide");
    return;
  }
};
