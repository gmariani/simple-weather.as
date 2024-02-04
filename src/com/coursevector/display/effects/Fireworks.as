package com.coursevector.display.effects {

	public class Fireworks extends EffectBase {
		
		public function Fireworks() {
			alpha = .4;
			xVelRandMin = -10;
			xVelRandMax = 10;
			yVelRandMin = -10;
			yVelRandMax = 10;
			scaleRandMin = 1;
			scaleRandMax = 2;
			scaleMult = .95;
			gravity = 1;
			alphaMult = 0.9;
			drag = 0.99;
			turnToPath = false;
			numParticles = 5;
		}
		
		public function toString():String {
			return "[type Fireworks]";
		}
	}
}