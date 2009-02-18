/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.resizer;
	
import Import_org_aswing_geom;
import org.aswing.Component;

/**
 * A basic implementation of ResizeStrategy.
 * 
 * <p>It will return the resized rectangle, the rectangle is not min than 
 * getResizableMinSize and not max than getResizableMaxSize if these method are defineded
 * in the resized comopoent.
 * </p>
 * @author iiley
 */
class ResizeStrategyImp implements ResizeStrategy {
	
	
	
	var wSign:Int;
	var hSign:Int;
	
	public function new(wSign:Int, hSign:Int){
		this.wSign = wSign;
		this.hSign = hSign;
	}
	
	/**
	 * Count and return the new bounds what the component would be resized to.<br>
	 * 
 	 * It will return the resized rectangle, the rectangle is not min than 
 	 * getResizableMinSize and not max than getResizableMaxSize if these method are defineded
 	 * in the resized comopoent.
	 */
	public function getBounds(origBounds:IntRectangle, minSize:IntDimension, maxSize:IntDimension, movedX:Int, movedY:Int):IntRectangle{
		var currentBounds:IntRectangle = origBounds.clone();
		if(minSize == null){
			minSize = new IntDimension(0, 0);
		}
		if(maxSize == null){
			maxSize = IntDimension.createBigDimension();
		}		
		var newX:Int;
		var newY:Int;
		var newW:Int;
		var newH:Int;
		if(wSign == 0){
			newW = currentBounds.width;
		}else{
			newW = currentBounds.width + wSign*movedX;
			newW = Std.int(Math.min(maxSize.width, Math.max(minSize.width, newW)));
		}
		if(wSign < 0){
			newX = currentBounds.x + (currentBounds.width - newW);
		}else{
			newX = currentBounds.x;
		}
		
		if(hSign == 0){
			newH = currentBounds.height;
		}else{
			newH = currentBounds.height + hSign*movedY;
			newH = Std.int(Math.min(maxSize.height, Math.max(minSize.height, newH)));
		}
		if(hSign < 0){
			newY = currentBounds.y + (currentBounds.height - newH);
		}else{
			newY = currentBounds.y;
		}
		newX = Math.round(newX);
		newY = Math.round(newY);
		newW = Math.round(newW);
		newH = Math.round(newH);
		return new IntRectangle(newX, newY, newW, newH);
	}
		
}
