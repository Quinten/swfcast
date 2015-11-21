package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.SharedObject;
	
	public class Qubicle extends MovieClip {
		
		private var fl:Number = 400;
		private var vpX:Number = 0;
		private var vpY:Number = 0; 
		private var p:Array = new Array();
		private var numPoints:int = 240;
		private var lineSize:Number = 40;
		private var Lx:Number = 0; 
		private var Ly:Number = 0; 
		private var Lz:Number = 0; 
		private var q:Number = 160;
		private var mX = 0;
		private var mY = 0;
		
		private var commonObj:Object;
		private var lineColor:uint = 0;
		
		public function Qubicle():void{
			commonObj = SharedObject.getLocal("swfcastLocalData", "/");
			lineColor = (commonObj.data.fluxCast) ? commonObj.data.fluxCast.colors[1] : 0x000000;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			vpX = stage.stageWidth / 2;
			vpY = stage.stageHeight / 2;
			mX = vpX + 140;
			mY = vpY + 140;
			for (var i:int = 0; i<numPoints; i++) {
				p[i] = new Object();
				var d:Number =Math.round(Math.random())?lineSize:-lineSize;
				var r:Number =Math.random()*3;
				if(r>2)Lx=(Lx+d>q||Lx+d<-q)?-Lx/2:Lx+d;
				if(r<1)Ly=(Ly+d>q||Ly+d<-q)?-Ly/2:Ly+d;
				if(r<2&&r>1)Lz=(Lz>q||Lz<-q)?-Lz/2:Lz+d;
				p[i].x =  Lx;
				p[i].y = Ly;
				p[i].z = Lz;
			}
			this.addEventListener(Event.ENTER_FRAME, onF);
			this.addEventListener(Event.REMOVED_FROM_STAGE, deInit);
		}
		
		private function onF(e:Event):void {
			var angleY:Number = (mX - vpX) * .001;
			var cosY:Number = Math.cos(angleY);
			var sinY:Number = Math.sin(angleY);
	
			var angleX:Number = (mY - vpY) * .001;
			var cosX:Number = Math.cos(angleX);
			var sinX:Number = Math.sin(angleX);
		
			for (var i:int=0;i<numPoints;i++) {
		
				var x1:Number = p[i].x * cosY - p[i].z * sinY;
				var z1:Number = p[i].z * cosY + p[i].x * sinY;
		
				var y1:Number = p[i].y * cosX - z1 * sinX;
				var z2:Number = z1 * cosX + p[i].y * sinX;
		
				p[i].x = x1;
				p[i].y = y1;
				p[i].z = z2;
		
				var scale:Number = fl / (fl + p[i].z);
				p[i]._x = vpX + p[i].x * scale;
				p[i]._y = vpY + p[i].y * scale;
			}
 
			graphics.clear();
			graphics.lineStyle(1, lineColor, 1); 
			graphics.moveTo(p[0]._x, p[0]._y);
			for (var l:int=1;l<numPoints;l++) {
				if(p[l].z<fl)
					graphics.lineTo(p[l]._x, p[l]._y);
			}
		}
		
		private function deInit(e:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onF);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, deInit);
		}
	}	
}