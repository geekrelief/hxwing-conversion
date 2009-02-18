/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import Import_org_aswing_event;
import Import_org_aswing_util;

/**
 * Abstract list model that provide the list model events base.
 * @author iiley
 */
class AbstractListModel {
	
    
	
    var listeners:Array<Dynamic>;
    
    public function new(){
    	listeners = new Array();
    }

    public function addListDataListener(l:ListDataListener):Void {
		listeners.push(l);
    }

    public function removeListDataListener(l:ListDataListener):Void {
    	ArrayUtils.removeFromArray(listeners, l);
    }

    function fireContentsChanged(target:Dynamic, index0:Int, index1:Int, removedItems:Array<Dynamic>):Void{
		var e:ListDataEvent = new ListDataEvent(target, index0, index1, removedItems);
	
		var i:Int = listeners.length - 1;
		while (i >= 0) {
			var lis:ListDataListener = cast(listeners[i], ListDataListener);
			lis.contentsChanged(e);
			i --;
		}
    }

    function fireIntervalAdded(target:Dynamic, index0:Int, index1:Int):Void{
		var e:ListDataEvent = new ListDataEvent(target, index0, index1, []);
	
		var i:Int = listeners.length - 1;
		while (i >= 0) {
			var lis:ListDataListener = cast(listeners[i], ListDataListener);
			lis.intervalAdded(e);     
			i --;
		}
    }

    function fireIntervalRemoved(target:Dynamic, index0:Int, index1:Int, removedItems:Array<Dynamic>):Void{
		var e:ListDataEvent = new ListDataEvent(target, index0, index1, removedItems);
	
		var i:Int = listeners.length - 1;
		while (i >= 0) {
			var lis:ListDataListener = cast(listeners[i], ListDataListener);
			lis.intervalRemoved(e);
			i --;
		}		
    }
}
