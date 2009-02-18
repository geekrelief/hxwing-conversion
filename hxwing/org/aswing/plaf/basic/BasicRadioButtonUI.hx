/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;
	
import Import_org_aswing;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
	
/**
 * Basic RadioButton implementation.
 * @author iiley
 * @private
 */	
class BasicRadioButtonUI extends BasicToggleButtonUI {
	
	
	
	var defaultIcon:Icon;
	
	public function new(){
		super();
	}
	
	override function installDefaults(b:AbstractButton):Void{
		super.installDefaults(b);
		defaultIcon = getIcon(getPropertyPrefix() + "icon");
	}
	
	override function uninstallDefaults(b:AbstractButton):Void{
		super.uninstallDefaults(b);
		if(defaultIcon.getDisplay(b) != null){
    		if(button.contains(defaultIcon.getDisplay(b))){
    			button.removeChild(defaultIcon.getDisplay(b));
    		}
		}
	}
	
    override function getPropertyPrefix():String {
        return "RadioButton.";
    }
    	
    public function getDefaultIcon():Icon {
        return defaultIcon;
    }
    
    override function getIconToLayout():Icon{
    	if(button.getIcon() == null){
    		if(defaultIcon.getDisplay(button) != null){
	    		if(!button.contains(defaultIcon.getDisplay(button))){
	    			button.addChild(defaultIcon.getDisplay(button));
	    		}
    		}
    		return defaultIcon;
    	}else{
    		return button.getIcon();
    	}
    }
    
	override function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):Void{
		if(c.isOpaque()){
			g.fillRectangle(new SolidBrush(c.getBackground()), b.x, b.y, b.width, b.height);
		}
	}
}
