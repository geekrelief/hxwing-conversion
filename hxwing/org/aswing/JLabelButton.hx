/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import org.aswing.plaf.basic.BasicLabelButtonUI;

/**
 * A button that performances like a hyper link text.
 * @author iiley
 */
class JLabelButton extends AbstractButton {
	
	
	
	var rolloverColor:ASColor;
	var pressedColor:ASColor;
	
    /**
     * Creates a label button.
     * @param text the text.
     * @param icon the icon.
     * @param horizontalAlignment the horizontal alignment, default is <code>CENTER</code>
     */	
	public function new(?text:String="", ?icon:Icon=null, ?horizontalAlignment:Int=0){
		super(text, icon);
		setName("JLabelButton");
    	setModel(new DefaultButtonModel());
    	setHorizontalAlignment(horizontalAlignment);
	}
	
    public override function updateUI():Void{
    	setUI(UIManager.getUI(this));
    }
	
    public override function getDefaultBasicUIClass():Class<Dynamic>{
    	return org.aswing.plaf.basic.BasicLabelButtonUI;
    }
    
	public override function getUIClassID():String{
		return "LabelButtonUI";
	}
	
	/**
	 * Sets the color for text rollover state.
	 * @param c the color.
	 */
	public function setRollOverColor(c:ASColor):Void{
		if(c != rolloverColor){
			rolloverColor = c;
			repaint();
		}
	}
	
	/**
	 * Gets the color for text rollover state.
	 * @param c the color.
	 */	
	public function getRollOverColor():ASColor{
		return rolloverColor;
	}	
	
	/**
	 * Sets the color for text pressed/selected state.
	 * @param c the color.
	 */	
	public function setPressedColor(c:ASColor):Void{
		if(c != pressedColor){
			pressedColor = c;
			repaint();
		}
	}
	
	/**
	 * Gets the color for text pressed/selected state.
	 * @param c the color.
	 */		
	public function getPressedColor():ASColor{
		return pressedColor;
	}	
}
