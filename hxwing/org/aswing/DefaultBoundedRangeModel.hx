/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;
	
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import org.aswing.event.InteractiveEvent;

/**
 * The default implementation of BoundedRangeModel.
 * @author iiley
 */
class DefaultBoundedRangeModel extends EventDispatcher, implements BoundedRangeModel {
	
	
	
	var value:Int;
	var extent:Int;
	var min:Int;
	var max:Int;
	var isAdjusting:Bool;
	
	/**
	 * Create a DefaultBoundedRangeModel
	 * @throws RangeError when invalid range properties
	 */
	public function new(?value:Int=0, ?extent:Int=0, ?min:Int=0, ?max:Int=100){
        super();
		isAdjusting = false;
		
		if (max >= min && value >= min && value + extent >= value && value + extent <= max){
			this.value = value;
			this.extent = extent;
			this.min = min;
			this.max = max;
		}else{
			//throw new RangeError("invalid range properties");
			throw ("invalid range properties");
		}
	}
	
	public function getValue():Int{
		return value;
	}
	
	public function getExtent():Int{
		return extent;
	}
	
	public function getMinimum():Int{
		return min;
	}
	
	public function getMaximum():Int{
		return max;
	}
	
	public function setValue(n:Int, ?programmatic:Bool=true):Void{
		n = Std.int(Math.min(n, max - extent));
		var newValue:Int = Std.int(Math.max(n, min));
		setRangeProperties(newValue, extent, min, max, isAdjusting, programmatic);
	}
	
	public function setExtent(n:Int):Void{
		var newExtent:Int = Std.int(Math.max(0, n));
		if (value + newExtent > max){
			newExtent = max - value;
		}
		setRangeProperties(value, newExtent, min, max, isAdjusting);
	}
	
	public function setMinimum(n:Int):Void{
		var newMax:Int = Std.int(Math.max(n, max));
		var newValue:Int = Std.int(Math.max(n, value));
		var newExtent:Int = Std.int(Math.min(newMax - newValue, extent));
		setRangeProperties(newValue, newExtent, n, newMax, isAdjusting);
	}
	
	public function setMaximum(n:Int):Void{
		var newMin:Int = Std.int(Math.min(n, min));
		var newExtent:Int = Std.int(Math.min(n - newMin, extent));
		var newValue:Int = Std.int(Math.min(n - newExtent, value));
		setRangeProperties(newValue, newExtent, newMin, n, isAdjusting);
	}
	
	public function setValueIsAdjusting(b:Bool):Void{
		setRangeProperties(value, extent, min, max, b, false);
	}
	
	public function getValueIsAdjusting():Bool{
		return isAdjusting;
	}
	
	public function setRangeProperties(newValue:Int, newExtent:Int, newMin:Int, newMax:Int, adjusting:Bool, ?programmatic:Bool=true):Void{
		if (newMin > newMax){
			newMin = newMax;
		}
		if (newValue > newMax){
			newMax = newValue;
		}
		if (newValue < newMin){
			newMin = newValue;
		}
		if (newExtent + newValue > newMax){
			newExtent = newMax - newValue;
		}
		if (newExtent < 0){
			newExtent = 0;
		}
		var isChange:Bool = newValue != value || newExtent != extent || newMin != min || newMax != max || adjusting != isAdjusting;
		if (isChange){
			value = newValue;
			extent = newExtent;
			min = newMin;
			max = newMax;
			isAdjusting = adjusting;
			fireStateChanged(programmatic);
		}
	}
	
	public function addStateListener(listener:Dynamic, ?priority:Int=0, ?useWeakReference:Bool=false):Void{
		addEventListener(InteractiveEvent.STATE_CHANGED, listener, false, priority);
	}
	
	public function removeStateListener(listener:Dynamic):Void{
		removeEventListener(InteractiveEvent.STATE_CHANGED, listener);
	}
		
	function fireStateChanged(programmatic:Bool):Void{
		dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED, programmatic));
	}
	
	public override function toString():String{
		var modelString:String = "value=" + getValue() + ", " + "extent=" + getExtent() + ", " + "min=" + getMinimum() + ", " + "max=" + getMaximum() + ", " + "adj=" + getValueIsAdjusting();
		return "DefaultBoundedRangeModel" + "[" + modelString + "]";
	}
	
}
