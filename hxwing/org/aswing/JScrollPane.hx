/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import Import_org_aswing_geom;
import Import_org_aswing_event;
import Import_org_aswing_error;
import org.aswing.plaf.basic.BasicScrollPaneUI;

/**
 * Dispatched when one of the scrollpane's scrollbar state changed.
 * @eventType org.aswing.event.ScrollPaneEvent.SCROLLBAR_STATE_CHANGED
 */
/*[Event(name="scrollbarStateChanged", type="org.aswing.event.ScrollPaneEvent")]*/
	
/**
 *  Dispatched when the viewport changed.
 *  @eventType org.aswing.event.ScrollPaneEvent.VIEWPORT_CHANGED
 */
/*[Event(name="viewportChanged", type="org.aswing.event.ScrollPaneEvent")]*/

/**
 * JScrollPane is a container with two scrollbar controllin the viewport's beeing viewed area.
 * <p>
 * If you want to change the unit or block increment of the scrollbars in a scrollpane, you shoud 
 * controll it with viewport instead of scrollbar directly, because the scrollbar's increment will 
 * be set to same to viewport's always. I mean use <code>JViewport.setHorizontalUnitIncrement()</code> instead of 
 * <code>JScrollBar.setUnitIncrement()</code>
 * 
 * @see org.aswing.Viewportable
 * @see org.aswing.JViewport
 * @see org.aswing.JScrollBar
 * @author iiley
 */
class JScrollPane extends Container {
		
    /**
     * scrollbar are displayed only when needed.
     */
    
		
    /**
     * scrollbar are displayed only when needed.
     */
    public static var SCROLLBAR_AS_NEEDED:Int = 0;
    /**
     * scrollbar are never displayed.
     */
    public static var SCROLLBAR_NEVER:Int = 1;
    /**
     * scrollbar are always displayed.
     */
    public static var SCROLLBAR_ALWAYS:Int = 2;
	
	var viewport:Viewportable;
	var vScrollBar:JScrollBar;
	var hScrollBar:JScrollBar;
	var vsbPolicy:Int;
	var hsbPolicy:Int;
	
	/**
	 * JScrollPane(view:Component, vsbPolicy:Number, hsbPolicy:Number)<br>
	 * JScrollPane(view:Component, vsbPolicy:Number)<br>
	 * JScrollPane(view:Component)<br>
	 * JScrollPane(viewport:Viewportable, vsbPolicy:Number, hsbPolicy:Number)<br>
	 * JScrollPane(viewport:Viewportable, vsbPolicy:Number)<br>
	 * JScrollPane(viewport:Viewportable)<br>
	 * JScrollPane()
	 * <p>
	 * Create a JScrollPane, you can specified a Component to be view,
	 * then here will create a JViewport to manager the view's scroll,
	 * or a Viewportable to be the view, it mananger the scroll itself.
	 * If view is not instanceof either, no view will be viewed.
	 * 
	 * @param viewOrViewport the scroll content component or a Viewportable
	 * @param vsbPolicy SCROLLBAR_AS_NEEDED or SCROLLBAR_NEVER or SCROLLBAR_ALWAYS, default SCROLLBAR_AS_NEEDED
	 * @param hsbPolicy SCROLLBAR_AS_NEEDED or SCROLLBAR_NEVER or SCROLLBAR_ALWAYS, default SCROLLBAR_AS_NEEDED
	 * @throw TypeError when viewOrViewport is not component or viewportable.
	 * @see #SCROLLBAR_AS_NEEDED
	 * @see #SCROLLBAR_NEVER
	 * @see #SCROLLBAR_ALWAYS
	 * @see #setViewportView()
	 * @see #setViewport()
	 * @see org.aswing.Viewportable
	 * @see org.aswing.JViewport
	 * @see org.aswing.JList
	 * @see org.aswing.JTextArea
	 */
	public function new(?viewOrViewport:Dynamic=null, ?vsbPolicy:Int, ?hsbPolicy:Int){
		super();
		setName("JScrollPane");

        if(vsbPolicy == null){
            vsbPolicy = SCROLLBAR_AS_NEEDED;
        }

        if(hsbPolicy == null){
            hsbPolicy = SCROLLBAR_AS_NEEDED;
        }
		this.vsbPolicy = vsbPolicy;
		this.hsbPolicy = hsbPolicy;
				
		setVerticalScrollBar(new JScrollBar(JScrollBar.VERTICAL));
		setHorizontalScrollBar(new JScrollBar(JScrollBar.HORIZONTAL));
		if(viewOrViewport != null){
			setView(viewOrViewport);
		}else{
			setViewport(new JViewport());
		}
		setLayout(new ScrollPaneLayout());
		updateUI();
	}
	
    public override function updateUI():Void{
    	setUI(UIManager.getUI(this));
    }
	
    public override function getDefaultBasicUIClass():Class<Dynamic>{
    	return org.aswing.plaf.basic.BasicScrollPaneUI;
    }
    	
	public override function getUIClassID():String{
		return "ScrollPaneUI";
	}	
	
	/**
	 * @throws ArgumentError when the layout is not ScrollPaneLayout instance.
	 */
	public override function setLayout(layout:LayoutManager):Void{
		if(Std.is( layout, ScrollPaneLayout)){
			super.setLayout(layout);
		}else{
			//throw new ArgumentError("Only can set ScrollPaneLayout to JScrollPane");
			throw ("Only can set ScrollPaneLayout to JScrollPane");
		}
	}
	
	/**
	 * @return true always here.
	 */
	public override function isValidateRoot():Bool{
		return true;
	}
	
	/**
	 * setView(view:Component)<br>
	 * setView(view:Viewportable)<br>
	 * Sets the view to viewed and scrolled by this scrollpane.
	 * if this view is not a Viewportable implementation,
	 * then here will create a JViewport to manager the view's scroll,
	 * else the Viewportable will be the viewport.
	 * <br>
	 * If view is not instanceof either, no view will be set.
	 * <br>If you want to make a component viewed by your way, you have two way:
	 * <p>
	 * <ul>
	 * <li>1.Make your component a <code>Viewportable</code> implementation.
	 * <li>2.Make a your new <code>Viewportable</code> likes <code>JViewport</code>, recommend
	 * you extends the <code>JViewport</code>, then make your component to be the viewport's view like
	 * <code>JViewport</code> does.
	 * </ul>
	 * </p>
	 * @param viewOrViewport a component or a Viewportable object.
	 * @see Viewportable
	 * @throw TypeError when viewOrViewport is not component or viewportable.
	 */
	public function setView(viewOrViewport:Dynamic):Void{
		if(Std.is( viewOrViewport, Viewportable)){
			setViewport(cast(viewOrViewport, Viewportable));
		}else if(Std.is( viewOrViewport, Component)){
			setViewportView(cast(viewOrViewport, Component));
		}else{
			//throw new TypeError("Only accept Component or Viewportable instance here!");
			throw ("Only accept Component or Viewportable instance here!");
		}
	}
	
    /**
     * If currently viewport is a <code>JViewport</code> instance, 
     * set the view to it. If not, then creates a <code>JViewport</code> and then sets this view. 
     * Applications that don't provide the view directly to the <code>JScrollPane</code>
     * constructor should use this method to specify the scrollable child that's going
     * to be displayed in the scrollpane. For example:
     * <pre>
     * JScrollPane scrollpane = new JScrollPane();
     * scrollpane.setViewportView(myBigComponentToScroll);
     * </pre>
     * Applications should not add children directly to the scrollpane.
     *
     * @param view the component to add to the viewport
     * @see #setViewport()
     * @see org.aswing.JViewport#setView()
     */
	public function setViewportView(view:Component):Void{
		var jviewport:JViewport = cast( getViewport(), JViewport);
		if(jviewport != null){
			jviewport.setView(view);
		}else{
			setViewport(new JViewport(view));
		}
	}
	
	/**
	 * Returns the view currently in the scrollpane's viewport if the viewport 
	 * is a JViewport instance, otherwise, null will be returned.
	 */
	public function getViewportView():Component{
		var jviewport:JViewport = cast( getViewport(), JViewport);
		if(jviewport != null){
			return jviewport.getView();
		}else{
			return null;
		}
	}
	
    /**
     * Removes the old viewport (if there is one); and syncs the scrollbars and
     * headers with the new viewport.
     * <p>
     * Most applications will find it more convenient to use 
     * <code>setView</code>
     * to add a viewport or a view to the scrollpane.
     * 
     * @param viewport the new viewport to be used; if viewport is
     *		<code>null</code>, the old viewport is still removed
     *		and the new viewport is set to <code>null</code>
     * @see #getViewport()
     * @see #setViewportView()
     * @see org.aswing.JList
     * @see org.aswing.JTextArea
     * @see org.aswing.JTable
     */
	public function setViewport(vp:Viewportable):Void{
		if(viewport != vp){
			if(viewport != null){
				remove(viewport.getViewportPane());
			}
			viewport = vp;
			if(viewport != null){
				insertImp(-1, viewport.getViewportPane());
			}
			revalidate();
			dispatchEvent(new ScrollPaneEvent(ScrollPaneEvent.VIEWPORT_CHANGED, true, null, true));
		}
	}
	
	public function getViewport():Viewportable{
		return viewport;
	}
	
	/**
	 * Returns the visible extent rectangle related the current scroll properties.
	 * @return the visible extent rectangle
	 */
	public function getVisibleRect():IntRectangle{
		return new IntRectangle(getHorizontalScrollBar().getValue(),
							 getVerticalScrollBar().getValue(),
							 getHorizontalScrollBar().getVisibleAmount(),
							 getVerticalScrollBar().getVisibleAmount());
	}
	
	/**
	 * Adds a scrollbar scrolled listener.
	 * @param listener the listener
	 * @param priority the priority
	 * @param useWeakReference Determines whether the reference to the listener is strong or weak.
	 * @see org.aswing.event.ScrollPaneEvent#SCROLLBAR_STATE_CHANGED
	 */
	public function addAdjustmentListener(listener:Dynamic, ?priority:Int=0, ?useWeakReference:Bool=false):Void{
		addEventListener(ScrollPaneEvent.SCROLLBAR_STATE_CHANGED, listener, false, priority);
	}
	
	/**
	 * Removes a state listener.
	 * @param listener the listener to be removed.
	 * @see org.aswing.event.ScrollPaneEvent#SCROLLBAR_STATE_CHANGED
	 */
	public function removeAdjustmentListener(listener:Dynamic):Void{
		removeEventListener(ScrollPaneEvent.SCROLLBAR_STATE_CHANGED, listener);
	}
		
	/**
	 * Event handler for scroll bars
	 */
	function __onBarScroll(e:InteractiveEvent):Void{
		dispatchEvent(new ScrollPaneEvent(ScrollPaneEvent.SCROLLBAR_STATE_CHANGED, 
		e.isProgrammatic(), cast(e.target, JScrollBar), false));
	}
		
	/**
	 * Adds the scrollbar that controls the viewport's horizontal view position to the scrollpane. 
	 */
	public function setHorizontalScrollBar(horizontalScrollBar:JScrollBar):Void{
		if(hScrollBar != horizontalScrollBar){
			if(hScrollBar != null){
				hScrollBar.removeStateListener(__onBarScroll);
				remove(hScrollBar);
			}
			hScrollBar = horizontalScrollBar;
			if(hScrollBar != null){
				hScrollBar.setName("HorizontalScrollBar");
				insertImp(-1, hScrollBar);
				hScrollBar.addStateListener(__onBarScroll);
			}
			revalidate();
		}
	}
	
	public function getHorizontalScrollBar():JScrollBar{
		return hScrollBar;
	}
	
	public function setHorizontalScrollBarPolicy(policy:Int):Void{
		hsbPolicy = policy;
	} 
 
	public function getHorizontalScrollBarPolicy():Int{
		return hsbPolicy;
	} 
	
 	/**
	 * Adds the scrollbar that controls the viewport's vertical view position to the scrollpane. 
	 */
	public function setVerticalScrollBar(verticalScrollBar:JScrollBar):Void{
		if(vScrollBar != verticalScrollBar){
			if(vScrollBar != null){
				vScrollBar.removeStateListener(__onBarScroll);
				remove(vScrollBar);
			}
			vScrollBar = verticalScrollBar;
			if(vScrollBar != null){
				vScrollBar.setName("verticalScrollBar");
				insertImp(-1, vScrollBar);
				vScrollBar.addStateListener(__onBarScroll);
			}
			revalidate();
		}
	}
	
	public function getVerticalScrollBar():JScrollBar{
		return vScrollBar;
	}
	
	public function setVerticalScrollBarPolicy(policy:Int):Void{
		vsbPolicy = policy;
	} 

	public function getVerticalScrollBarPolicy():Int{
		return vsbPolicy;
	}
	
	/**
	 * Sets the com to be the view.
	 */	
	public override function append(com:Component, ?constraints:Dynamic=null):Void{
		setView(com);
	}
	
	/**
	 * Sets the com to be the view.
	 */	
	public override function insert(i:Int, com:Component, ?constraints:Dynamic=null):Void{
		setView(com);
	}
	
	override function getFocusTransmit():Component{
		return getViewport().getViewportPane();
	}	
}
