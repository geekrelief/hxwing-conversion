/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;

import Import_org_aswing_plaf;
import Import_org_aswing;
import Import_org_aswing_event;
import flash.utils.Timer;
import Import_flash_events;

/**
 * @private
 * @author iiley
 */
class BasicMenuUI extends BasicMenuItemUI {
	
	
	
	var postTimer:Timer;
	
	public function new(){
		super();
	}

	override function getPropertyPrefix():String {
		return "Menu.";
	}

	override function installDefaults():Void {
		super.installDefaults();
		updateDefaultBackgroundColor();
	}	
	
	override function uninstallDefaults():Void {
		menuItem.getModel().setRollOver(false);
		menuItem.setSelected(false);
		super.uninstallDefaults();
	}

	override function installListeners():Void{
		super.installListeners();
		menuItem.addSelectionListener(__menuSelectionChanged);
	}
	
	override function uninstallListeners():Void{
		super.uninstallListeners();
		menuItem.removeSelectionListener(__menuSelectionChanged);
	}		
	
	function getMenu():JMenu{
		return cast(menuItem, JMenu);
	}
	
	/*
	 * Set the background color depending on whether this is a toplevel menu
	 * in a menubar or a submenu of another menu.
	 */
	function updateDefaultBackgroundColor():Void{
		if (!getBoolean("Menu.useMenuBarBackgroundForTopLevel")) {
			return;
		}
		var menu:JMenu = getMenu();
		if (Std.is( menu.getBackground(), UIResource)) {
			if (menu.isTopLevelMenu()) {
				menu.setBackground(getColor("MenuBar.background"));
			} else {
				menu.setBackground(getColor(getPropertyPrefix() + ".background"));
			}
		}
	}
	
	/**
	 * SubUI override this to do different
	 */
	override function isMenu():Bool{
		return true;
	}
	
	/**
	 * SubUI override this to do different
	 */
	override function isTopMenu():Bool{
		return getMenu().isTopLevelMenu();
	}
	
	/**
	 * SubUI override this to do different
	 */
	override function shouldPaintSelected():Bool{
		return menuItem.getModel().isRollOver() || menuItem.isSelected();
	}
	
	//---------------------
	
	public override function processKeyEvent(code : UInt) : Void {
		var manager:MenuSelectionManager = MenuSelectionManager.defaultManager();
		if(manager.isNextPageKey(code)){
			var path:Array<Dynamic> = manager.getSelectedPath();
			if(path[path.length-1] == menuItem){
				var popElement:MenuElement = getMenu().getPopupMenu();
				path.push(popElement);
				if(popElement.getSubElements().length > 0){
					path.push(popElement.getSubElements()[0]);
				}
				manager.setSelectedPath(menuItem.stage, path, false);
			}
		}else{
			super.processKeyEvent(code);
		}
	}	
	
	function __menuSelectionChanged(e:InteractiveEvent):Void{
		menuItem.repaint();
	}
	
	override function __menuItemRollOver(e:MouseEvent):Void{
		var menu:JMenu = getMenu();
		var manager:MenuSelectionManager = MenuSelectionManager.defaultManager();
		var selectedPath:Array<Dynamic> = manager.getSelectedPath();		
		if (!menu.isTopLevelMenu()) {
			if(!(selectedPath.length>0 && selectedPath[selectedPath.length-1]==menu.getPopupMenu())){
				if(menu.getDelay() <= 0) {
					appendPath(getPath(), menu.getPopupMenu());
				} else {
					manager.setSelectedPath(menuItem.stage, getPath(), false);
					setupPostTimer(menu);
				}
			}
		} else {
			if(selectedPath.length > 0 && selectedPath[0] == menu.getParent()) {
				// A top level menu's parent is by definition a JMenuBar
				manager.setSelectedPath(menuItem.stage, [menu.getParent(), menu, menu.getPopupMenu()], false);
			}
		}
		menuItem.repaint();
	}
	
	override function __menuItemAct(e:AWEvent):Void{
		var menu:JMenu = getMenu();
		var cnt:Container = menu.getParent();
		if(cnt != null && Std.is( cnt, JMenuBar)) {
			var me:Array<Dynamic> = [cnt, menu, menu.getPopupMenu()];
			MenuSelectionManager.defaultManager().setSelectedPath(menuItem.stage, me, false);
		}
		menuItem.repaint();
	}
	
	function __postTimerAct(e:Event):Void{
		var menu:JMenu = getMenu();
		var path:Array<Dynamic> = MenuSelectionManager.defaultManager().getSelectedPath();
		if(path.length > 0 && path[path.length-1] == menu) {
			appendPath(path, menu.getPopupMenu());
		}
	}
	
	//---------------------
	function appendPath(path:Array<Dynamic>, end:Dynamic):Void{
		path.push(end);
		MenuSelectionManager.defaultManager().setSelectedPath(menuItem.stage, path, false);
	}

	function setupPostTimer(menu:JMenu):Void {
		if(postTimer == null){
			postTimer = new Timer(menu.getDelay(), 1);
			postTimer.addEventListener(TimerEvent.TIMER, __postTimerAct);
		}
		postTimer.reset();
		postTimer.start();
	}	
}
