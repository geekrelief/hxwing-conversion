/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf;

/**
 * Pluginable ui for MenuItem.
 * @see org.aswing.JMenuItem
 * @author iiley
 */
interface MenuElementUI implements ComponentUI{
	
	/**
	 * Subclass override this to process key event.
	 */
	function processKeyEvent(code:UInt):Void;
}
