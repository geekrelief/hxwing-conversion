/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

	import org.aswing.plaf.basic.BasicToggleButtonUI;
	

/**
 * An implementation of a two-state button.  
 * The <code>JRadioButton</code> and <code>JCheckBox</code> classes
 * are subclasses of this class.
 * @author iiley
 */
class JToggleButton extends AbstractButton {
	
	public function new(?text:String="", ?icon:Icon=null)
	{
		super(text, icon);
		setName("JToggleButton");
    	setModel(new ToggleButtonModel());
		//updateUI();
	}
	
    public override function updateUI():Void{
    	setUI(UIManager.getUI(this));
    }
	
    public override function getDefaultBasicUIClass():Class<Dynamic>{
    	return org.aswing.plaf.basic.BasicToggleButtonUI;
    }
	
	public override function getUIClassID():String{
		return "ToggleButtonUI";
	}
	
}

