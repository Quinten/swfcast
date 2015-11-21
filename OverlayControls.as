package  
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.hires.debug.Stats;	
	
	public class OverlayControls extends MovieClip 
	{
		public const spacer:Number = 80;
		
		public var clearButtonMC:MovieClip;
		public var layerButtonMC:MovieClip;
		//public var playButtonMC:MovieClip;
		//public var recButtonMC:MovieClip;
		public var scrollButtonDownMC:MovieClip;
		//public var scrollButtonNextMC:MovieClip;
		//public var scrollButtonPrevMC:MovieClip;
		public var scrollButtonUpMC:MovieClip;
		public var typeButtonMC:MovieClip;
		//public var sequenceSelectorMC:MovieClip;
		public var channelSelectorMC:MovieClip;
		public var colorPreviewMC:ColorPreview;
		public var clipButtonContainerMC:MovieClip;
		public var clipButtonMask:MovieClip;
		public var formMC:MovieClip;
		
		public function OverlayControls() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event){
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			clipButtonContainerMC = new MovieClip();
			addChild(clipButtonContainerMC);
			clipButtonMask = new MovieClip();
			clipButtonMask.addChild(func.drawMask(80, 80));
			addChild(clipButtonMask);
			clipButtonContainerMC.mask = clipButtonMask;
			func.makeButton(scrollUp, scrollButtonUpMC);
			func.makeButton(scrollDown, scrollButtonDownMC);
			formMC.visible = false;
			stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize();
			var stats = new Stats();
			//stats.y = spacer;
			addChild(stats);
			addChild(formMC);
			this.addEventListener(Event.REMOVED_FROM_STAGE, deInit);
		}
		
		public function scrollUp(e:MouseEvent):void
		{
			if(clipButtonContainerMC.y < spacer){
				clipButtonContainerMC.y += spacer;
			}
		}
		
		public function scrollDown(e:MouseEvent):void
		{
			if(clipButtonContainerMC.y > -(clipButtonContainerMC.height - clipButtonMask.height - spacer)){
				clipButtonContainerMC.y -= spacer;
			}
		}
		
		public function onStageResize(e:Event = null):void
		{
			var sW:Number = stage.stageWidth;
			var sH:Number = stage.stageHeight;
			//recButtonMC.x = recButtonMC.width / 2;
			//recButtonMC.y = recButtonMC.height / 2;
			//playButtonMC.x = recButtonMC.width + (playButtonMC.width / 2);
			//playButtonMC.y = playButtonMC.height / 2;
			//sequenceSelectorMC.x = recButtonMC.width + playButtonMC.width + (sequenceSelectorMC.width / 2);
			//sequenceSelectorMC.y = sequenceSelectorMC.height / 2;
			//channelSelectorMC.x = recButtonMC.width + playButtonMC.width + sequenceSelectorMC.width + (channelSelectorMC.width / 2);
			//channelSelectorMC.y = channelSelectorMC.height / 2;
			scrollButtonUpMC.x = sW - (scrollButtonUpMC.width / 2);
			scrollButtonUpMC.y = scrollButtonUpMC.height / 2;
			channelSelectorMC.x = sW - (scrollButtonUpMC.width) - (channelSelectorMC.width / 2);
			channelSelectorMC.y = channelSelectorMC.height / 2;
			scrollButtonDownMC.x = sW - (scrollButtonDownMC.width / 2);
			scrollButtonDownMC.y = sH - (scrollButtonDownMC.height / 2);
			//scrollButtonPrevMC.x = scrollButtonPrevMC.width / 2;
			//scrollButtonPrevMC.y = sH - scrollButtonNextMC.height - colorPreviewMC.height - (scrollButtonPrevMC.height / 2);
			//scrollButtonNextMC.x = scrollButtonNextMC.width / 2;
			//scrollButtonNextMC.y = sH - (scrollButtonNextMC.height / 2);
			//typeButtonMC.x = scrollButtonNextMC.width + (typeButtonMC.width / 2);
			typeButtonMC.x = colorPreviewMC.width + (typeButtonMC.width / 2);
			typeButtonMC.y = typeButtonMC.height / 2;
			layerButtonMC.x = sW - scrollButtonDownMC.width - (layerButtonMC.width / 2);
			layerButtonMC.y = sH - (layerButtonMC.height / 2);
			clearButtonMC.x = sW - scrollButtonDownMC.width - layerButtonMC.width - (clearButtonMC.width / 2);
			clearButtonMC.y = sH - (clearButtonMC.height / 2);
			colorPreviewMC.x = colorPreviewMC.width / 2;
			//colorPreviewMC.y = sH - scrollButtonNextMC.height - (colorPreviewMC.height / 2);
			colorPreviewMC.y = sH - (colorPreviewMC.height / 2);
			clipButtonContainerMC.x = sW - scrollButtonUpMC.width;
			clipButtonContainerMC.y = scrollButtonUpMC.height;
			clipButtonMask.x = clipButtonContainerMC.x;
			clipButtonMask.y = clipButtonContainerMC.y;
			clipButtonMask.width = scrollButtonUpMC.width;
			clipButtonMask.height = sH - (scrollButtonDownMC.height + scrollButtonUpMC.height);
			//formMC.x = sW/2 - formMC.width/2;
			formMC.y = spacer;
		}
		
		public function deInit(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, deInit);
			stage.removeEventListener(Event.RESIZE, onStageResize);
		}
	}	
}
