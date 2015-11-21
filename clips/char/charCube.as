package  
{
	import flash.utils.setTimeout;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.materials.utils.MaterialsList;
	
	/**
	 * ...
	 * @author Quinten Clause
	 */
	public class charCube extends DisplayObject3D
	{
		public var cube:Array = new Array();
		public var nCubes:int = 36;
		
		public var gridSize:int;
		public var gridWidth:int = 9;
		public var gridHeight:int = 11;
		public var gridDepth:int = 9;
		public var xOffset:Number;
		public var yOffset:Number;
		public var zOffset:Number;
		
		public var fFace:Array = new Array();
		public var currentfFace:int = 0;
		public var stepOne:uint;
		public var stepTwo:uint;
		public var stepThree:uint;
		
		public var rotXhome:Number = 0;		
		public var rotYhome:Number = 0;
		public var rotZhome:Number = 0;
		
		public var springiness:Number = 0.2;
		public var decay:Number = 0.8;
		//public var fontPosArr:Array = new Array();
		
		public function charCube(materialsList:MaterialsList, cubeSizeInt:int = 50):void 
		{
			gridSize = cubeSizeInt;
			xOffset = ( gridWidth / 2 ) * cubeSizeInt;
			yOffset = ( gridHeight / 2 ) * cubeSizeInt;
			zOffset = ( gridDepth / 2 ) * cubeSizeInt;
			
			fFace[0] = "front2left";
			fFace[1] = "left2back";
			fFace[2] = "back2right";
			fFace[3] = "right2front";
			
			for (var c:int = 0; c < nCubes; c++ )
			{
				cube[c] = new Cube(materialsList, cubeSizeInt, cubeSizeInt, cubeSizeInt);
				cube[c].x = (Math.floor(Math.random()*gridWidth) * cubeSizeInt) - xOffset;
				cube[c].y = (Math.floor(Math.random() * gridHeight) * cubeSizeInt) - yOffset;
				cube[c].z = (Math.floor(Math.random()*gridDepth) * cubeSizeInt) - zOffset;
				var extraObj:Object = new Object();
				extraObj.xhome = (Math.floor(Math.random()*gridWidth) * cubeSizeInt) - xOffset;
				extraObj.yhome = (Math.floor(Math.random() * gridHeight) * cubeSizeInt) - yOffset;
				extraObj.zhome = (Math.floor(Math.random() * gridDepth) * cubeSizeInt) - zOffset;
				extraObj.xchange = 0;
				extraObj.ychange = 0;
				extraObj.zchange = 0;
				//extraObj.zhome = - zOffset;
				cube[c].extra = extraObj;
				this.addChild(cube[c]);
			}
		}
		
		public function contract():void
		{
			this.rotationX += (rotXhome - this.rotationX) / 10;
			this.rotationY += (rotYhome - this.rotationY) / 10;
			this.rotationZ += (rotZhome - this.rotationZ) / 10;
			
			for (var c:int = 0; c < nCubes; c++ )
			{
				//cube[c].x += (cube[c].extra.xhome - cube[c].x) / 8;
				//cube[c].y += (cube[c].extra.yhome - cube[c].y) / 8;
				//cube[c].z += (cube[c].extra.zhome - cube[c].z) / 8;
				cube[c].extra.xchange = ((cube[c].extra.xhome - cube[c].x) * springiness) + (cube[c].extra.xchange * decay);
				cube[c].x += cube[c].extra.xchange;
				cube[c].extra.ychange = ((cube[c].extra.yhome - cube[c].y) * springiness) + (cube[c].extra.ychange * decay);
				cube[c].y += cube[c].extra.ychange;
				cube[c].extra.zchange = ((cube[c].extra.zhome - cube[c].z) * springiness) + (cube[c].extra.zchange * decay);
				cube[c].z += cube[c].extra.zchange;
			}			
		}
		
		public function changeChar(fPos:Array):void
		{
			switch(fFace[currentfFace]) {
				case "front2left":
					stepOne = setTimeout(spreadZ, 40, fPos, 1);
					stepTwo = setTimeout(spreadY, 1000, fPos);
					stepThree = setTimeout(levelX, 2000, (-xOffset));
					break;
				case "left2back":
					stepOne = setTimeout(spreadX, 40, fPos, 1);
					stepTwo = setTimeout(spreadY, 1000, fPos);
					stepThree = setTimeout(levelZ, 2000, zOffset);
					break;
				case "back2right":
					stepOne = setTimeout(spreadZ, 40, fPos, -1);
					stepTwo = setTimeout(spreadY, 1000, fPos);
					stepThree = setTimeout(levelX, 2000, xOffset);
					break;
				case "right2front":
					stepOne = setTimeout(spreadX, 40, fPos, -1);
					stepTwo = setTimeout(spreadY, 1000, fPos);
					stepThree = setTimeout(levelZ, 2000, (-zOffset));
					break;
			}
			currentfFace = (currentfFace < (fFace.length - 1)) ? (currentfFace + 1) : 0;
		}
		
		public function levelX():void
		{
			for (var c:int = 0; c < nCubes; c++ )
			{
				cube[c].extra.xhome = arguments[0];
			}
			rotationStep();
		}
		
		public function levelZ():void
		{
			for (var c:int = 0; c < nCubes; c++ )
			{
				cube[c].extra.zhome = arguments[0];
			}
			rotationStep();
		}
		
		public function spreadX():void
		{
			var spreadIndex:int = 0;
			for (var c:int = 0; c < nCubes; c++ )
			{
				cube[c].extra.xhome = (xOffset - (arguments[0][spreadIndex][0] * gridSize)) * arguments[1];
				spreadIndex = (spreadIndex < (arguments[0].length - 1)) ? (spreadIndex + 1) : 0;
			}
			rotationStep();
		}
		
		public function spreadY():void
		{
			var spreadIndex:int = 0;
			for (var c:int = 0; c < nCubes; c++ )
			{
				cube[c].extra.yhome = yOffset - (arguments[0][spreadIndex][1] * gridSize);
				spreadIndex = (spreadIndex < (arguments[0].length - 1)) ? (spreadIndex + 1) : 0;
			}
			rotationStep();
		}
		
		public function spreadZ():void
		{
			var spreadIndex:int = 0;
			for (var c:int = 0; c < nCubes; c++ )
			{
				cube[c].extra.zhome = (zOffset - (arguments[0][spreadIndex][0] * gridSize)) * arguments[1];
				spreadIndex = (spreadIndex < (arguments[0].length - 1)) ? (spreadIndex + 1) : 0;
			}
			rotationStep();
		}
		
		public function rotationStep():void
		{
			rotXhome -= 120;
			rotYhome -= 30;
			rotZhome -= 120;
		}
		
	}
	
}