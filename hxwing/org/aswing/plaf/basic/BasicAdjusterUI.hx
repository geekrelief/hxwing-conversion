/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;
	
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import Import_org_aswing;
import org.aswing.border.BevelBorder;
import org.aswing.event.AWEvent;
import org.aswing.event.FocusKeyEvent;
import org.aswing.event.ReleaseEvent;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;
import org.aswing.plaf.basic.adjuster.PopupSliderUI;
import org.aswing.plaf.basic.icon.ArrowIcon;

/**
 * Basic adjust ui imp.
 * @author iiley
 * @private
 */
class BasicAdjusterUI extends BaseComponentUI, implements AdjusterUI {
	
	
	
	var adjuster:JAdjuster;
	var arrowButton:Component;
	var popup:JPopup;
	var inputText:JTextField;
	var popupSlider:JSlider;
	var popupSliderUI:SliderUI;
	var startMousePoint:IntPoint;
	var startValue:Int;
	
	var thumbLightHighlightColor:ASColor;
    var thumbHighlightColor:ASColor;
    var thumbLightShadowColor:ASColor;
    var thumbDarkShadowColor:ASColor;
    var thumbColor:ASColor;
    var arrowShadowColor:ASColor;
    var arrowLightColor:ASColor;
    
    var highlightColor:ASColor;
    var shadowColor:ASColor;
    var darkShadowColor:ASColor;
    var lightColor:ASColor;	
	
	public function new(){
		super();
		inputText   = new JTextField("", 3);
		inputText.setFocusable(false);
		popupSlider = new JSlider();
		popupSlider.setFocusable(false);
	}
	
	public function getPopupSlider():JSlider{
		return popupSlider;
	}
	
	public function getInputText():JTextField{
		return inputText;
	}
	
    public override function installUI(c:Component):Void{
    	adjuster = cast(c, JAdjuster);
		installDefaults();
		installComponents();
		installListeners();
    }
    
	public override function uninstallUI(c:Component):Void{
    	adjuster = cast(c, JAdjuster);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
    }
    
	function getPropertyPrefix():String {
		return "Adjuster.";
	}
	
	function installDefaults():Void{
		var pp:String = getPropertyPrefix();
        LookAndFeel.installBorderAndBFDecorators(adjuster, pp);
        LookAndFeel.installColorsAndFont(adjuster, pp);
        LookAndFeel.installBasicProperties(adjuster, pp);
		arrowShadowColor = getColor(pp+"arrowShadowColor");
		arrowLightColor = getColor(pp+"arrowLightColor");
	}
    
    function uninstallDefaults():Void{
    	LookAndFeel.uninstallBorderAndBFDecorators(adjuster);
    }
    
	function installComponents():Void{
		initInputText();
		initPopupSlider();
		arrowButton = createArrowButton();
		arrowButton.setUIElement(true);
		popupSlider.setUIElement(true);
		popupSliderUI = createPopupSliderUI();
		popupSlider.setUI(popupSliderUI);
		popupSlider.setModel(adjuster.getModel());
		adjuster.addChild(inputText);
		adjuster.addChild(arrowButton);
		
		inputText.addEventListener(MouseEvent.MOUSE_WHEEL, __onInputTextMouseWheel);
		arrowButton.addEventListener(MouseEvent.MOUSE_DOWN, __onArrowButtonPressed);
		arrowButton.addEventListener(ReleaseEvent.RELEASE, __onArrowButtonReleased);
    }
    
	function uninstallComponents():Void{
		inputText.removeEventListener(MouseEvent.MOUSE_WHEEL, __onInputTextMouseWheel);
		arrowButton.removeEventListener(MouseEvent.MOUSE_DOWN, __onArrowButtonPressed);
		arrowButton.removeEventListener(ReleaseEvent.RELEASE, __onArrowButtonReleased);
		
		adjuster.removeChild(arrowButton);
		adjuster.removeChild(inputText);
		if(popup != null && popup.isVisible()){
			popup.dispose();
		}
    }
	
	function installListeners():Void{
		adjuster.addStateListener(__onValueChanged);
		adjuster.addEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onInputTextKeyDown);
		adjuster.addEventListener(AWEvent.FOCUS_GAINED, __onFocusGained);
		adjuster.addEventListener(AWEvent.FOCUS_LOST, __onFocusLost);
	}
    
    function uninstallListeners():Void{
		adjuster.removeStateListener(__onValueChanged);
		adjuster.removeEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onInputTextKeyDown);
		adjuster.removeEventListener(AWEvent.FOCUS_GAINED, __onFocusGained);
		adjuster.removeEventListener(AWEvent.FOCUS_LOST, __onFocusLost);
    }
    
	public override function paint(c:Component, g:Graphics2D, b:IntRectangle):Void{
		super.paint(c, g, b);
		var text:String = getShouldFilledText();
		if(text != inputText.getText()){
			inputText.setText(text);
		}
		layoutAdjuster();
		getInputText().setEditable(adjuster.isEditable());
		getInputText().setEnabled(adjuster.isEnabled());
		arrowButton.setEnabled(adjuster.isEnabled());
	}
	
	
	//*******************************************************************************
	//              Override these methods to easily implement different look
	//*******************************************************************************
    /**
     * Returns the input text to receive the focus for the component.
     * @param c the component
     * @return the object to receive the focus.
     */
	public override function getInternalFocusObject(c:Component):InteractiveObject{
		return inputText.getTextField();
	}
	
	function initInputText():Void{
		inputText.setColumns(adjuster.getColumns());
		inputText.setForeground(null);//make it grap the property from parent
		inputText.setFont(adjuster.getFont());
	}
	
	function initPopupSlider():Void{
		popupSlider.setOrientation(adjuster.getOrientation());
	}
	
	function createArrowButton():Component{
		var btn:JButton = new JButton(null, createArrowIcon());
		btn.setMargin(new Insets(2, 2, 2, 2));
		btn.setForeground(null);//make it grap the property from parent
		btn.setBackground(null);//make it grap the property from parent
		btn.setFont(null);//make it grap the property from parent
		btn.setFocusable(false);
		return btn;
	}
	
	function createPopupSliderUI():SliderUI{
		return new PopupSliderUI();
	}
	
	function createArrowIcon() : Icon {
		return new ArrowIcon(Math.PI/2, 6,
				    arrowLightColor,
				    arrowShadowColor);
	}
		
	function getPopup():JPopup{
		if(popup == null){
			popup = new JPopup();
			popup.setBorder(new BevelBorder(null, BevelBorder.RAISED));
			popup.append(popupSlider, BorderLayout.CENTER);
			popup.setBackground(adjuster.getBackground());
		}
		return popup;
	}
	
	function fillInputTextWithCurrentValue():Void{
		inputText.setText(getShouldFilledText());
	}
	
	function getShouldFilledText():String{
		var value:Int = adjuster.getValue();
		var text:String = adjuster.getValueTranslator()(value);
		return text;
	}
	
	function getTextButtonGap():Int{
		return 1;
	}
	
	function layoutAdjuster():Void{
    	var td:IntDimension = adjuster.getSize();
		var insets:Insets = adjuster.getInsets();
		var top:Int = insets.top;
		var left:Int = insets.left;
		var right:Int = td.width - insets.right;
		var gap:Int = getTextButtonGap();
		
		var height:Int = td.height - insets.top - insets.bottom;
    	var buttonSize:IntDimension = arrowButton.getPreferredSize(); 
    	arrowButton.setSizeWH(buttonSize.width, height);
    	arrowButton.setLocationXY(right - buttonSize.width, top);
    	inputText.setLocationXY(left, top);
    	inputText.setSizeWH(td.width - insets.left - insets.right - buttonSize.width-gap, height);		
	}
    
    public override function getPreferredSize(c:Component):IntDimension{
    	var insets:Insets = adjuster.getInsets();
    	var textSize:IntDimension = inputText.getPreferredSize();
    	var btnSize:IntDimension = arrowButton.getPreferredSize();
    	var size:IntDimension = new IntDimension(
    		textSize.width + getTextButtonGap() + btnSize.width,
    		Std.int(Math.max(textSize.height, btnSize.height))
    	);
    	return insets.getOutsideSize(size);
    }

    public override function getMinimumSize(c:Component):IntDimension{
    	return adjuster.getInsets().getOutsideSize(arrowButton.getPreferredSize());
    }

    public override function getMaximumSize(c:Component):IntDimension{
		return IntDimension.createBigDimension();
    }    	
	
	//--------------------- handlers--------------------
	
	function __onValueChanged(e:Event):Void{
		fillInputTextWithCurrentValue();
	}
	
	function __onInputTextMouseWheel(e:MouseEvent):Void{
		adjuster.setValue(adjuster.getValue()+e.delta*getUnitIncrement());
	}
	
	function __inputTextAction(?fireActOnlyIfChanged:Bool=false):Void{
		var text:String = inputText.getText();
		var value:Int = adjuster.getValueParser()(text);
		adjuster.setValue(value);
		//revalidte a legic text
		fillInputTextWithCurrentValue();
		if(!fireActOnlyIfChanged){
			fireActionEvent();
		}else if(value != startEditingValue){
			fireActionEvent();
		}
	}
	
	var startEditingValue:Int;
	function fireActionEvent():Void{
		startEditingValue = adjuster.getValue();
		adjuster.dispatchEvent(new AWEvent(AWEvent.ACT));
	}
	
	function __onFocusGained(e:AWEvent):Void{
		startEditingValue = adjuster.getValue();
	}
	
	function __onFocusLost(e:AWEvent):Void{
		__inputTextAction(true);
	}
	
	function __onInputTextKeyDown(e:FocusKeyEvent):Void{
    	var code:UInt = e.keyCode;
    	var unit:Int = getUnitIncrement();
    	var block:Int = popupSlider.getMajorTickSpacing() > 0 ? popupSlider.getMajorTickSpacing() : unit*10;
    	var delta:Int = 0;
    	if(code == Keyboard.ENTER){
    		__inputTextAction(false);
    		return;
    	}
    	if(code == Keyboard.UP){
    		delta = unit;
    	}else if(code == Keyboard.DOWN){
    		delta = -unit;
    	}else if(code == Keyboard.PAGE_UP){
    		delta = block;
    	}else if(code == Keyboard.PAGE_DOWN){
    		delta = -block;
    	}else if(code == Keyboard.HOME){
    		adjuster.setValue(adjuster.getMinimum());
    		return;
    	}else if(code == Keyboard.END){
    		adjuster.setValue(adjuster.getMaximum() - adjuster.getExtent());
    		return;
    	}
    	adjuster.setValue(adjuster.getValue() + delta);
	}
	
	function __onArrowButtonPressed(e:Event):Void{
		var popupWindow:JPopup = getPopup();
		if(popupWindow.isOnStage()){
			popupWindow.dispose();
		}
		popupWindow.changeOwner(AsWingUtils.getOwnerAncestor(adjuster));
		popupWindow.pack();
		popupWindow.show();
		var max:Int = adjuster.getMaximum();
		var min:Int = adjuster.getMinimum();
		var pw:Int = popupWindow.getWidth();
		var ph:Int = popupWindow.getHeight();
		var sw:Int = getSliderTrackWidth();
		var sh:Int = getSliderTrackHeight();
		var insets:Insets = popupWindow.getInsets();
		var sliderInsets:Insets = popupSliderUI.getTrackMargin();
		insets.top += sliderInsets.top;
		insets.left += sliderInsets.left;
		insets.bottom += sliderInsets.bottom;
		insets.right += sliderInsets.right;
		var mouseP:IntPoint = adjuster.getMousePosition();
		var windowP:IntPoint = new IntPoint(Std.int(mouseP.x - pw/2), Std.int(mouseP.y - ph/2));
		var value:Int = adjuster.getValue();
		var valueL:Float;
		if(adjuster.getOrientation() == JAdjuster.VERTICAL){
			valueL = (value - min)/(max - min) * sh;
			windowP.y = Std.int(mouseP.y - (sh - valueL) - insets.top);
		}else{
			valueL = (value - min)/(max - min) * sw;
			windowP.x = Std.int(mouseP.x - valueL - insets.left);
			windowP.y += Std.int(adjuster.getHeight()/4);
		}
		var agp:IntPoint = adjuster.getGlobalLocation();
		agp.move(windowP.x, windowP.y);
		popupWindow.setLocation(agp);
		
		startMousePoint = adjuster.getMousePosition();
		startValue = adjuster.getValue();
		if(adjuster.stage != null){
			adjuster.stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMoveOnSlider, false, 0, true);
			adjuster.addEventListener(Event.REMOVED_FROM_STAGE, __onMouseMoveOnSliderRemovedFromStage, false, 0, true);
		}
	}
	
	function __onMouseMoveOnSliderRemovedFromStage(e:Event):Void{
		adjuster.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMoveOnSlider);
		adjuster.removeEventListener(Event.REMOVED_FROM_STAGE, __onMouseMoveOnSliderRemovedFromStage);
	}
	
	function __onArrowButtonReleased(e:Event):Void{
		if(adjuster.stage != null){
			__onMouseMoveOnSliderRemovedFromStage(null);
		}
		popup.dispose();
		fireActionEvent();
	}
	
	function __onMouseMoveOnSlider(e:MouseEvent):Void{
		var delta:Int = 0;
		var valueDelta:Int = 0;
		var range:Int = adjuster.getMaximum() - adjuster.getMinimum();
		var p:IntPoint = adjuster.getMousePosition();
		if(adjuster.getOrientation() == JAdjuster.VERTICAL){
			delta = -p.y + startMousePoint.y;
			valueDelta = Std.int(delta/(getSliderTrackHeight()) * range);
		}else{
			delta = p.x - startMousePoint.x;
			valueDelta = Std.int(delta/(getSliderTrackWidth()) * range);	
		}
		adjuster.setValue(startValue + valueDelta);
		e.updateAfterEvent();
	}	
	
    function getUnitIncrement():Int{
    	var unit:Int = 0;
    	if(popupSlider.getMinorTickSpacing() >0 ){
    		unit = popupSlider.getMinorTickSpacing();
    	}else if(popupSlider.getMajorTickSpacing() > 0){
    		unit = popupSlider.getMajorTickSpacing();
    	}else{
    		var range:Int = popupSlider.getMaximum() - popupSlider.getMinimum();
    		if(range > 2){
    			unit = Std.int(Math.max(1, Math.round(range/500)));
    		}else{
    			unit = Std.int(range/100);
    		}
    	}
    	return unit;
    }
	
	function getSliderTrackWidth():Int{
		var sliderInsets:Insets = popupSliderUI.getTrackMargin();
		var w:Int = popupSlider.getWidth();
		if(w == 0){
			w = popupSlider.getPreferredWidth();
		}
		return w - sliderInsets.left - sliderInsets.right;
	}
	
	function getSliderTrackHeight():Int{
		var sliderInsets:Insets = popupSliderUI.getTrackMargin();
		var h:Int = popupSlider.getHeight();
		if(h == 0){
			h = popupSlider.getPreferredHeight();
		}
		return h - sliderInsets.top - sliderInsets.bottom;
	}
}
