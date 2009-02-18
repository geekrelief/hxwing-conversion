/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf;


import org.aswing.Border;
import org.aswing.Icon;
import org.aswing.GroundDecorator;

/**
 * The default empty values for ui resources.
 * A value defined in LAF with null or missing definition, it will be treat as these 
 * default values here.
 * <p>
 * For example, if you define button.border = null in the LAF class, then in fact the 
 * <code>UIDefaults</code> will return <code>EmptyUIResources.BORDER</code> to you.
 * </p>
 * @author iiley
 */
class EmptyUIResources
 {
	/**
	 * The default empty value for border.
	 */
	public function new() { }
	
	/**
	 * The default empty value for border.
	 */
	public static var BORDER:Border = DefaultEmptyDecoraterResource.INSTANCE;
	
	/**
	 * The default empty value for icon.
	 */
	public static var ICON:Icon = DefaultEmptyDecoraterResource.INSTANCE;
	
	/**
	 * The default empty value for ground decorator.
	 */
	public static var DECORATOR:GroundDecorator = DefaultEmptyDecoraterResource.INSTANCE;
	
	/**
	 * The default empty value for insets.
	 */
	public static var INSETS:InsetsUIResource = new InsetsUIResource();
	
	/**
	 * The default empty value for font.
	 */
	public static var FONT:ASFontUIResource = new ASFontUIResource();
	
	/**
	 * The default empty value for color.
	 */
	public static var COLOR:ASColorUIResource = new ASColorUIResource();
}

