// Handles effects like rain or snow

package com.coursevector.display.effects {

	public class Precipitation extends EffectBase {
		
		public function Precipitation() {
			wander = .5;
			gravity = .05;
			//gravity = 1;
			alpha = 0.8;
			xVelRandMin = -.3;
			xVelRandMax = .3;
			yVelRandMin = 1;
			yVelRandMax = 2;
			bounce = 0;
			drag = 0.97;
			numParticles = 1;
			this.edgeBehavior = "wrap";
			this.alphaMult = .99995;
		}
		
		public function toString():String {
			return "[type Precipitation]";
		}
	}
}