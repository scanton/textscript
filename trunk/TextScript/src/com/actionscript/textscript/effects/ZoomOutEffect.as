package com.actionscript.textscript.effects {
	
	import com.actionscript.textscript.components.TextScriptCharacter;
	
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import com.actionscript.textscript.effects.interfaces.ITextScriptEffect;

	public class ZoomOutEffect implements ITextScriptEffect {
		
		private var _delayValue:Number = 1;
		private var _effectType:String = TextScriptEffectType.DESTRUCTIVE;
		
		public function ZoomOutEffect() {
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
		}
		
		public function effect(tc:TextScriptCharacter):void {
			tc.delay--;
			if(tc.delay <= 0) {
				tc.scaleX -= (tc.scaleX - 5) / 3;
				tc.scaleY = tc.scaleX;
				tc.filters = [new BlurFilter((tc.scaleX-1)*5, (tc.scaleY-1)*5)];
				tc.alpha = 1 - (tc.scaleX/5);
				if(tc.scaleX > 4.9) {
					tc.alpha = 0;
					tc.complete();
				}
			}
		}
	}
}