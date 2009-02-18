package org.aswing.plaf.basic;

import Import_org_aswing;
import Import_flash_display;
import Import_org_aswing_geom;
import Import_org_aswing_plaf;

/**
 * @private
 * @author iiley
 */
class BasicPopupMenuUI extends BaseComponentUI, implements MenuElementUI {

	

	var popupMenu:JPopupMenu;
	
	public function new() {
		super();
	}
	
	public override function installUI(c:Component):Void {
		popupMenu = cast(c, JPopupMenu);
		installDefaults();
		installListeners();
	}

	public override function uninstallUI(c:Component):Void {
		popupMenu = cast(c, JPopupMenu);
		uninstallDefaults();
		uninstallListeners();
	}
	
	function getPropertyPrefix():String {
		return "PopupMenu.";
	}

	function installDefaults():Void {
		var pp:String = getPropertyPrefix();
        LookAndFeel.installColorsAndFont(popupMenu, pp);
        LookAndFeel.installBorderAndBFDecorators(popupMenu, pp);
        LookAndFeel.installBasicProperties(popupMenu, pp);
		var layout:LayoutManager = popupMenu.getLayout();
		if(layout == null || Std.is( layout, UIResource)){
			popupMenu.setLayout(new DefaultMenuLayout(DefaultMenuLayout.Y_AXIS));
		}
	}
	
	function installListeners():Void{
	}

	function uninstallDefaults():Void {
		LookAndFeel.uninstallBorderAndBFDecorators(popupMenu);
	}
	
	function uninstallListeners():Void{
	}
	
	//-----------------
	
	/**
	 * Subclass override this to process key event.
	 */
	public function processKeyEvent(code : UInt) : Void {
		var manager:MenuSelectionManager = MenuSelectionManager.defaultManager();
		var path:Array<Dynamic> = manager.getSelectedPath();
		if(path[path.length-1] != popupMenu){
			return;
		}
		var root:MenuElement;
		var prev:MenuElement;
		var subs:Array<Dynamic>;
		if(manager.isPrevPageKey(code)){
			if(path.length > 2){
				path.pop();
			}
			if(path.length == 2 && !(Std.is( path[0], JPopupMenu))){ //generally means jmenubar here
				root = cast(path[0], MenuElement);
				prev = manager.prevSubElement(root, cast(path[1], MenuElement));
				path.pop();
				path.push(prev);
				if(prev.getSubElements().length > 0){
					var prevPop:MenuElement = cast(prev.getSubElements()[0], MenuElement);
					path.push(prevPop);
					if(prevPop.getSubElements().length > 0){
						path.push(prevPop.getSubElements()[0]);
					}
				}
			}else{
				subs = popupMenu.getSubElements();
				if(subs.length > 0){
					path.push(subs[subs.length-1]);
				}
			}
			manager.setSelectedPath(popupMenu.stage, path, false);
		}else if(manager.isNextPageKey(code)){
			root = cast(path[0], MenuElement);
			if(root.getSubElements().length > 1 && !(Std.is( root, JPopupMenu))){
				var next:MenuElement = manager.nextSubElement(root, cast(path[1], MenuElement));
				path = [root];
				path.push(next);
				if(next.getSubElements().length > 0){
					var nextPop:MenuElement = cast(next.getSubElements()[0], MenuElement);
					path.push(nextPop);
					if(nextPop.getSubElements().length > 0){
						path.push(nextPop.getSubElements()[0]);
					}
				}
			}else{
				subs = popupMenu.getSubElements();
				if(subs.length > 0){
					path.push(subs[0]);
				}
			}
			manager.setSelectedPath(popupMenu.stage, path, false);
		}else if(manager.isNextItemKey(code)){
			subs = popupMenu.getSubElements();
			if(subs.length > 0){
				if(manager.isPrevItemKey(code)){
					path.push(subs[subs.length-1]);
				}else{
					path.push(subs[0]);
				}
			}
			manager.setSelectedPath(popupMenu.stage, path, false);
		}
	}	   
	
	//-----------------
		
	public static function getFirstPopup():MenuElement {
		var msm:MenuSelectionManager = MenuSelectionManager.defaultManager();
		var p:Array<Dynamic> = msm.getSelectedPath();
		var me:MenuElement = null;		
	
        var i:Int = 0;
        while(i < p.length){
			if (Std.is( p[i], JPopupMenu)){
				me = p[i];
                break;
			}
            ++i;
		}
	
		return me;
	}
	
	public static function getLastPopup():MenuElement {
		var msm:MenuSelectionManager = MenuSelectionManager.defaultManager();
		var p:Array<Dynamic> = msm.getSelectedPath();
		var me:MenuElement = null;		
	
		var i:Int = p.length-1 ;
		while (me == null && i >= 0 ) {
			if (Std.is( p[i], JPopupMenu)){
				me = p[i];
			}
			i--;
		}
	
		return me;
	}
	
}
