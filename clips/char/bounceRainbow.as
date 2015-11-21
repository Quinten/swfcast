package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	import flash.net.SharedObject;
	
	public class bounceRainbow extends MovieClip
	{
		private var commonObj:Object;
		private var textStr:String;
		private var txtColor:int;
		private var blockArr:Array = new Array();
		private var bounceInt:uint;
		private var ground:Number = 400;
		
		public function bounceRainbow():void
		{
			commonObj = SharedObject.getLocal("common-object", "/");
			textStr = (commonObj.data.textStr) ? commonObj.data.textStr : "some title";
			//textStr = "cubic clash";
			textStr = textStr.toLowerCase();
			txtColor = (commonObj.data.txtColor) ? commonObj.data.txtColor : 0x00ff00;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void
		{
			ground = stage.stageHeight/2;
			for(var c:int = 0; c < textStr.length; c++)
			{
				var blockObj:MovieClip = new block();
				blockObj.textbox.textColor = Math.random() * 0xffffff;
				blockObj.textbox.text = textStr.substr(c,1);
				blockObj.width = (stage.stageWidth - 200) / textStr.length;
				blockObj.height = blockObj.width;
				blockObj.x = 100 + (c * blockObj.width);
				//blockObj.y = Math.random() * -500;
				blockObj.y = ground;
				blockObj.gravity = 2;
				blockObj.step = 0;
				blockObj.decay = 0.8;
				addChild(blockObj);
				blockArr.push(blockObj);
			}
			addEventListener(Event.ENTER_FRAME, animationLoop);
			bounceInt = setInterval(bounceUp, 2400);
			bounceUp();
		}
		
		public function animationLoop(e:Event):void
		{
			for each(var blockObj in blockArr)
			{
				blockObj.step += blockObj.gravity;
				if((blockObj.y + blockObj.step) > ground)
				{
					blockObj.y = ground;
					blockObj.step = - blockObj.step * blockObj.decay;
				}else{
					blockObj.y += blockObj.step;
				}
			}
		}
		
		public function bounceUp():void
		{
			for each(var blockObj in blockArr)
			{
				blockObj.step = 10 + Math.random() * 20;
			}			
		}
	}
}