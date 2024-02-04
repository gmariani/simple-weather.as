/**
* ...
* @author Default
* @version 0.1
*/

package {

	import com.coursevector.display.Particle;
	import com.coursevector.display.SimpleParticles;
	import com.coursevector.display.effects.*;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	//[IconFile("te1_icon.png")]
	//[TagName("Text Effect 1")]
	public class SimpleWeather extends MovieClip {
		
		private var __width:Number = defSize;
		private var __height:Number = defSize;
		private var __linkId:Class = SW_SnowFlake;
		private var __windDirection:String = "None"; // Can be Left, Right, None
		private var __windStrength:Number = 0;
		private var __total:Number = 50;
		private var efEffect:EffectBase = new Precipitation();
		private var sp:SimpleParticles = new SimpleParticles();
		private var defSize:int = 100;
		private var defInteval:int = 6;
		private var nCounter:int = 0;
		private var nInterval:int = defInteval;
		//private var mcHideMe:MovieClip;
		
		private var isLivePreview:Boolean;
		
		public function SimpleWeather() {
			init();
		}
		
		private function init():void {
			isLivePreview = (parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent");
			if(!isLivePreview) {
				this.mcHideMe.visible = false;
				sp.addParticleType(__linkId, efEffect);
				setSize(this.width, this.height);
				//sp.setRunMethod("end");
				sp.setParticleLimit(__total);
				sp.setEnterFrame = customEnterFrame;
				sp.start();
				this.parent.addChild(sp);
			}
			
			// Storm
			//strength = 6;
			//windDirection = "Right";
			//windStrength = 20;
		}
		
		private function customEnterFrame():void {
			sp.updateParticles();
			nCounter++;
			if(nCounter % nInterval == 0 && nCounter != 0) {
				sp.update();
			}
		}
		
		//////////////////////
		// Get/Set Particle //
		//////////////////////
		[Inspectable(category="A", name="Particle Link Id:", type=Class, defaultValue=SW_SnowFlake)]
		public function set linkId(val:Class):void {
			trace("Set linkid");
			__linkId = val;// as Particle;
			sp.clearParticleTypes();
			sp.addParticleType(__linkId, efEffect);
		}
		public function get linkId():Class {
			return __linkId;
		}
		
		////////////////////////////
		// Get/Set Wind Direction //
		////////////////////////////
		[Inspectable(category="B", name="Wind Direction:", type=String, defaultValue="None", enumeration="None,Left,Right")]
		public function set windDirection(val:String):void {
			__windDirection = val;
		}
		public function get windDirection():String {
			return __windDirection;
		}
		
		///////////////////////////
		// Get/Set Wind Strength //
		///////////////////////////
		[Inspectable(category="C", name="Wind Strength:", type=Number, defaultValue=0)]
		public function set windStrength(val:Number):void {
			__windStrength = int(val);
			
			switch(__windDirection) {
				case "Left" :
					if(__windStrength < 1) __windStrength = 1;
				
					this.efEffect.xVelRandMin = __windStrength * -1;
					this.efEffect.xVelRandMax = this.efEffect.xVelRandMin - 3;
					this.efEffect.yVelRandMin = __windStrength;
					this.efEffect.yVelRandMax = this.efEffect.yVelRandMin + 3;
					break;
				case "Right" :
					if(__windStrength < 1) __windStrength = 1;
					this.efEffect.xVelRandMin = __windStrength;
					this.efEffect.xVelRandMax = this.efEffect.xVelRandMin + 3;
					this.efEffect.yVelRandMin = __windStrength;
					this.efEffect.yVelRandMax = this.efEffect.yVelRandMin + 3;
					break;
				case "None" :
					this.efEffect.xVelRandMin = __windStrength * -1;
					this.efEffect.xVelRandMax = __windStrength;
					this.efEffect.drag = 0.97;
			}
		}
		public function get windStrength():Number {
			return __windStrength;
		}
		
		//////////////////////
		// Get/Set Strength //
		//////////////////////
		[Inspectable(category="D", name="Strength:", type=Number, defaultValue=1)]
		public function set strength(val:Number):void {
			nInterval = (val * -1) + defInteval;
			if(nInterval == 0) nInterval = 1;
		}
		public function get strength():Number {
			return nInterval;
		}
		
		/////////////////////////////
		// Get/Set Total Particles //
		/////////////////////////////
		[Inspectable(category="E", name="Total Particles:", type=Number, defaultValue=100)]
		public function set total(val:Number):void {
			__total = int(val);
			sp.setParticleLimit(__total);
		}
		public function get total():Number {
			return __total;
		}
			
		public function setSize(w:Number, h:Number):void {
			if(!isNaN(w)) this.__width = w;
			if(!isNaN(h)) this.__height = h;
			
			if(isLivePreview) {
				this.mcHideMe.mcBG.width = w;
				this.mcHideMe.mcBG.height = h;
				this.mcHideMe.mcInfo.x = (this.mcHideMe.mcBG.width - this.mcHideMe.mcInfo.width) / 2;
				this.mcHideMe.mcInfo.y = (this.mcHideMe.mcBG.height - this.mcHideMe.mcInfo.height) / 2;
			} else {
				this.width = defSize;
				this.height = defSize;
			}
			
			var r:Rectangle = new Rectangle(0, 0, this.__width, 1);
			sp.setXYBounds(r);
			var r2:Rectangle = new Rectangle(0, 0, this.__width, this.__height);
			sp.setBounds(r2);
			
			
		}
	}
}