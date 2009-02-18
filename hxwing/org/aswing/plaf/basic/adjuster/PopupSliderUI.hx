/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.adjuster;

import org.aswing.plaf.basic.BasicSliderUI;
import Import_org_aswing;
import org.aswing.geom.IntRectangle;

/**
 * SliderUI for JAdjuster popup slider.
 * @author iiley
 * @private
 */
class PopupSliderUI extends BasicSliderUI {
	
	
	
	public function new()
	{
		super();
	}
	
	override function getPropertyPrefix():String {
		return "Adjuster.";
	}
	
	override function installDefaults():Void{	
		super.installDefaults();
		slider.setOpaque(true);
	}
	
	override function getPrefferedLength():Int{
		return 100;
	}
}
