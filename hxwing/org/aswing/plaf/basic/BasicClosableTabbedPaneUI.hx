package org.aswing.plaf.basic;

import org.aswing.event.FocusKeyEvent;
import flash.events.MouseEvent;
import flash.events.Event;
import org.aswing.plaf.basic.tabbedpane.ClosableTab;
import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.DisplayObjectContainer;
import org.aswing.plaf.basic.tabbedpane.BasicClosableTabbedPaneTab;
import org.aswing.event.TabCloseEvent;
import org.aswing.plaf.basic.tabbedpane.Tab;
import org.aswing.JClosableTabbedPane;
import org.aswing.Component;	

/**
 * Basic imp for JClosableTabbedPane UI.
 * @author iiley
 */
class BasicClosableTabbedPaneUI extends BasicTabbedPaneUI {
	
	
	
	public function new(){
		super();
	}	
	
    override function getPropertyPrefix():String {
        return "ClosableTabbedPane.";
    }
	
	function getClosableTab(i:Int):ClosableTab{
    	return cast(tabs[i], ClosableTab);
	}
	
    override function setTabProperties(header:Tab, i:Int):Void{
    	super.setTabProperties(header, i);
    	cast(header, ClosableTab).getCloseButton().setEnabled(
    		cast(tabbedPane, JClosableTabbedPane).isCloseEnabledAt(i)
    		&& tabbedPane.isEnabledAt(i));
    }
	
	override function installListeners():Void{
		super.installListeners();
		tabbedPane.addEventListener(MouseEvent.CLICK, __onTabPaneClicked);
	}
	
	override function uninstallListeners():Void{
		super.uninstallListeners();
		tabbedPane.removeEventListener(MouseEvent.CLICK, __onTabPaneClicked);
	}
	
	override function __onTabPanePressed(e:Event):Void{
		if((prevButton.hitTestMouse() || nextButton.hitTestMouse())
			&& (prevButton.isShowing() && nextButton.isShowing())){
			return;
		}
		var index:Int = getMousedOnTabIndex();
		if(index >= 0 && tabbedPane.isEnabledAt(index) && !isButtonEvent(e, index)){
			tabbedPane.setSelectedIndex(index);
		}
	}
	
    /**
     * Just override this method if you want other LAF headers.
     */
    override function createNewTab():Tab{    	
    	var tab:Tab = cast( getInstance(getPropertyPrefix() + "tab"), Tab);
    	if(tab == null){
    		tab = new BasicClosableTabbedPaneTab();
    	}
    	tab.initTab(tabbedPane);
    	tab.getTabComponent().setFocusable(false);
    	return tab;
    }
    
	function isButtonEvent(e:Event, index:Int):Bool{
		var eventTarget:DisplayObject = cast( e.target, DisplayObject);
		if(eventTarget != null){
			var button:Component = getClosableTab(index).getCloseButton();
			if(button == eventTarget || button.contains(eventTarget)){
				return true;
			}
		}
		return false;
	}
	
	function __onTabPaneClicked(e:Event):Void{
		var index:Int = getMousedOnTabIndex();
		if(index >= 0 && tabbedPane.isEnabledAt(index) && isButtonEvent(e, index)){
			tabbedPane.dispatchEvent(new TabCloseEvent(index));
		}
	}	
}
