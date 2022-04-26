<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="jex.util.date.DateTime"%>
<%@page import="jex.util.StringUtil"%>
<%@page import="jex.sys.JexSystem"%>
<%
String _CURR_DATETIME = DateTime.getInstance().getDate("yyyymmdd");

if(JexSystem.getProperty("JEX.id").indexOf("_DEV") > -1){
	_CURR_DATETIME = DateTime.getInstance().getDate("yyyymmddhh24miss");
}
%>

<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="No-Cache">
<meta http-equiv="Pragma" content="No-Cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

<link rel="stylesheet" type="text/css" href="/admin/css/reset.cms.css?<%=_CURR_DATETIME%>" />
<link rel="stylesheet" type="text/css" href="/admin/css/content.cms.css?<%=_CURR_DATETIME%>" />
<link rel="stylesheet" type="text/css" href="/admin/css/calendar.css?<%=_CURR_DATETIME%>" />
<link rel="stylesheet" type="text/css" href="/admin/css/jquery-ui.css"/>
<link rel="stylesheet" type="text/css" href="/admin/css/jquery-ui-1.8.16.custom.css" />
<link rel="stylesheet" type="text/css" href="/admin/css/colorbox.css">

<script type="text/javascript" src="/admin/js/lib/jquery-1.8.1.min.js"></script>
<script type="text/javascript" src="/admin/js/lib/jquery.inherit-1.3.2.js"></script>
<script type="text/javascript" src="/admin/js/lib/json2.js"></script>
<script type="text/javascript" src="/admin/js/lib/jquery.cookie.js"></script>
<script type="text/javascript" src="/admin/js/lib/jquery.modal.js"></script>
<script type="text/javascript" src="/admin/js/lib/beautify.js"></script>
<script type="text/javascript" src="/admin/js/lib/loader.js"></script>
<script type="text/javascript" src="/admin/js/jex/jex.core.js?<%=_CURR_DATETIME%>"></script>
<script type="text/javascript" src="/admin/js/jexPlugin/jex.calendar.js?<%=_CURR_DATETIME%>"></script>
<script type="text/javascript" src="/admin/js/jexPlugin/jex.formatter.js?<%=_CURR_DATETIME%>"></script>
<script type="text/javascript" src="/admin/js/jexPlugin/jex.div.js?<%=_CURR_DATETIME%>"></script>
<script type="text/javascript" src="/admin/js/jexPlugin/jex.msg.js?<%=_CURR_DATETIME%>"></script>
<script type="text/javascript" src="/admin/js/jqueryPlugin/jquery-ui-1.11.0.min.js"></script>
<script type="text/javascript" src="/admin/js/jqueryPlugin/jquery.livequery.js"></script>
<script type="text/javascript" src="/admin/js/jqueryPlugin/jquery.select-to-autocomplete.js"></script>
<script type="text/javascript" src="/admin/js/jqueryPlugin/jquery.ui.datepicker-ko.js"></script>

<script type="text/javascript" src="/admin/js/jex.loading.js?<%=_CURR_DATETIME%>"></script>

<script type="text/javascript" src="/admin/js/fintech/fintech.common.js?<%=_CURR_DATETIME%>"></script>
<script type="text/javascript" src="/admin/js/include/smart.popup.js?<%=_CURR_DATETIME%>"></script>
<script type="text/javascript" src="/admin/js/fintech/fintech.table.paging.js?<%=_CURR_DATETIME%>"></script>
<script type="text/javascript" src="/admin/js/fintech/fintech.datepicker.js?<%=_CURR_DATETIME%>"></script>
<script type="text/javascript" src="/admin/js/fintech/fintech.formValidation.js?<%=_CURR_DATETIME%>"></script>

<link rel="stylesheet" type="text/css" href="/admin/js/jexjs/jex1.css?<%=_CURR_DATETIME%>">
<script type="text/javascript" src="/admin/js/jexGrid/jgrid-1.5.0-min.js?<%=_CURR_DATETIME%>"></script>

<!--[if IE 8]>
<script type="text/javascript" src="/admin/js/jexjs/jex-ie8.js?<%=_CURR_DATETIME%>"></script>
<script type="text/javascript" src="/admin/js/jexjs/jex.js?<%=_CURR_DATETIME%>"></script>
<![endif]-->
<!--[if !IE 8]><!--><script type="text/javascript" src="/admin/js/jexjs/jex1.js?<%=_CURR_DATETIME%>"></script><!--<![endif]-->


<style>
/* layer popup */
.modalOverlay {position:fixed;left:0;top:0;width:100%;height:100%;min-width:100%;min-height:100%;background:#000;opacity:0.3;filter:alpha(opacity=30);z-index:1995;}
* html .modalOoverlay {position:absolute;left:0;top:expression(eval(document.documentElement.scrollTop+document.documentElement.clientHeight-this.offsetHeight));}
.wrapLayerOn {width:100%;}

.title_wrap{z-index:1;}
.card_combo2 .layer_combo2 {z-index:2;}
.com_list div.group_name.type5 a:first-child{ padding: 2px 7px 0 34px !important;}
</style>