/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;

import flash.display.Shape;
import Import_flash_events;
import flash.ui.Keyboard;

import Import_org_aswing;
import Import_org_aswing_event;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;
import Import_org_aswing_util;

/**
 * Basic slider ui imp.
 * @author iiley
 * @private
 */
class BasicSliderUI extends BaseComponentUI, implements SliderUI {
	
	
	
	var slider:JSlider;
	var thumbIcon:Icon;

	var highlightColor:ASColor;
	var shadowColor:ASColor;
	var darkShadowColor:ASColor;
	var lightColor:ASColor;
	var tickColor:ASColor;
	var progressColor:ASColor;
	
	var trackRect:IntRectangle;
	var trackDrawRect:IntRectangle;
	var tickRect:IntRectangle;
	var thumbRect:IntRectangle;
	
	var offset:Int;
	var isDragging:Bool;
	var scrollIncrement:Int;
	var scrollContinueDestination:Int;
	var scrollTimer:Timer;
	static var scrollSpeedThrottle:Int = 60; // delay in milli seconds
	static var initialScrollSpeedThrottle:Int = 500; // first delay in milli seconds
	
	var progressCanvas:Shape;
	
	public function new(){
		super();
		trackRect   = new IntRectangle();
		tickRect	= new IntRectangle();
		thumbRect   = new IntRectangle();
		trackDrawRect = new IntRectangle();
		offset	  = 0;
		isDragging  = false;
	}
		
	function getPropertyPrefix():String {
		return "Slider.";
	}
		
	public override function installUI(c:Component):Void{
		slider = cast(c, JSlider);
		installDefaults();
		installComponents();
		installListeners();
	}
	
	public override function uninstallUI(c:Component):Void{
		slider = cast(c, JSlider);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
	}
	
	function installDefaults():Void{
		var pp:String = getPropertyPrefix();
		LookAndFeel.installColorsAndFont(slider, pp);
		LookAndFeel.installBasicProperties(slider, pp);
		LookAndFeel.installBorderAndBFDecorators(slider, pp);
		configureSliderColors();
	}
	
	function configureSliderColors():Void{
		var pp:String = getPropertyPrefix();
		highlightColor = getColor(pp+"highlight");
		shadowColor = getColor(pp+"shadow");
		darkShadowColor = getColor(pp+"darkShadow");
		lightColor = getColor(pp+"light");
		
		tickColor = getColor(pp+"tickColor");
		progressColor = getColor(pp+"progressColor");
	}
	
	function uninstallDefaults():Void{
		LookAndFeel.uninstallBorderAndBFDecorators(slider);
	}
	
	function installComponents():Void{
		var pp:String = getPropertyPrefix();
		thumbIcon = getIcon(pp+"thumbIcon");
		if(thumbIcon.getDisplay(slider)==null){
			throw new Error("Slider thumb icon must has its own display object(getDisplay()!=null)!");
		}
		progressCanvas = new Shape();
		slider.addChild(progressCanvas);
		slider.addChild(thumbIcon.getDisplay(slider));
	}
	
	function uninstallComponents():Void{
		slider.removeChild(progressCanvas);
		slider.removeChild(thumbIcon.getDisplay(slider));
		thumbIcon = null;
		progressCanvas = null;
	}
	
	function installListeners():Void{
		slider.addEventListener(MouseEvent.MOUSE_DOWN, __onSliderPress);
		slider.addEventListener(ReleaseEvent.RELEASE, __onSliderReleased);
		slider.addEventListener(MouseEvent.MOUSE_WHEEL, __onSliderMouseWheel);
		slider.addStateListener(__onSliderStateChanged);
		slider.addEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onSliderKeyDown);
		scrollTimer = new Timer(scrollSpeedThrottle);
		scrollTimer.setInitialDelay(initialScrollSpeedThrottle);
		scrollTimer.addActionListener(__scrollTimerPerformed);
	}
	
	function uninstallListeners():Void{
		slider.removeEventListener(MouseEvent.MOUSE_DOWN, __onSliderPress);
		slider.removeEventListener(ReleaseEvent.RELEASE, __onSliderReleased);
		slider.removeEventListener(MouseEvent.MOUSE_WHEEL, __onSliderMouseWheel);
		slider.removeStateListener(__onSliderStateChanged);
		slider.removeEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onSliderKeyDown);
		scrollTimer.stop();
		scrollTimer = null;
	}
	
	function isVertical():Bool{
		return slider.getOrientation() == JSlider.VERTICAL;
	}
	
	public override function paint(c:Component, g:Graphics2D, b:IntRectangle):Void{
		super.paint(c, g, b);
		countTrackRect(b);
		countThumbRect();
		countTickRect(b);
		paintTrack(g, trackDrawRect);
		paintThumb(g, thumbRect);
		paintTick(g, tickRect);
	}
	
	function countTrackRect(b:IntRectangle):Void{
		var thumbSize:IntDimension = getThumbSize();
		var h_margin:Int, v_margin:Int;
		if(isVertical()){
			v_margin = Math.ceil(thumbSize.height/2.0);
			h_margin = Std.int(thumbSize.width/3-1);
			trackDrawRect.setRectXYWH(b.x+h_margin, b.y+v_margin, 
				h_margin+2, b.height-v_margin*2);
			trackRect.setRectXYWH(b.x, b.y+v_margin, 
				thumbSize.width, b.height-v_margin*2);
		}else{
			h_margin = Math.ceil(thumbSize.width/2.0);
			v_margin = Std.int(thumbSize.height/3-1);
			trackDrawRect.setRectXYWH(b.x+h_margin, b.y+v_margin, 
				b.width-h_margin*2, v_margin+2);
			trackRect.setRectXYWH(b.x+h_margin, b.y, 
				b.width-h_margin*2, thumbSize.height);
		}
	}
	
	function countTickRect(b:IntRectangle):Void{
		if(isVertical()){
			tickRect.y = trackRect.y;
			tickRect.x = trackRect.x+trackRect.width+getTickTrackGap();
			tickRect.height = trackRect.height;
			tickRect.width = b.width-trackRect.width-getTickTrackGap();
		}else{
			tickRect.x = trackRect.x;
			tickRect.y = trackRect.y+trackRect.height+getTickTrackGap();
			tickRect.width = trackRect.width;
			tickRect.height = b.height-trackRect.height-getTickTrackGap();
		}
	}
	
	function countThumbRect():Void{
		thumbRect.setSize(getThumbSize());
		if (slider.getSnapToTicks()){
			var sliderValue:Int = slider.getValue();
			var snappedValue:Int = sliderValue; 
			var majorTickSpacing:Int = slider.getMajorTickSpacing();
			var minorTickSpacing:Int = slider.getMinorTickSpacing();
			var tickSpacing:Int = 0;
			if (minorTickSpacing > 0){
				tickSpacing = minorTickSpacing;
			}else if (majorTickSpacing > 0){
				tickSpacing = majorTickSpacing;
			}
			if (tickSpacing != 0){
				// If it's not on a tick, change the value
				if ((sliderValue - slider.getMinimum()) % tickSpacing != 0){
					var temp:Float = (sliderValue - slider.getMinimum()) / tickSpacing;
					var whichTick:Int = Math.round( temp );
					snappedValue = slider.getMinimum() + (whichTick * tickSpacing);
				}
				if(snappedValue != sliderValue){ 
					slider.setValue(snappedValue);
				}
			}
		}
		var valuePosition:Int;
		if (isVertical()) {
			valuePosition = yPositionForValue(slider.getValue());
			thumbRect.x = trackRect.x;
			thumbRect.y = Std.int(valuePosition - (thumbRect.height / 2));
		}else {
			valuePosition = xPositionForValue(slider.getValue());
			thumbRect.x = Std.int(valuePosition - (thumbRect.width / 2));
			thumbRect.y = trackRect.y;
		}
	}
	
	function getThumbSize():IntDimension{
		if(isVertical()){
			return new IntDimension(thumbIcon.getIconHeight(slider), thumbIcon.getIconWidth(slider));
		}else{
			return new IntDimension(thumbIcon.getIconWidth(slider), thumbIcon.getIconHeight(slider));
		}
	}
	
	function countTickSize(sliderRect:IntRectangle):IntDimension{
		if(isVertical()){
			return new IntDimension(getTickLength(), sliderRect.height);
		}else{
			return new IntDimension(sliderRect.width, getTickLength());
		}
	}
	
	/**
	 * Gets the height of the tick area for horizontal sliders and the width of the
	 * tick area for vertical sliders.  BasicSliderUI uses the returned value to
	 * determine the tick area rectangle.  If you want to give your ticks some room,
	 * make this larger than you need and paint your ticks away from the sides in paintTicks().
	 */
	function getTickLength():Int {
		return 10;
	}	
	
	function countTrackAndThumbSize(sliderRect:IntRectangle):IntDimension{
		if(isVertical()){
			return new IntDimension(getThumbSize().width, sliderRect.height);
		}else{
			return new IntDimension(sliderRect.width, getThumbSize().height);
		}
	}
	
	function getTickTrackGap():Int{
		return 2;
	}
	
	public function xPositionForValue(value:Int):Int{
		var min:Int = slider.getMinimum();
		var max:Int = slider.getMaximum();
		var trackLength:Int = trackRect.width;
		var valueRange:Int = max - min;
		var pixelsPerValue:Float = trackLength / valueRange;
		var trackLeft:Int = trackRect.x;
		var trackRight:Int = trackRect.x + (trackRect.width - 0);//0
		var xPosition:Int;

		if ( !slider.getInverted() ) {
			xPosition = trackLeft;
			xPosition += Math.round(pixelsPerValue * (value - min));
		}else {
			xPosition = trackRight;
			xPosition -= Math.round(pixelsPerValue * (value - min));
		}

		xPosition = Std.int(Math.max( trackLeft, xPosition ));
		xPosition = Std.int(Math.min( trackRight, xPosition ));

		return xPosition;
	}

	public function yPositionForValue( value:Int ):Int  {
		var min:Int = slider.getMinimum();
		var max:Int = slider.getMaximum();
		var trackLength:Int = trackRect.height; 
		var valueRange:Int = max - min;
		var pixelsPerValue:Float = trackLength / valueRange;
		var trackTop:Int = trackRect.y;
		var trackBottom:Int = trackRect.y + (trackRect.height - 1);
		var yPosition:Int;

		if ( !slider.getInverted() ) {
			yPosition = trackTop;
			yPosition += Math.round(pixelsPerValue * (max - value));
		}
		else {
			yPosition = trackTop;
			yPosition += Math.round(pixelsPerValue * (value - min));
		}

		yPosition = Std.int(Math.max( trackTop, yPosition ));
		yPosition = Std.int(Math.min( trackBottom, yPosition ));

		return yPosition;
	}	
	
	/**
	 * Returns a value give a y position.  If yPos is past the track at the top or the
	 * bottom it will set the value to the min or max of the slider, depending if the
	 * slider is inverted or not.
	 */
	public function valueForYPosition( yPos:Int ):Int {
		var value:Int;
		var minValue:Int = slider.getMinimum();
		var maxValue:Int = slider.getMaximum();
		var trackLength:Int = trackRect.height;
		var trackTop:Int = trackRect.y;
		var trackBottom:Int = trackRect.y + (trackRect.height - 1);
		var inverted:Bool = slider.getInverted();
		if ( yPos <= trackTop ) {
			value = inverted ? minValue : maxValue;
		}else if ( yPos >= trackBottom ) {
			value = inverted ? maxValue : minValue;
		}else {
			var distanceFromTrackTop:Int = yPos - trackTop;
			var valueRange:Int = maxValue - minValue;
			var valuePerPixel:Float = valueRange / trackLength;
			var valueFromTrackTop:Int = Math.round(distanceFromTrackTop * valuePerPixel);
	
			value = inverted ? minValue + valueFromTrackTop : maxValue - valueFromTrackTop;
		}
		return value;
	}
  
	/**
	 * Returns a value give an x position.  If xPos is past the track at the left or the
	 * right it will set the value to the min or max of the slider, depending if the
	 * slider is inverted or not.
	 */
	public function valueForXPosition( xPos:Int ):Int {
		var value:Int;
		var minValue:Int = slider.getMinimum();
		var maxValue:Int = slider.getMaximum();
		var trackLength:Int = trackRect.width;
		var trackLeft:Int = trackRect.x; 
		var trackRight:Int = trackRect.x + (trackRect.width - 0);//1
		var inverted:Bool = slider.getInverted();
		if ( xPos <= trackLeft ) {
			value = inverted ? maxValue : minValue;
		}else if ( xPos >= trackRight ) {
			value = inverted ? minValue : maxValue;
		}else {
			var distanceFromTrackLeft:Int = xPos - trackLeft;
			var valueRange:Int = maxValue - minValue;
			var valuePerPixel:Float = valueRange / trackLength;
			var valueFromTrackLeft:Int = Math.round(distanceFromTrackLeft * valuePerPixel);
			
			value = inverted ? maxValue - valueFromTrackLeft : minValue + valueFromTrackLeft;
		}
		return value;
	}
	
	//-------------------------
	
	function paintTrack(g:Graphics2D, drawRect:IntRectangle):Void{
		if(!slider.getPaintTrack()){
			return;
		}
		if(slider.isEnabled()){
			BasicGraphicsUtils.paintLoweredBevel(g, drawRect, shadowColor, darkShadowColor, lightColor, highlightColor);
			paintTrackProgress(new Graphics2D(progressCanvas.graphics), drawRect);
		}else{
			g.beginDraw(new Pen(lightColor, 1));
			drawRect.grow(-1, -1);
			g.rectangle(drawRect.x, drawRect.y, drawRect.width, drawRect.height);
			g.endDraw();
		}
	}
	function paintTrackProgress(g:Graphics2D, trackDrawRect:IntRectangle):Void{
		if(!slider.getPaintTrack()){
			return;
		}		
		var rect:IntRectangle = trackDrawRect.clone();
		var width:Int;
		var height:Int;
		var x:Int;
		var y:Int;
		var inverted:Bool = slider.getInverted();
		if(isVertical()){
			width = rect.width-5;
			height = Std.int(thumbRect.y + thumbRect.height/2 - rect.y - 5);
			x = rect.x + 2;
			if(inverted){
				y = rect.y + 2;
			}else{
				height = Std.int(rect.y + rect.height - thumbRect.y - thumbRect.height/2 - 2);
				y = Std.int(thumbRect.y + thumbRect.height/2);
			}
		}else{
			height = rect.height-5;
			if(inverted){
				width = Std.int(rect.x + rect.width - thumbRect.x - thumbRect.width/2 - 2);
				x = Std.int(thumbRect.x + thumbRect.width/2);
			}else{
				width = Std.int(thumbRect.x + thumbRect.width/2 - rect.x - 5);
				x = rect.x + 2;
			}
			y = rect.y + 2;
		}
		g.fillRectangle(new SolidBrush(progressColor), x, y, width, height);		
	}
	
	function paintThumb(g:Graphics2D, drawRect:IntRectangle):Void{
		if(isVertical()){
			thumbIcon.getDisplay(slider).rotation = 90;
			thumbIcon.updateIcon(slider, g, drawRect.x+thumbIcon.getIconHeight(slider), drawRect.y);
		}else{
			thumbIcon.getDisplay(slider).rotation = 0;
			thumbIcon.updateIcon(slider, g, drawRect.x, drawRect.y);
		}
	}
	
	function paintTick(g:Graphics2D, drawRect:IntRectangle):Void{
		if(!slider.getPaintTicks()){
			return;
		}		
		var tickBounds:IntRectangle = drawRect;
		var majT:Int = slider.getMajorTickSpacing();
		var minT:Int = slider.getMinorTickSpacing();
		var max:Int = slider.getMaximum();
		
		g.beginDraw(new Pen(tickColor, 0));
			
		var yPos:Int = 0;
		var value:Int = 0;
		var xPos:Int = 0;
			
		if (isVertical()) {
			xPos = tickBounds.x;
			value = slider.getMinimum();
			yPos = 0;

			if ( minT > 0 ) {
				while ( value <= max ) {
					yPos = yPositionForValue( value );
					paintMinorTickForVertSlider( g, tickBounds, xPos, yPos );
					value += minT;
				}
			}

			if ( majT > 0 ) {
				value = slider.getMinimum();
				while ( value <= max ) {
					yPos = yPositionForValue( value );
					paintMajorTickForVertSlider( g, tickBounds, xPos, yPos );
					value += majT;
				}
			}
		}else {
			yPos = tickBounds.y;
			value = slider.getMinimum();
			xPos = 0;

			if ( minT > 0 ) {
				while ( value <= max ) {
					xPos = xPositionForValue( value );
					paintMinorTickForHorizSlider( g, tickBounds, xPos, yPos );
					value += minT;
				}
			}

			if ( majT > 0 ) {
				value = slider.getMinimum();

				while ( value <= max ) {
					xPos = xPositionForValue( value );
					paintMajorTickForHorizSlider( g, tickBounds, xPos, yPos );
					value += majT;
				}
			}
		}
		g.endDraw();		
	}

	function paintMinorTickForHorizSlider( g:Graphics2D, tickBounds:IntRectangle, x:Int, y:Int ):Void {
		g.line( x, y, x, y+tickBounds.height / 2 - 1);
	}

	function paintMajorTickForHorizSlider( g:Graphics2D, tickBounds:IntRectangle, x:Int, y:Int ):Void {
		g.line( x, y, x, y+tickBounds.height - 2);
	}

	function paintMinorTickForVertSlider( g:Graphics2D, tickBounds:IntRectangle, x:Int, y:Int ):Void {
		g.line( x, y, x+tickBounds.width / 2 - 1, y );
	}

	function paintMajorTickForVertSlider( g:Graphics2D, tickBounds:IntRectangle, x:Int, y:Int ):Void {
		g.line( x, y, x+tickBounds.width - 2, y );
	}
	
	//----------------------------
	
	function __onSliderStateChanged(e:Event):Void{
		if(!isDragging){
			countThumbRect();
			paintThumb(null, thumbRect);
			progressCanvas.graphics.clear();
			paintTrackProgress(new Graphics2D(progressCanvas.graphics), trackDrawRect);
		}
	}
	
	function __onSliderKeyDown(e:FocusKeyEvent):Void{
		if(!slider.isEnabled()){
			return;
		}
		var code:UInt = e.keyCode;
		var unit:Int = getUnitIncrement();
		var block:Int = slider.getMajorTickSpacing() > 0 ? slider.getMajorTickSpacing() : unit*5;
		if(isVertical()){
			unit = -unit;
			block = -block;
		}
		if(slider.getInverted()){
			unit = -unit;
			block = -block;
		}
		if(code == Keyboard.UP || code == Keyboard.LEFT){
			scrollByIncrement(-unit);
		}else if(code == Keyboard.DOWN || code == Keyboard.RIGHT){
			scrollByIncrement(unit);
		}else if(code == Keyboard.PAGE_UP){
			scrollByIncrement(-block);
		}else if(code == Keyboard.PAGE_DOWN){
			scrollByIncrement(block);
		}else if(code == Keyboard.HOME){
			slider.setValue(slider.getMinimum());
		}else if(code == Keyboard.END){
			slider.setValue(slider.getMaximum() - slider.getExtent());
		}
	}
	
	function __onSliderPress(e:Event):Void{
		var mousePoint:IntPoint = slider.getMousePosition();
		if(thumbRect.containsPoint(mousePoint)){
			__startDragThumb();
		}else{
			var inverted:Bool = slider.getInverted();
			var thumbCenterPos:Float;
			if(isVertical()){
				thumbCenterPos = thumbRect.y + thumbRect.height/2;
				if(mousePoint.y > thumbCenterPos){
					scrollIncrement = inverted ? getUnitIncrement() : -getUnitIncrement();
				}else{
					scrollIncrement = inverted ? -getUnitIncrement() : getUnitIncrement();
				}
				scrollContinueDestination = valueForYPosition(mousePoint.y);
			}else{
				thumbCenterPos = thumbRect.x + thumbRect.width/2;
				if(mousePoint.x > thumbCenterPos){
					scrollIncrement = inverted ? -getUnitIncrement() : getUnitIncrement();
				}else{
					scrollIncrement = inverted ? getUnitIncrement() : -getUnitIncrement();
				}
				scrollContinueDestination = valueForXPosition(mousePoint.x);
			}
			scrollTimer.restart();
			__scrollTimerPerformed(null);//run one time immediately first
		}
	}
	function __onSliderReleased(e:Event):Void{
		if(isDragging){
			__stopDragThumb();
		}
		if(scrollTimer.isRunning()){
			scrollTimer.stop();
		}
	}
	function __onSliderMouseWheel(e:MouseEvent):Void{
		if(!slider.isEnabled()){
			return;
		}
		var delta:Int = e.delta;
		if(slider.getInverted()){
			delta = -delta;
		}
		scrollByIncrement(delta*getUnitIncrement());
	}
	
	function __scrollTimerPerformed(e:Event):Void{
		var value:Int = slider.getValue() + scrollIncrement;
		var finished:Bool = false;
		if(scrollIncrement > 0){
			if(value >= scrollContinueDestination){
				finished = true;
			}
		}else{
			if(value <= scrollContinueDestination){
				finished = true;
			}
		}
		if(finished){
			slider.setValue(scrollContinueDestination);
			scrollTimer.stop();
		}else{
			scrollByIncrement(scrollIncrement);
		}
	}	
	
	function scrollByIncrement(increment:Int):Void{
		slider.setValue(slider.getValue() + increment);
	}
	
	function getUnitIncrement():Int{
		var unit:Int = 0;
		if(slider.getMinorTickSpacing() >0 ){
			unit = slider.getMinorTickSpacing();
		}else if(slider.getMajorTickSpacing() > 0){
			unit = slider.getMajorTickSpacing();
		}else{
			var range:Int = slider.getMaximum() - slider.getMinimum();
			if(range > 2){
				unit = Std.int(Math.max(1, Math.round(range/500)));
			}else{
				unit = Std.int(range/100);
			}
		}
		return unit;
	}
	
	function __startDragThumb():Void{
		isDragging = true;
		slider.setValueIsAdjusting(true);
		var mp:IntPoint = slider.getMousePosition();
		var mx:Int = mp.x;
		var my:Int = mp.y;
		var tr:IntRectangle = thumbRect;
		if(isVertical()){
			offset = my - tr.y;
		}else{
			offset = mx - tr.x;
		}
		__startHandleDrag();
	}
	
	function __stopDragThumb():Void{
		__stopHandleDrag();
		if(isDragging){
			isDragging = false;
			countThumbRect();
		}
		slider.setValueIsAdjusting(false);
		offset = 0;
	}
	
	function __startHandleDrag():Void{
		if(slider.stage != null){
			slider.stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMoveThumb, false, 0, true);
			slider.addEventListener(Event.REMOVED_FROM_STAGE, __onMoveThumbRFS, false, 0, true);
			showValueTip();
		}
	}
	function __onMoveThumbRFS(e:Event):Void{
		slider.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMoveThumb);
		slider.removeEventListener(Event.REMOVED_FROM_STAGE, __onMoveThumbRFS);
	}
	function __stopHandleDrag():Void{
		if(slider.stage != null){
			__onMoveThumbRFS(null);
		}
		disposValueTip();
	}
	function __onMoveThumb(e:MouseEvent):Void{
		scrollThumbToCurrentMousePosition();
		showValueTip();
		e.updateAfterEvent();
	}
	
	function showValueTip():Void{
		if(slider.getShowValueTip()){
			var tip:JToolTip = slider.getValueTip();
			tip.setWaitThenPopupEnabled(false);
			tip.setTipText(slider.getValue()+"");
			if(!tip.isShowing()){
				tip.showToolTip();
			}
			tip.moveLocationRelatedTo(slider.componentToGlobal(slider.getMousePosition()));
		}
	}
	
	function disposValueTip():Void{
		if(slider.getValueTip() != null){
			slider.getValueTip().disposeToolTip();
		}
	}
	
	function scrollThumbToCurrentMousePosition():Void{
		var mp:IntPoint = slider.getMousePosition();
		var mx:Int = mp.x;
		var my:Int = mp.y;
		
		var thumbPos:Int, minPos:Int, maxPos:Int;
		var halfThumbLength:Int;
		var sliderValue:Int;
		var paintThumbRect:IntRectangle = thumbRect.clone();
		if(isVertical()){
			halfThumbLength = Std.int(thumbRect.height / 2);
			thumbPos = my - offset;
			if(!slider.getInverted()){
				maxPos = yPositionForValue(slider.getMinimum()) - halfThumbLength;
				minPos = yPositionForValue(slider.getMaximum() - slider.getExtent()) - halfThumbLength;
			}else{
				minPos = yPositionForValue(slider.getMinimum()) - halfThumbLength;
				maxPos = yPositionForValue(slider.getMaximum() - slider.getExtent()) - halfThumbLength;
			}
			thumbPos = Std.int(Math.max(minPos, Math.min(maxPos, thumbPos)));
			sliderValue = valueForYPosition(thumbPos + halfThumbLength);
			slider.setValue(sliderValue);
			thumbRect.y = yPositionForValue(slider.getValue()) - halfThumbLength;
			paintThumbRect.y = thumbPos;
		}else{
			halfThumbLength = Std.int(thumbRect.width / 2);
			thumbPos = mx - offset;
			if(slider.getInverted()){
				maxPos = xPositionForValue(slider.getMinimum()) - halfThumbLength;
				minPos = xPositionForValue(slider.getMaximum() - slider.getExtent()) - halfThumbLength;
			}else{
				minPos = xPositionForValue(slider.getMinimum()) - halfThumbLength;
				maxPos = xPositionForValue(slider.getMaximum() - slider.getExtent()) - halfThumbLength;
			}
			thumbPos = Std.int(Math.max(minPos, Math.min(maxPos, thumbPos)));
			sliderValue = valueForXPosition(thumbPos + halfThumbLength);
			slider.setValue(sliderValue);
			thumbRect.x = xPositionForValue(slider.getValue()) - halfThumbLength;
			paintThumbRect.x = thumbPos;
		}
		paintThumb(null, paintThumbRect);
		progressCanvas.graphics.clear();
		paintTrackProgress(new Graphics2D(progressCanvas.graphics), trackDrawRect);
	}

    public function getTrackMargin():Insets{
    	var b:IntRectangle = slider.getPaintBounds();
    	countTrackRect(b);
    	
    	var insets:Insets = new Insets();
    	insets.top = trackRect.y - b.y;
    	insets.bottom = b.y + b.height - trackRect.y - trackRect.height;
    	insets.left = trackRect.x - b.x;
    	insets.right = b.x + b.width - trackRect.x - trackRect.width;
    	return insets;
    }	
	
	//---------------------
	
	function getPrefferedLength():Int{
		return 200;
	}
		
    public override function getPreferredSize(c:Component):IntDimension{
    	var size:IntDimension;
    	var thumbSize:IntDimension = getThumbSize();
    	var tickLength:Int = this.getTickLength();
    	var gap:Int = this.getTickTrackGap();
    	var wide:Int = slider.getPaintTicks() ? gap+tickLength : 0;
    	if(isVertical()){
    		wide += thumbSize.width;
    		size = new IntDimension(wide, Std.int(Math.max(wide, getPrefferedLength())));
    	}else{
    		wide += thumbSize.height;
    		size = new IntDimension(Std.int(Math.max(wide, getPrefferedLength())), wide);
    	}
    	return c.getInsets().getOutsideSize(size);
    }

    public override function getMaximumSize(c:Component):IntDimension{
		return IntDimension.createBigDimension();
    }

	public override function getMinimumSize(c:Component):IntDimension{
    	var size:IntDimension;
    	var thumbSize:IntDimension = getThumbSize();
    	var tickLength:Int = this.getTickLength();
    	var gap:Int = this.getTickTrackGap();
    	var wide:Int = slider.getPaintTicks() ? gap+tickLength : 0;
    	if(isVertical()){
    		wide += thumbSize.width;
    		size = new IntDimension(wide, thumbSize.height);
    	}else{
    		wide += thumbSize.height;
    		size = new IntDimension(thumbSize.width, wide);
    	}
    	return c.getInsets().getOutsideSize(size);
    }    	
}
