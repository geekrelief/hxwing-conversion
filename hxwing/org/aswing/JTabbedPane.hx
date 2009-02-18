/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

	
import Import_org_aswing_plaf;
import org.aswing.plaf.basic.BasicTabbedPaneUI;
	
/**
 * A component that lets the user switch between a group of components by
 * clicking on a tab with a given title and/or icon.
 * <p>
 * Tabs/components are added to a <code>TabbedPane</code> object by using the
 * <code>addTab</code> and <code>insertTab</code> methods.
 * A tab is represented by an index corresponding
 * to the position it was added in, where the first tab has an index equal to 0
 * and the last tab has an index equal to the tab count minus 1.
 * @author iiley
 */	
	
class JTabbedPane extends AbstractTabbedPane {

	/**
	 * A fast access to AsWingConstants Constant
	 * @see org.aswing.AsWingConstants
	 */
	

	/**
	 * A fast access to AsWingConstants Constant
	 * @see org.aswing.AsWingConstants
	 */
	public static var TOP:Int     = AsWingConstants.TOP;
	/**
	 * A fast access to AsWingConstants Constant
	 * @see org.aswing.AsWingConstants
	 */
    public static var LEFT:Int    = AsWingConstants.LEFT;
	/**
	 * A fast access to AsWingConstants Constant
	 * @see org.aswing.AsWingConstants
	 */
    public static var BOTTOM:Int  = AsWingConstants.BOTTOM;
 	/**
	 * A fast access to AsWingConstants Constant
	 * @see org.aswing.AsWingConstants
	 */
    public static var RIGHT:Int   = AsWingConstants.RIGHT;	
	
	var tabPlacement:Int;
	
    /**
     * JTabbedPane()
     * <p>
     */
	public function new() {
		super();
		setName("JTabbedPane");
		tabPlacement = TOP;
		
		updateUI();
	}

	public override function updateUI():Void{
		setUI(UIManager.getUI(this));
	}
	
    public override function getDefaultBasicUIClass():Class<Dynamic>{
    	return org.aswing.plaf.basic.BasicTabbedPaneUI;
    }
		
	public override function getUIClassID():String{
		return "TabbedPaneUI";
	}
	
    /**
     * Sets the tab placement for this tabbedpane.
     * Possible values are:<ul>
     * <li><code>JTabbedPane.TOP</code>
     * <li><code>JTabbedPane.BOTTOM</code>
     * <li><code>JTabbedPane.LEFT</code>
     * <li><code>JTabbedPane.RIGHT</code>
     * </ul>
     * The default value, if not set, is <code>SwingConstants.TOP</code>.
     *
     * @param tabPlacement the placement for the tabs relative to the content
     */
    public function setTabPlacement(tabPlacement:Int):Void {
    	if(this.tabPlacement != tabPlacement){
    		this.tabPlacement = tabPlacement;
    		revalidate();
    		repaint();
    	}
    }
    
    /**
     * Returns the placement of the tabs for this tabbedpane.
     * @see #setTabPlacement()
     */
    public function getTabPlacement():Int{
    	return tabPlacement;
    }
    
	/**
	 * Generally you should not set layout to JTabbedPane.
	 * @param layout layoutManager for JTabbedPane
	 * @throws ArgumentError when you set a non-TabbedPaneUI layout to JTabbedPane.
	 */
	public override function setLayout(layout:LayoutManager):Void{
		if(Std.is( layout, ComponentUI)){
			super.setLayout(layout);
		}else{
			//throw ArgumentError("Cannot set non-AccordionUI layout to JAccordion!");
			throw ("Cannot set non-AccordionUI layout to JAccordion!");
		}
	}
    
    /**
     * Not support this function.
     * @throws Error("Not supported setVisibleAt!")
     */
    public override function setVisibleAt(index:Int, visible:Bool):Void{
    	//throw new Error("Not supported setVisibleAt!");
    	throw ("Not supported setVisibleAt!");
    }	
	
}
