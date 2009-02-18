/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing; 

import org.aswing.AbstractCellEditor;
import org.aswing.Component;
import org.aswing.FocusManager;
import org.aswing.JComboBox;
import org.aswing.event.AWEvent;

/**
 * The default editor for table and tree cells, use a combobox.
 * <p>
 * @author iiley
 */
class DefaultComboBoxCellEditor extends AbstractCellEditor {
	
	
	
	var comboBox:JComboBox;
	
	public function new(){
		super();
		setClickCountToStart(1);
	}
	
	public function getComboBox():JComboBox{
		if(comboBox == null){
			comboBox = new JComboBox();
		}
		return comboBox;
	}
	
 	public override function getEditorComponent():Component{
 		return getComboBox();
 	}
	
	public override function getCellEditorValue():Dynamic {
		return getComboBox().getSelectedItem();
	}
	
    /**
     * Sets the value of this cell. 
     * @param value the new value of this cell
     */
	override function setCellEditorValue(value:Dynamic):Void{
		getComboBox().setSelectedItem(value);
	}
	
	public function toString():String{
		return "DefaultComboBoxCellEditor[]";
	}
}
