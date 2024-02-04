package com.coursevector.display.effects {

	public class Smoke extends EffectBase {
		
		public function Smoke() {
			alpha = 0.3;
			xVelRandMin = -0.3;
			xVelRandMax = 0.3;
			yVel = 0;
			scaleMult = 1.03;
			gravity = -0.05;
			alphaMult = 0.999;
			drag = 0.99;
			numParticles = 2;
			edgeBehavior = "remove";
		}
		
		public function toString():String {
			return "[type Smoke]";
		}
	}
}