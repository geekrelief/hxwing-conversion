/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.event;  
	
/**
 * Exception used to stop and expand/collapse from happening.
 * @author iiley
 */
class ExpandVetoException extends Error {
	
	
	
	public function new(message : String) {
		super(message);
	}

}
