/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;


import flash.display.SimpleButton;

import org.aswing.plaf.basic.BasicButtonUI;

/**
 * An implementation of a "push" button.
 * @author iiley
 */
class JButton extends AbstractButton {
	
	public function new(?text:String="", ?icon:Icon=null){
		super(text, icon);
		setName("JButton");
    	setModel(new DefaultButtonModel());
	}
	
	/**
	 * Returns whether this button is the default button of its root pane or not.
	 * @return true if this button is the default button of its root pane, false otherwise.
	 */
	public function isDefaultButton():Bool{
		var rootPane:JRootPane = getRootPaneAncestor();
		if(rootPane != null){
			return rootPane.getDefaultButton() == this;
		}
		return false;
	}
	
	/**
	 * Wrap a SimpleButton to be this button's representation.
	 * @param btn the SimpleButton to be wrap.
	 * @return the button self
	 */
	public override function wrapSimpleButton(btn:SimpleButton):AbstractButton{
		mouseChildren = true;
		drawTransparentTrigger = false;
		setShiftOffset(0);
		setIcon(new SimpleButtonIcon(btn));
		setBorder(null);
		setMargin(new Insets());
		setBackgroundDecorator(null);
		setOpaque(false);
		setHorizontalTextPosition(AsWingConstants.CENTER);
		setVerticalTextPosition(AsWingConstants.CENTER);
		return this;
	}
	
    public override function updateUI():Void{
    	setUI(UIManager.getUI(this));
    }
	
    public override function getDefaultBasicUIClass():Class<Dynamic>{
    	return org.aswing.plaf.basic.BasicButtonUI;
    }
    
	public override function getUIClassID():String{
		return "ButtonUI";
	}
	
}

