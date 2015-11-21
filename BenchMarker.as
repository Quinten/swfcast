package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	
	public class BenchMarker extends MovieClip {
		
		private var elapsedTime:int;
		private var rhythm:int = 5;
		private var bar:int = 1; 

		public function BenchMarker() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			this.addEventListener(Event.ENTER_FRAME, doTick);
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, doRemove);
		}
		
		public function doTick(e:Event):void
		{
			bar++;
			if(bar > rhythm){
				var timeSpan:int = getTimer() - elapsedTime;
				var fpsStr:String = String(1000 * rhythm / timeSpan);
				fpsStr = fpsStr.substr(0, 2);
				this.textbox.text = fpsStr;
				elapsedTime = getTimer();
				bar = 1;
			}
		}
		
		public function doRemove():void
		{
			this.removeEventListener(Event.ENTER_FRAME, doTick);
		}
		
	}
	
}
