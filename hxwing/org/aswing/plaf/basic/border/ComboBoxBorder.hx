/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.border;

import org.aswing.Border;
import org.aswing.ASColor;
import org.aswing.border.BevelBorder;
import org.aswing.plaf.UIResource;
import org.aswing.Component;
import org.aswing.EditableComponent;
import org.aswing.graphics.Graphics2D;
import org.aswing.geom.IntRectangle;

/**
 * @private
 */
class ComboBoxBorder extends BevelBorder, implements UIResource {
	
	
	
	var colorInited:Bool;
	
	public function new(){
		super(null, BevelBorder.LOWERED);
		colorInited = false;
	}

	public override function updateBorderImp(c:Component, g:Graphics2D, b:IntRectangle):Void{
		if(!colorInited){
			setHighlightOuterColor(c.getUI().getColor("ComboBox.light"));
			setHighlightInnerColor(c.getUI().getColor("ComboBox.highlight"));
			setShadowOuterColor(c.getUI().getColor("ComboBox.darkShadow"));
			setShadowInnerColor(c.getUI().getColor("ComboBox.shadow"));
		}
        
    	var box:EditableComponent = cast( c, EditableComponent);
    	if(box != null){
	    	if(box.isEditable()){
	    		setBevelType(LOWERED);
	    	}else{
	    		setBevelType(RAISED);
	    	}
    	}
    	super.updateBorderImp(c, g, b);
    }	
	
}
