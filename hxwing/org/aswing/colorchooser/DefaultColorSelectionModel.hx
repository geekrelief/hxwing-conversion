/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package org.aswing.colorchooser;  
import flash.events.EventDispatcher;

import org.aswing.ASColor;
import Import_org_aswing_event;

/**
 * A generic implementation of <code>ColorSelectionModel</code>.
 * @author iiley
 */
class DefaultColorSelectionModel extends EventDispatcher, implements ColorSelectionModel {
		
	
		
	var selectedColor:ASColor;
	
	/**
	 * DefaultColorSelectionModel(selectedColor:ASColor)<br>
	 * DefaultColorSelectionModel() default to ASColor.WHITE
	 * <p>
     * Creates a <code>DefaultColorSelectionModel</code> with the
     * current color set to <code>color</code>.  Note that setting the color to
     * <code>null</code> means default to WHITE.
	 */
	public function new(?selectedColor:ASColor=null) {
		super();
		if (selectedColor == null) selectedColor=ASColor.WHITE;
		this.selectedColor = selectedColor;
	}

	public function getSelectedColor() : ASColor {
		return selectedColor;
	}

	public function setSelectedColor(color : ASColor) : Void {
		if((selectedColor == null && color != null)
			 || (color == null && selectedColor != null)
			 || (color != null && !color.equals(selectedColor))){
			selectedColor = color;
			fireStateChanged();
		}else{
			selectedColor = color;
		}
	}

	public function addChangeListener(func : Dynamic) : Void {
		addEventListener(InteractiveEvent.STATE_CHANGED, func);
	}
	
    public function addColorAdjustingListener(func:Dynamic):Void{
    	addEventListener(ColorChooserEvent.COLOR_ADJUSTING, func);
    }
	
    public function removeChangeListener(func:Dynamic):Void{
    	removeEventListener(InteractiveEvent.STATE_CHANGED, func);
    }

    public function removeColorAdjustingListener(func:Dynamic):Void{
    	removeEventListener(ColorChooserEvent.COLOR_ADJUSTING, func);    	
    }
	
	function fireStateChanged():Void{
		dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
	}
	
	public function fireColorAdjusting(color : ASColor) : Void {
		dispatchEvent(new ColorChooserEvent(ColorChooserEvent.COLOR_ADJUSTING, color));
	}

}
