package com.actionscript.textscript.components {
	
	import com.actionscript.textscript.effects.interfaces.ITextScriptEffect;
	import com.actionscript.textscript.effects.TextScriptDelayType;
	import com.actionscript.textscript.effects.TextScriptEffectType;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;

	public class TextScriptLine extends Sprite {
		
		private var _characterArray:Array = [];
		private var _tf:TextField;
		private var _effect:ITextScriptEffect;
		private var _type:String;
		private var _effectType:String;
		private var _isComplete:Boolean = false;
		
		public function TextScriptLine(phrase:String, textFormat:TextFormat, timer:Timer, effect:ITextScriptEffect, type:String = "forward", maxDelay:Number=500, delayOffset:int = 0) {
			super();
			init(phrase, textFormat, timer, effect, delayOffset, type, maxDelay);
		}
		public function init(s:String, tf:TextFormat, t:Timer, e:ITextScriptEffect, d:int, type:String, maxDelay:Number):void {
			_effect = e;
			_effectType = e.effectType;
			_type = type;
			_tf = new TextField();
			_tf.defaultTextFormat = tf;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.embedFonts = true;
			_tf.text = s;
			var l:int = s.length;
			var tsc:TextScriptCharacter;
			for(var i:int = 0; i < l; i++) {
				tsc = new TextScriptCharacter(s.slice(i, i+1), tf);
				tsc.y = 0;
				if(i > 0) {
					var lm:TextLineMetrics = _characterArray[i-1].lineMetrics;
					tsc.x = _characterArray[i-1].x + lm.width;
				} else {
					tsc.x = 0;
				}
				tsc.textEffect = e;
				if(type==TextScriptDelayType.RANDOM) {
					tsc.delay = Math.round(Math.random() * maxDelay * e.delayValue);
				} else {
					tsc.delay = (type==TextScriptDelayType.REVERSE ? s.length - i : i) * e.delayValue + d;
				}
				tsc.timer = t;
				tsc.addEventListener(Event.COMPLETE, onComplete);
				addChild(tsc);
				_characterArray.push(tsc);
			}
		}
		public function get isComplete():Boolean {
			return _isComplete;
		}
		public function set delayOffset(value:int):void {
			if(_type != TextScriptDelayType.RANDOM) {
				var l:int = _characterArray.length;
				while(l--) {
					_characterArray[l].delay = value + (_type==TextScriptDelayType.REVERSE ? _tf.text.length - l : l) * _effect.delayValue;
				}
			}
		}
		public function get lineMetrics():TextLineMetrics {
			return _tf.getLineMetrics(0);
		}
		
		private function allChildrenComplete():Boolean {
			var l:int = _characterArray.length;
			while(l--) {
				if(_characterArray[l].isComplete == false) {
					return false;
				}
			}
			return true;
		}
		
		private function onComplete(e:Event):void {
			var tc:TextScriptCharacter = TextScriptCharacter(e.target);
			tc.removeEventListener(Event.COMPLETE, onComplete);
			if(_effectType == TextScriptEffectType.DESTRUCTIVE) {
				removeChild(tc);
				if(this.numChildren == 0) {
					_isComplete = true;
					dispatchEvent(new Event(Event.COMPLETE));
					_characterArray = [];
				}
			} else if(allChildrenComplete()) {
				_isComplete = true;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}