/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

	
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;
import org.aswing.util.HashMap;

/**
 * A table of defaults for AsWing components.  Applications can set/get
 * default values via the <code>UIManager</code>.
 * 
 * @see UIManager
 * @author iiley
 */
class UIDefaults extends HashMap {
	
	public function new()
	{
		super();
	}
	
    /**
     * Sets the value of <code>key</code> to <code>value</code>.
     * If value is <code>null</code>, the key is removed from the table.
     *
     * @param key    the unique <code>Object</code> who's value will be used
     *          to retrieve the data value associated with it
     * @param value  the new <code>Object</code> to store as data under
     *		that key
     * @return the previous <code>Object</code> value, or <code>null</code>
     * @see #putDefaults()
     * @see org.aswing.utils.HashMap#put()
     */	
 	public override function put(key:Dynamic, value:Dynamic):Dynamic{
 		var oldValue:Dynamic = (value == null) ? super.remove(key) : super.put(key, value);
 		return oldValue;
 	}
 	
	/**
     * Puts all of the key/value pairs in the database.
     * @param keyValueList  an array of key/value pairs
     * @see #put()
     * @see org.aswing.utils.Hashtable#put()
     */
	public function putDefaults(keyValueList:Array<Dynamic>):Void{
		var i:Int = 0;
           while (i < keyValueList.length) {
            var value:Dynamic = keyValueList[i + 1];
            if (value == null) {
                super.remove(keyValueList[i]);
            }else {
                super.put(keyValueList[i], value);
            }
        	i += 2;
           }
	}
	
	/**
	 * Returns the component LookAndFeel specified UI object
	 * @return target's UI object, or null if there is not his UI object
	 */
	public function getUI(target:Component):ComponentUI{
		var ui:ComponentUI = cast( getInstance(target.getUIClassID()), ComponentUI);
		if(ui == null){
			ui = cast( getCreateInstance(target.getDefaultBasicUIClass()), ComponentUI);
		}
		return ui;
	}
	
	public function getBoolean(key:String):Bool{
		return (this.get(key) == true);
	}
	
	public function getNumber(key:String):Float{
		return cast(this.get(key), Float);
	}
	
	public function getInt(key:String):Int{
		return cast(this.get(key), Int);
	}
	
	public function getUint(key:String):UInt{
		return cast(this.get(key), UInt);
	}
	
	public function getString(key:String):String{
		return cast(this.get(key), String);
	}
	
	public function getBorder(key:String):Border{
		var border:Border = cast( getInstance(key), Border);
		if(border == null){
			border = EmptyUIResources.BORDER; //make it to be an ui resource then can override by next LAF
		}
		return border;
	}
	
	public function getIcon(key:String):Icon{
		var icon:Icon = cast( getInstance(key), Icon);
		if(icon == null){
			icon = EmptyUIResources.ICON; //make it to be ui resource property then can override by next LAF
		}
		return icon;
	}
	
	public function getGroundDecorator(key:String):GroundDecorator{
		var dec:GroundDecorator = cast( getInstance(key), GroundDecorator);
		if(dec == null){
			dec = EmptyUIResources.DECORATOR; //make it to be ui resource property then can override by next LAF
		}
		return dec;
	}
	
	public function getColor(key:String):ASColor{
		var color:ASColor = cast( getInstance(key), ASColor);
		if(color == null){
			color = EmptyUIResources.COLOR; //make it to be an ui resource then can override by next LAF
		}
		return color;
	}
	
	public function getFont(key:String):ASFont{
		var font:ASFont = cast( getInstance(key), ASFont);
		if(font == null){
			font = EmptyUIResources.FONT; //make it to be an ui resource then can override by next LAF
		}
		return font;
	}
	
	public function getInsets(key:String):Insets{
		var i:Insets = cast( getInstance(key), Insets);
		if(i == null){
			i = EmptyUIResources.INSETS; //make it to be an ui resource then can override by next LAF
		}
		return i;
	}	
	
	//-------------------------------------------------------------
	public function getConstructor(key:String):Class<Dynamic>{
		return cast(this.get(key), Class<Dynamic>);
	}
	
	public function getInstance(key:String):Dynamic{
		var value = this.get(key);
		if(Std.is( value, Class)){
			return getCreateInstance(cast(value, Class<Dynamic>));
		}else{
			return value;
		}
	}
	
	function getCreateInstance(constructor:Class<Dynamic>):Dynamic{
		return Type.createInstance(constructor, []);
	}
}

