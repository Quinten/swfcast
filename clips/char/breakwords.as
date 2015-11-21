package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.net.SharedObject;
	import fl.motion.Animator;
	
	public class breakwords extends MovieClip
	{
		private var commonObj:Object; 
		
		public function genTitle():void
		{
			mainMC.textbox.autoSize = TextFieldAutoSize.CENTER;
			commonObj = SharedObject.getLocal("common-object", "/");
			var newTitle:String = (commonObj.data.textStr) ? commonObj.data.textStr : "some title";
			mainMC.textbox.textColor = (commonObj.data.txtColor) ? commonObj.data.txtColor : 0x000000;
			mainMC.textbox.text = newTitle;
			addEventListener(Event.ADDED_TO_STAGE, repositTextbox);
		}
		
		public function repositTextbox(e:Event = null):void
		{
			mainMC.x = (stage.stageWidth/2) - (mainMC.width/2);
			mainMC.y = (stage.stageHeight/2) - (mainMC.height/2);
		}
	}
}