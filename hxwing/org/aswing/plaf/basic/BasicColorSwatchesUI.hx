/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package org.aswing.plaf.basic;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.text.TextField;
import flash.ui.Mouse;

import Import_org_aswing;
import org.aswing.border.BevelBorder;
import Import_org_aswing_colorchooser;
import Import_org_aswing_event;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;

/**
 * @private
 */
class BasicColorSwatchesUI extends BaseComponentUI, implements ColorSwatchesUI {
	
	
	
	var colorSwatches:JColorSwatches;
	var selectedColorLabel:JLabel;
	var selectedColorIcon:ColorRectIcon;
	var colorHexText:JTextField;
	var alphaAdjuster:JAdjuster;
	var noColorButton:AbstractButton;
	var colorTilesPane:JPanel;
	var topBar:Container;
	var barLeft:Container;
	var barRight:Container;
	var selectionRectMC:AWSprite;
	
	public function new(){
		super();		
	}
    
    function getPropertyPrefix():String{
    	return "ColorSwatches.";
    }

    public override function installUI(c:Component):Void{
		colorSwatches = cast(c, JColorSwatches);
		installDefaults();
		installComponents();
		installListeners();
    }
    
	public override function uninstallUI(c:Component):Void{
		colorSwatches = cast(c, JColorSwatches);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
    }
	
	function installDefaults():Void{
		var pp:String = getPropertyPrefix();
        LookAndFeel.installColorsAndFont(colorSwatches, pp);
		LookAndFeel.installBasicProperties(colorSwatches, pp);
        LookAndFeel.installBorderAndBFDecorators(colorSwatches, pp);
	}
    function uninstallDefaults():Void{
    	LookAndFeel.uninstallBorderAndBFDecorators(colorSwatches);
    }	
    
	function installComponents():Void{
		selectedColorLabel = createSelectedColorLabel();
		selectedColorIcon = createSelectedColorIcon();
		selectedColorLabel.setIcon(selectedColorIcon);
		
		colorHexText = createHexText();
		alphaAdjuster = createAlphaAdjuster();
		noColorButton = createNoColorButton();
		colorTilesPane = createColorTilesPane();
		
		topBar = new JPanel(new BorderLayout());
		barLeft = SoftBox.createHorizontalBox(2, SoftBoxLayout.LEFT);
		barRight = SoftBox.createHorizontalBox(2, SoftBoxLayout.RIGHT);
		topBar.append(barLeft, BorderLayout.WEST);
		topBar.append(barRight, BorderLayout.EAST);
		
		barLeft.append(selectedColorLabel);
		barLeft.append(colorHexText);
		barRight.append(alphaAdjuster);
		barRight.append(noColorButton);
		
		topBar.setUIElement(true);
		colorTilesPane.setUIElement(true);
		
		colorSwatches.setLayout(new BorderLayout(4, 4));
		colorSwatches.append(topBar, BorderLayout.NORTH);
		colorSwatches.append(colorTilesPane, BorderLayout.CENTER);
		createTitles();
		updateSectionVisibles();
    }
	function uninstallComponents():Void{
		colorSwatches.remove(topBar);
		colorSwatches.remove(colorTilesPane);
    }
        
	function installListeners():Void{
		noColorButton.addActionListener(__noColorButtonAction);

		colorSwatches.addEventListener(InteractiveEvent.STATE_CHANGED, __colorSelectionChanged);
		colorSwatches.addEventListener(AWEvent.HIDDEN, __colorSwatchesUnShown);
		
		colorTilesPane.addEventListener(MouseEvent.ROLL_OVER, __colorTilesPaneRollOver);
		colorTilesPane.addEventListener(MouseEvent.ROLL_OUT, __colorTilesPaneRollOut);
		colorTilesPane.addEventListener(DragAndDropEvent.DRAG_EXIT, __colorTilesPaneRollOut);
		colorTilesPane.addEventListener(MouseEvent.MOUSE_UP, __colorTilesPaneReleased);
		
		colorHexText.addActionListener(__hexTextAction);
		colorHexText.getTextField().addEventListener(Event.CHANGE, __hexTextChanged);
		
		alphaAdjuster.addStateListener(__adjusterValueChanged);
		alphaAdjuster.addActionListener(__adjusterAction);
	}
    function uninstallListeners():Void{
    	noColorButton.removeActionListener(__noColorButtonAction);
    	
    	colorSwatches.removeEventListener(InteractiveEvent.STATE_CHANGED, __colorSelectionChanged);
    	colorSwatches.removeEventListener(AWEvent.HIDDEN, __colorSwatchesUnShown);
    	colorSwatches.removeEventListener(MouseEvent.MOUSE_MOVE, __colorTilesPaneMouseMove); 
    	
		colorTilesPane.removeEventListener(MouseEvent.ROLL_OVER, __colorTilesPaneRollOver);
		colorTilesPane.removeEventListener(MouseEvent.ROLL_OUT, __colorTilesPaneRollOut);
		colorTilesPane.removeEventListener(DragAndDropEvent.DRAG_EXIT, __colorTilesPaneRollOut);
		colorTilesPane.removeEventListener(MouseEvent.MOUSE_UP, __colorTilesPaneReleased);   
		
		colorHexText.removeActionListener(__hexTextAction);
		colorHexText.getTextField().removeEventListener(Event.CHANGE, __hexTextChanged);	
		
		alphaAdjuster.removeStateListener(__adjusterValueChanged);
		alphaAdjuster.removeActionListener(__adjusterAction);		
    }
    
    //------------------------------------------------------------------------------
    function __adjusterValueChanged(e:Event):Void{
		updateSelectedColorLabelColor(getColorFromHexTextAndAdjuster());
    }
    function __adjusterAction(e:Event):Void{
    	colorSwatches.setSelectedColor(getColorFromHexTextAndAdjuster());
    }
    
    function __hexTextChanged(e:Event):Void{
		updateSelectedColorLabelColor(getColorFromHexTextAndAdjuster());
    }
    function __hexTextAction(e:Event):Void{
    	colorSwatches.setSelectedColor(getColorFromHexTextAndAdjuster());
    }
    
    function __colorTilesPaneRollOver(e:Event):Void{
    	colorSwatches.removeEventListener(MouseEvent.MOUSE_MOVE, __colorTilesPaneMouseMove);
    	colorSwatches.addEventListener(MouseEvent.MOUSE_MOVE, __colorTilesPaneMouseMove);
    	
    }
    function __colorTilesPaneRollOut(e:Event):Void{
    	stopMouseMovingSelection();
    }
    var lastOutMoving:Bool;
    function __colorTilesPaneMouseMove(e:Event):Void{
    	var p:IntPoint = colorTilesPane.getMousePosition();
    	var color:ASColor = getColorWithPosAtColorTilesPane(p);
    	if(color != null){
    		var sp:IntPoint = getSelectionRectPos(p);
    		selectionRectMC.visible = true;
    		selectionRectMC.x = sp.x;
    		selectionRectMC.y = sp.y;
			updateSelectedColorLabelColor(color);
			fillHexTextWithColor(color);
    		lastOutMoving = false;
    		//updateAfterEvent();
    	}else{
    		color = colorSwatches.getSelectedColor();
    		selectionRectMC.visible = false;
    		if(lastOutMoving != true){
				updateSelectedColorLabelColor(color);
				fillHexTextWithColor(color);
    		}
    		lastOutMoving = true;
    	}
    }
    function __colorTilesPaneReleased(e:MouseEvent):Void{
    	var p:IntPoint = new IntPoint(Std.int(e.localX), Std.int(e.localY));//colorTilesPane.getMousePosition();
    	var color:ASColor = getColorWithPosAtColorTilesPane(p);
    	if(color != null){
    		colorSwatches.setSelectedColor(color);
    	}
    }
    
    function __noColorButtonAction(e:AWEvent):Void{
    	colorSwatches.setSelectedColor(null);
    }
    
    var colorTilesMC:AWSprite;
	function createTitles():Void{
		colorTilesMC = new AWSprite();
		selectionRectMC = new AWSprite();
		colorTilesPane.addChild(colorTilesMC);
		colorTilesPane.addChild(selectionRectMC);
		paintColorTiles();
		paintSelectionRect();
		selectionRectMC.visible = false;
	}
	
	function __colorSelectionChanged(e:Event):Void{
		var color:ASColor = colorSwatches.getSelectedColor();
		fillHexTextWithColor(color);
		fillAlphaAdjusterWithColor(color);
		updateSelectedColorLabelColor(color);
	}
	function __colorSwatchesUnShown(e:Event):Void{
		stopMouseMovingSelection();
	}
	function stopMouseMovingSelection():Void{
		colorSwatches.removeEventListener(MouseEvent.MOUSE_MOVE, __colorTilesPaneMouseMove);
		selectionRectMC.visible = false;
		var color:ASColor = colorSwatches.getSelectedColor();
		updateSelectedColorLabelColor(color);
		fillHexTextWithColor(color);
	}
	
	//-----------------------------------------------------------------------
	public override function paint(c:Component, g:Graphics2D, b:IntRectangle):Void{
		super.paint(c, g, b);
		updateSectionVisibles();
		updateSelectedColorLabelColor(colorSwatches.getSelectedColor());
		fillHexTextWithColor(colorSwatches.getSelectedColor());
	}
	function updateSectionVisibles():Void{
		colorHexText.setVisible(colorSwatches.isHexSectionVisible());
		alphaAdjuster.setVisible(colorSwatches.isAlphaSectionVisible());
		noColorButton.setVisible(colorSwatches.isNoColorSectionVisible());
	}
    
	//*******************************************************************************
	//      Data caculating methods
	//******************************************************************************
    function getColorFromHexTextAndAdjuster():ASColor{
    	var text:String = colorHexText.getText();
    	if(text.charAt(0) == "#"){
    		text = text.substr(1);
    	}
    	var rgb:Int = Std.parseInt("0x" + text);
    	return new ASColor(rgb, alphaAdjuster.getValue()/100);
    }
    var hexTextColor:ASColor;
    function fillHexTextWithColor(color:ASColor):Void{
    	if (color == null){
    		 hexTextColor = color;
	    	colorHexText.setText("#000000");
    	}else if(!color.equals(hexTextColor)){
	    	hexTextColor = color;
	    	var hex:String = StringTools.hex(color.getRGB(), 6);
            /*
	    	var i:Int=6-hex.length;
	    	while (i>0){
	    		hex = "0" + hex;
	    		i--;
	    	}
            */
	    	hex = "#" + hex.toUpperCase();
	    	colorHexText.setText(hex);
    	}
    }
    function fillAlphaAdjusterWithColor(color:ASColor):Void{
    	var alpha:Int = (color == null ? 100 : Std.int(color.getAlpha()*100));
		//alphaAdjuster.setValue(alpha*100);
		alphaAdjuster.setValue(alpha);
    }
    
    function isEqualsToSelectedIconColor(color:ASColor):Bool{
		if(color == null){
			return selectedColorIcon.getColor() == null;
		}else{
			return color.equals(selectedColorIcon.getColor());
		}
	}
    function updateSelectedColorLabelColor(color:ASColor):Void{
    	if(!isEqualsToSelectedIconColor(color)){
	    	selectedColorIcon.setColor(color);
	    	selectedColorLabel.repaint();
	    	colorSwatches.getModel().fireColorAdjusting(color);
    	}
    }
    function getSelectionRectPos(p:IntPoint):IntPoint{
    	var L:Int = getTileL();
    	return new IntPoint(Math.floor(p.x/L)*L, Math.floor(p.y/L)*L);
    }
    //if null returned means not in color tiles bounds
    function getColorWithPosAtColorTilesPane(p:IntPoint):ASColor{
    	var L:Int = getTileL();
    	var size:IntDimension = getColorTilesPaneSize();
    	if(p.x < 0 || p.y < 0 || p.x >= size.width || p.y >= size.height){
    		return null;
    	}
    	var alpha:Float = alphaAdjuster.getValue()/100;
    	if(p.x < L){
    		var index:Int = Math.floor(p.y/L);
    		index = Std.int(Math.max(0, Math.min(11, index)));
    		return new ASColor(getLeftColumColors()[index], alpha);
    	}
    	if(p.x < L*2){
    		return new ASColor(0x000000, alpha);
    	}
    	var x:Int = p.x - L*2;
    	var y:Int = p.y;
    	var bigTile:Int = (L*6);
    	var tx:Int = Math.floor(x/bigTile);
    	var ty:Int = Math.floor(y/bigTile);
    	var ti:Int = ty*3 + tx;
    	var xi:Int = Math.floor((x - tx*bigTile)/L);
    	var yi:Int = Math.floor((y - ty*bigTile)/L);
    	return getTileColorByTXY(ti, xi, yi, alpha);
    }
    function getLeftColumColors():Array<Dynamic>{
    	return [0x000000, 0x333333, 0x666666, 0x999999, 0xCCCCCC, 0xFFFFFF, 
							  0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF];
    }
    function getTileColorByTXY(t:Float, x:Float, y:Float, ?alpha:Float=1):ASColor{
		var rr:Int = Std.int(0x33*t);
		var gg:Int = Std.int(0x33*x);
		var bb:Int = Std.int(0x33*y);
		var c:ASColor = ASColor.getASColor(rr, gg, bb, alpha);
		return c;
    }
	function paintColorTiles():Void{
		var g:Graphics2D = new Graphics2D(colorTilesMC.graphics);	
		var startX:Int = 0;
		var startY:Int = 0;
		var L:Int = getTileL();
		var leftLine:Array<Dynamic> = getLeftColumColors();
		for(y in 0...6*2){
			fillRect(g, startX, startY+y*L, new ASColor(leftLine[y]));
		}
		startX += L;
		for(y2 in 0...6*2){
			fillRect(g, startX, startY+y2*L, ASColor.BLACK);
		}
		startX += L;		
		
		for(t in 0...6){
			for(x in 0...6){
				for(y3 in 0...6){
					var c:ASColor = getTileColorByTXY(t, x, y3);
					fillRect(g, 
							 startX + (t%3)*(6*L) + x*L, 
							 startY + Math.floor(t/3)*(6*L) + y3*L, 
							 c);
				}
			}
		}
	}
	function paintSelectionRect():Void{
		var g:Graphics2D = new Graphics2D(selectionRectMC.graphics);
		g.drawRectangle(new Pen(ASColor.WHITE, 0), 0, 0, getTileL(), getTileL());
	}
	
	function fillRect(g:Graphics2D, x:Float, y:Float, c:ASColor):Void{
		g.beginDraw(new Pen(ASColor.BLACK, 0));
		g.beginFill(new SolidBrush(c));
		g.rectangle(x, y, getTileL(), getTileL());
		g.endFill();
		g.endDraw();
	}
	function getColorTilesPaneSize():IntDimension{
		return new IntDimension((3*6+2)*getTileL(), (2*6)*getTileL());
	}
	
	function getTileL():Int{
		return 12;
	}
    
	//*******************************************************************************
	//              Override these methods to easiy implement different look
	//******************************************************************************
	public function addComponentColorSectionBar(com:Component):Void{
		barRight.append(com);
	}	
	
	function createSelectedColorLabel():JLabel{
		var label:JLabel = new JLabel();
		var bb:BevelBorder = new BevelBorder(null, BevelBorder.LOWERED);
		bb.setThickness(1);
		label.setBorder(bb); 
		return label;
	}
	
	function createSelectedColorIcon():ColorRectIcon{
		return new ColorRectIcon(38, 18, colorSwatches.getSelectedColor());
	}
	
	function createHexText():JTextField{
		return new JTextField("#FFFFFF", 6);
	}
	
	function createAlphaAdjuster():JAdjuster{
		var adjuster:JAdjuster = new JAdjuster(4, JAdjuster.VERTICAL);
		adjuster.setValueTranslator(
			function(value:Float):String{
				return Math.round(value) + "%";
			});
		adjuster.setValues(100, 0, 0, 100);
		return adjuster;
	}
	function createNoColorButton():AbstractButton{
		return new JButton("", new NoColorIcon(16, 16));
	}
	function createColorTilesPane():JPanel{
		var p:JPanel = new JPanel();
		p.setBorder(null); //ensure there is no border there
    	var size:IntDimension = getColorTilesPaneSize();
    	size.change(1, 1);
		p.setPreferredSize(size);
		p.mouseChildren = false;
		return p;
	}
}
