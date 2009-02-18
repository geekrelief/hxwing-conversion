/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import org.aswing.event.AWEvent;

class DefaultComboBoxEditor extends EventDispatcher, implements ComboBoxEditor {

    

    var textField:JTextField;
    var lostingFocus:Bool;
    var value:Dynamic;
    var valueText:String;
    	
	public function new(){
        super();
		lostingFocus = false;
	}
	
	public function selectAll():Void{
		if(getTextField().isEditable() && !lostingFocus){
			getTextField().selectAll();
		}
		//getTextField().makeFocus();
	}
	
	public function setValue(value:Dynamic):Void{
		this.value = value;
		if(value == null){
			getTextField().setText("");
		}else{
			getTextField().setText(value+"");
		}
		valueText = getTextField().getText();
	}
	
	public function addActionListener(listener:Dynamic, ?priority:Int=0, ?useWeakReference:Bool=false):Void{
		addEventListener(AWEvent.ACT, listener, false,  priority, useWeakReference);
	}
	
	public function getValue():Dynamic{
		return value;
	}
	
	public function removeActionListener(listener:Dynamic):Void{
		removeEventListener(AWEvent.ACT, listener, false);
	}
	
	public function setEditable(b:Bool):Void{
        getTextField().setEditable(b);
        getTextField().setEnabled(b);
	}
	
	public function getEditorComponent():Component{
		return getTextField();
	}
	
	public function isEditable():Bool{
		return getTextField().isEditable();
	}

    public override function toString():String{
        return "DefaultComboBoxEditor[]";
    }	
    
    //------------------------------------------------------
	
	function createTextField():JTextField{
		var tf:JTextField = new JTextField("", 1); //set rows 1 to ensure the JTextField has a perfer height when empty
		tf.setBorder(null);
        tf.setOpaque(false);
        tf.setFocusable(false);
        tf.setBackgroundDecorator(null);
        return tf;
	}
    
    function getTextField():JTextField{
        if(textField == null){
        	textField = createTextField();
            initHandler();
        }
        return textField;
    }

    function initHandler():Void{
        getTextField().getTextField().addEventListener(KeyboardEvent.KEY_DOWN, __textKeyDown);
        getTextField().getTextField().addEventListener(FocusEvent.FOCUS_OUT, __grapValueFormText);
    }
	
    function __grapValueFormText(e:Event):Void{
    	if(grapValueFormText()){
    		lostingFocus = true;
	        dispatchEvent(new AWEvent(AWEvent.ACT));
	        lostingFocus = false;
     	}
    }
    
    function grapValueFormText():Bool{
    	if(getTextField().isEditable() && valueText != getTextField().getText()){
    		value = getTextField().getText();
    		return true;
    	}
    	return false;
    }

    function __textKeyDown(e:KeyboardEvent):Void{
    	if(getTextField().isEditable() && e.keyCode == Keyboard.ENTER){
	        grapValueFormText();
	        dispatchEvent(new AWEvent(AWEvent.ACT));
     	}
    }   
}
