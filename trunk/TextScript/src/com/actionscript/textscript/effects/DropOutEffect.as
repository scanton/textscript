package com.actionscript.textscript.effects {
	
	import com.actionscript.textscript.components.TextScriptCharacter;
	
	import flash.filters.BlurFilter;
	import com.actionscript.textscript.effects.interfaces.ITextScriptEffect;

	public class DropOutEffect implements ITextScriptEffect {
		
		private var _delayValue:Number;
		private var _gravity:Number;
		private var _rotationRate:Number;
		private var _effectType:String = TextScriptEffectType.DESTRUCTIVE;
		private var _lowerBoundary:Number;
		
		public function DropOutEffect(lowerBoundary:Number = 300, delayValue:Number = 1, gravity:Number = 3, rotationRate:Number = 10) {
			_delayValue = delayValue;
			_gravity = gravity;
			_rotationRate = rotationRate;
			_lowerBoundary = lowerBoundary;
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
			tc.data.yVelocity = -10;
			tc.data.rotationRate = Math.random() * _rotationRate - _rotationRate / 2;
		}
		
		public function effect(tc:TextScriptCharacter):void {
			tc.delay--;
			if(tc.delay <= 0) {
				tc.y += tc.data.yVelocity;
				tc.rotation += tc.data.rotationRate;
				tc.filters = [new BlurFilter(0, tc.data.yVelocity, 1)];
				tc.data.yVelocity += _gravity;
				if(tc.y > _lowerBoundary) {
					tc.complete();
				}
			}
		}
	}
}