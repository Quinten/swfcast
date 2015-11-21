package{
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.net.*;
	import flash.events.*;
	
	public class func {
		
		/* ------------------------- */
		/* generic usefull functions */
		/* collected by Quinten Clause */
		
		public static function makeButton(clickCallBack:Function, targetMC:MovieClip, rollOverCallBack:Function = null, rollOutCallBack:Function = null):void
		{
			targetMC.buttonMode = true;
			targetMC.mouseChildren = false;
			targetMC.addEventListener(MouseEvent.CLICK, clickCallBack);
			if(rollOverCallBack != null){
				targetMC.addEventListener(MouseEvent.ROLL_OVER, rollOverCallBack);
			}
			if(rollOutCallBack != null){
				targetMC.addEventListener(MouseEvent.ROLL_OUT, rollOutCallBack);
			}
		}
		
		/* loads an image or even an swf and adds it to the target MovieClip */
		public static function loadIMG(imgLocation:String, targetMC:MovieClip):void
		{
			var imgLoader:Loader = new Loader();
			var	imgReq:URLRequest = new URLRequest(imgLocation);
			imgLoader.load(imgReq);
			targetMC.addChild(imgLoader);
		}
		
		/* loads an image or even an swf and adds it to the target MovieClip and executes a callback when ready */
		public static function loadIMGExtra(imgLocation:String, targetMC:MovieClip, callBack:Function):void
		{
			var imgLoader:Loader = new Loader();
			var	imgReq:URLRequest = new URLRequest(imgLocation);
      imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, callBack);
			imgLoader.load(imgReq);
			targetMC.addChild(imgLoader);
		}
		
		/* creates a new loader and returns it */
		public static function grabLoader(imgLocation:String, callBack:Function = null):Loader
		{
			var imgLoader:Loader = new Loader();
			var	imgReq:URLRequest = new URLRequest(imgLocation);
			if(callBack != null){
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, callBack);
			}
			imgLoader.load(imgReq);
			//targetMC.addChild(imgLoader);
			return imgLoader;
		}
		
		/* resizes a DisplayObject, with or without constrain of proportions */
		public static function resizeDisplayObject(targetDObj:DisplayObject, maxW:Number, maxH:Number=0, constrainProportions:Boolean=true):void
		{
				maxH = maxH == 0 ? maxW : maxH;
				targetDObj.width = maxW;
				targetDObj.height = maxH;
				if (constrainProportions) {
						targetDObj.scaleX < targetDObj.scaleY ? targetDObj.scaleY = targetDObj.scaleX : targetDObj.scaleX = targetDObj.scaleY;
				}
		}
		
		// centers a displayObject (that is aligned 0,0) to a given rectangle
		public static function centerDisplayObject(targetDObj:DisplayObject, W:Number, H:Number):void
		{
				targetDObj.x = (W - targetDObj.width)/2;
				targetDObj.y = (H - targetDObj.height)/2;
		}
		
		// aligns the displayObject(center, center)
		public static function centerToAnchor(targetDObj:DisplayObject):void
		{
				targetDObj.x = - targetDObj.width/2;
				targetDObj.y = - targetDObj.height/2;		
		}
		
		// aligns the displayObject(center, center)
		public static function centerToCenter(targetDObj:DisplayObject):void
		{
				targetDObj.x = targetDObj.width/2;
				targetDObj.y = targetDObj.height/2;		
		}
		
		/* colors a MovieClip */
		public static function colorMC(targetMC:MovieClip, newColor:uint):void
		{
			//var colorTransform:ColorTransform = targetMC.transform.colorTransform;
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = newColor;
			targetMC.transform.colorTransform = colorTransform;
		}
		
		public static function unColorMC(targetMC:MovieClip):void
		{
			targetMC.transform.colorTransform = null;
		}
		
		/* loads an xml-file and executes a callback when ready */
		public static function loadXML(xmlLocation:String, callBack:Function):void
		{
			var xmlRequest:URLRequest = new URLRequest(xmlLocation);
      		var urlLoader:URLLoader = new URLLoader();
      		urlLoader.addEventListener(Event.COMPLETE, callBack);
     	 	urlLoader.load(xmlRequest);
		}
		
		// sends an asynchronuos request without handling the response
		public static function sendAsync(urlStr:String): void
		{	
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = urlStr;
			urlRequest.method = URLRequestMethod.GET;
			urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.load( urlRequest );
		}
		
		// posts form data
		public static function sendPost(urlStr:String, urlVars:URLVariables, callBack:Function = null): void
		{	
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = urlStr;
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			urlRequest.data = urlVars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			if(callBack != null){
				urlLoader.addEventListener(Event.COMPLETE, callBack);
			}
			try {
				urlLoader.load(urlRequest);
			} catch (e:Error) {
				trace(e);
			}
		}
		
		/* chops the first character of an objects name and returns the rest as integer */
		public static function returnIndex(targetObj:Object):int
		{
			var targetName:String = targetObj.name;
			var targetIndex:int = int(targetName.slice(1, targetName.length));
			return targetIndex;
		}
		
		/* chops the first character of an objects name and returns the rest as integer as String */
		public static function returnStringIndex(targetObj:Object):String
		{
			var targetName:String = targetObj.name;
			var targetIndex:String = targetName.slice(1, targetName.length);
			return targetIndex;
		}
		
		/* returns the filename at the end of a relative or absolute path */
		public static function returnFilename(fullPathStr:String):String
		{
			var folderArr:Array = fullPathStr.split("/");
			return folderArr.pop();
		}
		
		/* removes unnecessary white space in a string so there are no double whitelines in a textbox */
		public static function trim(textStr:String):String
		{
			return textStr.split("\r\n").join("\n")
		}
		
		// creates a uniqID based on date in millieseconds
		public static function getUniqueName():String
		{
			var d : Date = new Date();
			return d.getMonth() + 1 + '' + d.getDate() + '' + d.getHours() + '' + d.getMinutes() + ''  + d.getMilliseconds();
		}
		
		// removes all children from a MovieClip
		public static function clearMovieClip(targetMC:MovieClip)
		{
			for(var c:int = 0; c < targetMC.numChildren; c++)
			{
				targetMC.removeChildAt(c);
			}
		}
		
		// creates a set of random numbers with each number appearing only once
		public static function randomUnique(startNumber:int = 0, endNumber:int = 9):Array
		{
			var baseNumber:Array = new Array();
			var randNumber:Array = new Array();
			for(var i:int =startNumber; i<=endNumber; i++){
				baseNumber[i] = i;
			}
			for(i=endNumber; i>startNumber; i--){
				var tempRandom:Number = startNumber + Math.floor(Math.random()*(i - startNumber));
				randNumber[i] = baseNumber[tempRandom];
				baseNumber[tempRandom] = baseNumber[i]; 																																											
			}
			randNumber[startNumber] = baseNumber[startNumber];
			return randNumber;		
		}
		
		// creates a rectangular mask shape
		public static function drawMask(w:Number, h:Number, corner:Number = 0):Shape {
				var maskShape:Shape = new Shape();
				maskShape.graphics.beginFill(0x66ff00);
				maskShape.graphics.drawRoundRect(0, 0, w, h, corner);
				maskShape.graphics.endFill();
				return maskShape;
		}
		
		// creates a transparant black shape
		public static function blackOverlay(w:Number, h:Number, corner:Number = 0):Shape {
				var maskShape:Shape = new Shape();
				maskShape.graphics.beginFill(0x000000, 0.6);
				maskShape.graphics.drawRoundRect(0, 0, w, h, corner);
				maskShape.graphics.endFill();
				return maskShape;
		}
		
		// creates a completly transparant shape
		public static function transparantOverlay(w:Number, h:Number, corner:Number = 0):Shape {
				var maskShape:Shape = new Shape();
				maskShape.graphics.beginFill(0x000000, 0);
				maskShape.graphics.drawRoundRect(0, 0, w, h, corner);
				maskShape.graphics.endFill();
				return maskShape;
		}
		
		// creates a circle mask shape
		public static function drawCircleMask(size:Number):Shape {
				var maskShape:Shape = new Shape();
				var halfSize:uint = Math.round(size/2);
				maskShape.graphics.beginFill(0x00ff00);
				maskShape.graphics.drawCircle(halfSize, halfSize, halfSize);
				maskShape.graphics.endFill();
				return maskShape;
		}
		
		// a white rectangle
		public static function whiteFill(w:Number, h:Number, corner:Number = 0):Shape {
				var maskShape:Shape = new Shape();
				maskShape.graphics.beginFill(0xffffff);
				maskShape.graphics.drawRoundRect(0, 0, w, h, corner);
				maskShape.graphics.endFill();
				return maskShape;
		}

		// creates a bitmap of a displayObject and crops it to rectangle
		public static function croppedBitmapData(sourceObj:DisplayObject, rect:Rectangle, smoothing:Boolean = true):BitmapData
		{
		 
			if(!sourceObj is IBitmapDrawable)
			{
				throw new Error("Cannot create BitmapData.  sourceObj must implement IBitmapDrawable");
			}
		 
			var bmpData1:BitmapData = new BitmapData(sourceObj.width, sourceObj.height, true);
			var bmpData2:BitmapData = new BitmapData(rect.width, rect.height, true);
		 
			bmpData1.draw(sourceObj, null, null, null, null, smoothing);
			bmpData2.copyPixels(bmpData1, rect, new Point(0, 0));
		 
			bmpData1.dispose();
		 
			return bmpData2;
		}
		
	}
	
}