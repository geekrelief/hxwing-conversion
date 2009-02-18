/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.colorchooser; 

import Import_org_aswing;
import org.aswing.plaf.ColorSwatchesUI;
import org.aswing.plaf.basic.BasicColorSwatchesUI;

/**
 * @author iiley
 */
class JColorSwatches extends AbstractColorChooserPanel {
		
	
		
	public function new() {
		super();
		updateUI();
	}
	
	public override function updateUI():Void{
		setUI(UIManager.getUI(this));
	}
	
    public override function getDefaultBasicUIClass():Class<Dynamic>{
    	return org.aswing.plaf.basic.BasicColorSwatchesUI;
    }
	
	public override function getUIClassID():String{
		return "ColorSwatchesUI";
	}
	
	/**
	 * Adds a component to this panel's sections bar
	 * @param com the component to be added
	 */
	public function addComponentColorSectionBar(com:Component):Void{
		cast(getUI(), ColorSwatchesUI).addComponentColorSectionBar(com);
	}
}
