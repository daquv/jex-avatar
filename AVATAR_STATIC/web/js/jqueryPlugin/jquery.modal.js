/*
    A simple jQuery modal (http://github.com/kylefox/jquery-modal)
    Version 0.5.3
*/
(function($) {

  var current = null;

  $.modal = function(el, options) {
    $.modal.close(); // Close any open modals.
    var remove, target;
    this.$body = $('body');
    this.options = $.extend({}, $.modal.defaults, options);
    if (el.is('a')) {
      target = el.attr('href');
      //Select element by id from href
      if (/^#/.test(target)) {
        this.$elm = $(target);
        if (this.$elm.length !== 1) return null;
        this.open();
      //AJAX
      } else {
        this.$elm = $('<div>');
        this.$body.append(this.$elm);
        remove = function(event, modal) { modal.elm.remove(); };
        this.showSpinner();
        el.trigger($.modal.AJAX_SEND);
        $.get(target).done(function(html) {
          if (!current) return;
          el.trigger($.modal.AJAX_SUCCESS);
          current.$elm.empty().append(html).on($.modal.CLOSE, remove);
          current.hideSpinner();
          current.open();
          el.trigger($.modal.AJAX_COMPLETE);
        }).fail(function() {
          el.trigger($.modal.AJAX_FAIL);
          current.hideSpinner();
          el.trigger($.modal.AJAX_COMPLETE);
        });
      }
    } else {
      this.$elm = el;
      this.open();
    }
  };

  $.modal.prototype = {
    constructor: $.modal,
    layerWrap : $('.layerType1'),
    open: function() {
      
      this.block();
      this.show();
      if (this.options.escapeClose) {
        $(document).on('keydown.modal', function(event) {
          if (event.which == 27) $.modal.close();
        });
      }
      if (this.options.clickClose) this.blocker.click($.modal.close);
    },

    close: function() {
      this.unblock();
      this.hide();
      $(document).off('keydown.modal');
    },

    block: function() {
      
      this.$elm.trigger($.modal.BEFORE_BLOCK, [this._ctx()]);
      this.blocker = $('<div class="jquery-modal blocker"></div>').css({
        top: 0, right: 0, bottom: 0, left: 0,
        width: "100%", height: "100%",
        position: "fixed",
        zIndex: this.options.zIndex,
        background: this.options.overlay,
        opacity: this.options.opacity
      });
      this.$body.append(this.blocker);
      this.$elm.trigger($.modal.BLOCK, [this._ctx()]);
       
    },

    unblock: function() {
      this.blocker.remove();
    },

    show: function() {
      this.$elm.trigger($.modal.BEFORE_OPEN, [this._ctx()]);
      if (this.options.showClose) {
        this.closeButton = $('<a href="#close-modal" rel="modal:close" class="close-modal">' + this.options.closeText + '</a>');
        this.$elm.append(this.closeButton);
      }
      this.$elm.addClass(this.options.modalClass + ' current' +' wrapLayerOn');
      this.layerWrap.attr("tabindex","0").focus();
      
      this.center();
      this.callLayerPopBefore(); 
      this.$elm.show().trigger($.modal.OPEN, [this._ctx()]);
    },

    hide: function() {
      this.$elm.trigger($.modal.BEFORE_CLOSE, [this._ctx()]);
      if (this.closeButton) this.closeButton.remove();
      this.$elm.removeClass('current').hide();
      this.$elm.trigger($.modal.CLOSE, [this._ctx()]);
    },

    showSpinner: function() {
      if (!this.options.showSpinner) return;
      this.spinner = this.spinner || $('<div class="' + this.options.modalClass + '-spinner"></div>')
        .append(this.options.spinnerHtml);
      this.$body.append(this.spinner);
      this.spinner.show();
    },

    hideSpinner: function() {
      if (this.spinner) this.spinner.remove();
    },

    center: function() {
      this.$elm.css({
        position: 'fixed',
        top: "50%",
        left: "50%",
        marginTop: - (this.$elm.outerHeight() / 2),
        marginLeft: - (this.$elm.outerWidth() / 2),
        zIndex: this.options.zIndex + 1
      });
    },
    callLayerPopBefore: function(){
        $(this.layerWrap).defineInputStatus();
        // select 디자인
        if($(this.layerWrap).find('.selectRadio').length){
            var listWidth;
            $(this.layerWrap).find('.selectRadio').each(function(i,o){              
                if(!$(o).hasClass("noDefault")){
                    listWidth = $(o).width();       
                    if($(this).find("li a").length){
                        $(this).selectRadio({listWidth : listWidth, selectEvent : "a", selectEl : "li"});
                    }else{          
                        $(this).selectRadio({listWidth : listWidth});   
                    }
                }
                
            });
        }   
        
        // button 처리
        uiButtonCtrl();
        // UI 개선 라디오/체크 상자
        uiCheckCtrl();  
        // input
        uiInputTextCtrl();
        // numberFormat
        numberFormat();
        printDialog();
        
        // scroll 디자인
        
        //console.log(this, $(this.layerWrap));

        
        //if(!$(this.layerWrap).find('.scrollContent:first').find(".scrollBox").length){
            //$(this.layerWrap).find(".scrollContent:first").each(function(i,o){
                //$(this.layerWrap).not(".selectRadio").find(".scrollContent:first").jScrollPane({autoReinitialise : true});
            //});
        //}
        //$(this.layerWrap).find('.scrollContent:not(.listOption)').jScrollPane({autoReinitialise : true});
        $(this.layerWrap).find('.scrollContent:not(.listOption)').jScrollPane(
            {
                autoReinitialise: true
                //autoReinitialiseDelay: 5000
            }
        );
    },

    //Return context for custom events
    _ctx: function() {
      return { elm: this.$elm, blocker: this.blocker, options: this.options };
    }
  };

  //resize is alias for center for now
  $.modal.prototype.resize = $.modal.prototype.center;

  $.modal.close = function(event) {
  
    if (!current) return;
    if (event) event.preventDefault();
    $('.layerType1').remove();
    current.close();
    var that = current.$elm;
    current = null;
    return that;
  };

  $.modal.resize = function() {
    if (!current) return;
    current.resize();
  };

  $.modal.defaults = {
    overlay: "#000",
    opacity: 0.30,
    zIndex: 995,
    escapeClose: false,
    clickClose: false,
    closeText: 'Close',
    modalClass: "modal",
    spinnerHtml: null,
    showSpinner: true,
    showClose: true
  };

  // Event constants
  $.modal.BEFORE_BLOCK = 'modal:before-block';
  $.modal.BLOCK = 'modal:block';
  $.modal.BEFORE_OPEN = 'modal:before-open';
  $.modal.OPEN = 'modal:open';
  $.modal.BEFORE_CLOSE = 'modal:before-close';
  $.modal.CLOSE = '.btnClose';
  $.modal.AJAX_SEND = 'modal:ajax:send';
  $.modal.AJAX_SUCCESS = 'modal:ajax:success';
  $.modal.AJAX_FAIL = 'modal:ajax:fail';
  $.modal.AJAX_COMPLETE = 'modal:ajax:complete';

  $.fn.modal = function(options){

      
      //if (this.length === 1) {
      current = new $.modal(this, options);
    //}
    //return this;
  };

  // Automatically bind links with rel="modal:close" to, well, close the modal.
  $(document).on('click.modal', 'a[rel="modal:close"]', $.modal.close);
  $(document).on('click.modal', '.btnClose', $.modal.close);
  $(document).on('click.modal', 'a[rel="modal:open"]', function(event) {
    event.preventDefault();
    $(this).modal();
  });
})(jQuery);
