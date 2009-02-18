/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;
	
import org.aswing.plaf.BaseComponentUI;
import Import_org_aswing;
import org.aswing.event.ToolTipEvent;
import flash.filters.DropShadowFilter;

/**
 * @private
 */
class BasicToolTipUI extends BaseComponentUI {
	
	
	
	var tooltip:JToolTip;
	var label:JLabel;
	
	public function new() {
		super();
	}
	
    public override function installUI(c:Component):Void{
    	tooltip = cast(c, JToolTip);
        installDefaults();
        initallComponents();
        installListeners();
    }

    function getPropertyPrefix():String {
        return "ToolTip.";
    }

	function installDefaults():Void{
        var pp:String = getPropertyPrefix();
        LookAndFeel.installColorsAndFont(tooltip, pp);
        LookAndFeel.installBorderAndBFDecorators(tooltip, pp);
        LookAndFeel.installBasicProperties(tooltip, pp);
        var filters:Array<Dynamic> = cast( getInstance(getPropertyPrefix()+"filters"), Array<Dynamic>);
        tooltip.filters = filters;
	}
	
	function initallComponents():Void{
		var b:JToolTip = tooltip;
		b.setLayout(new BorderLayout());
		label = new JLabel(b.getTipText());
		label.setFont(null); //make it to use parent(JToolTip) font
		label.setForeground(null); //make it to user parent(JToolTip) foreground
		label.setUIElement(true);
		b.append(label, BorderLayout.CENTER);
	}
	
	function installListeners():Void{
		tooltip.addEventListener(ToolTipEvent.TIP_TEXT_CHANGED, __tipTextChanged);
	}
	
	function __tipTextChanged(e:ToolTipEvent):Void{
		label.setText(tooltip.getTipText());
	}
	
    public override function uninstallUI(c:Component):Void{
        uninstallDefaults();
        uninstallListeners();
        uninstallComponents();
    }
    
    function uninstallDefaults():Void{
    	LookAndFeel.uninstallBorderAndBFDecorators(tooltip);
        tooltip.filters = [];
    }
    
    function uninstallComponents():Void{
    	tooltip.remove(label);
    	label = null;
    }    
    
    function uninstallListeners():Void{
    	tooltip.removeEventListener(ToolTipEvent.TIP_TEXT_CHANGED, __tipTextChanged);
    }

	
}
