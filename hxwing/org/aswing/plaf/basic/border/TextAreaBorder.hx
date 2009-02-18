/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.border;

/**
 * @private
 */
class TextAreaBorder extends TextComponentBorder {
	
	
	
	public function new(){
		super();
	}
	
	//override this to the sub component's prefix
	override function getPropertyPrefix():String {
		return "TextArea.";
	}
	
}
