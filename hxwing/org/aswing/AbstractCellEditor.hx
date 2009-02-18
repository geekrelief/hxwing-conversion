/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;  

import org.aswing.CellEditor;
import org.aswing.Component;
import org.aswing.Container;
import Import_org_aswing_event;
import Import_org_aswing_geom;
import org.aswing.table.TableCellEditor;
import org.aswing.tree.TreeCellEditor;
import org.aswing.util.ArrayUtils;
import org.aswing.error.ImpMissError;
import flash.events.Event;
import flash.ui.Keyboard;

/**
 * @author iiley
 */
class AbstractCellEditor implements CellEditor, implements TableCellEditor, implements TreeCellEditor {
	
	
	
	var listeners:Array<Dynamic>;
	var clickCountToStart:Int;
	
	var popup:JPopup;
	
	public function new(){
		listeners = new Array();
		clickCountToStart = 0;
		popup = new JPopup();
		popup.setLayout(new EmptyLayout());
	}
	
    /**
     * Specifies the number of clicks needed to start editing.
     * Default is 0.(mean start after pressed)
     * @param count  an int specifying the number of clicks needed to start editing
     * @see #getClickCountToStart()
     */
    public function setClickCountToStart(count:Int):Void {
		clickCountToStart = count;
    }

    /**
     * Returns the number of clicks needed to start editing.
     * @return the number of clicks needed to start editing
     */
    public function getClickCountToStart():Float {
		return clickCountToStart;
    }	
    
    /**
     * Calls the editor's component to update UI.
     */
    public function updateUI():Void{
    	getEditorComponent().updateUI();
    }    
    
    public function getEditorComponent():Component{
		throw new ImpMissError();
		return null;
    }
	
	public function getCellEditorValue():Dynamic {		
		throw new ImpMissError();
	}
	
   /**
    * Sets the value of this cell. Subclass must override this method to 
    * make editor display this value.
    * @param value the new value of this cell
    */
	function setCellEditorValue(value:Dynamic):Void{		
		throw new ImpMissError();
	}

	public function isCellEditable(clickCount : Int) : Bool {
		return clickCount == clickCountToStart;
	}

	public function startCellEditing(owner : Container, value:Dynamic, bounds : IntRectangle) : Void {
		popup.changeOwner(AsWingUtils.getOwnerAncestor(owner));
		var gp:IntPoint = owner.getGlobalLocation().move(bounds.x, bounds.y);
		popup.setSizeWH(bounds.width, bounds.height);
		popup.show();
		popup.setGlobalLocation(gp);
		popup.validate();
		popup.toFront();
		
		var com:Component = getEditorComponent();
		com.removeEventListener(AWEvent.ACT, __editorComponentAct);
		com.removeEventListener(AWEvent.FOCUS_LOST, __editorComponentFocusLost);
		com.removeEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __editorComponentKeyDown);
		com.setSizeWH(bounds.width, bounds.height);
		popup.append(com);
		setCellEditorValue(value);
		com.requestFocus();
		//if com is a container and can't has focus, then focus its first sub child.
		if(Std.is( com, Container) && !com.isFocusOwner()){
			var con:Container = cast(com, Container);
			var sub:Component;
			sub = con.getFocusTraversalPolicy().getDefaultComponent(con);
			if(sub != null) sub.requestFocus();
			if(sub == null || !sub.isFocusOwner()){
				for(i in 0...con.getComponentCount()){
					sub = con.getComponent(i);
					sub.requestFocus();
					if(sub.isFocusOwner()){
						break;
					}
				}
			}
		}
		com.addEventListener(AWEvent.ACT, __editorComponentAct);
		com.addEventListener(AWEvent.FOCUS_LOST, __editorComponentFocusLost);
		com.addEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __editorComponentKeyDown);
		com.validate();
	}
	
	function __editorComponentFocusLost(e:Event):Void{
		trace("__editorComponentFocusLost");
		cancelCellEditing();
	}
	
	function __editorComponentAct(e:Event):Void{
		stopCellEditing();
	}
	
	function __editorComponentKeyDown(e:FocusKeyEvent):Void{
		if(e.keyCode == Keyboard.ESCAPE){
			cancelCellEditing();
		}
	}

	public function stopCellEditing() : Bool {
		removeEditorComponent();
		fireEditingStopped();
		return true;
	}

	public function cancelCellEditing() : Void {
		removeEditorComponent();
		fireEditingCanceled();
	}
	
	public function isCellEditing() : Bool {
		var editorCom:Component = getEditorComponent();
		return editorCom != null && editorCom.isShowing();
	}

	public function addCellEditorListener(l : CellEditorListener) : Void {
		listeners.push(l);
	}

	public function removeCellEditorListener(l : CellEditorListener) : Void {
		ArrayUtils.removeFromArray(listeners, l);
	}
	
	function fireEditingStopped():Void{
		var i:Int = listeners.length-1;
		while (i>=0){
			var l:CellEditorListener = cast(listeners[i], CellEditorListener);
			l.editingStopped(this);
			i--;
		}
	}
	function fireEditingCanceled():Void{
		var i:Int = listeners.length-1;
		while (i>=0){
			var l:CellEditorListener = cast(listeners[i], CellEditorListener);
			l.editingCanceled(this);
			i--;
		}
	}
	
	function removeEditorComponent():Void{
		getEditorComponent().removeFromContainer();
		popup.dispose();
	}
}