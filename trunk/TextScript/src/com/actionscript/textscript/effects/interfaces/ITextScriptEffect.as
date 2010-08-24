package com.actionscript.textscript.effects.interfaces {
	import com.actionscript.textscript.components.TextScriptCharacter;
	
	
	public interface ITextScriptEffect {
		
		function get delayValue():Number;
		function set delayValue(value:Number):void;
		function get effectType():String;
		
		function initialize(tc:TextScriptCharacter):void;
		function effect(tc:TextScriptCharacter):void;
	}
}