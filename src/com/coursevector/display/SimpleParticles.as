package com.coursevector.display {
	
	import com.coursevector.util.MathUtil;
	import com.coursevector.display.Particle;
	import com.coursevector.display.effects.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.geom.Rectangle;

	public class SimpleParticles extends Sprite {
		
		protected var particleTypes:Array = new Array();
		protected var currentParticles:Array = new Array();
		protected var spareParticles:Dictionary = new Dictionary();
		protected var p:Particle;
		protected var POINT:Point = new Point(0,0);
		
		private var _pLimit:int = 500;
		private var _tLimit:int = -1;
		private var _tx:Number;
		private var _ty:Number;
		private var _xyBounds:Object = new Object();
		private var _pBounds:Rectangle;
		private var _loopBehavior:String = "wrap";
		private var isEnd:Boolean = false;
		private var _getCoordinateCustom:Function;
		private var _getEnterFrameCustom:Function;
		private var _count:int = 0;
		
		public function SimpleParticles() {	}
		
		/**
		 * Passes in a custom positioning system for the particles
		 */
		public function set setPoint(f:Function):void {
			_getCoordinateCustom = f;
		}
		
		/**
		 * Allows user to override what happens on the enterframe
		 * Combine with update() and updateParticles() to work effectively
		 */
		public function set setEnterFrame(f:Function):void {
			_getEnterFrameCustom = f;
		}
		
		/**
		 * Adds a particle type to the system. Effect type is unique to that particle
		 * 
		 * @param	spriteClass	Library linkage class
		 * @param	effectType	Effect class (def. None)
		 * @return				The speficied effect class
		 */
		public function addParticleType(spriteClass:Class, effectType:EffectBase = null):EffectBase {
			var et:EffectBase = effectType == null ? new None() : effectType;
			et.spriteClass = spriteClass;
			particleTypes.push(et);
			return et;
		}
		
		public function clearParticleTypes():void {
			particleTypes = new Array();
		}
		
		/**
		 * Starts the system
		 */
		public function start():void {
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Stops the system
		 */
		public function stop():void {
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Sets the particles to be created within boundries
		 * @param	rBounds	Rectangle
		 */
		public function setXYBounds(rBounds:Rectangle):void {
			_xyBounds.top = rBounds.y;
			_xyBounds.bottom = rBounds.height + rBounds.y;
			_xyBounds.left = rBounds.x;
			_xyBounds.right = rBounds.width + rBounds.x;
		}
		
		/**
		 * Sets the particles to be created at specified point
		 * @param	pt	Point with X & Y
		 */
		public function setXYPoint(pt:Point):void {
			_xyBounds.top = pt.y;
			_xyBounds.bottom = pt.y;
			_xyBounds.left = pt.x;
			_xyBounds.right = pt.x;
		}
		
		/**
		 * Sets the particles to be created at mouse position
		 */
		public function setXYMouse():void {
			_xyBounds = new Object();
		}
		
		/**
		 * Where particles will automatically cull at
		 */
		public function setBounds(r:Rectangle):void { _pBounds = r }
		
		/**
		 * Determines how the system will run. If it will run continuously, or end after
		 * a specified number of particles.
		 * @param	s	Can be set to "wrap" or "end"
		 */
		public function setRunMethod(s:String):void { _loopBehavior = s }
		
		/**
		 * Total number of particles in the system
		 */
		public function setParticleLimit(n:int):void { _pLimit = n }
		
		/**
		 * Determines how long the system will run.
		 * @param	n	Number of seconds
		 */
		//public function setTimeLimit(n:int):void { _tLimit = n }
		
		/**
		 * Get the master array of particles running
		 * @return
		 */
		public function getParticles():Array { return currentParticles }
		
		/**
		 * Gets a specifc set of particles by type
		 * @return
		 */
		//public function getParticlesByType():Array { return currentParticles }
		
		/**
		 * Gets all effects used
		 * 
		 * @return
		 */
		public function getEffects():Array { return particleTypes }
		
		/**
		 * Determines where to place a particle. Or if the user has chosen to use a custom
		 * function, it will use that instead.
		 * 
		 * @return
		 */
		protected function getCoordinate():Point {
			var pt:Point = POINT;
			if(_getCoordinateCustom != null) {
				pt = _getCoordinateCustom();
			} else {
				if(_xyBounds.left != undefined) {
					pt.x = MathUtil.randomRange(_xyBounds.left, _xyBounds.right);
					pt.y = MathUtil.randomRange(_xyBounds.top, _xyBounds.bottom);
				} else {
					pt.x = mouseX;
					pt.y = mouseY;
				}
			}
			return pt;
		}
		
		/**
		 * EnterFrame handler, updates particles and adds new ones as necessary
		 * 
		 * @param	e	Event
		 */
		protected function onEnterFrame(e:Event):void {
			if(_getEnterFrameCustom != null) {
				_getEnterFrameCustom();
			} else {
				var l:int = particleTypes.length;
				if(l > 0) {
					updateParticles();
					update();
				}
			}
		}
		
		/**
		 * Adds a new particle to the mix, but if one of the same type exists in the
		 * spare particles array, use that instead. Reusing is faster than recreating.
		 * 
		 * @param	effect	The effect type
		 * @param	pt		Point with X & Y
		 */
		protected function addParticle(effect:EffectBase, pt:Point):void {
			var l:int = effect.numParticles;
			var pclass:Class = effect.spriteClass;
			
			for (var i:int = 0; i < l; i++) {
				
				if(spareParticles[pclass] && spareParticles[pclass].length > 0) {
					p = spareParticles[pclass].shift();
				} else {
					p = new pclass();
					//p.cacheAsBitmap = true;
					this.addChild(p);
					_count++;
				}
				
				p.x = pt.x;
				p.y = pt.y;
				p.updateSettings(effect);
				if(_pBounds) p.setBounds(_pBounds);
				currentParticles.push(p);
			}
		}
		
		/**
		 * Updates particle settings, and handles garbage collection.
		 * If more than the limit of particles is created, the oldest are tossed into a spare
		 * particles array. These will be called upon later to be recycled.
		 */
		public function updateParticles():void {
			if(_loopBehavior == "end" && _count > _pLimit) {
				isEnd = true;
			} else {
				//while(currentParticles.length > _pLimit) {
				for(var i:int = 0; i < currentParticles.length; i++) {
					if(currentParticles[i].isEnabled == false) {
						//p = currentParticles.shift();
						p = currentParticles.splice(i, 1)[0];
						p.isEnabled = false;
						
						var spareSpr:Array = spareParticles[p];
						if (!spareSpr) spareSpr = new Array();
						spareSpr.push(p);
					}
				}
			}
			
			// go through the array of particles and update
			var curLen:int = currentParticles.length;
			var j:int = 0;
			while(j < curLen) {
				p = currentParticles[j];
				p.update();
				if (p.width < 1) p.isEnabled = false;
				if (p.alpha < .01) p.isEnabled = false;
				j++;
			}
		}
		
		public function update():void {
			var l:int = particleTypes.length;
			if(isEnd == false) {
				var pt:Point = getCoordinate();
				if(pt != null) {
					for (var i:int = 0; i < l; i++) {
						addParticle(particleTypes[i], pt);
					}
				}
			}
		}
	}
}