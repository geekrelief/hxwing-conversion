/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import org.aswing.plaf.ComponentUI;
import org.aswing.plaf.basic.BasicAccordionUI;

/**
 * Accordion Container.
 * @author iiley
 */
class JAccordion extends AbstractTabbedPane {
	
    /**
     * Create an accordion.
     */
	
	
    /**
     * Create an accordion.
     */
	public function new() {
		super();
		setName("JAccordion");
		
		updateUI();
	}
	
	public override function updateUI():Void{
		setUI(UIManager.getUI(this));
	}
	
    public override function getDefaultBasicUIClass():Class<Dynamic>{
    	return org.aswing.plaf.basic.BasicAccordionUI;
    }
	
	public override function getUIClassID():String{
		return "AccordionUI";
	}
	
	/**
	 * Generally you should not set layout to JAccordion.
	 * @param layout layoutManager for JAccordion
	 * @throws ArgumentError when you set a non-AccordionUI layout to JAccordion.
	 */
	public override function setLayout(layout:LayoutManager):Void{
		if(Std.is( layout, ComponentUI)){
			super.setLayout(layout);
		}else{
			//throw ArgumentError("Cannot set non-AccordionUI layout to JAccordion!");
			throw ("Cannot set non-AccordionUI layout to JAccordion!");
		}
	}
}
