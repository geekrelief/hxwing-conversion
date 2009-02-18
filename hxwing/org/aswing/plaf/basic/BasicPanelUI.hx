/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;


import Import_org_aswing;
import org.aswing.plaf.BaseComponentUI;

/**
 * @private
 * @author iiley
 */
class BasicPanelUI extends BaseComponentUI {
	
	public function new()
	{
		super();
	}
	
	public override function installUI(c:Component):Void {
		var p:JPanel = cast(c, JPanel);
		installDefaults(p);
	}

	public override function uninstallUI(c:Component):Void {
		var p:JPanel = cast(c, JPanel);
		uninstallDefaults(p);
	}

	function installDefaults(p:JPanel):Void {
		var pp:String = "Panel.";
		LookAndFeel.installColorsAndFont(p, pp);
		LookAndFeel.installBorderAndBFDecorators(p, pp);
		LookAndFeel.installBasicProperties(p, pp);
	}

	function uninstallDefaults(p:JPanel):Void {
		LookAndFeel.uninstallBorderAndBFDecorators(p);
	}
}
