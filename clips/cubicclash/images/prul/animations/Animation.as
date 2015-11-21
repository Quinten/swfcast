package prul.animations {
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Animation {
		
		public var targetMC:MovieClip;
		public var propertyName:String = "x";
		public var restless:Boolean;

		public function start():void
		{
			//trace(targetMC[propertyName]);
			targetMC.addEventListener(Event.ENTER_FRAME, onF);
			targetMC.addEventListener(Event.REMOVED_FROM_STAGE, stop);
		}
		
		public function onF(e:Event):void
		{

		}
		
		public function stop(e:Event = null):void
		{
			trace("Animation stopped.");
			targetMC.removeEventListener(Event.ENTER_FRAME, onF);
			targetMC.removeEventListener(Event.REMOVED_FROM_STAGE, stop);
			targetMC = null;
		}
	}
}
