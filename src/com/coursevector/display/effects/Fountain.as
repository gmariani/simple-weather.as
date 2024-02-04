package com.coursevector.display.effects {

	public class Fountain extends EffectBase {
		
		public function Fountain() {
			xVelRandMin = -20;
			xVelRandMax = 20;
			yVelRandMin = -40;
			yVelRandMax = -20;
			gravity = 2;
			alphaMult = 0.955;
			drag = .5;
			numParticles = 3;
			edgeBehavior = "bounce";
		}
		
		public function toString():String {
			return "[type Fountain]";
		}
	}
}