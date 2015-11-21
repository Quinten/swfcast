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
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.materials.utils.MaterialsList;
	
	import charCube;
	
	/**
	 * ...
	 * @author Quinten Clause
	 */
	public class wordSpring extends MovieClip 
	{
		
		private var commonObj:Object;
		
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
		
		public var shapefillColor:int;
		public var lightColor:int;
		
		//public var sentence:String = "abcd efgh ijkl mnop qrst uvwx yz";
		public var sentence:String = "five words made of cubes _";
		//public var sentence:String = "cubic clash _last satur _day of octo ber _www _dot cubic clash _dot be";
		public var word:Array;
		public var currentWord:int = 0;
		public var intervalID:uint;
		public var timeOutID:Array = new Array();
		
		public function wordSpring():void 
		{	
			include "fieldFont9by11Matrix.as"
			commonObj = SharedObject.getLocal("common-object", "/");
			sentence = (commonObj.data.textStr) ? commonObj.data.textStr.toLowerCase() : sentence;
			//mainMC.textbox.textColor = (commonObj.data.txtColor) ? commonObj.data.txtColor : 0xffffff;
			shapefillColor = (commonObj.data.shapefillColor) ? commonObj.data.shapefillColor : 0x000000;
			lightColor = (commonObj.data.lightColor) ? commonObj.data.lightColor : 0xffffff;
			word = sentence.split(" ");
	    	addEventListener(Event.ADDED_TO_STAGE,init);		
			//init();
		}
		
		private function init(e:Event = null):void 
		{
			//var vpWidth:Number = stage.stageWidth;
			//var vpHeight:Number = stage.stageHeight;
			var vpWidth:Number = 1024;
			var vpHeight:Number = 576;
			// create the 3D viewport, renderer, camera and scene
			init3Dengine(vpWidth, vpHeight);
			init3D();
		}
		
		private function init3Dengine(vpWidth:Number, vpHeight:Number):void 
		{
			viewport = new Viewport3D(vpWidth, vpHeight, false, true);
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
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			changeWord();
			intervalID = setInterval(changeWord, nCharCubes * 1000);
		}
		
		public function changeWord():void
		{
			trace(currentWord);
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
		
	}
	
}