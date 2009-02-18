/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf;

import Import_org_aswing;
import org.aswing.plaf.ComponentUI;

/**
 * Pluginable ui for JAdjuster.
 * @see org.aswing.JAdjuster
 * @author iiley
 */
interface AdjusterUI implements ComponentUI{
	
	function getInputText():JTextField;
	
	function getPopupSlider():JSlider;
}
