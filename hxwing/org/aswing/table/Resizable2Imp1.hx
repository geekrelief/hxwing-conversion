/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.table;
	
/**
 * @author iiley
 */
class Resizable2Imp1 implements Resizable2 {
	
	
	
	var r:Resizable3;
	var flag:Bool;
	
	public function new(r:Resizable3, flag:Bool){
		this.r = r;
		this.flag = flag;
	}
	
    public function getElementCount():Int      { 
    	return r.getElementCount(); 
    }
    
    public function getLowerBoundAt(i:Int):Int { 
    	if(flag){
    		return r.getLowerBoundAt(i);
    	}else{
    		return r.getMidPointAt(i);
    	}
    }
    
    public function getUpperBoundAt(i:Int):Int { 
    	if(flag){
    		return r.getMidPointAt(i);
    	}else{
    		return r.getUpperBoundAt(i);
    	} 
    }
    
    public function setSizeAt(newSize:Int, i:Int):Void { 
    	r.setSizeAt(newSize, i); 
    }
}
