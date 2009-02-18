package org.aswing.tree;  
/*
 Copyright aswing.org, see the LICENCE.txt.
*/
import org.aswing.tree.FHTreeStateNode;

/**
 * @author iiley
 */
class EnumerationInfo  {
	
	/** Parent thats children are being enumerated. */
	public function new() { }
	
	
	/** Parent thats children are being enumerated. */
	public var parent:FHTreeStateNode;
	/** Index of next child. An index of -1 signifies parent should be
	 * visibled next. */
	public var nextIndex:Int;
	/** Number of children in parent. */
	public var childCount:Int;
	/** The number of path left to enumerat*/
	public var enumCount:Int;
}
