/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import flash.events.MouseEvent;

/**
 * The list cell for combobox drop down list.
 * @author iiley
 */
class DefaultComboBoxListCell extends DefaultListCell {

	

	var rolloverBackground:ASColor;
	var rolloverForeground:ASColor;
	var realBackground:ASColor;
	var realForeground:ASColor;
		
	public function new(){
		super();
	}
	
	override function initJLabel(jlabel:JLabel):Void{
		super.initJLabel(jlabel);
		jlabel.addEventListener(MouseEvent.ROLL_OVER, __labelRollover, false, 0, true);
		jlabel.addEventListener(MouseEvent.ROLL_OUT, __labelRollout, false, 0, true);
	}
	
	public override function setListCellStatus(list:JList, isSelected:Bool, index:Int):Void{
		var com:Component = getCellComponent();
		if(isSelected){
			com.setBackground((realBackground = list.getSelectionBackground()));
			com.setForeground((realForeground = list.getSelectionForeground()));
		}else{
			com.setBackground((realBackground = list.getBackground()));
			com.setForeground((realForeground = list.getForeground()));
		}
		com.setFont(list.getFont());
		rolloverBackground = list.getSelectionBackground().changeAlpha(0.8);
		rolloverForeground = list.getSelectionForeground();
	}
	
	function __labelRollover(e:MouseEvent):Void{
		if(rolloverBackground != null){
			getJLabel().setBackground(rolloverBackground);
			getJLabel().setForeground(rolloverForeground);
		}
	}
	
	function __labelRollout(e:MouseEvent):Void{
		if(realBackground != null){
			getJLabel().setBackground(realBackground);
			getJLabel().setForeground(realForeground);
		}
	}	
}
