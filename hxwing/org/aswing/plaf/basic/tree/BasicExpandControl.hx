/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.tree;

import Import_org_aswing;
import org.aswing.plaf.UIResource;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import org.aswing.tree.TreePath;

/**
 * @private
 */
class BasicExpandControl implements ExpandControl, implements UIResource {
	
	public function new() { }
	
	
	public function paintExpandControl(c:Component, g:Graphics2D, bounds:IntRectangle, 
		totalChildIndent:Int, path:TreePath, row:Int, expanded:Bool, leaf:Bool):Void{
		if(leaf){
			return;
		}
		var w:Int = totalChildIndent;
		var cx:Int = Std.int(bounds.x - w/2);
		var cy:Int = Std.int(bounds.y + bounds.height/2);
		var r:Int = 4;
		var trig:Array<Dynamic>;
		if(!expanded){
			cx -= 2;
			trig = [new IntPoint(cx, cy-r), new IntPoint(cx, cy+r), new IntPoint(cx+r, cy)];
		}else{
			cy -= 2;
			trig = [new IntPoint(cx-r, cy), new IntPoint(cx+r, cy), new IntPoint(cx, cy+r)];
		}
		g.fillPolygon(new SolidBrush(ASColor.BLACK), trig);
	}
	
}
