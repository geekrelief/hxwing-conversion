/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;
	
/**
 * Basic CheckBox implementation.
 * @author iiley
 * @private
 */		
class BasicCheckBoxUI extends BasicRadioButtonUI {
	
	
	
	public function new(){
		super();
	}
	
    override function getPropertyPrefix():String {
        return "CheckBox.";
    }
}
