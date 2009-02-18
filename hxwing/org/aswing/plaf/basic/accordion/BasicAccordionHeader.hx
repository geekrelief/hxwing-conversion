/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.accordion;

import Import_org_aswing;
import org.aswing.plaf.basic.tabbedpane.Tab;
	
/**
 * BasicAccordionHeader implemented with a JButton 
 * @author iiley
 * @private
 */
class BasicAccordionHeader implements Tab {
	
	
	
	var button:AbstractButton;
	var owner:Component;
	
	public function new(){
	}
	
	public function initTab(owner:Component):Void{
		this.owner = owner;
		button = createHeaderButton();
	}
	
	function createHeaderButton():AbstractButton{
		return new JButton();
	}
	
	public function setTextAndIcon(text : String, icon : Icon) : Void {
		button.setText(text);
		button.setIcon(icon);
	}
	
	public function setFont(font:ASFont):Void{
		button.setFont(font);
	}
	
	public function setForeground(color:ASColor):Void{
		button.setForeground(color);
	}
	
	public function setSelected(b:Bool):Void{
		//Do nothing here, if your header is selectable, you can set it here like
		//button.setSelected(b);
	}
	
    public function setVerticalAlignment(alignment:Int):Void {
    	button.setVerticalAlignment(alignment);
    }
    public function setHorizontalAlignment(alignment:Int):Void {
    	button.setHorizontalAlignment(alignment);
    }
    public function setVerticalTextPosition(textPosition:Int):Void {
    	button.setVerticalTextPosition(textPosition);
    }
    public function setHorizontalTextPosition(textPosition:Int):Void {
    	button.setHorizontalTextPosition(textPosition);
    }
    public function setIconTextGap(iconTextGap:Int):Void {
    	button.setIconTextGap(iconTextGap);
    }
    public function setMargin(m:Insets):Void{
    	button.setMargin(m);
    }

	public function getTabComponent() : Component {
		return button;
	}

}
