/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;  

import org.aswing.DefaultTextFieldCellEditor;

/**
 * @author iiley
 */
class DefaultNumberTextFieldCellEditor extends DefaultTextFieldCellEditor {
	
	
	
	public function new() {
		super();
	}
	
	/**
	 * Subclass override this method to implement specified input restrict
	 */
	override function getRestrict():String{
		return "-0123456789.E";
	}
	
	/**
	 * Subclass override this method to implement specified value transform
	 */
	override function transforValueFromText(text:String):Dynamic{
		return Std.parseFloat(text);
	}	
}
