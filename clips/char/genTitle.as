package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.net.SharedObject;
	import fl.motion.Animator;
	
	public class genTitle extends MovieClip
	{
		private var commonObj:Object;
		private var motionMC_animator:Animator 
		
		public function genTitle():void
		{
			mainMC.textbox.autoSize = TextFieldAutoSize.CENTER;
			commonObj = SharedObject.getLocal("common-object", "/");
			var newTitle:String = (commonObj.data.textStr) ? commonObj.data.textStr : "some title";
			mainMC.textbox.textColor = (commonObj.data.txtColor) ? commonObj.data.txtColor : 0x000000;
			mainMC.textbox.text = newTitle;
			addEventListener(Event.ADDED_TO_STAGE, repositTextbox);
		}
		
		public function repositTextbox(e:Event = null):void
		{
			mainMC.x = (stage.stageWidth/2) - (mainMC.width/2);
			mainMC.y = (stage.stageHeight/2) - (mainMC.height/2);
			var motionMC_xml:XML = <Motion duration="95" xmlns="fl.motion.*" xmlns:geom="flash.geom.*" xmlns:filters="flash.filters.*">
			<source>
				<Source frameRate="25" scaleX="1" scaleY="1" rotation="0" elementType="movie clip" instanceName="mainMC" symbolName="mainMC">
				</Source>
			</source>
			
			<Keyframe index="0" rotateDirection="none" tweenScale="false" tweenSnap="true" tweenSync="true">
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
				<filters>
					<filters:BlurFilter blurX="0" blurY="100" quality="3"/>
				</filters>
			</Keyframe>
			
			<Keyframe index="14" rotateDirection="none" tweenScale="false" tweenSnap="true" tweenSync="true">
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
				<filters>
					<filters:BlurFilter blurX="0" blurY="0" quality="3"/>
				</filters>
			</Keyframe>
			
			<Keyframe index="33" rotateDirection="none" tweenScale="false" tweenSnap="true" tweenSync="true">
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
				<filters>
					<filters:BlurFilter blurX="0" blurY="0" quality="3"/>
				</filters>
			</Keyframe>
			
			<Keyframe index="49" rotateDirection="none" tweenScale="false" tweenSnap="true" tweenSync="true">
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
				<filters>
					<filters:BlurFilter blurX="0" blurY="0" quality="3"/>
				</filters>
			</Keyframe>
			
			<Keyframe index="64" rotateDirection="none" tweenScale="false" tweenSnap="true" tweenSync="true">
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
				<filters>
					<filters:BlurFilter blurX="100" blurY="0" quality="3"/>
				</filters>
			</Keyframe>
			
			<Keyframe index="79" rotateDirection="none" tweenScale="false" tweenSnap="true" tweenSync="true">
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
				<filters>
					<filters:BlurFilter blurX="100" blurY="100" quality="3"/>
				</filters>
			</Keyframe>
			
			<Keyframe index="94" rotateDirection="none" tweenScale="false" tweenSnap="true" tweenSync="true">
				<tweens>
					<SimpleEase ease="0"/>
				</tweens>
				<filters>
					<filters:BlurFilter blurX="0" blurY="100" quality="3"/>
				</filters>
			</Keyframe>
			</Motion>;
			
			motionMC_animator = new Animator(motionMC_xml, mainMC);
			motionMC_animator.repeatCount = 0;
			motionMC_animator.play();

		}
	}
}