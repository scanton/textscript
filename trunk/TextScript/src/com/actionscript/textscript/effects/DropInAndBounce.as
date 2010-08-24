package com.actionscript.textscript.effects {
	
	import com.actionscript.textscript.components.TextScriptCharacter;
	
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import com.actionscript.textscript.effects.interfaces.ITextScriptEffect;

	public class DropInAndBounce implements ITextScriptEffect {
		
		private var _delayValue:Number = 1;
		private var _gravity:Number = 3;
		private var _dampening:Number = .25;
		private var _effectType:String = TextScriptEffectType.CONSTRUCTIVE;
		
		public function DropInAndBounce(gravity:Number = 3, dampening:Number = .25) {
			_gravity = gravity;
			_dampening = dampening;
		}

		public function get delayValue():Number {
			return _delayValue;
		}
		
		public function set delayValue(value:Number):void {
			_delayValue = value;
		}
		
		public function get effectType():String {
			return _effectType;
		}
		
		public function initialize(tc:TextScriptCharacter):void {
			tc.data.originalLocation = new Point(tc.x, tc.y);
			tc.visible = false;
		}
		
		public function effect(tc:TextScriptCharacter):void {
			tc.delay--;
			if(tc.delay <= 0 && tc.localToGlobal(new Point(tc.x, tc.y)).y != tc.data.originalLocation.y) {
				if(tc.visible == false) {
					tc.y = tc.globalToLocal(new Point(tc.x, -tc.height)).y;
					tc.data.yVelocity = 1;
					tc.data.bounces = 0;
					tc.visible = true;
				}
				tc.y += tc.data.yVelocity;
				tc.filters = [new BlurFilter(0, tc.data.yVelocity, 1)];
				tc.data.yVelocity += _gravity;
				if(tc.y > tc.data.originalLocation.y) {
					tc.data.bounces++;
					tc.y = tc.data.originalLocation.y;
					if(tc.data.yVelocity < 6 || tc.data.bounces > 3) {
						tc.data.yVelocity = 0;
						tc.filters = [];
						tc.complete();
					} else {
						tc.data.yVelocity = -tc.data.yVelocity * _dampening;
					}
				}
			}
		}
	}
}