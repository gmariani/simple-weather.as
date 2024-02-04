package com.coursevector.display {
	
	import com.coursevector.display.effects.EffectBase;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.coursevector.util.MathUtil;
	
	public class Particle extends Sprite {
		
		// Settings Variables
		private var _am:Number = 1; // Alpha multiplier
		private var _sm:Number = 1; // Scale Multiplier
		private var _vx:Number = 0; // X Velocity
		private var _vy:Number = 0; // Y Velocity
		private var _isMouseSpring:Boolean = false; // If mouse spring is enabled
		private var _mouseSpring:Number = .2; // Mouse Spring
		private var _isMouseGravity:Boolean = false; // If mouse gravity is enabled
		private var _mouseGravity:Number = 5000; // Mouse Gravity
		private var _isMouseRepel:Boolean = false; // If mouse repels
		private var _mouseRepel:Number = .2; // Mouse Repel
		private var _mouseRepelDist:Number = 100; // Mouse Repel Min Distance
		
		private var _drag:Number = .9; // Damp or Drag (Friction)
		private var _bounce:Number = -.5; // Bounce
		private var _gravity:Number = 0; // Gravity
		private var _bounds:Object = new Object(); // Boundry where particle is displayed
		private var _maxSpeed:Number = Number.MAX_VALUE; // Maximum speed
		private var _wander:Number = 0;  // Amount of erratic movement
		private var _turn:Boolean = false; // Point sprite in direction of movement
		private var _edgeBehavior:String = "bounce";
		
		// Dragging Settings
		private var _isDraggable:Boolean = false;
		private var _isDragging:Boolean;
		private var _oldx:Number;
		private var _oldy:Number;
		
		private var _arrSpringPoints:Array = new Array();
		private var _arrSpringSprites:Array = new Array();
		private var _arrGravityPoints:Array = new Array();
		private var _arrGravitySprites:Array = new Array();
		private var _arrRepelPoints:Array = new Array();
		private var _arrRepelSprites:Array = new Array();
		private var _isEnabled:Boolean = true;
		
		public function Particle() { }
		
		public function set isEnabled(bool:Boolean):void { _isEnabled = visible = bool }
		public function get isEnabled():Boolean {	return _isEnabled }
		
		public function set alphaMult(n:Number):void { _am = n }
		public function get alphaMult():Number { return _am }
		
		public function set scaleMult(n:Number):void { _sm = n }
		public function get scaleMult():Number { return _sm }
		
		public function set vx(n:Number):void { _vx = n}
		public function get vx():Number { return _vx }
		
		public function set vy(n:Number):void { _vy = n }
		public function get vy():Number { return _vy }
		
		public function set drag(n:Number):void { _drag = n }
		public function get drag():Number { return _drag }
		
		public function set bounce(n:Number):void { _bounce = n }
		public function get bounce():Number { return _bounce }
		
		public function set grav(n:Number):void { _gravity = n }
		public function get grav():Number { return _gravity }
		
		public function set maxSpeed(n:Number):void { _maxSpeed = n }
		public function get maxSpeed():Number {	return _maxSpeed }
		
		public function set wander(n:Number):void { _wander = n }
		public function get wander():Number { return _wander }
		
		public function set edgeBehavior(s:String):void { _edgeBehavior = s }
		public function get edgeBehavior():String{ return _edgeBehavior }
		
		public function set turnToPath(b:Boolean):void { _turn = b }
		public function get turnToPath():Boolean { return _turn }
		
		/*
		public function set draggable(b:Boolean):void {
			_isDraggable = true;
			if (b) {
				this.addEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
				this.addEventListener(MouseEvent.MOUSE_UP, releaseHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, outsideHandler);
			} else {
				this.removeEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
				this.removeEventListener(MouseEvent.MOUSE_UP, releaseHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, outsideHandler);
				_isDragging = false;
			}
		}
		public function get draggable():Boolean { return _isDraggable }
		*/
		
		public function setScale(s:Number):void { scaleX = scaleY = s }
		
		public function setBounds(rBounds:Rectangle):void {
			_bounds.top = rBounds.y;
			_bounds.bottom = rBounds.height + rBounds.y;
			_bounds.left = rBounds.x;
			_bounds.right = rBounds.width + rBounds.x;
		}
		
		public function updateSettings(effect:EffectBase):void {
			if(!isNaN(effect.alpha)) alpha = effect.alpha;
			if(!isNaN(effect.alphaMult)) _am = effect.alphaMult;
			if(!isNaN(effect.scaleMult)) _sm = effect.scaleMult;
			if(!isNaN(effect.gravity)) _gravity = effect.gravity;
			if(!isNaN(effect.drag)) _drag = effect.drag;
			if(!isNaN(effect.bounce)) _bounce = effect.bounce;
			if(!isNaN(effect.wander)) _wander = effect.wander;
			if(effect.turnToPath) _turn = effect.turnToPath;
			if(effect.edgeBehavior != null) _edgeBehavior = effect.edgeBehavior;
			
			// Mouse Settings
			if(!isNaN(effect.mouseGravity)) {
				_mouseGravity = !effect.mouseGravity ? 1000 : effect.mouseGravity;
				_isMouseGravity = true;
			}
			
			if(!isNaN(effect.mouseRepel)) {
				_mouseRepel = !effect.mouseRepel ? .1 : effect.mouseRepel;
				_mouseRepelDist = !effect.mouseRepelDist ? 100 : effect.mouseRepelDist;
				_isMouseRepel = true;
			}
			
			if(!isNaN(effect.mouseSpring)) {
				_mouseSpring = !effect.mouseSpring ? .1 : effect.mouseSpring;
				_isMouseSpring = true;
			}
			
			// Point Settings
			_arrSpringPoints =  effect.getSpringPoints();
			_arrGravityPoints =  effect.getGravityPoints();
			_arrRepelPoints =  effect.getRepelPoints();
			
			// Sprite Settings
			_arrSpringSprites =  effect.getSpringSprites();
			_arrGravitySprites =  effect.getGravitySprites();
			_arrRepelSprites =  effect.getRepelSprites();
			
			if(!isNaN(effect.xVel)) {
				vx = effect.xVel;
			} else if(effect.xVelRandMin && effect.xVelRandMax) {
				vx = MathUtil.randomRange(effect.xVelRandMin, effect.xVelRandMax);
			}
			
			if(effect.yVel >= 0) {
				vy = effect.yVel;
			} else if(effect.yVelRandMin && effect.yVelRandMax) {
				vy = MathUtil.randomRange(effect.yVelRandMin, effect.yVelRandMax);
			}
			
			if(!isNaN(effect.scale)) {
				setScale(effect.scale);
			} else if(effect.scaleRandMin && effect.scaleRandMax) {
				setScale(MathUtil.randomRange(effect.scaleRandMin, effect.scaleRandMax));
			}
		}
		
		public function update():void {
			if(!_isEnabled) return;
			
			var dx:Number;
			var dy:Number;
			var dist:Number;
			var point:Object;
			var distSQ:Number;
			var force:Number;
			var tx:Number;
			var ty:Number;
			var k:Number;
			var clip:Sprite;
			
			if (_isDragging) {
				_vx = this.x - _oldx;
				_vy = this.y - _oldy;
				_oldx = this.x;
				_oldy = this.y;
			} else {
				if (_isMouseSpring) {
					_vx += (this.parent.mouseX - this.x) * _mouseSpring;
					_vy += (this.parent.mouseY - this.y) * _mouseSpring;
				}
				
				if (_isMouseGravity) {
					dx = this.parent.mouseX - this.x;
					dy = this.parent.mouseY - this.y;
					distSQ = dx * dx + dy * dy;
					dist = Math.sqrt(distSQ);
					force = _mouseGravity / distSQ;
					_vx += force * dx / dist;
					_vy += force * dy / dist;
				}
				
				if (_isMouseRepel) {
					dx = parent.mouseX - x;
					dy = parent.mouseY - y;
					dist = Math.sqrt(dx * dx + dy * dy);
					
					if (dist < _mouseRepelDist) {
						tx = parent.mouseX - _mouseRepelDist * dx / dist;
						ty = parent.mouseY - _mouseRepelDist * dy / dist;
						_vx += (tx - x) * _mouseRepel;
						_vy += (ty - y) * _mouseRepel;
					}
				}
				
				var spL:uint = _arrSpringPoints.length;
				for (var sp:int = 0; sp < spL; sp++) {
					point = _arrSpringPoints[sp];
					_vx += (point.x - x) * point.k;
					_vy += (point.y - y) * point.k;
				}
				
				var gpL:uint = _arrGravityPoints.length;
				for (var gp:int = 0; gp < gpL; gp++) {
					point = _arrGravityPoints[gp];
					dx = point.x - x;
					dy = point.y - y;
					distSQ = dx * dx + dy * dy;
					dist = Math.sqrt(distSQ);
					force = point.force / distSQ;
					_vx += force * dx / dist;
					_vy += force * dy / dist;
				}
				
				var rpL:uint = _arrRepelPoints.length;
				for (var rp:int = 0; rp < rpL; rp++) {
					point = _arrRepelPoints[rp];
					dx = point.x - x;
					dy = point.y - y;
					dist = Math.sqrt(dx * dx + dy * dy);
					
					if (dist < point.minDist) {
						tx = point.x - point.minDist * dx / dist;
						ty = point.y - point.minDist * dy / dist;
						_vx += (tx - x) * point.k;
						_vy += (ty - y) * point.k;
					}
				}
				
				var scL:uint = _arrSpringSprites.length;
				for (var sc:int = 0; sc < scL; sc++) {
					clip = _arrSpringSprites[sc].clip;
					k = _arrSpringSprites[sc].k;
					_vx += (clip.x - x) * k;
					_vy += (clip.y - y) * k;
				}
				
				var gcL:uint = _arrGravitySprites.length;
				for (var gc:int = 0; gc < gcL; gc++) {
					clip = _arrGravitySprites[gc].clip;
					dx = clip.x - x;
					dy = clip.y - y;
					distSQ = dx * dx + dy * dy;
					dist = Math.sqrt(distSQ);
					force = _arrGravitySprites[gc].force / distSQ;
					_vx += force * dx / dist;
					_vy += force * dy / dist;
				}
				
				var rcL:uint = _arrRepelSprites.length;
				for (var rc:int = 0; rc < rcL; rc++) {
					clip = _arrRepelSprites[rc].clip;
					var minDist = _arrRepelSprites[rc].minDist;
					k = _arrRepelSprites[rc].k;
					dx = clip.x - x;
					dy = clip.y - y;
					dist = Math.sqrt(dx * dx + dy * dy);
					if (dist < minDist) {
						tx = clip.x - minDist * dx / dist;
						ty = clip.y - minDist * dy / dist;
						_vx += (tx - x) * k;
						_vy += (ty - y) * k;
					}
				}
				
				_vx += Math.random() * _wander - _wander / 2;
				_vy += Math.random() * _wander - _wander / 2;
				_vy += _gravity;
				_vx *= drag;
				_vy *= drag;
				
				var halfWidth:Number = width / 2;
				var halfHeight:Number = height / 2;
				var speed:Number = Math.sqrt(_vx * _vx + _vy * _vy);
				
				// Speed
				if (speed > _maxSpeed) {
					_vx = _maxSpeed * _vx / speed;
					_vy = _maxSpeed * _vy / speed;
				}
				
				// Rotation
				if (_turn) this.rotation = Math.atan2(_vy, _vx) * 180 / Math.PI;
				
				// Alpha
				this.alpha = (alpha * 1000) * _am / 1000;
				
				// Scale
				this.scaleX = this.scaleY *= _sm;
				
				// Position
				this.x += _vx;
				this.y += _vy;
				
				switch(_edgeBehavior) {
					case "wrap" :
						if (this.x > _bounds.right + halfWidth) {
							this.x = _bounds.left - halfWidth;
						} else if (this.x < _bounds.left - halfWidth) {
							this.x = _bounds.right + halfWidth;
						}
						if(this.y > _bounds.bottom + halfHeight) {
							this.y = _bounds.top - halfHeight;
						} else if (this.y < _bounds.top - halfHeight) {
							this.y = _bounds.bottom + halfHeight;
						}
						break;
					case "bounce" :
						if (this.x > _bounds.right - halfWidth) {
							this.x = _bounds.right - halfWidth;
							_vx *= _bounce;
						} else if (this.x < _bounds.left + halfWidth) {
							this.x = _bounds.left + halfWidth;
							_vx *= _bounce
						}
						if(this.y > _bounds.bottom - halfHeight) {
							this.y = _bounds.bottom - halfHeight;
							_vy *= _bounce
						} else if (this.y < _bounds.top + halfHeight) {
							this.y = _bounds.top + halfHeight;
							_vy *= _bounce;
						}
						break;
					case "remove" :
						if(this.x > _bounds.right + halfWidth || this.x < _bounds.left - halfWidth || this.y > _bounds.bottom + halfHeight || this.y < _bounds.top - halfHeight) {
							//TODO: get this picked up by simple particles GC
							this.isEnabled = false;
							//_efClip.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
							//parent.removeChild(this);
						}
				}
				
				// Force redraw of stage
				if(stage != null) stage.invalidate();
			}
		};
		
		//public function toString():String { return "[ type Particle]" }
		
		private function pressHandler(event:MouseEvent):void {
			startDrag();
			_isDragging = true;
		}
		
		private function releaseHandler(event:MouseEvent):void {
			stopDrag();
			_isDragging = false;
		}
		
		private function outsideHandler(event:MouseEvent):void {
			stopDrag();
			_isDragging = false;
		}
	}
}