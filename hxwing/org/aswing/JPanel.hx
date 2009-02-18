/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import org.aswing.plaf.basic.BasicPanelUI;
	
/**
 * The general container - panel.
 * @author iiley
 */
class JPanel extends Container {
	
	
	
	public function new(?layout:LayoutManager=null){
		super();
		setName("JPanel");
		if(layout == null) layout = new FlowLayout();
		this.layout = layout;
		updateUI();
	}
	
	public override function updateUI():Void{
		setUI(UIManager.getUI(this));
	}
	
    public override function getDefaultBasicUIClass():Class<Dynamic>{
    	return org.aswing.plaf.basic.BasicPanelUI;
    }
	
	public override function getUIClassID():String{
		return "PanelUI";
	}
}
