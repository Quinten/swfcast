package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;
	import flash.text.*;
	import flash.net.SharedObject;
	
	public class matrixBin extends MovieClip
	{
		private var commonObj:Object;
		private var textStr:String;
		private var txtColor:int;
		private var blockArr:Array = new Array();
		private var gridSpacing:Number = 100;
		private var gridX:Number = 10;
		private var gridY:Number = 5;
		private var offsetX:Number;
		private var offsetY:Number;
		private var stopIndex:int = 0;
		private var charIndex:int = 0;
		private var colIndex:int = 0;
		private var rollingIn:Boolean = false;
		
		public function matrixBin():void
		{
			commonObj = SharedObject.getLocal("swfcastLocalData", "/");
			textStr = (commonObj.data.fluxCast) ? (commonObj.data.fluxCast.text + " ") : "some title ";
			//textStr = "t raum schmiere !!!!!! !! ";
			textStr = textStr.toLowerCase();
			txtColor = (commonObj.data.fluxCast) ? commonObj.data.fluxCast.colors[1] : 0x00ff00;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event = null):void
		{
			offsetX = (stage.stageWidth - (gridSpacing * gridX))/2;
			offsetY = (stage.stageHeight - (gridSpacing * gridY))/2;
			for(var gY:int = 0; gY < gridY; gY++){
				for(var gX:int = 0; gX < gridX; gX++)
				{
					var blockObj:MovieClip = new block();
					blockObj.textbox.textColor = txtColor;
					//blockObj.textbox.text = textStr.substr(c,1);
					blockObj.width = gridSpacing;
					blockObj.height = gridSpacing;
					blockObj.x = offsetX + (gX * gridSpacing);
					blockObj.y = offsetY + (gY * gridSpacing);
					blockObj.rolling = true;
					addChild(blockObj);
					blockArr.push(blockObj);
				}
			}
			addEventListener(Event.ENTER_FRAME, animationLoop);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, deInit);
		}
		
		public function animationLoop(e:Event):void
		{
			for each(var blockObj in blockArr)
			{
				if(blockObj.rolling){
					blockObj.textbox.text = textStr.substr(Math.floor(Math.random()*textStr.length),1);
				}
			}
			blockArr[stopIndex].rolling = rollingIn;
			if(!rollingIn){
				blockArr[stopIndex].textbox.text = textStr.substr(charIndex,1);
				if(textStr.substr(charIndex,1) == " "){
					for(var c:int = (colIndex + 1); c < gridX;c++){
							stopIndex++;
							blockArr[stopIndex].rolling = rollingIn;
							blockArr[stopIndex].textbox.text = " ";
							colIndex++;
					}
				}
			}
			charIndex++;
			colIndex++;
			if(stopIndex > (blockArr.length - 2)){
				stopIndex = 0;
				rollingIn = (rollingIn) ? false : true;
				charIndex = 0;
			}else{
				stopIndex++;
			}
			if(charIndex == textStr.length){
				charIndex = 0;
				//stopIndex = 0;
				//rollingIn = (rollingIn) ? false : true;
				//colIndex = 0;
			}
			if(colIndex > (gridX - 1)){
				colIndex = 0;
			}
		}
		
		public function deInit(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, animationLoop);
			removeEventListener(Event.REMOVED_FROM_STAGE, deInit);
		}
	}
}