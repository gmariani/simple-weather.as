package com.coursevector.display.effects {
	
	import flash.display.Sprite;
	import flash.geom.Point;

	public class EffectBase {
		public var alpha:Number;
		public var alphaMult:Number;
		
		public var xVel:Number;
		public var xVelRandMin:Number;
		public var xVelRandMax:Number;
		
		public var yVel:Number;
		public var yVelRandMin:Number;
		public var yVelRandMax:Number;
		
		public var scale:Number;
		public var scaleMult:Number;
		public var scaleRandMin:Number;
		public var scaleRandMax:Number;
		
		public var mouseSpring:Number;
		public var mouseGravity:Number;
		public var mouseRepel:Number;
		public var mouseRepelDist:Number;
		
		public var gravity:Number;
		public var drag:Number;
		public var bounce:Number;
		public var wander:Number;
		public var numParticles:int;
		public var edgeBehavior:String;
		public var turnToPath:Boolean = false;
		
		private var __spriteClass:Class;
		private var arrPointsSpring:Array = new Array();
		private var arrPointsGravity:Array = new Array();
		private var arrPointsRepel:Array = new Array();
		private var arrSpritesSpring:Array = new Array();
		private var arrSpritesGravity:Array = new Array();
		private var arrSpritesRepel:Array = new Array();
		
		public function EffectBase() { }
		
		// Spring Settings //
		/////////////////////
		/**
		 * Adds a point for the particle to spring to for the particle type
		 * 
		 * @param	point	Point with X & Y
		 * @param	force	Amount of gravity that specific point exerts
		 * @return			Current array index of new item
		 */
		final public function addSpringPoint(point:Point, force:Number = .1):uint {
			return arrPointsSpring.push({x:point.x, y:point.y, k:force}) - 1;
		}
		
		/**
		 * Adds a sprite for the particle to spring to for the particle type
		 * 
		 * @param	spr		Sprite to gravitate towards
		 * @param	force	Spring strength (def. .1)
		 * @return			Current array index of new item
		 */
		final public function addSpringSprite(spr:Sprite, force:Number = .1):uint {
			return arrSpritesSpring.push({clip:spr, k:force}) - 1;
		}
		
		/**
		 * Adds a spring force to the mouse for the particle type
		 * 
		 * @param	force	Spring strength (def. .1)
		 */
		final public function addSpringMouse(force:Number = .1):void {
			mouseSpring = force;
		}
		
		/**
		 * Removes a spring point at a specified index
		 * 
		 * @param	i	index to delete
		 */
		final public function removeSpringPoint(i:uint):void { arrPointsSpring.splice(i, 1) }
		final public function removeSpringSprite(i:uint):void { arrSpritesSpring.splice(i, 1) }
		final public function clearSpringMouse():void { mouseSpring = undefined }
		final public function clearSpringPoints():void { arrPointsSpring = new Array() }
		final public function clearSpringSprites():void { arrSpritesSpring = new Array() }
		final public function getSpringPoints():Array { return arrPointsSpring }
		final public function getSpringSprites():Array { return arrSpritesSpring }
		
		// Gravity Settings //
		//////////////////////
		/**
		 * Adds a point for the particle to gravitate to for the particle type
		 * 
		 * @param	point	Point with X & Y
		 * @param	force	Gravity strength (def. 1000)
		 * @return			Current array index of new item
		 */
		final public function addGravityPoint(point:Point, force:Number = 1000):uint {
			return arrPointsGravity.push({x:point.x, y:point.y, force:force}) - 1;
		}
		
		/**
		 * Adds a sprite for the particle to gravitate to for the particle type
		 * 
		 * @param	spr		Sprite to gravitate towards
		 * @param	force	Gravity strength (def. 1000)
		 * @return			Current array index of new item
		 */
		final public function addGravitySprite(spr:Sprite, force:Number = 1000):uint {
			return arrSpritesGravity.push({clip:spr, force:force}) - 1;
		}
		
		/**
		 * Adds a attracting force from the mouse for the particle type
		 * 
		 * @param	force	Gravity strength (def. 1000)
		 */
		final public function addGravityMouse(force:Number = 1000):void {
			mouseGravity = force;
		}
		
		/**
		 * Removes a gravity point at a specified index
		 * 
		 * @param	i	Index to delete
		 */
		final public function removeGravityPoint(i:uint):void { arrPointsGravity.splice(i, 1) }
		final public function removeGravitySprite(i:uint):void { arrSpritesGravity.splice(i, 1) }
		final public function clearGravityMouse():void { mouseGravity = undefined }
		final public function clearGravityPoints():void { arrPointsGravity = new Array() }
		final public function clearGravitySprites():void { arrSpritesGravity = new Array() }
		final public function getGravityPoints():Array { return arrPointsGravity }
		final public function getGravitySprites():Array { return arrSpritesGravity }
		
		// Repel Settings //
		////////////////////
		/**
		 * Adds a point for the particle to repel from for the particle type
		 * 
		 * @param	point		Point with X & Y
		 * @param	force		Repel strength	(def. .1)
		 * @param	minDist		Distance to maintain (def. 100)
		 * @return				Current array index of new item
		 */
		final public function addRepelPoint(point:Point, force:Number = .1, minDist:Number = 100):uint {
			return arrPointsRepel.push({x:point.x, y:point.y, k:force, minDist:minDist}) - 1;
		}
		
		/**
		 * Adds a sprite for the particle to repel from for the particle type
		 * 
		 * @param	spr			Sprite to repel from
		 * @param	force		Repel strength	(def. .1)
		 * @param	minDist		Distance to maintain (def. 100)
		 * @return				Current array index of new item
		 */
		final public function addRepelSprite(spr:Sprite, force:Number = .1, minDist:Number = 100):uint {
			return arrSpritesRepel.push({clip:spr, k:force, minDist:minDist}) - 1;
		}
		
		/**
		 * Adds a repelling force from the mouse for the particle type
		 * 
		 * @param	force		Repel strength	(def. .1)
		 * @param	minDist		Distance to maintain (def. 100)
		 */
		final public function addRepelMouse(force:Number = .1, minDist:Number = 100):void {
			mouseRepel = force;
			mouseRepelDist = minDist;
		}
		
		/**
		 * Removes a repel point at a specified index
		 * 
		 * @param	i	Index to delete
		 */
		final public function removeRepelPoint(i:uint):void { arrPointsRepel.splice(i, 1) }
		final public function removeRepelSprite(i:uint):void { arrSpritesRepel.splice(i, 1) }
		final public function clearRepelMouse():void { mouseRepel = mouseRepelDist = undefined }
		final public function clearRepelPoints():void { arrPointsRepel = new Array() }
		final public function clearRepelSprites():void { arrSpritesRepel = new Array() }
		final public function getRepelPoints():Array { return arrPointsRepel }
		final public function getRepelSprites():Array { return arrSpritesRepel }
		
		/**
		 * Sets the specific library linkId (class reference) for this effect
		 */
		final public function set spriteClass(sprClass:Class):void {	__spriteClass = sprClass }
		final public function get spriteClass():Class { return __spriteClass }
	}
}