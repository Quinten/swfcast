package
{
	
	public class Cast 
	{
		
		private var CastObj:Object;
		
		public function Cast()
		{
			// constructor code
			CastObj = new Object();
			CastObj.clip = "";
			CastObj.layer = "bottom";
			CastObj.colors = [0xffffff, 0xcccccc, 0x999999, 0x000000];
			CastObj.text = "type some";
			CastObj.sustain = 0;
		}
		
		public function set replicateObject(newCastObj:Object):void
		{
			CastObj = newCastObj;
		}
		
		public function get asObject():Object
		{
			return CastObj;
		}
		
		public function get clip():String
		{
			return CastObj.clip;
		}
		
		public function set clip(clipStr:String):void
		{
			CastObj.clip = clipStr;
		}
		
		public function get layer():String
		{
			return CastObj.layer;
		}
		
		public function set layer(layerStr:String):void
		{
			CastObj.layer = layerStr;
		}
		
		public function get colors():Array
		{
			return CastObj.colors;
		}
		
		public function set colors(colorsArr:Array):void
		{
			CastObj.colors = colorsArr;
		}
		
		public function set colorsFromXMLList(colorsXMLList:XMLList):void
		{	
			//trace(colorsXMLList);
			var colorsArr:Array = [uint(colorsXMLList[0]), uint(colorsXMLList[1]), uint(colorsXMLList[2]), uint(colorsXMLList[3])];
			CastObj.colors = colorsArr;
		}
		
		public function get text():String
		{
			return CastObj.text;
		}
		
		public function set text(textStr:String):void
		{
			CastObj.text = textStr;
		}
		
		public function get sustain():uint
		{
			return CastObj.sustain;
		}
		
		public function set sustain(sustainNum:uint):void
		{
			CastObj.sustain = sustainNum;
		}
		
	}
}