/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;
	
import Import_flash_text;
import Import_org_aswing;
import org.aswing.event.InteractiveEvent;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;
import org.aswing.plaf.basic.background.ProgressBarIcon;
import org.aswing.util.DepthManager;

/**
 * @private
 */
class BasicProgressBarUI extends BaseComponentUI {
	
	
	
	var iconDecorator:GroundDecorator;
	var stringText:TextField;
	var stateListener:Dynamic;
	var progressBar:JProgressBar;
	
	public function new() {
		super();
	}

    function getPropertyPrefix():String {
        return "ProgressBar.";
    }    	

	public override function installUI(c:Component):Void{
		progressBar = cast(c, JProgressBar);
		installDefaults();
		installComponents();
		installListeners();
	}
	
	public override function uninstallUI(c:Component):Void{
		progressBar = cast(c, JProgressBar);		
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
	}
	
	function installDefaults():Void{
		var pp:String = getPropertyPrefix();
		LookAndFeel.installColorsAndFont(progressBar, pp);
		LookAndFeel.installBasicProperties(progressBar, pp);
		LookAndFeel.installBorderAndBFDecorators(progressBar, pp);
		if(!progressBar.isIndeterminateDelaySet()){
			progressBar.setIndeterminateDelay(getUint(pp + "indeterminateDelay"));
			progressBar.setIndeterminateDelaySet(false);
		}
	}
	
	function uninstallDefaults():Void{
		LookAndFeel.uninstallBorderAndBFDecorators(progressBar);
	}
	
	function installComponents():Void{
		stringText = new TextField();
		stringText.autoSize = TextFieldAutoSize.CENTER;
		stringText.mouseEnabled = false;
		stringText.tabEnabled = false;
		stringText.selectable = false;
		progressBar.addChild(stringText);
	}
	
	function uninstallComponents():Void{
		if(stringText.parent != null) {
    		stringText.parent.removeChild(stringText);
		}
		stringText = null;
		iconDecorator = null;
	}
	
	function installListeners():Void{
		progressBar.addEventListener(InteractiveEvent.STATE_CHANGED, __stateChanged);
	}
	function uninstallListeners():Void{
		progressBar.removeEventListener(InteractiveEvent.STATE_CHANGED, __stateChanged);
	}
	
	function __stateChanged(source:JProgressBar):Void{
		source.repaint();
	}
	
    public override function paint(c:Component, g:Graphics2D, b:IntRectangle):Void{
		super.paint(c, g, b);
		var sp:JProgressBar = cast(c, JProgressBar);
		if(sp.getString() != null && sp.getString().length>0){
			stringText.text = sp.getString();
	    	AsWingUtils.applyTextFontAndColor(stringText, sp.getFont(), sp.getForeground());
			
			if (sp.getOrientation() == JProgressBar.VERTICAL){
				//TODO use bitmap to achieve rotate
				stringText.rotation = -90;
				stringText.x = Math.round(b.x + (b.width - stringText.width)/2);
				stringText.y = Math.round(b.y + (b.height - stringText.height)/2 + stringText.height);
			}else{
				stringText.rotation = 0;
				stringText.x = Math.round(b.x + (b.width - stringText.width)/2);
				stringText.y = Math.round(b.y + (b.height - stringText.height)/2);
			}
			DepthManager.bringToTop(stringText);
		}else{
			stringText.text = "";
		}
	}

    //--------------------------Dimensions----------------------------
    
	public override function getPreferredSize(c:Component):IntDimension{
		var sp:JProgressBar = cast(c, JProgressBar);
		var size:IntDimension;
		if (sp.getOrientation() == JProgressBar.VERTICAL){
			size = getPreferredInnerVertical();
		}else{
			size = getPreferredInnerHorizontal();
		}
		
		if(sp.getString() != null){
			var textSize:IntDimension = c.getFont().computeTextSize(sp.getString(), false);
			if (sp.getOrientation() == JProgressBar.VERTICAL){
				size.width = Std.int(Math.max(size.width, textSize.height));
				size.height = Std.int(Math.max(size.height, textSize.width));
			}else{
				size.width = Std.int(Math.max(size.width, textSize.width));
				size.height = Std.int(Math.max(size.height, textSize.height));
			}
		}
		return sp.getInsets().getOutsideSize(size);
	}
    public override function getMaximumSize(c:Component):IntDimension{
		return IntDimension.createBigDimension();
    }
    public override function getMinimumSize(c:Component):IntDimension{
		return c.getInsets().getOutsideSize(new IntDimension(1, 1));
    }
    
    function getPreferredInnerHorizontal():IntDimension{
    	return new IntDimension(80, 12);
    }
    function getPreferredInnerVertical():IntDimension{
    	return new IntDimension(12, 80);
    }	
	
}
