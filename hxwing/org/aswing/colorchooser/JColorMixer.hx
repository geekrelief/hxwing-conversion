/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.colorchooser;  
import org.aswing.colorchooser.AbstractColorChooserPanel;
import org.aswing.UIManager;
import org.aswing.plaf.basic.BasicColorMixerUI;

/**
 * @author iiley
 */
class JColorMixer extends AbstractColorChooserPanel {
	
	
	
	public function new() {
		super();
		updateUI();
	}
	
	public override function updateUI():Void{
		setUI(UIManager.getUI(this));
	}
	
	public override function getUIClassID():String{
		return "ColorMixerUI";
	}
	
    public override function getDefaultBasicUIClass():Class<Dynamic>{
    	return org.aswing.plaf.basic.BasicColorMixerUI;
    }

}
