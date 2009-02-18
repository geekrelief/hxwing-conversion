/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.tabbedpane;

import Import_org_aswing;
import org.aswing.border.EmptyBorder;

/**
 * BasicTabbedPaneTab implemented with a JLabel 
 * @author iiley
 * @private
 */
class BasicTabbedPaneTab implements Tab {
	
	
	
	var label:JLabel;
	var margin:Insets;
	var owner:Component;
	
	public function new(){
	}
	
	public function initTab(owner:Component):Void{
		this.owner = owner;
		label = new JLabel();
		margin = new Insets(0,0,0,0);
	}
	
	public function setFont(font:ASFont):Void{
		label.setFont(font);
	}
	
	public function setForeground(color:ASColor):Void{
		label.setForeground(color);
	}
	
	public function setMargin(m:Insets):Void
	{
		if(!margin.equals(m)){
			label.setBorder(new EmptyBorder(null, m));
			margin = m.clone();
		}
	}
	
	public function setVerticalAlignment(alignment:Int):Void
	{
		label.setVerticalAlignment(alignment);
	}
	
	public function getTabComponent():Component
	{
		return label;
	}
	
	public function setHorizontalTextPosition(textPosition:Int):Void
	{
		label.setHorizontalTextPosition(textPosition);
	}
	
	public function setTextAndIcon(text:String, icon:Icon):Void
	{
		label.setText(text);
		label.setIcon(icon);
	}
	
	public function setIconTextGap(iconTextGap:Int):Void
	{
		label.setIconTextGap(iconTextGap);
	}
	
	public function setSelected(b:Bool):Void
	{
		//do nothing
	}
	
	public function setVerticalTextPosition(textPosition:Int):Void
	{
		label.setVerticalTextPosition(textPosition);
	}
	
	public function setHorizontalAlignment(alignment:Int):Void
	{
		label.setHorizontalAlignment(alignment);
	}
	
}
