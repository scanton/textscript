package com.actionscript.textscript.effects {
	
	import com.actionscript.textscript.components.TextScriptCharacter;
	
	import flash.filters.BlurFilter;
	import com.actionscript.textscript.effects.interfaces.ITextScriptEffect;
	
	
	public class ZipOutEffect implements ITextScriptEffect {
		
		private var _delayValue:Number = 1;
		private var _effectType:String = TextScriptEffectType.DESTRUCTIVE;
		
		public function ZipOutEffect() {
			
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
			tc.data.xTarget = tc.x + 50;
			tc.data.originalX = tc.x;
		}
		public function effect(tc:TextScriptCharacter):void {
			tc.delay--;
			if(tc.delay < 0) {
				if(tc.alpha > 0) {
					tc.data.lastX = tc.x;
					tc.alpha -= tc.alpha / 4;
					tc.x -= (tc.x - tc.data.xTarget) / 4;
					tc.filters = [new BlurFilter((tc.x - tc.data.lastX) * 2, 0, 1)];
				} else {
					tc.complete();
				}
			}
		}
	}
}