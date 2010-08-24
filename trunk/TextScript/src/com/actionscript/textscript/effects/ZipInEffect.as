package com.actionscript.textscript.effects {
	
	import com.actionscript.textscript.components.TextScriptCharacter;
	
	import flash.filters.BlurFilter;
	import com.actionscript.textscript.effects.interfaces.ITextScriptEffect;
	
	
	public class ZipInEffect implements ITextScriptEffect {
		
		private var _delayValue:Number = 1;
		private var _effectType:String = TextScriptEffectType.CONSTRUCTIVE;
		
		public function ZipInEffect() {
			
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
			tc.data.originalX = tc.x;
			tc.data.lastX = 0;
			tc.alpha = 0;
		}
		public function effect(tc:TextScriptCharacter):void {
			tc.delay--;
			if(tc.delay < 0) {
				if(tc.alpha < 1) {
					tc.alpha -= (tc.alpha - 1) / 3;
					tc.x -= (tc.x - tc.data.originalX) / 3;
					tc.filters = [new BlurFilter(tc.x - tc.data.lastX, 0, 1)];
					tc.data.lastX = tc.x;
					if(Math.abs(tc.x - tc.data.originalX) < 1) {
						tc.alpha = 1;
						tc.x = tc.data.originalX;
						tc.complete();
					}
				}
			} else {
				tc.x = -50;
			}
		}
	}
}