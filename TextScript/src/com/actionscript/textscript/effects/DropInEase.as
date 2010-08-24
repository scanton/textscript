package com.actionscript.textscript.effects {
	
	import com.actionscript.textscript.components.TextScriptCharacter;
	
	import flash.geom.Point;
	import com.actionscript.textscript.effects.interfaces.ITextScriptEffect;

	public class DropInEase implements ITextScriptEffect {
		
		private var _delayValue:Number = 1;
		private var _effectType:String = TextScriptEffectType.CONSTRUCTIVE;
		
		public function DropInEase() {
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
					tc.visible = true;
				}
				tc.y -= (tc.y - tc.data.originalLocation.y) / 3;
				if(Math.abs(tc.y - tc.data.originalLocation.y) < 1) {
					tc.y = tc.data.originalLocation.y;
					tc.complete();
				}
			}
		}
		
	}
}