/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import Import_org_aswing_event;
import org.aswing.geom.IntPoint;

/**
 * Default list cell, render item value.toString() text.
 * @author iiley
 */
class DefaultListCell extends AbstractListCell {
	
	
	
	var jlabel:JLabel;
			
	static var sharedToolTip:JSharedToolTip;
	
	public function new(){
		super();
		if(sharedToolTip == null){
			sharedToolTip = new JSharedToolTip();
			sharedToolTip.setOffsetsRelatedToMouse(false);
			sharedToolTip.setOffsets(new IntPoint(0, 0));
		}
	}
	
	public override function setCellValue(value:Dynamic) : Void {
		super.setCellValue(value);
		getJLabel().setText(getStringValue(value));
		__resized(null);
	}
	
	/**
	 * Override this if you need other value->string translator
	 */
	function getStringValue(value:Dynamic):String{
		return value + "";
	}
	
	public override function getCellComponent() : Component {
		return getJLabel();
	}

	function getJLabel():JLabel{
		if(jlabel == null){
			jlabel = new JLabel();
			initJLabel(jlabel);
		}
		return jlabel;
	}
	
	function initJLabel(jlabel:JLabel):Void{
		jlabel.setHorizontalAlignment(JLabel.LEFT);
		jlabel.setOpaque(true);
		jlabel.setFocusable(false);
		jlabel.addEventListener(ResizedEvent.RESIZED, __resized);
	}
	
	function __resized(e:ResizedEvent):Void{
		if(getJLabel().getWidth() < getJLabel().getPreferredWidth()){
			getJLabel().setToolTipText(value.toString());
			JSharedToolTip.getSharedInstance().unregisterComponent(getJLabel());
			sharedToolTip.registerComponent(getJLabel());
		}else{
			getJLabel().setToolTipText(null);
			sharedToolTip.unregisterComponent(getJLabel());
		}
	}
}
