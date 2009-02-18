package org.aswing;

import flash.events.Event;

import org.aswing.event.AWEvent;
import org.aswing.event.FrameEvent;
import org.aswing.event.InteractiveEvent;
import org.aswing.event.WindowEvent;
import org.aswing.plaf.UIResource;

/**
 * The default Imp of FrameTitleBar
 */
class JFrameTitleBar extends Container, implements FrameTitleBar, implements UIResource {
	
	
	
	var iconifiedButton:AbstractButton;
	var maximizeButton:AbstractButton;
	var restoreButton:AbstractButton;
	var closeButton:AbstractButton;
	var activeTextColor:ASColor;
	var inactiveTextColor:ASColor;
	var titleLabel:JLabel;
	var icon:Icon;
	var text:String;
	var titleEnabled:Bool;
	
	var buttonPane:Container;
	var buttonPaneLayout:SoftBoxLayout;
	
	var owner:JWindow;
	var frame:JFrame;
	
	public function new(){
		super();
		titleEnabled = true;
		setLayout(new FrameTitleBarLayout());
		
		buttonPane = new Container();
		buttonPane.setCachePreferSizes(false);
		buttonPaneLayout = new SoftBoxLayout(SoftBoxLayout.X_AXIS, 0);
		buttonPane.setLayout(buttonPaneLayout);
		titleLabel = new JLabel();
		titleLabel.mouseEnabled = false;
		titleLabel.mouseChildren = false;
		titleLabel.setHorizontalAlignment(JLabel.LEFT);
		append(titleLabel, BorderLayout.CENTER);
		append(buttonPane, BorderLayout.EAST);
		
		setIconifiedButton(createIconifiedButton());
		setMaximizeButton(createMaximizeButton());
		setRestoreButton(createRestoreButton());
		setCloseButton(createCloseButton());
		setMaximizeButtonVisible(false);
		buttonPane.appendAll([iconifiedButton, restoreButton, maximizeButton, closeButton]);
		
		setUIElement(true);
		addEventListener(AWEvent.PAINT, __framePainted);
	}
	
	function createPureButton():JButton{
		var b:JButton = new JButton();
		b.setBackgroundDecorator(null);
		b.setMargin(new Insets());
		return b;
	}
	
	function createIconifiedButton():AbstractButton{
		return createPureButton();
	}
	
	function createMaximizeButton():AbstractButton{
		return createPureButton();
	}
	
	function createRestoreButton():AbstractButton{
		return createPureButton();
	}
	
	function createCloseButton():AbstractButton{
		return createPureButton();
	}
	
	public function updateUIPropertiesFromOwner():Void{
		if(getIconifiedButton() != null){
			getIconifiedButton().setIcon(getFrameIcon("Frame.iconifiedIcon"));
		}
		if(getMaximizeButton() != null){
			getMaximizeButton().setIcon(getFrameIcon("Frame.maximizeIcon"));
		}
		if(getRestoreButton() != null){
			getRestoreButton().setIcon(getFrameIcon("Frame.normalIcon"));
		}
		if(getCloseButton() != null){
			getCloseButton().setIcon(getFrameIcon("Frame.closeIcon"));
		}
		
		activeTextColor     = getFrameUIColor("Frame.activeCaptionText");
		inactiveTextColor   = getFrameUIColor("Frame.inactiveCaptionText"); 	
		setBackgroundDecorator(getTitleBGD("Frame.titleBarBG"));
		buttonPaneLayout.setGap(getFrameUIInt("Frame.titleBarButtonGap"));
		revalidateIfNecessary();
		__activeChange(null);
		__framePainted(null);
	}
	
	function getFrameIcon(key:String):Icon{
		if(owner.getUI() != null){
			return owner.getUI().getIcon(key);
		}else{
			return UIManager.getIcon(key);
		}
	}
	
	function getTitleBGD(key:String):GroundDecorator{
		if(owner.getUI() != null){
			return owner.getUI().getGroundDecorator(key);
		}else{
			return UIManager.getGroundDecorator(key);
		}
	}
	
	function getFrameUIInt(key:String):Int{
		if(owner.getUI() != null){
			return owner.getUI().getInt(key);
		}else{
			return UIManager.getInt(key);
		}
	}
	
	function getFrameUIColor(key:String):ASColor{
		if(owner.getUI() != null){
			return owner.getUI().getColor(key);
		}else{
			return UIManager.getColor(key);
		}
	}
	
	public function getSelf():Component{
		return this;
	}
	
	public function setFrame(f:JWindow):Void{
		if(owner != null){
			owner.removeEventListener(FrameEvent.FRAME_ABILITY_CHANGED, __frameAbilityChanged);
			owner.removeEventListener(AWEvent.PAINT, __framePainted);
			owner.removeEventListener(InteractiveEvent.STATE_CHANGED, __stateChanged);
			owner.removeEventListener(WindowEvent.WINDOW_ACTIVATED, __activeChange);
			owner.removeEventListener(WindowEvent.WINDOW_DEACTIVATED, __activeChange);
		}
		owner = f;
		frame = cast( f, JFrame);
		if(owner != null){
			owner.addEventListener(FrameEvent.FRAME_ABILITY_CHANGED, __frameAbilityChanged, false, 0, true);
			owner.addEventListener(AWEvent.PAINT, __framePainted, false, 0, true);
			owner.addEventListener(InteractiveEvent.STATE_CHANGED, __stateChanged, false, 0, true);
			owner.addEventListener(WindowEvent.WINDOW_ACTIVATED, __activeChange, false, 0, true);
			owner.addEventListener(WindowEvent.WINDOW_DEACTIVATED, __activeChange, false, 0, true);
			
			updateUIPropertiesFromOwner();
		}
		__stateChanged(null);
	}
	
	public function getFrame():JWindow{
		return owner;
	}
	
	public function setTitleEnabled(b:Bool):Void{
		titleEnabled = b;
	}
	
	public function isTitleEnabled():Bool{
		return titleEnabled;
	}
		
	public function addExtraControl(c:Component, position:Int):Void{
		if(position == AsWingConstants.LEFT){
			buttonPane.insert(0, c);
		}else{
			buttonPane.append(c);
		}
	}
	
	public function removeExtraControl(c:Component):Component{
		return buttonPane.remove(c);
	}
	
	public function getLabel():JLabel{
		return titleLabel;
	}
	
	public function setIcon(i:Icon):Void{
		icon = i;
		if(titleLabel != null){
			titleLabel.setIcon(i);
		}
	}
	
	public function getIcon():Icon{
		return icon;
	}
	
	public function setText(t:String):Void{
		text = t;
		if(titleLabel != null){
			titleLabel.setText(t);
		}
	}
	
	public function getText():String{
		return text;
	}
	
	public function setIconifiedButton(b:AbstractButton):Void{
		if(iconifiedButton != b){
			var index:Int = -1;
			if(iconifiedButton != null){
				index = buttonPane.getIndex(iconifiedButton);
				buttonPane.removeAt(index);
				iconifiedButton.removeActionListener(__iconifiedPressed);
			}
			iconifiedButton = b;
			if(iconifiedButton != null){
				buttonPane.insert(index, iconifiedButton);
				iconifiedButton.addActionListener(__iconifiedPressed);
			}
		}
	}
	
	public function setMaximizeButton(b:AbstractButton):Void{
		if(maximizeButton != b){
			var index:Int = -1;
			if(maximizeButton != null){
				index = buttonPane.getIndex(maximizeButton);
				buttonPane.removeAt(index);
				maximizeButton.removeActionListener(__maximizePressed);
			}
			maximizeButton = b;
			if(maximizeButton != null){
				buttonPane.insert(index, maximizeButton);
				maximizeButton.addActionListener(__maximizePressed);
			}
		}
	}
	
	public function setRestoreButton(b:AbstractButton):Void{
		if(restoreButton != b){
			var index:Int = -1;
			if(restoreButton != null){
				index = buttonPane.getIndex(restoreButton);
				buttonPane.removeAt(index);
				restoreButton.removeActionListener(__restorePressed);
			}
			restoreButton = b;
			if(restoreButton != null){
				buttonPane.insert(index, restoreButton);
				restoreButton.addActionListener(__restorePressed);
			}
		}
	}
	
	public function setCloseButton(b:AbstractButton):Void{
		if(closeButton != b){
			var index:Int = -1;
			if(closeButton != null){
				index = buttonPane.getIndex(closeButton);
				buttonPane.removeAt(index);
				closeButton.removeActionListener(__closePressed);
			}
			closeButton = b;
			if(closeButton != null){
				buttonPane.insert(index, closeButton);
				closeButton.addActionListener(__closePressed);
			}
		}
	}
	
	public function getIconifiedButton():AbstractButton{
		return iconifiedButton;
	}
	
	public function getMaximizeButton():AbstractButton{
		return maximizeButton;
	}
	
	public function getRestoreButton():AbstractButton{
		return restoreButton;
	}
	
	public function getCloseButton():AbstractButton{
		return closeButton;
	}
	
	public function setIconifiedButtonVisible(b:Bool):Void{
		if(getIconifiedButton() != null){
			getIconifiedButton().setVisible(b);
		}
	}
	
	public function setMaximizeButtonVisible(b:Bool):Void{
		if(getMaximizeButton() != null){
			getMaximizeButton().setVisible(b);
		}
	}
	
	public function setRestoreButtonVisible(b:Bool):Void{
		if(getRestoreButton() != null){
			getRestoreButton().setVisible(b);
		}
	}
	
	public function setCloseButtonVisible(b:Bool):Void{
		if(getCloseButton() != null){
			getCloseButton().setVisible(b);
		}
	}
	
	function __iconifiedPressed(e:Event):Void{
		if(frame != null && isTitleEnabled()){
			frame.setState(JFrame.ICONIFIED, false);
		}
	}
	
	function __maximizePressed(e:Event):Void{
		if(frame != null && isTitleEnabled()){
			frame.setState(JFrame.MAXIMIZED, false);
		}
	}
	
	function __restorePressed(e:Event):Void{
		if(frame != null && isTitleEnabled()){
			frame.setState(JFrame.NORMAL, false);
		}
	}
	
	function __closePressed(e:Event):Void{
		if(frame != null && isTitleEnabled()){
			frame.closeReleased();
		}
	}
	
	function __activeChange(e:Event):Void{
		if(getLabel() != null){
			getLabel().setForeground(owner.isActive() ? activeTextColor : inactiveTextColor);
			getLabel().repaint();
		}
		repaint();
	}
	
	function __framePainted(e:AWEvent):Void{
		if(getLabel() != null){
			getLabel().setFont(owner.getFont());
		}
	}
	
	function __frameAbilityChanged(e:FrameEvent):Void{
		__stateChanged(null);
	}
	
	function __stateChanged(e:InteractiveEvent):Void{
		if(frame == null){
			return;
		}
		var state:Int = frame.getState();
		if(state != JFrame.ICONIFIED 
			&& state != JFrame.NORMAL
			&& state != JFrame.MAXIMIZED_HORIZ
			&& state != JFrame.MAXIMIZED_VERT
			&& state != JFrame.MAXIMIZED){
			state = JFrame.NORMAL;
		}
		if(state == JFrame.ICONIFIED){
			setIconifiedButtonVisible(false);
			setMaximizeButtonVisible(false);
			setRestoreButtonVisible(true);
			setCloseButtonVisible(frame.isClosable());
		}else if(state == JFrame.NORMAL){
			setIconifiedButtonVisible(frame.isResizable());
			setRestoreButtonVisible(false);
			setMaximizeButtonVisible(frame.isResizable());
			setCloseButtonVisible(frame.isClosable());
		}else{
			setIconifiedButtonVisible(frame.isResizable());
			setRestoreButtonVisible(frame.isResizable());
			setMaximizeButtonVisible(false);
			setCloseButtonVisible(frame.isClosable());
		}
		revalidateIfNecessary();
	}
}
