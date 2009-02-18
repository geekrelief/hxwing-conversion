package org.aswing.plaf;

import Import_org_aswing;

/**
 * Pluggable look and feel interface for JSplitPane.
 * @author iiley
 */
class SplitPaneUI extends BaseComponentUI {
	
	public function new() {
		super();
	}

    /**
     * Messaged to relayout the JSplitPane based on the preferred size
     * of the children components.
     */
    public function resetToPreferredSizes(jc:JSplitPane):Void{
    	trace("Subclass need to override this method!");
    }	
	
}
