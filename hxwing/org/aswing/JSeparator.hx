/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;
	
import org.aswing.plaf.basic.BasicSeparatorUI;
	
/**
 * <code>JSeparator</code> provides a general purpose component for
 * implementing divider lines - most commonly used as a divider
 * between menu items that breaks them up into logical groupings.
 * Instead of using <code>JSeparator</code> directly,
 * you can use the <code>JMenu</code> or <code>JPopupMenu</code>
 * <code>addSeparator</code> method to create and add a separator.
 * <code>JSeparator</code>s may also be used elsewhere in a GUI
 * wherever a visual divider is useful.
 * 
 * @author iiley
 */	
class JSeparator extends Component, implements Orientable {
	
    /** 
     * Horizontal orientation.
     */
    
	
    /** 
     * Horizontal orientation.
     */
    public static var HORIZONTAL:Int = AsWingConstants.HORIZONTAL;
    /** 
     * Vertical orientation.
     */
    public static var VERTICAL:Int   = AsWingConstants.VERTICAL;
	
	var orientation:Int;
	
	/**
	 * JSeparator(orientation:Number)<br>
	 * JSeparator() default orientation to HORIZONTAL;
	 * <p>
	 * @param orientation (optional) the orientation.
	 */
	public function new(?orientation:Int){
		super();
        if(orientation == null){
            orientation = AsWingConstants.HORIZONTAL;
        }
		setName("JSeparator");
		this.orientation = orientation;
		setFocusable(false);
		updateUI();
	}

	public override function updateUI():Void{
		setUI(UIManager.getUI(this));
	}
	
	public override function getUIClassID():String{
		return "SeparatorUI";
	}
	
    public override function getDefaultBasicUIClass():Class<Dynamic>{
    	return org.aswing.plaf.basic.BasicSeparatorUI;
    }
	
	public function getOrientation():Int{
		return orientation;
	}
	
	public function setOrientation(orientation:Int):Void{
		if (this.orientation != orientation){
			this.orientation = orientation;
			revalidate();
			repaint();
		}
	}
}

