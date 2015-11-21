package  {
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	
	public class Tube extends MovieClip {

		public var bgColorMC:MovieClip;
		public var bottomLayerMC:MovieClip;
		public var topLayerMC:MovieClip;
		
		public var bottomLoader:Loader;
		public var topLoader:Loader;

		public function Tube() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			bgColorMC = new MovieClip();
			bgColorMC.addChild(func.drawMask(80, 80));
			func.colorMC(bgColorMC, 0x003333);
			this.addChild(bgColorMC);
			bottomLayerMC = new MovieClip();
			this.addChild(bottomLayerMC);
			topLayerMC = new MovieClip();
			this.addChild(topLayerMC);
			stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize();
		}
		
		public function processCast(fluxCast:Cast):void
		{
			if(fluxCast.clip != ""){
				trace("Loading " + fluxCast.clip + " @" + fluxCast.layer);
			}else{
				trace("Clearing " + fluxCast.layer);
			}
			switch(fluxCast.layer){
				case "bottom":
					if(bottomLoader){
						bottomLayerMC.removeChild(bottomLoader);
						bottomLoader.unloadAndStop();
						bottomLoader = null;
					}
					if(fluxCast.clip != ""){
						bottomLoader = func.grabLoader(fluxCast.clip);
						bottomLayerMC.addChild(bottomLoader);
					}
					break;
				case "top":
					if(topLoader){
						topLayerMC.removeChild(topLoader);
						topLoader.unloadAndStop();
						topLoader = null;
					}
					if(fluxCast.clip != ""){
						topLoader = func.grabLoader(fluxCast.clip);
						topLayerMC.addChild(topLoader);
					}
					break;
			}

			trace("Change bgColor to " + fluxCast.colors[0]);
			func.colorMC(bgColorMC, fluxCast.colors[0]);
		}
		
		public function clearTube():void
		{
			if(bottomLoader != null){
				bottomLayerMC.removeChild(bottomLoader);
				bottomLoader.unloadAndStop();
				bottomLoader = null;
			}
			if(topLoader != null){
				topLayerMC.removeChild(topLoader);
				topLoader.unloadAndStop();
				topLoader = null;
			}
		}
		
		public function onStageResize(e:Event = null):void
		{
			var sW:Number = stage.stageWidth;
			var sH:Number = stage.stageHeight;
			bgColorMC.width = sW;
			bgColorMC.height = sH;
		}

	}
	
}
