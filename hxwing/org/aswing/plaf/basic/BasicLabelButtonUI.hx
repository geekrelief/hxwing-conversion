package org.aswing.plaf.basic;

import Import_org_aswing;
import org.aswing.plaf.UIResource;
import Import_org_aswing_graphics;
import Import_org_aswing_geom;

/**
 * @private
 */
class BasicLabelButtonUI extends BasicButtonUI {
	
	
	
	public function new(){
		super();
	}
	
    override function getPropertyPrefix():String {
        return "LabelButton.";
    }
	
	override function installDefaults(bb:AbstractButton):Void{
		super.installDefaults(bb);
		var pp:String = getPropertyPrefix();
    	var b:JLabelButton = cast( bb, JLabelButton);
    	if(b.getRollOverColor() == null || Std.is( b.getRollOverColor(), UIResource)){
    		b.setRollOverColor(getColor(pp+"rollOver"));
    	}
    	if(b.getPressedColor() == null || Std.is( b.getPressedColor(), UIResource)){
    		b.setPressedColor(getColor(pp+"pressed"));
    	}
    	b.buttonMode = true;
	}
	
    override function getTextPaintColor(bb:AbstractButton):ASColor{
    	var b:JLabelButton = cast( bb, JLabelButton);
    	if(b.isEnabled()){
    		var model:ButtonModel = b.getModel();
    		if(model.isSelected() || (model.isPressed() && model.isArmed())){
    			return b.getPressedColor();
    		}else if(b.isRollOverEnabled() && model.isRollOver()){
    			return b.getRollOverColor();
    		}
    		return b.getForeground();
    	}else{
    		return BasicGraphicsUtils.getDisabledColor(b);
    	}
    }
    
    /**
     * paint normal bg
     */
	override function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):Void{
		if(c.isOpaque()){
			g.fillRectangle(new SolidBrush(c.getBackground()), b.x, b.y, b.width, b.height);
		}		
	}
}
