/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf;

	
import flash.display.DisplayObject;

import Import_org_aswing;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import org.aswing.border.EmptyBorder;

/**
 * The default empty border to be the component border as default. So it can be 
 * replaced by LAF specified.
 * 
 * @author iiley
 */
class DefaultEmptyDecoraterResource implements org.aswing.Icon, implements org.aswing.Border, implements org.aswing.GroundDecorator, implements UIResource {
	/**
	 * Shared instance.
	 */
	
	/**
	 * Shared instance.
	 */
	public static var INSTANCE:DefaultEmptyDecoraterResource = new DefaultEmptyDecoraterResource();
	
	public static var DEFAULT_BACKGROUND_COLOR:ASColorUIResource = new ASColorUIResource(0);
	public static var DEFAULT_FOREGROUND_COLOR:ASColorUIResource = new ASColorUIResource(0xFFFFFF);
	public static var DEFAULT_FONT:ASFontUIResource = new ASFontUIResource();	
	
	/**
	 * Used to be a null ui resource color.
	 */
	public static var NULL_COLOR:ASColorUIResource = new ASColorUIResource(0);
	
	/**
	 * Used to be a null ui resource font.
	 */
	public static var NULL_FONT:ASFontUIResource = new ASFontUIResource();
	
	public function new(){
	}
	
	/**
	 * return null
	 */
	public function getDisplay(c:Component):DisplayObject{
		return null;
	}	
	
	/**
	 * return 0
	 */
	public function getIconWidth(c:Component):Int{
		return 0;
	}
	
	/**
	 * return 0
	 */
	public function getIconHeight(c:Component):Int{
		return 0;
	}
	
	/**
	 * do nothing
	 */
	public function updateIcon(com:Component, g:Graphics2D, x:Int, y:Int):Void{
	}	
	

	/**
	 * do nothing
	 */
	public function updateBorder(com:Component, g:Graphics2D, bounds:IntRectangle):Void{
	}
	
	/**
	 * return new Insets(0,0,0,0)
	 */
	public function getBorderInsets(com:Component, bounds:IntRectangle):Insets{
		return new Insets(0,0,0,0);
	}
	
	/**
	 * do nothing
	 */
	public function updateDecorator(com:Component, g:Graphics2D, bounds:IntRectangle):Void{
	}
}
