package com.actionscript.textscript.effects {
	
	import com.actionscript.textscript.components.TextScriptCharacter;
	
	import flash.geom.Point;
	import com.actionscript.textscript.effects.interfaces.ITextScriptEffect;

	public class TypewriterInEffect implements ITextScriptEffect {
		
		private var _delayValue:Number = 1;
		private var _effectType:String = TextScriptEffectType.CONSTRUCTIVE;
		
		public function TypewriterInEffect() {
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
			tc.visible = false;
		}
		
		public function effect(tc:TextScriptCharacter):void {
			tc.delay--;
			if(tc.delay <= 0 ) {
				tc.visible = true;
				tc.complete();
			}
		}
		
	}
}