/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;

import Import_org_aswing;
import org.aswing.plaf.BaseComponentUI;
import org.aswing.geom.IntDimension;

/**
 * @private
 */
class BasicSpacerUI extends BaseComponentUI {
	
	public function new(){
		super();
	}
	
	function getPropertyPrefix():String {
		return "Spacer.";
	}
	
	public override function installUI(c:Component):Void{
		installDefaults(cast(c, JSpacer));
	}
	
	public override function uninstallUI(c:Component):Void{
		uninstallDefaults(cast(c, JSpacer));
	}
	
	function installDefaults(s:JSpacer):Void{
		var pp:String = getPropertyPrefix();
		LookAndFeel.installColors(s, pp);
		LookAndFeel.installBasicProperties(s, pp);
		LookAndFeel.installBorderAndBFDecorators(s, pp);
	}
	
	function uninstallDefaults(s:JSpacer):Void{
		LookAndFeel.uninstallBorderAndBFDecorators(s);
	}
	
	public override function getPreferredSize(c:Component):IntDimension{
		return c.getInsets().getOutsideSize(new IntDimension(0, 0));
	}
	
	public override function getMaximumSize(c:Component):IntDimension
	{
		return IntDimension.createBigDimension();
	}
	/**
	 * Returns null
	 */	
	public override function getMinimumSize(c:Component):IntDimension
	{
		return new IntDimension(0, 0);
	}
}
