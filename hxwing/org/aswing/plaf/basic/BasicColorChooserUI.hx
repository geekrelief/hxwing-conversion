/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;  

import Import_flash_events;

import Import_org_aswing;
import org.aswing.border.BevelBorder;
import org.aswing.border.EmptyBorder;
import org.aswing.colorchooser.AbstractColorChooserPanel;
import org.aswing.colorchooser.JColorMixer;
import org.aswing.colorchooser.JColorSwatches;
import org.aswing.colorchooser.PreviewColorIcon;
import org.aswing.event.InteractiveEvent;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import org.aswing.plaf.BaseComponentUI;

/**
 * @author iiley
 * @private
 */
class BasicColorChooserUI extends BaseComponentUI {
	
	
	
	var chooser:JColorChooser;
	var previewColorLabel:JLabel;
	var previewColorIcon:PreviewColorIcon;
	
	public function new(){
		super();		
	}

    function getPropertyPrefix():String {
        return "ColorChooser.";
    }

    public override function installUI(c:Component):Void{
		chooser = cast(c, JColorChooser);
		installDefaults();
		installComponents();
		installListeners();
    }
    
	public override function uninstallUI(c:Component):Void{
		chooser = cast(c, JColorChooser);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
    }
	
	function installDefaults():Void{
		var pp:String = getPropertyPrefix();
        LookAndFeel.installColorsAndFont(chooser, pp);
		LookAndFeel.installBasicProperties(chooser, pp);
        LookAndFeel.installBorderAndBFDecorators(chooser, pp);
	}
    function uninstallDefaults():Void{
    	LookAndFeel.uninstallBorderAndBFDecorators(chooser);
    }	
    
	function installComponents():Void{
		addChooserPanels();
		previewColorLabel = createPreviewColorLabel();
		previewColorLabel.setUIElement(true);
		previewColorIcon = createPreviewColorIcon();
		previewColorLabel.setIcon(previewColorIcon);
		previewColorIcon.setColor(chooser.getSelectedColor());
		
		layoutComponents();
		updateSectionVisibles();
    }
	function uninstallComponents():Void{
		chooser.removeAllChooserPanels();
    }
        
	function installListeners():Void{
		chooser.addEventListener(InteractiveEvent.STATE_CHANGED, __selectedColorChanged);
	}
    function uninstallListeners():Void{
    	chooser.removeEventListener(InteractiveEvent.STATE_CHANGED, __selectedColorChanged);
    }
    
    //------------------------------------------------------------------------------
    
	function __selectedColorChanged(e:Event):Void{
		previewColorIcon.setPreviousColor(previewColorIcon.getCurrentColor());
		previewColorIcon.setCurrentColor(chooser.getSelectedColor());
		previewColorLabel.repaint();
	}

	public override function paint(c:Component, g:Graphics2D, b:IntRectangle):Void{
		super.paint(c, g, b);
		previewColorIcon.setColor(chooser.getSelectedColor());
		previewColorLabel.repaint();
		updateSectionVisibles();
	}
	function updateSectionVisibles():Void{
		for(i in 0...chooser.getChooserPanelCount()){
			var pane:AbstractColorChooserPanel = chooser.getChooserPanelAt(i);
			pane.setAlphaSectionVisible(chooser.isAlphaSectionVisible());
			pane.setHexSectionVisible(chooser.isHexSectionVisible());
			pane.setNoColorSectionVisible(chooser.isNoColorSectionVisible());
		}
	}
	//*******************************************************************************
	//       Override these methods to easiy implement different look
	//*******************************************************************************
	
	function layoutComponents():Void{
		chooser.setLayout(new BorderLayout(6, 6));	
		chooser.append(chooser.getTabbedPane(), BorderLayout.CENTER);
		var bb:BevelBorder = new BevelBorder(new EmptyBorder(null, new Insets(0, 0, 2, 0)), BevelBorder.LOWERED);
		chooser.getTabbedPane().setBorder(bb);
		
		var rightPane:Container = SoftBox.createVerticalBox(6, SoftBoxLayout.TOP);
		chooser.getCancelButton().setMargin(new Insets(0, 5, 0, 5));
		rightPane.append(chooser.getOkButton());
		rightPane.append(chooser.getCancelButton());
		rightPane.append(new JLabel("Old"));
		rightPane.append(AsWingUtils.createPaneToHold(previewColorLabel, new CenterLayout()));
		rightPane.append(new JLabel("Current"));
		chooser.append(rightPane, BorderLayout.WEST);
	}
	
    function addChooserPanels():Void{
    	var colorS:JColorSwatches = new JColorSwatches();
    	var colorM:JColorMixer = new JColorMixer();
    	colorS.setUIElement(true);
    	colorM.setUIElement(true);
    	chooser.addChooserPanel("Color Swatches", colorS);
    	chooser.addChooserPanel("Color Mixer", colorM);
    }
    
	function createPreviewColorIcon():PreviewColorIcon{
		return new PreviewColorIcon(60, 60, PreviewColorIcon.VERTICAL);
	}
	
	function createPreviewColorLabel():JLabel{
		var label:JLabel = new JLabel();
		var bb:BevelBorder = new BevelBorder(null, BevelBorder.LOWERED);
		bb.setThickness(1);
		label.setBorder(bb); 
		return label;
	}
}
