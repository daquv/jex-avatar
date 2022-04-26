$(document).ready(function(){
	'use strict';
	$('.gnbMenu_wrap').toggleAccordion({
		wrapClass:".gnbMenu_wrap",
		clickClass:".depthOneNode_click",
		showClass:".depthTwo",
		layer:false,
		multiShow:false,
		speed:300
	});

	$(".bt_menu").click(function(){
		$(".gnbMenu_wrap").css({"display":"block"});
		$(".gnbMenu").animate({
			marginLeft: '0'
		},250);
	})
	$(".depthTwo li a,.noSub,.menu_dimm").click(function(){
		$(".gnbMenu").animate({
			marginLeft: '-262px'
		},250,function(){
			$(".gnbMenu_wrap").css({"display":"none"});
		});
	})
	var scroll_position = 0;
	var scroll_direction;
	window.addEventListener('scroll', function(e){
		try{
			scroll_direction = (document.body.getBoundingClientRect()).top > scroll_position ? 'up' : 'down';
			scroll_position = (document.body.getBoundingClientRect()).top;
			var wH = $(window).height(),
			wS = $(this).scrollTop();

			if(scroll_direction==="down"){
				if(wS > (0-wH)){
					$(".header").removeClass("fixed");
				}
				//console.log("down");
			}else{
				//console.log("up");
				$(".header").addClass("fixed");
			}

		}catch (error) {
			//console.log(error);
		}
	});

	$(".mouse_scroll").click(function(){
		$('html, body').animate({
			scrollTop:$(".slider2").offset().top-60
		},300);
	});

	$(".btn_totop_wrap").gotoTopStyle1({
		wrapClass:".btn_totop_wrap",
		clickClass:".btn_gotoTop",
		jumpOnClass:".footer",
		bottom:["-46","26","26"],
		speed:500
	});

	$('.mfrm_wrap').toggleAccordion({
		wrapClass:".mfrm_wrap",
		clickClass:".js_click",
		showClass:".magr_layer",
		clickclassNoHide:[".mCSB_dragger_bar", ".mCSB_draggerRail"],
		layer:false,
		speed:300
	});

});