/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

/**
 * Cell Pane is just a container, it do not layout children, 
 * do not invalidate parent.
 * @author iiley
 */
class CellPane extends Container {
	
	
	
	public function new(){
		super();
	}
	
	public override function revalidate():Void{
		valid = true;
	}
	
	public override function invalidate():Void{
		valid = true;
	}
	
	override function invalidateTree():Void{
		valid = true;
	}
	
	public override function validate():Void {
		valid = true;
	}
}
