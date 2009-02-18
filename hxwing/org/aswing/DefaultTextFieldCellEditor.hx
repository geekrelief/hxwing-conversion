/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;  

import org.aswing.AbstractCellEditor;
import org.aswing.Component;
import org.aswing.JTextField;

/**
 * The default editor for table and tree cells, use a textfield.
 * <p>
 * @author iiley
 */
class DefaultTextFieldCellEditor extends AbstractCellEditor {
	
	
	
	var textField:JTextField;
	
	public function new(){
		super();
		setClickCountToStart(2);
	}
	
	public function getTextField():JTextField{
		if(textField == null){
			textField = new JTextField();
			//textField.setBorder(null);
			textField.setRestrict(getRestrict());
		}
		return textField;
	}
	
	/**
	 * Subclass override this method to implement specified input restrict
	 */
	function getRestrict():String{
		return null;
	}
	
	/**
	 * Subclass override this method to implement specified value transform
	 */
	function transforValueFromText(text:String):Dynamic{
		return text;
	}
	
 	public override function getEditorComponent():Component{
 		return getTextField();
 	}
	
	public override function getCellEditorValue():Dynamic {		
		return transforValueFromText(getTextField().getText());
	}
	
   /**
    * Sets the value of this cell. 
    * @param value the new value of this cell
    */
	override function setCellEditorValue(value:Dynamic):Void{
		getTextField().setText(value+"");
		getTextField().selectAll();
	}
	
	public function toString():String{
		return "DefaultTextFieldCellEditor[]";
	}
}
