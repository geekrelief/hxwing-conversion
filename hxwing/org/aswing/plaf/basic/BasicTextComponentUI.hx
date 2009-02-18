/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;
	
import org.aswing.plaf.BaseComponentUI;
import Import_org_aswing;
import Import_org_aswing_graphics;
import Import_org_aswing_geom;
import org.aswing.error.ImpMissError;

/**
 * The base class for text component UIs.
 * @author iiley
 * @private
 */
class BasicTextComponentUI extends BaseComponentUI {
	
	
	
	var textComponent:JTextComponent;
	
	public function new(){
		super();
	}

    function getPropertyPrefix():String {
    	throw new ImpMissError();
        return "";
    }
    
    public override function paint(c:Component, g:Graphics2D, r:IntRectangle):Void{
    	super.paint(c, g, r);
    }
    
	public override function installUI(c:Component):Void{
		textComponent = cast(c, JTextComponent);
		installDefaults();
		installComponents();
		installListeners();
	}
    
	public override function uninstallUI(c:Component):Void{
		textComponent = cast(c, JTextComponent);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
 	}
 	
 	function installDefaults():Void{
        var pp:String = getPropertyPrefix();
        LookAndFeel.installColorsAndFont(textComponent, pp);
        LookAndFeel.installBorderAndBFDecorators(textComponent, pp);
        LookAndFeel.installBasicProperties(textComponent, pp);
 	}
	
 	function uninstallDefaults():Void{
 		LookAndFeel.uninstallBorderAndBFDecorators(textComponent);
 	}
 	
 	function installComponents():Void{
 	}
	
 	function uninstallComponents():Void{
 	}
 	
 	function installListeners():Void{
 	}
	
 	function uninstallListeners():Void{
 	}
	
	public override function getMaximumSize(c:Component):IntDimension
	{
		return IntDimension.createBigDimension();
	}
	public override function getMinimumSize(c:Component):IntDimension
	{
		return c.getInsets().getOutsideSize();
	}    
}
