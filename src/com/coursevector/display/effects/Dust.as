package com.coursevector.display.effects {

	public class Dust extends EffectBase {
		
		public function Dust() {
			wander = 1;
			gravity = .1;
			numParticles = 2;
			//mouseGravity = 10;
			//mouseSpring = .2;
			//mouseRepel = .2;
			//mouseRepelDist = 50;
		}
		
		public function toString():String {
			return "[type Dust]";
		}
	}
}