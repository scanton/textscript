package com.actionscript.textscript.components {
	import com.actionscript.textscript.effects.interfaces.ITextScriptEffect;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;

	public class TextScriptCharacter extends Sprite {
		
		private var _tf:TextField;
		private var _effect:ITextScriptEffect;
		private var _delayCounter:int = 0;
		private var _isComplete:Boolean = false;
		private var _timer:Timer;
		public var data:Object = {};
		
		public function TextScriptCharacter(character:String, textFormat:TextFormat) {
			super();
			init(character, textFormat);
		}
		
		public function init(s:String, tf:TextFormat):void {
			if(_tf != null) removeChild(_tf);
			_tf = new TextField();
			_tf.embedFonts = true;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.selectable = _tf.mouseEnabled = false;
			defaultTextFormat = tf;
			text = s;
			addChild(_tf);
		}
		public function get isComplete():Boolean {
			return _isComplete;
		}
		public function get timer():Timer {
			return _timer;
		}
		public function set timer(t:Timer):void {
			_timer = t;
			t.addEventListener(TimerEvent.TIMER, onTimer);
		}
		public function get delay():int {
			return _delayCounter;
		}
		public function set delay(value:int):void {
			_delayCounter = value;
		}
		public function get defaultTextFormat():TextFormat {
			return _tf.defaultTextFormat;
		}
		public function set defaultTextFormat(tf:TextFormat):void {
			_tf.defaultTextFormat = tf;
		}
		public function get textWidth():Number {
			return _tf.textWidth;
		}
		public function get textHeight():Number {
			return _tf.textHeight;
		}
		public function get lineMetrics():TextLineMetrics {
			return _tf.getLineMetrics(0);
		}
		public function get text():String {
			return _tf.text;
		}
		public function set text(value:String):void {
			_tf.text = value;
			_tf.x = -_tf.textWidth/2;
			_tf.y = -_tf.textHeight/2;
		}
		public override function get x():Number {
			return super.x + _tf.x;
		}
		public override function set x(value:Number):void {
			super.x = value - _tf.x;
		}
		public override function get y():Number {
			return super.y + _tf.y;
		}
		public override function set y(value:Number):void {
			super.y = value - _tf.y;
		}
		public function set textEffect(effect:ITextScriptEffect):void {
			effect.initialize(this);
			_effect = effect;
		}
		public function onTimer(e:TimerEvent):void {
			_effect.effect(this);
		}
		public function complete():void {
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_isComplete = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}