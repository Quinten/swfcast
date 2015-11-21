package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.materials.utils.MaterialsList;
	
	import charCube;
	
	/**
	 * ...
	 * @author Quinten Clause
	 */
	public class words extends MovieClip 
	{
		// properties for papervision 
		public var viewport:Viewport3D;		
		public var renderer:BasicRenderEngine;
		public var default_scene:Scene3D;
		public var default_camera:Camera3D;
	
		public var charcube:Array = new Array();
		public var nCharCubes:int = 5;
		public var fontArr:Array = new Array();		
		public var gridSize:int = 20;
		public var gridWidth:int = 7;
		public var gridDepth:int = 9;
		public var zOffset:int = 650;
		
		private var commonObj:Object;
		
		//public var sentence:String = "abcd efgh ijkl mnop qrst uvwx yz";
		public var sentence:String = "five words made of cubes _";
		//public var sentence:String = "cubic clash _last satur _day of octo ber _www _dot cubic clash _dot be";
		public var word:Array;
		public var currentWord:int = 0;
		public var intervalID:uint;
		public var timeOutID:Array = new Array();
		
		private var shapefillColor:uint;
		private var lightColor:uint;
		
		public function words():void 
		{
			commonObj = SharedObject.getLocal("swfcastLocalData", "/");
			shapefillColor = (commonObj.data.fluxCast) ? commonObj.data.fluxCast.colors[2] : 0x000000;
			lightColor = (commonObj.data.fluxCast) ? commonObj.data.fluxCast.colors[3] : 0xffffff;
			
			sentence = (commonObj.data.fluxCast) ? commonObj.data.fluxCast.text : sentence;
			
			include "fieldFont9by11Matrix.as"
			
			word = sentence.split(" ");
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			var vpWidth:Number = stage.stageWidth;
			var vpHeight:Number = stage.stageHeight;
			// create the 3D viewport, renderer, camera and scene
			init3Dengine(vpWidth, vpHeight);
			init3D();
			this.root.loaderInfo.addEventListener(Event.UNLOAD, deInit);
		}
		
		private function init3Dengine(vpWidth:Number, vpHeight:Number):void 
		{
			viewport = new Viewport3D(vpWidth, vpHeight, true, true);
			addChild(viewport);
			renderer = new BasicRenderEngine();
			default_scene = new Scene3D();
			default_camera = new Camera3D();
		}
		
		// builds the 3D world
		public function init3D():void
		{
			// add objects to the scene here
			var flatShadeMaterial:FlatShadeMaterial = new FlatShadeMaterial(new PointLight3D(), lightColor, shapefillColor);
			var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(flatShadeMaterial, "all");
			
			for (var c:int = 0; c < nCharCubes; c++ )
			{
				charcube[c] = new charCube(materialsList, gridSize);
				charcube[c].x = (c - ((nCharCubes - 1) / 2)) * gridSize * gridWidth;
				charcube[c].z = ((gridDepth / 2) * gridSize) - zOffset;
				default_scene.addChild(charcube[c]);
				//charcube[c].changeChar(fontArr["b"]);
			}
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			changeWord();
			intervalID = setInterval(changeWord, nCharCubes * 2000);
		}
		
		public function changeWord():void
		{
			trace("change word");
			for (var c:int = 0; c < nCharCubes; c++ )
			{
				var charKey:String = word[currentWord].substr(c, 1);
				timeOutID[c] = setTimeout(morfCharCubes, c * 300, charcube[c], charKey);
			}
			currentWord = (currentWord < (word.length - 1)) ? (currentWord + 1) : 0;
		}
		
		public function morfCharCubes():void
		{
			var dotContraction:Array = new Array();
			dotContraction[0] = [4, 5];
			var fontShape:Array = (fontArr[arguments[1]]) ? fontArr[arguments[1]] : dotContraction;
			arguments[0].changeChar(fontShape);
		}
		
		public function animationLoop():void
		{
			// animate objects here
			for (var c:int = 0; c < nCharCubes; c++ )
			{
				charcube[c].contract();
			}
		}
		
		// what happens every frame
		protected function onEnterFrame(e:Event):void 
		{
			animationLoop();
			renderer.renderScene(default_scene, default_camera, viewport);
		}
		
		public function deInit(e:Event){
			clearInterval(intervalID);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			this.root.loaderInfo.removeEventListener(Event.UNLOAD, deInit);
		}
		
	}
	
}