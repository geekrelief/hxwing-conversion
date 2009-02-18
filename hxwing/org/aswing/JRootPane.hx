/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import flash.display.InteractiveObject;
import Import_flash_events;
import flash.text.TextField;
import flash.ui.Keyboard;

import org.aswing.error.ImpMissError;
import org.aswing.util.HashMap;

/**
 * The general AsWing window root container, it is the popup, window and frame's ancestor.
 * It manages the key accelerator and mnemonic for a pane.
 * @see #registerMnemonic()
 * @author iiley
 */	
class JRootPane extends Container {
	
	
	
	var defaultButton:JButton;
	var mnemonics:HashMap;
	var mnemonicJustActed:Bool;
	var keyManager:KeyboardManager;
	
	var triggerProxy:InteractiveObject;
	
	//TODO imp
	//private var menuBar:*;
	
	public function new(){
		super();
		setName("JRootPane");
		mnemonicJustActed = false;
		layout = new BorderLayout();
		mnemonics = new HashMap();
		keyManager = new KeyboardManager();
		keyManager.init(this);
		triggerProxy = this;//just make below call works
		setMnemonicTriggerProxy(null);
		addEventListener(Event.REMOVED_FROM_STAGE, __removedFromStage);
	}
	
	public function setDefaultButton(button:JButton):Void{
		if(defaultButton != button){
			if(defaultButton != null){
				defaultButton.repaint();
			}
			defaultButton = button;
			defaultButton.repaint();
		}
	}
	
	public function getDefaultButton():JButton{
		return defaultButton;
	}
	
	/**
	 * Sets the main menuBar of this root pane.(Main menu bar means that 
	 * if user press Alt key, the first menu of the menu bar will be actived)
	 * The menuBar must be located in this root pane(or in its child), 
	 * otherwise, it will not have the main menu bar ability.
	 * @menuBar the menu bar, or null 
	 */
	public function setMenuBar(menuBar:Dynamic):Void{
		//TODO imp
		throw new ImpMissError();
	}
	
	/**
	 * Returns the key -> action map of this window.
	 * When a window is actived, it's keymap will be in working, or it is out of working.
	 * @see org.aswing.KeyMap
	 * @see org.aswing.KeyboardController
	 */
	public function getKeyMap():KeyMap{
		return keyManager.getKeyMap();
	}
	
	public override function getKeyboardManager():KeyboardManager{
		return keyManager;
	}
	
	/**
	 * Sets whether or not the kay map action will be fired.
	 * @param b true to make it work, false not.
	 */
	public function setKeyMapActived(b:Bool):Void{
		keyManager.setEnabled(b);
	}
	
	/**
	 * Sets the mnemonic be forced to work or not.
	 * <p>
	 * true, to make the mnemonic be forced to work, it means what ever the root pane and 
	 * it children has focused or not, it will listen the key to make mnemonic works.<br>
	 * false, to make the mnemonic works in normal way, it means the mnenonic will only works 
	 * when the root pane or its children has focus.
	 * </p>
	 * @param b forced work or not.
	 */
	public function setMnemonicTriggerProxy(trigger:InteractiveObject):Void{
		if(trigger != triggerProxy){
			if(triggerProxy != null){
				triggerProxy.removeEventListener(TextEvent.TEXT_INPUT, __textInput, true);
				triggerProxy.removeEventListener(KeyboardEvent.KEY_DOWN, __keyDown, true);
			}
			triggerProxy = trigger;
			if(trigger == null){
				trigger = this;
			}
			trigger.addEventListener(TextEvent.TEXT_INPUT, __textInput, true, 0, true);
			trigger.addEventListener(KeyboardEvent.KEY_DOWN, __keyDown, true, 0, true);
		}
	}
	
	/**
	 * Register a button with its mnemonic.
	 */
	public function registerMnemonic(button:AbstractButton):Void{
		if(button.getMnemonic() >= 0){
			mnemonics.put(button.getMnemonic(), button);
		}
	}
	
	public function unregisterMnemonic(button:AbstractButton):Void{
		if(mnemonics.get(button.getMnemonic()) == button){
			mnemonics.remove(button.getMnemonic());
		}
	}
	
	//-------------------------------------------------------
	//        Event Handlers
	//-------------------------------------------------------
	
	function __keyDown(e:KeyboardEvent):Void{
		mnemonicJustActed = false;
		
		var code:UInt = e.keyCode;
		
		if(code == Keyboard.ENTER){
			var dfBtn:AbstractButton = getDefaultButton();
			if(dfBtn != null){
				if(dfBtn.isShowing() && dfBtn.isEnabled()){
					dfBtn.doClick();
					mnemonicJustActed = true;
					return;
				}
			}
		}
		if(stage == null){
			return;
		}
		//try to trigger the mnemonic
		if(Std.is( stage.focus, TextField)){
			if(!keyManager.isMnemonicModifierDown()){
				return;
			}
		}
		var mnBtn:AbstractButton = mnemonics.getValue(code);
		if(mnBtn != null){
			if(mnBtn.isShowing() && mnBtn.isEnabled()){
				mnBtn.doClick();
				var fm:FocusManager = FocusManager.getManager(stage);
				if(fm != null){
					fm.setTraversing(true);
					mnBtn.paintFocusRect();
				}
				mnemonicJustActed = true;
			}
		}
	}
	
	function __textInput(e:TextEvent):Void{
		if(keyManager.isMnemonicModifierDown() || keyManager.isKeyJustActed()){
			e.preventDefault();
		}
	}
	
	function __removedFromStage(e:Event):Void{
		mnemonics.clear();
	}
}

