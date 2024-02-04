package com.coursevector.display.effects {

	public class None extends EffectBase {
		
		public function None() {
			gravity = 1;
			drag = 0.99;
			numParticles = 5;
			edgeBehavior = "bounce";
		}
		
		public function toString():String {
			return "[type None]";
		}
	}
}