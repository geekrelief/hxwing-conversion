/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;

	
import org.aswing.plaf.BaseComponentUI;
import Import_org_aswing;
import Import_org_aswing_event;
import Import_org_aswing_geom;

/**
 * The basic scroll pane ui imp.
 * @author iiley
 * @private
 */
class BasicScrollPaneUI extends BaseComponentUI {

	

	var scrollPane:JScrollPane;
	var lastViewport:Viewportable;
	
	public function new(){
        super();
	}
    	
    public override function installUI(c:Component):Void{
		scrollPane = cast(c, JScrollPane);
		installDefaults();
		installComponents();
		installListeners();
    }
    
	public override function uninstallUI(c:Component):Void{
		scrollPane = cast(c, JScrollPane);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
    }
    
    function getPropertyPrefix():String {
        return "ScrollPane.";
    }
    
	function installDefaults():Void{
		var pp:String = getPropertyPrefix();
        LookAndFeel.installColorsAndFont(scrollPane, pp);
        LookAndFeel.installBorderAndBFDecorators(scrollPane, pp);
        LookAndFeel.installBasicProperties(scrollPane, pp);
        if(!scrollPane.getVerticalScrollBar().isFocusableSet()){
        	scrollPane.getVerticalScrollBar().setFocusable(false);
        	scrollPane.getVerticalScrollBar().setFocusableSet(false);
        }
        if(!scrollPane.getHorizontalScrollBar().isFocusableSet()){
        	scrollPane.getHorizontalScrollBar().setFocusable(false);
        	scrollPane.getHorizontalScrollBar().setFocusableSet(false);
        }
	}
    
    function uninstallDefaults():Void{
    	LookAndFeel.uninstallBorderAndBFDecorators(scrollPane);
    }
    
	function installComponents():Void{
    }
	function uninstallComponents():Void{
    }
	
	function installListeners():Void{
		scrollPane.addAdjustmentListener(__adjustChanged);
		scrollPane.addEventListener(ScrollPaneEvent.VIEWPORT_CHANGED, __viewportChanged);
		__viewportChanged(null);
	}
    
    function uninstallListeners():Void{
		scrollPane.removeAdjustmentListener(__adjustChanged);
		scrollPane.removeEventListener(ScrollPaneEvent.VIEWPORT_CHANGED, __viewportChanged);
		if(lastViewport != null){
			lastViewport.removeStateListener(__viewportStateChanged);
		}
    }
    
	//-------------------------listeners--------------------------
    function syncScrollPaneWithViewport():Void{
		var viewport:Viewportable = scrollPane.getViewport();
		var vsb:JScrollBar = scrollPane.getVerticalScrollBar();
		var hsb:JScrollBar = scrollPane.getHorizontalScrollBar();
		if (viewport != null) {
		    var extentSize:IntDimension = viewport.getExtentSize();
		    if(extentSize.width <=0 || extentSize.height <= 0){
		    	//trace("/w/zero extent size");
		    	return;
		    }
		    var viewSize:IntDimension = viewport.getViewSize();
		    var viewPosition:IntPoint = viewport.getViewPosition();
			var extent:Int, max:Int, value:Int;
		    if (vsb != null) {
				extent = extentSize.height;
				max = viewSize.height;
				value = Std.int(Math.max(0, Math.min(viewPosition.y, max - extent)));
				vsb.setValues(value, extent, 0, max);
				vsb.setUnitIncrement(viewport.getVerticalUnitIncrement());
				vsb.setBlockIncrement(viewport.getVerticalBlockIncrement());
	    	}

		    if (hsb != null) {
				extent = extentSize.width;
				max = viewSize.width;
				value = Std.int(Math.max(0, Math.min(viewPosition.x, max - extent)));
				hsb.setValues(value, extent, 0, max);
				hsb.setUnitIncrement(viewport.getHorizontalUnitIncrement());
				hsb.setBlockIncrement(viewport.getHorizontalBlockIncrement());
	    	}
		}
    }	
	
	function __viewportChanged(e:ScrollPaneEvent):Void{
		if(lastViewport != null){
			lastViewport.removeStateListener(__viewportStateChanged);
		}
		lastViewport = scrollPane.getViewport();
		lastViewport.addStateListener(__viewportStateChanged);
	}
	
	function __viewportStateChanged(e:InteractiveEvent):Void{
		syncScrollPaneWithViewport();
	}
	
    function __adjustChanged(e:ScrollPaneEvent):Void{
    	var viewport:Viewportable = scrollPane.getViewport();
    	viewport.scrollRectToVisible(scrollPane.getVisibleRect(), e.isProgrammatic());
    }
	
}
