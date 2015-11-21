package prul.animations {
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Spring extends Animation {
		
		public var home:Number;
		public var change:Number = 0;

		private var springiness:Number = .2;
		private var decay:Number = .8;

		public function Spring(targetMC:MovieClip, propertyName:String, home:Number, springiness:Number = .2, decay:Number = .8, change:Number = 0, restless:Boolean = false, autoStart:Boolean = true):void
		{
			this.targetMC = targetMC;
			this.propertyName = propertyName;
			this.home = home;
			this.change = change;
			this.springiness = springiness;
			this.decay = decay;
			this.restless = restless;
			if(autoStart){
				start();
			}
		}
		
		public function onF(e:Event):void
		{
			trace(targetMC[propertyName]);
			change = (home - targetMC[propertyName]) * springiness + (change * decay); 
			targetMC[propertyName] += change;
			if(!restless && Math.abs(change) < 0.01){
				stop();
			}
		}
	}
}
