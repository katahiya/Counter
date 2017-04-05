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

  //close flash message
  $(document).on('click', '.close-flash-message', function(){
    $(this).parent().remove()
  });

  //scroll
  $(document).on('click', '.scroll-button', function(){
    var speed = 500;
    var href= $(this).attr("href");
    var position = $(href).offset().top - 60;
    $("html, body").animate({scrollTop:position}, speed, "swing");
    return false;
  });

  //slide options bar
  var duration = 500;
  var sidebar = '.options-col';
  var button = '.slide-button';
  $(document).on('click', '.slide-button', function(){
    $(button).toggleClass('slide-close');
    $(button).removeClass('slide-open');
    if ($(button).hasClass('slide-close')) {
      $(sidebar).stop().animate({
        left: '0'
      }, duration);
    } else {
      $(sidebar).stop().animate({
        left: '-300px'
      }, duration);
      $(button).addClass('slide-open');
    };
  });

  //loading animation
  $(document).on('ajaxSend', function(){
    console.log('send')
    $('#loading').show();
  });
  $(document).on('ajaxComplete', function(){
    console.log('conplete')
    $('#loading').hide();
  });


  //private
  var uncheck_all_button = '<button name="button" type="button" class="uncheck_all btn btn-default btn-sm">全選択解除</button>'
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
  filter("recorders", "new", size_setup_form);
  filter("recorders", "show", resize_windowful);
  filter("recorders", "show", slide_options);
  filter("recorders", "edit", affix_change);
  deploy_loading();
  size_modal_window();
});

$(window).resize(function() {
  filter("recorders", "new", size_setup_form);
  filter("recorders", "show", resize_windowful);
  filter("recorders", "show", slide_options);
  filter("recorders", "edit", affix_change);
  deploy_loading();
  size_modal_window();
});

var deploy_loading = function() {
  var selector = '#loading-image';
  var window_height = $(window).height();
  var image_height = $(selector).height();
  var window_width = $(window).width();
  var image_width = $(selector).width();
  $(selector).css("margin-top", (window_height - image_height) / 2 + "px");
  $(selector).css("margin-left", (window_width - image_width) / 2 + "px");
}

//コントローラーとアクションで呼び出しに制限をかける
var filter = function(controller, action, callback) {
  selector = "body[data-controller='" + controller + "'][data-action='" + action + "']";
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
  if($(window).width() < 768)
    var resize = window_height_without_header() - 30;
  else
    var resize = window_height_without_header() - 50;
  $('.windowful').css("max-height", resize + "px");
  resize_option_bar(resize);
  resize_records_table(resize + 30);
};
var resize_option_bar = function(base) {
  /*
  if($('.option-bar').width() < 125){
    $('.options-col').css("visibility", "hidden");
    return;
  }
  $('.options-col').css("visibility", "visible");
  */
  var side_height = $('.option-bar-head').height();
  $('.record_form').css("max-height", base-side_height + "px");
}
var resize_records_table = function(base) {
  var head_height = $('.records-head').height();
  var buttons_height = $('.records-buttons').height();
  var thead_height = $('.records-thead').height();
  var table_width = $('.records-table').width();
  var tbody_height = base-head_height-buttons_height-thead_height
  $('.records-tbody').css("max-height", tbody_height + "px");
  $('.record-select').css("width", table_width*0.1 + "px");
  $('.record-action').css("width", table_width*0.1 + "px");
  $('.record-no').css("width", table_width*0.1 + "px");
  $('.record-data').css("width", table_width*0.6 + "px");
  $('.record-count').css("width", table_width*0.1 + "px");
  $('.record-select').css("max-width", table_width*0.1 + "px");
  $('.record-action').css("max-width", table_width*0.1 + "px");
  $('.record-no').css("max-width", table_width*0.1 + "px");
  $('.record-data').css("max-width", table_width*0.6 + "px");
  $('.record-count').css("max-width", table_width*0.1 + "px");
}

var size_modal_window = function() {
  if($('.modal-container').length == 0) return;
  var window_height = $(window).height();
  var header_height = 41;
  var buttons_height = 50;
  var margin = window_height * 0.1;
  var scroll_height = window_height_without_header()*0.8 - header_height - buttons_height - margin*2
  $('.modal-form').css("margin-top", margin + "px");
  $('.scroll-window').css("max-height", scroll_height + "px");
};

/*
var size_options_list = function() {
  var body_height = window_height_without_header();
  var header_height = $('.options-head').height();
  var buttons_height = $('.options-buttons').height();
  var scroll_height = body_height - header_height - buttons_height - 50
  change_overflow('.options-list', scroll_height)
  $('.options-list').css("max-height", scroll_height + "px");
};
*/

var affix_change = function() {
  $('.options-buttons').affix({
    offset: {
      top: function() {
        var options_head_offset = $('.recorder-item:first').offset().top + $('.recorder-item:first').height() + 10;
        var buttons_height = $('.options-buttons').height();
        //var options_buttons_offset = options_head_offset + buttons_height + 39;
        var options_buttons_offset_top = options_head_offset + 15;
        $('.buttons-wrap').css('height', buttons_height);
        //console.log($('.custom-affix').offset().top);
        return options_buttons_offset_top;
      }
    }
  });
}

var size_setup_form = function() {
  var window_height = window_height_without_header();
  var form_height = window_height * 0.8;
  var options_height = form_height - 300;
  $('.setup-form').css('max-height', form_height);
  $('.scroll-window').css('max-height', options_height);
}

/*
var size_graph = function() {
  if('.modal-container'.length == 0) return;
  if('.graph'.length == 0) return;
  console.log("graph");
  $('.graph').css("width", "100%");
  $('.graph').css("height", "100%");
  $('rect').css("text-overflow", "ellipsis");
};
*/

var hide_less_than_min_modal = function() {
  if($('.modal-container').length == 0) return;
  var window_width = $(window).width();
  if(window_width < 480){
    $('.modal-container').modal("hide");
    return;
  }
};

//スマートフォン以下のウィンドウサイズでoptions-barをスライドさせるボタンを用意
var slide_options = function() {
  var container = '.slide-button-container';
  var options = '.options-col';
  var grid = 'col-sm-3';
  if($(window).width() < 768){
    if($(options).hasClass(grid)){
      $(options).removeClass(grid);
      $(options).attr(grid);
    }
    if($('div.slide-button').length == 0){
      $(container).append('<div class="slide-button slide-open"></div>');
    }
  }
  else{
    if(!$(options).hasClass(grid)) {
      $(options).addClass(grid);
      $(options).css('left', '');
    }
    $(container).empty();
  }
};
