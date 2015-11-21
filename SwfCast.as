package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.media.Video;
	
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
	
	import flash.net.NetConnection;
	import flash.events.NetStatusEvent;

	import flash.net.SharedObject;
	import flash.events.SyncEvent;
	
	import flash.utils.setInterval;
	
	public class SwfCast extends MovieClip {
		
		public var channel:int = 1;
		public var numChannels:int = 20;
		
		public var channelCast:Array = new Array();
		public var draftCast:Cast;
		
		public var paramObj:Object;
		
		public var showUI:Boolean = true;
		public var dataXML:XML;
		public var OverlayControlsMC:OverlayControls;
		public var colorSetIndex:int = 0;
		public var numColorSets:int = 0;
		
		public var tubeMC:Tube;
		
		//private var rtmpPath:String = "rtmp://localhost/ConnectToSharedObject";
		private var rtmpPath:String = "rtmpt://localhost/ConnectToSharedObject"; // via http (passes more firewalls)
		private var uniqID:String;
		private var localSO:SharedObject;
		private var remoteSO:SharedObject;
		private var nc:NetConnection;
		private var good:Boolean;
		
		private var bar:Number = 4;
		private var changeInterval:uint;
		private var changeDelay:Number = 1000 * 60;
		private var startChannel:int = 1;
		
		public function SwfCast() {
			// collect flashvars
			paramObj = this.root.loaderInfo.parameters;
			showUI = (paramObj["showUI"] == "no") ? false : showUI;
			channel = (paramObj["channel"]) ? int(Number(paramObj["channel"])) : channel;
			// load local data
			localSO = SharedObject.getLocal("swfcastLocalData", "/");
			// setup
			draftCast = new Cast();
			trace(draftCast.text);
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			// lock m flash player into landscapemode
			var lockVid:Video = new Video();
			addChild(lockVid);
			// align and scaleMode
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			// fullscreenmenu
			buildFSMenu();
			// add tube viewport
			tubeMC = new Tube();
			this.addChild(tubeMC);
			// consider showing UI
			if(showUI){
				func.loadXML("data.xml", initUI);
			}
			makeConnection();
		}
		
		public function makeConnection():void
		{
			// connect to server
			nc=new NetConnection();
			nc.connect(rtmpPath);
			nc.addEventListener (NetStatusEvent.NET_STATUS, doSO);
		}
		
		// when connection to server is okay
		
		private function doSO (e:NetStatusEvent):void
		{
			good = e.info.code == "NetConnection.Connect.Success";
			if (good){
				trace("Connected to server.");
				// connect the remote shared object
				remoteSO=SharedObject.getRemote("swfcastChannels",nc.uri,true);
				remoteSO.connect(nc);
				remoteSO.addEventListener(SyncEvent.SYNC, doUpdate);
				if(!showUI){
					startChannel = channel;
					numChannels = Math.min(startChannel + (bar - 1), numChannels);
					changeInterval = setInterval(tuneChannnel, changeDelay);
					trace("AutoChangeChannel On for " + channel + " to " + numChannels);
				}
			}else {
				trace("Not Connected to server.");
			}
		}
		
		// handle incoming sync requests
		
		private function doUpdate (se:SyncEvent):void
		{
			for (var cl:uint; cl < se.changeList.length; cl++)
			{
				if (se.changeList[cl].code == "change"){
					var changedChannel:String = se.changeList[cl].name;
					var channelIndex:int = int(changedChannel.slice(1, changedChannel.length));
					trace("Change on channel " + channelIndex);
					if(channelCast[channelIndex] == undefined){
						channelCast[channelIndex] = new Cast();
					}
					channelCast[channelIndex].replicateObject = remoteSO.data[changedChannel];
					if(channelIndex == channel){
						trace("Changed channel " + channelIndex + " is active channel");
						localSO.data.fluxCast = channelCast[channelIndex];
						tubeMC.processCast(channelCast[channelIndex]);
					}
				}
			}	
		}
		
		public function initUI(e:Event):void
		{
			dataXML = new XML(e.currentTarget.data);
			//trace(dataXML);
			numColorSets = dataXML.colorStuff.colorSet.length();
			trace(numColorSets + " ColorSets loaded");
			OverlayControlsMC = new OverlayControls();
			addChild(OverlayControlsMC);
			for(var c in dataXML.clipStuff.clip){
				var clipButtonMC:MovieClip = new MovieClip();
				clipButtonMC.clipSWF = dataXML.clipStuff.clip[c].clipSWF;
				clipButtonMC.y = c * 80;
				func.loadIMG(dataXML.clipStuff.clip[c].clipIMG, clipButtonMC);
				func.makeButton(castClip, clipButtonMC);
				OverlayControlsMC.clipButtonContainerMC.addChild(clipButtonMC);
				trace(dataXML.clipStuff.clip[c].clipIMG);
			}
			func.makeButton(toggleLayer, OverlayControlsMC.layerButtonMC);
			func.makeButton(clearLayer, OverlayControlsMC.clearButtonMC);
			func.makeButton(changeChannel, OverlayControlsMC.channelSelectorMC);
			func.makeButton(changeColor, OverlayControlsMC.colorPreviewMC);
			func.makeButton(toggleForm, OverlayControlsMC.typeButtonMC);
			func.makeButton(submitText, OverlayControlsMC.formMC.submitButtonMC);
			colorSetIndex = (numColorSets - 1);
			changeColor();
		}
		
		public function castClip(e:MouseEvent):void
		{
			//trace(e.currentTarget.clipSWF);
			draftCast.clip = e.currentTarget.clipSWF;
			remoteSO.setProperty("c" + channel, draftCast.asObject);
			remoteSO.setDirty("c" + channel);
			localSO.data.fluxCast = draftCast.asObject;
			channelCast[channel] = draftCast;
			tubeMC.processCast(draftCast);
		}
		
		public function changeColor(e:MouseEvent = null):void
		{
			colorSetIndex = (colorSetIndex == (numColorSets - 1)) ? 0 : (colorSetIndex + 1);
			draftCast.colorsFromXMLList = dataXML.colorStuff.colorSet[colorSetIndex].colors;
			OverlayControlsMC.colorPreviewMC.setPreviewFrom(draftCast);
		}
		
		public function clearLayer(e:MouseEvent):void
		{
			draftCast.clip = "";
			remoteSO.setProperty("c" + channel, draftCast.asObject);
			remoteSO.setDirty("c" + channel);
			tubeMC.processCast(draftCast);
		}
		
		public function toggleLayer(e:MouseEvent):void
		{
			draftCast.layer = (draftCast.layer == "bottom") ? "top" : "bottom";
			(e.currentTarget as MovieClip).gotoAndStop(draftCast.layer);
			trace(draftCast.layer);
		}
		
		public function changeChannel(e:MouseEvent):void
		{
			tuneChannnel();
			(e.currentTarget as MovieClip).textBox.text = (channel > 9) ? String(channel) : "0" + String(channel);
		}
		
		public function tuneChannnel():void
		{
			channel = (channel == numChannels) ? startChannel : (channel + 1);
			trace("Now tuning channel " + channel);
			tubeMC.clearTube();
			if(channelCast[channel] != undefined){
				localSO.data.fluxCast = channelCast[channel].asObject;
				tubeMC.processCast(channelCast[channel]);
			}			
		}
		
		public function submitText(e:MouseEvent):void
		{
			draftCast.text = OverlayControlsMC.formMC.textBox.text;
			OverlayControlsMC.formMC.visible = false;
		}
		
		public function toggleForm(e:MouseEvent):void
		{
			OverlayControlsMC.formMC.textBox.text = draftCast.text;
			OverlayControlsMC.formMC.visible = !OverlayControlsMC.formMC.visible;
		}
		
		public function goFullScreen(e:ContextMenuEvent):void
		{
		   stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		public function exitFullScreen(e:ContextMenuEvent):void
		{
		   stage.displayState = StageDisplayState.NORMAL;
		}
		
		public function menuHandler(e:ContextMenuEvent):void
		{
		   if (stage.displayState == StageDisplayState.NORMAL)
		   {
			  e.target.customItems[0].enabled = true;
			  e.target.customItems[1].enabled = false;
		   }
		   else
		   {
			  e.target.customItems[0].enabled = false;
			  e.target.customItems[1].enabled = true;
		   }
		}
		
		public function buildFSMenu():void
		{
			var fullscreenCM:ContextMenu = new ContextMenu();
			fullscreenCM.addEventListener(ContextMenuEvent.MENU_SELECT, menuHandler);
			fullscreenCM.hideBuiltInItems();
			
			var fs:ContextMenuItem = new ContextMenuItem("Go Full Screen" );
			fs.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, goFullScreen);
			fullscreenCM.customItems.push( fs );
			
			var xfs:ContextMenuItem = new ContextMenuItem("Exit Full Screen");
			xfs.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, exitFullScreen);
			fullscreenCM.customItems.push( xfs );
			
			this.contextMenu = fullscreenCM;
		}
		
	}
}
