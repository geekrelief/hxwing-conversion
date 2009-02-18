/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;

/**
 * @private
 */
class BasicTextAreaUI extends BasicTextComponentUI {
	
	
	
	public function new(){
		super();
	}
	
	//override this to the sub component's prefix
	override function getPropertyPrefix():String {
		return "TextArea.";
	}
}
