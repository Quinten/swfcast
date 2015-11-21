package  {
	
	import flash.display.MovieClip;
	
	
	public class ColorPreview extends MovieClip {
		public var bgColorPreviewMC:MovieClip;
		public var lightColorPreviewMC:MovieClip;
		public var lineColorPreviewMC:MovieClip;
		public var shadeColorPreview:MovieClip;
		
		public function ColorPreview() {
			// constructor code
		}
		
		public function setPreviewFrom(cast:Cast):void
		{
			func.colorMC(bgColorPreviewMC, cast.colors[0]);
			func.colorMC(lineColorPreviewMC, cast.colors[1]);
			func.colorMC(shadeColorPreview, cast.colors[2]);
			func.colorMC(lightColorPreviewMC, cast.colors[3]);
		}
	}
	
}
