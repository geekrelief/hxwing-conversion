/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.background;

	
import Import_flash_display;

import Import_org_aswing;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;

/**
 * The barIcon decorator for ProgressBar.
 * @author senkay
 * @private
 */
class ProgressBarIcon implements org.aswing.GroundDecorator, implements org.aswing.plaf.UIResource {
	
	var indeterminatePercent:Float;
	var color:ASColor;
	
	public function new(){
		indeterminatePercent = 0;
	}
	
	function reloadColors(ui:ComponentUI):Void{
		color = ui.getColor("ProgressBar.progressColor");
	}
	
	public function updateDecorator(com:Component, g:Graphics2D, b:IntRectangle):Void{
		if(color == null){
			reloadColors(com.getUI());
		}
		var pb:JProgressBar = JProgressBar(com);
		if(pb == null){
			return;
		}
		
		var box:IntRectangle = b.clone();
		var percent:Float;
		if(pb.isIndeterminate()){
			percent = indeterminatePercent;
			indeterminatePercent += 0.1;
			if(indeterminatePercent > 1){
				indeterminatePercent = 0;
			}
		}else{
			percent = pb.getPercentComplete();
		}
		
		var boxWidth:Int = 5;
		var gap:Int = 1;
		g.beginFill(new SolidBrush(color));
		
		if(pb.getOrientation() == JProgressBar.VERTICAL){
			box.height = boxWidth;
			var minY:Int = b.y + b.height - b.height * percent;
			box.y = b.y+b.height-boxWidth;
			while (box.y >= minY){
				g.rectangle(box.x, box.y, box.width, box.height);
				box.y -= (boxWidth+gap);
			}
			if(box.y < minY && box.y + boxWidth > minY){
				box.height = boxWidth - (minY - box.y);
				box.y = minY;
				g.rectangle(box.x, box.y, box.width, box.height);
			}
		}else{
			box.width = boxWidth;
			var maxX:Int = b.x + b.width * percent;

			while (box.x <= maxX - boxWidth){
				g.rectangle(box.x, box.y, box.width, box.height);
				box.x += (boxWidth+gap);
			}
			box.width = maxX - box.x;
			if(box.width > 0){
				g.rectangle(box.x, box.y, box.width, box.height);
			}
		}
		g.endFill();
	}
	
	public function getDisplay(c:Component):DisplayObject
	{
		return null;
	}	
}
