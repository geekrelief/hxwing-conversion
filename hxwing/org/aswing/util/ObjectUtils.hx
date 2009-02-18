/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package org.aswing.util;
/*
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;
*/

class ObjectUtils
 {
	/**
	 * Deep clone object using thiswind@gmail.com 's solution
	 */
	public function new() { }
	
	/**
	 * Deep clone object using thiswind@gmail.com 's solution
	 */
     /*
	public static function baseClone(source:Dynamic):Dynamic{
		var typeName:String = getQualifiedClassName(source);
        var packageName:String = typeName.split("::")[1];
        var type:Class = Class(getDefinitionByName(typeName));

        registerClassAlias(packageName, type);
        
        var copier:ByteArray = new ByteArray();
        copier.writeObject(source);
        copier.position = 0;
        return copier.readObject();
	}
	*/
	/**
	 * Checks wherever passed-in value is <code>String</code>.
	 */
	public static function isString(value:Dynamic):Bool {
		return ( Std.is( value, String) );
	}
	
	/**
	 * Checks wherever passed-in value is <code>Number</code>.
	 */
	public static function isNumber(value:Dynamic):Bool {
		return ( Std.is( value, Float) );
	}

	/**
	 * Checks wherever passed-in value is <code>Boolean</code>.
	 */
	public static function isBoolean(value:Dynamic):Bool {
		return ( Std.is( value, Bool) );
	}

	/**
	 * Checks wherever passed-in value is <code>Function</code>.
	 */
	public static function isFunction(value:Dynamic):Bool {
		return ( Reflect.isFunction(value) );
	}

	
}
