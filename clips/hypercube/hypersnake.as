package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import hype.framework.display.BitmapCanvas;
	
	//import charCube;
	
	/**
	 * ...
	 * @author Quinten Clause
	 */
	public class hypersnake extends MovieClip 
	{
		
		private var commonObj:Object;
		
		// properties for papervision 
		public var viewport:Viewport3D;		
		public var renderer:BasicRenderEngine;
		public var default_scene:Scene3D;
		public var default_camera:Camera3D;
		public var flatShadeMaterial:FlatShadeMaterial;
		public var materialsList:MaterialsList;
	
		public var cubePart:Array = new Array();
		public var nCubeParts:int = 160;		
		public var cubeSize:int = 240;
		public var sectionSize:int = 5;
		public var sectionCount:int = 1;
		public var cubeIndex:int = 0;
		public var xpos:int = 0;
		public var ypos:int = 0;
		public var zpos:int = 0;
		public var xdir:int = 0; //1, -1 or 0 
		public var ydir:int = 0;
		public var zdir:int = -1;
		public var xBoundsA:Number = -4000;
		public var xBoundsB:Number = 4000;
		public var yBoundsA:Number = -4000;
		public var yBoundsB:Number = 4000;
		public var zBoundsA:Number = -4000;
		public var zBoundsB:Number = 4000;
		
		public var camera_float = false;
				
		public var shapefillColor:int;
		public var lightColor:int;
		
		//public var intervalID:uint;
		//public var timeOutID:Array = new Array();
		
		public var bmc:BitmapCanvas;
		public var viewportLayer:MovieClip;
		
		public function hypersnake():void 
		{	
			//commonObj = SharedObject.getLocal("common-object", "/");
			//shapefillColor = (commonObj.data.shapefillColor) ? commonObj.data.shapefillColor : 0x000000;
			//lightColor = (commonObj.data.lightColor) ? commonObj.data.lightColor : 0xffffff;
			//shapefillColor = 0x4e9b00;
			//lightColor = 0x91ff22;
			commonObj = SharedObject.getLocal("swfcastLocalData", "/");
			shapefillColor = (commonObj.data.fluxCast) ? commonObj.data.fluxCast.colors[2] : 0x000000;
			lightColor = (commonObj.data.fluxCast) ? commonObj.data.fluxCast.colors[3] : 0xffffff;
	    	this.addEventListener(Event.ADDED_TO_STAGE,init);
			this.root.loaderInfo.addEventListener(Event.UNLOAD, deInit);
		}
		
		private function init(e:Event = null):void 
		{
			var vpWidth:Number = stage.stageWidth;
			var vpHeight:Number = stage.stageHeight;
			//var vpWidth:Number = 1024;
			//var vpHeight:Number = 576;
			// create the 3D viewport, renderer, camera and scene
			init3Dengine(vpWidth, vpHeight);
			init3D();
		}
		
		private function init3Dengine(vpWidth:Number, vpHeight:Number):void 
		{
			bmc = new BitmapCanvas(vpWidth, vpHeight);
			addChild(bmc);
			viewportLayer = new MovieClip();
			addChild(viewportLayer);
			viewport = new Viewport3D(vpWidth, vpHeight, true, true);
			viewportLayer.addChild(viewport);
			renderer = new BasicRenderEngine();
			default_scene = new Scene3D();
			default_camera = new Camera3D();
			var extraObj:Object = new Object();
			extraObj.xRothome = Math.floor(Math.random()*360);
			extraObj.yRothome = Math.floor(Math.random()*360);
			extraObj.zRothome = Math.floor(Math.random()*360);
			default_camera.extra = extraObj;
		}
		
		// builds the 3D world
		public function init3D():void
		{
			// add objects to the scene here
			flatShadeMaterial = new FlatShadeMaterial(new PointLight3D(), lightColor, shapefillColor);
			materialsList = new MaterialsList();
			materialsList.addMaterial(flatShadeMaterial, "front");
			materialsList.addMaterial(flatShadeMaterial, "back");
			materialsList.addMaterial(flatShadeMaterial, "top");
			materialsList.addMaterial(flatShadeMaterial, "bottom");
			materialsList.addMaterial(flatShadeMaterial, "left");
			materialsList.addMaterial(flatShadeMaterial, "right");
			
/*			for (var c:int = 0; c < nCubeDrops; c++ )
			{
				cubeDrop[c] = new Cube(materialsList, cubeSize, cubeSize, cubeSize);
				cubeDrop[c].x = xBoundsA + Math.floor(Math.random()*(xBoundsB - xBoundsA));
				cubeDrop[c].y = yBoundsA + Math.floor(Math.random()*(yBoundsB - yBoundsA));
				cubeDrop[c].z = zBoundsA + Math.floor(Math.random()*(zBoundsB - zBoundsA));
				var extraObj:Object = new Object(); 
				extraObj.nRoll = - Math.random()*2 + Math.random()*4;
				extraObj.nYaw = - Math.random()*2 + Math.random()*4;
				extraObj.nPitch = - Math.random()*2 + Math.random()*4;
				cubeDrop[c].extra = extraObj;
				default_scene.addChild(cubeDrop[c]);
			}*/
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			bmc.startCapture(viewportLayer, true);

			//intervalID = setInterval(changeWord, nCharCubes * 1000);
		}
		
		public function animationLoop():void
		{
			// animate objects here
			//make new cube
			cubeIndex = (cubeIndex < nCubeParts) ? (cubeIndex + 1) : 0;
			//default_scene.removeChild(cubePart[cubeIndex]);
			if(cubePart[cubeIndex] == null){
				cubePart[cubeIndex] = new Cube(materialsList, cubeSize, cubeSize, cubeSize);
				cubePart[cubeIndex].x = xpos = xpos + (xdir * cubeSize);
				cubePart[cubeIndex].y = ypos = ypos + (ydir * cubeSize);
				cubePart[cubeIndex].z = zpos = zpos + (zdir * cubeSize);
				default_scene.addChild(cubePart[cubeIndex]);
			}else{
				cubePart[cubeIndex].x = xpos = xpos + (xdir * cubeSize);
				cubePart[cubeIndex].y = ypos = ypos + (ydir * cubeSize);
				cubePart[cubeIndex].z = zpos = zpos + (zdir * cubeSize);				
			}
			//trace(default_scene.numChildren);
			//manage directions
			if(sectionCount == sectionSize){
				var randomDir:Number = Math.floor(Math.random() * 6);
				switch(randomDir){
					case 0:
						xdir = (xdir == 1) ? 1 : -1;
						ydir = 0;
						zdir = 0;
					break;
					case 1:
						xdir = 0;
						ydir = (ydir == 1) ? 1 : -1;
						zdir = 0;
					break;
					case 2:
						xdir = 0;
						ydir = 0;
						zdir = (zdir == 1) ? 1 : -1;
					break;
					case 3:
						xdir = (xdir == -1) ? -1 : 1;
						ydir = 0;
						zdir = 0;
					break;
					case 4:
						xdir = 0;
						ydir = (ydir == -1) ? -1 : 1;
						zdir = 0;
					break;
					case 5:
						xdir = 0;
						ydir = 0;
						zdir = (zdir == -1) ? -1 : 1;
					break;
				}
				sectionCount = 0;
			}else{
				sectionCount++;
			}
			//check for boundaries
			if(xpos < xBoundsA){
				xdir = 1;
				ydir = 0;
				zdir = 0;				
			}
			if(xpos > xBoundsB){
				xdir = -1;
				ydir = 0;
				zdir = 0;				
			}
			if(ypos < yBoundsA){
				xdir = 0;
				ydir = 1;
				zdir = 0;				
			}
			if(ypos > yBoundsB){
				xdir = 0;
				ydir = -1;
				zdir = 0;				
			}
			if(zpos < zBoundsA){
				xdir = 0;
				ydir = 0;
				zdir = 1;				
			}
			if(zpos > zBoundsB){
				xdir = 0;
				ydir = 0;
				zdir = -1;				
			}

			//camera spinning
			default_camera.rotationX += (default_camera.extra.xRothome - default_camera.rotationX)/30;
			default_camera.rotationY += (default_camera.extra.yRothome - default_camera.rotationY)/30;
			default_camera.rotationZ += (default_camera.extra.zRothome - default_camera.rotationZ)/30;
			var camera_step:Number = (camera_float) ? 8 : -8;
			default_camera.z += camera_step;
			default_camera.y += camera_step;
			if((camera_float && default_camera.z  > zBoundsB/6) || (!camera_float && default_camera.z  < zBoundsA/6)){
				default_camera.extra.xRothome = Math.floor(Math.random()*360);
				default_camera.extra.yRothome = Math.floor(Math.random()*360);
				default_camera.extra.zRothome = Math.floor(Math.random()*360);
				camera_float = (camera_float) ? false : true;
			}
		}
		
		// what happens every frame
		protected function onEnterFrame(e:Event):void 
		{
			animationLoop();
			renderer.renderScene(default_scene, default_camera, viewport);
		}
		
		public function deInit(e:Event){
			trace("hypersnake unloaded");
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			this.root.loaderInfo.removeEventListener(Event.UNLOAD, deInit);
		}
		
	}
	
}