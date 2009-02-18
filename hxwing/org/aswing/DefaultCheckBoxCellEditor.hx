/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;  

import org.aswing.AbstractCellEditor;
import org.aswing.Component;
import org.aswing.JCheckBox;

/**
 * @author iiley
 */
class DefaultCheckBoxCellEditor extends AbstractCellEditor {
	
	
	
	var checkBox:JCheckBox;
	
	public function new(){
		super();
		setClickCountToStart(1);
	}
	
	public function getCheckBox():JCheckBox{
		if(checkBox == null){
			checkBox = new JCheckBox();
		}
		return checkBox;
	}
	
 	public override function getEditorComponent():Component{
 		return getCheckBox();
 	}
	
	public override function getCellEditorValue():Dynamic {		
		return getCheckBox().isSelected();
	}
	
    /**
     * Sets the value of this cell. 
     * @param value the new value of this cell
     */
	override function setCellEditorValue(value:Dynamic):Void{
		var selected:Bool = false;
		if(value == true){
			selected = true;
		}
		if(Std.is( value, String)){
			var va:String = cast( value, String);
			if(va.toLowerCase() == "true"){
				selected = true;
			}
		}
		getCheckBox().setSelected(selected);
	}
	
	public function toString():String{
		return "DefaultCheckBoxCellEditor[]";
	}
}
