package org.aswing.plaf.basic.tabbedpane;

import org.aswing.Component;

/**
 * The closable tab has a close button.
 * @author iiley
 */
interface ClosableTab implements Tab{
	
	function getCloseButton():Component;
	
}
