/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;
	
import Import_org_aswing;
import org.aswing.graphics.Graphics2D;
import org.aswing.geom.IntRectangle;
import org.aswing.geom.IntDimension;
import Import_org_aswing_plaf;	
	
/**
 * Basic ToggleButton implementation.
 * @author iiley
 * @private
 */	
class BasicToggleButtonUI extends BasicButtonUI {
	
	
	
	public function new(){
		super();
	}
	
    override function getPropertyPrefix():String {
        return "ToggleButton.";
    }
        
    /**
     * Overriden so that the text will not be rendered as shifted for
     * Toggle buttons and subclasses.
     */
    override function getTextShiftOffset():Int{
    	return 0;
    }
    
    override function paintIcon(b:AbstractButton, g:Graphics2D, iconRect:IntRectangle):Void {
		var model:ButtonModel = b.getModel();
		var icon:Icon = null;
        
        var icons:Array<Dynamic> = getIcons();
        for(i in 0...icons.length){
        	var ico:Icon = icons[i];
			setIconVisible(ico, false);
        }
        
        if(!model.isEnabled()) {
			if(model.isSelected()) {
				icon = b.getDisabledSelectedIcon();
			} else {
				icon = b.getDisabledIcon();
			}
		} else if(model.isPressed() && model.isArmed()) {
			icon = b.getPressedIcon();
			if(icon == null) {
				// Use selected icon
				icon = b.getSelectedIcon();
			} 
		} else if(model.isSelected()) {
			if(b.isRollOverEnabled() && model.isRollOver()) {
				icon = b.getRollOverSelectedIcon();
				if (icon == null) {
					icon = b.getSelectedIcon();
				}
			} else {
				icon = b.getSelectedIcon();
			}
		} else if(b.isRollOverEnabled() && model.isRollOver()) {
			icon = b.getRollOverIcon();
		} 
        
		if(icon == null) {
			icon = b.getIcon();
		}
		if(icon == null){
			icon = getIconToLayout();
		}
        if(icon != null){
			setIconVisible(icon, true);
			icon.updateIcon(b, g, iconRect.x, iconRect.y);
        }
    }
}

