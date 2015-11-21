<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<title># <?php echo $_REQUEST['q'];?> swfcast</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="swfobject.js"></script>
		<script type="text/javascript">
			var swfVersionStr = "10.1.52";
			var xiSwfUrlStr = "";
			var flashvars = {showUI: "no", channel: "<?php echo $_REQUEST['q'];?>", noLoop: "<?php if($_REQUEST['noLoop']) echo $_REQUEST['noLoop']; else echo "no"; ?>"};
			var params = {};
			params.quality = "high";
			params.bgcolor = "#333333";
			params.play = "true";
			params.loop = "true";
			params.wmode = "window";
			params.scale = "noscale";
			params.menu = "true";
			params.devicefont = "false";
			params.salign = "";
			params.allowscriptaccess = "sameDomain";
			params.allowFullScreen = "true";
			params.fullScreenOnSelection = "true";
			var attributes = {};
			attributes.id = "swfcast";
			attributes.name = "swfcast";
			attributes.align = "middle";
			swfobject.createCSS("html", "height:100%; background-color: #003333;");
			swfobject.createCSS("body", "margin:0; padding:0; overflow:hidden; height:100%;");
			swfobject.embedSWF(
				"swfcast.swf", "flashContent",
				"100%", "100%",
				swfVersionStr, xiSwfUrlStr,
				flashvars, params, attributes);
		</script>
	</head>
	<body>
		<div id="flashContent">
			<a href="http://www.adobe.com/go/getflash">
				Update your Flash Player to 10.1.52
			</a>
		</div>
	</body>
</html>
