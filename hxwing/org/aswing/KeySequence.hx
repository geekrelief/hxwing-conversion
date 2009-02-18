/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

/**
 * Key Sequence, defines a key sequence.
 * <p>
 * Thanks Romain for his Fever{@link http://fever.riaforge.org} accelerator framworks implementation, 
 * this is a simpler implementation study from his.
 * @author iiley
 */
class KeySequence implements KeyType {
	
	/** Constant definition for concatenation character. */
	
	
	/** Constant definition for concatenation character. */
	public static var LIMITER: String = "+";
	
	var codeString:String;
	var codeSequence:Array<Dynamic>;
	
	/**
	 * KeySequence(key1:KeyStroke, key2:KeyStroke, ...)<br>
	 * KeySequence(description:String, codeSequence:Array)<br>
	 * Create a key definition with keys.
	 * @throws ArgumentError when arguments is not illegular.
	 */
	public function new(arguments:Array<Dynamic>){
		if(Std.is( arguments[0], KeyStroke)){
			var key:KeyStroke = cast(arguments[0], KeyStroke);
			codeSequence = [key.getCode()];
			codeString = key.getDescription();
			for(i in 1...arguments.length){
				key = cast(arguments[i], KeyStroke);
				codeString += (LIMITER+key.getDescription());
				codeSequence.push(key.getCode());
			}
		}else{
			if(Std.is( arguments[1], Array)){
				codeString = arguments[0].toString();
				codeSequence = arguments[1].copy();
			}else{
				//throw new ArgumentError("KeySequence constructing error!!");
				throw ("KeySequence constructing error!!");
			}
		}
	}
	
	public function getDescription() : String {
		return codeString;
	}

	public function getCodeSequence() : Array<Dynamic> {
		return codeSequence.copy();
	}
	
	public function toString():String{
		return "KeySequence[" + getDescription + "]";
	}
}
