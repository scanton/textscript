package com.actionscript.textscript {
	
	import com.actionscript.textscript.effects.interfaces.ITextScriptEffect;
	import com.actionscript.textscript.effects.TextScriptDelayType;
	import com.actionscript.textscript.effects.TextScriptEffectType;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import com.actionscript.textscript.components.TextScriptLine;

	public class TextScript extends Sprite {
		
		private var _width:Number;
		private var _linesArray:Array;
		private var _stringsArray:Array;
		private var _timer:Timer;
		private var _effectType:String;
		private var _isComplete:Boolean = false;
		
		public function TextScript(phrase:String, textFormat:TextFormat, effect:ITextScriptEffect, delayType:String="forward", textWidth:Number = 100) {
			super();
			init(phrase, textFormat, textWidth, effect, delayType);
		}
		
		public function init(s:String, tf:TextFormat, w:Number, e:ITextScriptEffect, type:String):void {
			var delayValue:int = 0;
			_effectType = e.effectType;
			_timer = new Timer(50);
			_width = w;
			_stringsArray = createStringsArray(s, tf, w);
			_linesArray = [];
			var tsl:TextScriptLine;
			for(var i:int = 0; i < _stringsArray.length; i++) {
				tsl = new TextScriptLine(_stringsArray[i], tf, _timer, e, type, s.length);
				tsl.addEventListener(Event.COMPLETE, onComplete);
				addChild(tsl);
				_linesArray.push(tsl);
				if(i > 0) {
					tsl.y = _linesArray[i-1].y + _linesArray[i-1].lineMetrics.height;
					delayValue += _stringsArray[i-1].length;
				}
				tsl.delayOffset = type==TextScriptDelayType.REVERSE ? s.length - _stringsArray[_stringsArray.length-1].length - delayValue : delayValue;
				tsl.x = _width/2 - tsl.lineMetrics.width/2;
			}
			_timer.start();
		}
		public function start():void {
			_timer.start();
		}
		public function stop():void {
			_timer.stop();
		}
		public function get isComplete():Boolean {
			return _isComplete;
		}
		
		private function createStringsArray(s:String, tf:TextFormat, w:Number):Array {
			var _tf:TextField = new TextField();
			_tf.defaultTextFormat = tf;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.embedFonts = true;
			var s2:String = "";
			var a:Array = s.split(" ");
			var a2:Array = [];
			for(var i:int = 0; i < a.length; i++) {
				_tf.text = s2 + (i > 0 ? " " : "") + a[i];
				if(_tf.getLineMetrics(0).width > w) {
					a2.push(s2);
					s2 = a[i];
				} else {
					s2 += (i > 0 ? " " : "") + a[i];
				}
			}
			a2.push(s2);
			return a2;
		}
		private function allChildrenComplete():Boolean {
			var l:int = _linesArray.length;
			while(l--) {
				if(_linesArray[l].isComplete == false) {
					return false;
				}
			}
			return true;
		}
		private function onComplete(e:Event):void {
			if(_effectType == TextScriptEffectType.DESTRUCTIVE) {
				removeChild(TextScriptLine(e.target));
				e.target.removeEventListener(Event.COMPLETE, onComplete);
				if(numChildren == 0) {
					_isComplete = true;
					dispatchEvent(new Event(Event.COMPLETE));
					_linesArray = [];
				}
			} else if(allChildrenComplete()) {
				_isComplete = true;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}