package prul.animations {
	import flash.events.Event;

	/**
	 * Interface all animations must implement
	 */
	public interface IAnimation {
		
		/**
		 * Starts the animation
		 */
		function start():void;
		/**
		 * Stops the animation
		 */
		function stop(e:Event = null):void;
		function onF(e:Event):void;
	}
}
