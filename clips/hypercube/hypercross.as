﻿package 
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
	import hype.extended.rhythm.FilterCanvasRhythm;
	import flash.filters.BlurFilter;
	import hype.framework.core.TimeType;
	
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.core.geom.Lines3D;
	
	//import charCube;
	
	/**
	 * ...
	 * @author Quinten Clause
	 */
	public class hypercross extends MovieClip 
	{
		
		private var commonObj:Object;
		
		// properties for papervision 
		public var viewport:Viewport3D;		
		public var renderer:BasicRenderEngine;
		public var default_scene:Scene3D;
		public var default_camera:Camera3D;
	
		public var cubeDrop:Array = new Array();
		public var nCubeDrops:int = 36;		
		public var cubeSize:int = 480;
		public var xBoundsA:Number = -10000;
		public var xBoundsB:Number = 10000;
		public var yBoundsA:Number = -10000;
		public var yBoundsB:Number = 10000;
		public var zBoundsA:Number = -10000;
		public var zBoundsB:Number = 10000;
		
		public var camera_float = false;
				
		public var shapefillColor:int;
		public var lightColor:int;
		public var lineColor:int;
		
		public var intervalID:uint;
		public var timeOutID:Array = new Array();
		
		public var bmc:BitmapCanvas;
		public var blur:FilterCanvasRhythm;
		public var viewportLayer:MovieClip;
		
		public function hypercross():void 
		{	
			//commonObj = SharedObject.getLocal("common-object", "/");
			//shapefillColor = (commonObj.data.shapefillColor) ? commonObj.data.shapefillColor : 0x000000;
			//lightColor = (commonObj.data.lightColor) ? commonObj.data.lightColor : 0xffffff;
			commonObj = SharedObject.getLocal("swfcastLocalData", "/");
			//shapefillColor = (commonObj.data.fluxCast) ? commonObj.data.fluxCast.colors[2] : 0x000000;
			//lightColor = (commonObj.data.fluxCast) ? commonObj.data.fluxCast.colors[3] : 0xffffff;
			lineColor = (commonObj.data.fluxCast) ? commonObj.data.fluxCast.colors[1] : 0x000000;
			//shapefillColor = 0x4e9b00;
			//lightColor = 0x91ff22;
	    	this.addEventListener(Event.ADDED_TO_STAGE,init);
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
			this.root.loaderInfo.addEventListener(Event.UNLOAD, deInit);
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
			var flatShadeMaterial:FlatShadeMaterial = new FlatShadeMaterial(new PointLight3D(), lightColor, shapefillColor);
			var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(flatShadeMaterial, "all");
			
			for (var c:int = 0; c < nCubeDrops; c++ )
			{
				//cubeDrop[c] = new Cube(materialsList, cubeSize, cubeSize, cubeSize);
				cubeDrop[c] = new Lines3D(new LineMaterial(lineColor,0.25));
				// bottom
				cubeDrop[c].addNewSegmentedLine(2,1,-cubeSize,0,cubeSize,-cubeSize,0,-cubeSize);
				cubeDrop[c].addNewSegmentedLine(2,1,-cubeSize,0,-cubeSize,cubeSize,0,-cubeSize);
				cubeDrop[c].addNewSegmentedLine(2,1,cubeSize,0,-cubeSize,cubeSize,0,cubeSize);
				cubeDrop[c].addNewSegmentedLine(2,7,cubeSize,0,cubeSize,-cubeSize,0,cubeSize);
				cubeDrop[c].x = xBoundsA + Math.floor(Math.random()*(xBoundsB - xBoundsA));
				cubeDrop[c].y = yBoundsA + Math.floor(Math.random()*(yBoundsB - yBoundsA));
				cubeDrop[c].z = zBoundsA + Math.floor(Math.random()*(zBoundsB - zBoundsA));
				var extraObj:Object = new Object(); 
				extraObj.nRoll = - Math.random()*2 + Math.random()*4;
				extraObj.nYaw = - Math.random()*2 + Math.random()*4;
				extraObj.nPitch = - Math.random()*2 + Math.random()*4;
				cubeDrop[c].extra = extraObj;
				default_scene.addChild(cubeDrop[c]);
			}
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			bmc.startCapture(viewportLayer, true);
			
			blur = new FilterCanvasRhythm([new BlurFilter(1.05, 1.05, 1)], bmc);
			blur.start(TimeType.TIME, 400);

			//intervalID = setInterval(changeWord, nCharCubes * 1000);
		}
		
		public function animationLoop():void
		{
			// animate objects here
			for (var c:int = 0; c < nCubeDrops; c++ )
			{
				cubeDrop[c].yaw(cubeDrop[c].extra.nRoll);
				cubeDrop[c].roll(cubeDrop[c].extra.nYaw);
				cubeDrop[c].pitch(cubeDrop[c].extra.nPitch);
			}
			default_camera.rotationX += (default_camera.extra.xRothome - default_camera.rotationX)/40;
			default_camera.rotationY += (default_camera.extra.yRothome - default_camera.rotationY)/40;
			default_camera.rotationZ += (default_camera.extra.zRothome - default_camera.rotationZ)/40;
			var camera_step:Number = (camera_float) ? 10 : -10;
			default_camera.z += camera_step;
			if((camera_float && default_camera.z  > zBoundsB/4) || (!camera_float && default_camera.z  < zBoundsA/4)){
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
			trace("hypercube unloaded");
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			this.root.loaderInfo.removeEventListener(Event.UNLOAD, deInit);
		}
		
	}
	
}