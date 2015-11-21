package prul.animations {
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Slidy extends Animation {
		
		public var home:Number;

		private var friction:Number = .2;
		
		public function Slidy(targetMC:MovieClip, propertyName:String, home:Number, friction:Number = .2, restless:Boolean = false, autoStart:Boolean = true):void
		{
			this.targetMC = targetMC;
			this.propertyName = propertyName;
			this.home = home;
			this.friction = friction;
			this.restless = restless;
			if(autoStart){
				start();
			}
		}
		
		override public function onF(e:Event):void
		{
			//trace(targetMC[propertyName]);
			targetMC[propertyName] += (home - targetMC[propertyName]) * friction;
			if(!restless && Math.abs((home - targetMC[propertyName])) < 0.01){
				stop();
			}
		}
	}
}
