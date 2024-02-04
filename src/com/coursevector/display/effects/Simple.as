package com.coursevector.display.effects {

	public class Simple extends EffectBase {
		
		public function Simple() {
			alpha = .7;
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
			numParticles = 1;
			edgeBehavior = "bounce";
		}
		
		public function toString():String {
			return "[type Simple]";
		}
	}
}