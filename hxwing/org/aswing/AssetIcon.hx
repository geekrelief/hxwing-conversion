package org.aswing;
	
import Import_org_aswing_graphics;
import Import_flash_display;
import Import_org_aswing_error;

/**
 * Abstract class for A icon with a decorative displayObject.
 * @see org.aswing.AttachIcon
 * @see org.aswing.LoadIcon
 * @author senkay
 * @author iiley
 */	
class AssetIcon implements Icon {
	
	
	
	var width:Int;
	var height:Int;
	var scale:Bool; 
	var asset:DisplayObject;
	var assetContainer:DisplayObjectContainer;
	var maskShape:Shape;
	
	/**
	 * Creates a AssetIcon with a path to load external content.
	 * @param path the path of the external content.
	 * @param width (optional)if you specifiled the width of the Icon, and scale is true,
	 * 		the mc will be scale to this width when paint. If you do not specified the with, it will use 
	 * 		asset.width.
	 * @param height (optional)if you specifiled the height of the Icon, and scale is true, 
	 * 		the mc will be scale to this height when paint. If you do not specified the height, it will use 
	 * 		asset.height.
	 * @param scale (optional)whether scale MC to fix the width and height specified. Default is true
	 */
	public function new(?asset:DisplayObject=null, ?width:Int=-1, ?height:Int=-1, ?scale:Bool=false){
		this.asset = asset;
		this.scale = scale;
		
		if (width==-1 && height==-1){
			if (asset != null){
				this.width = Std.int(asset.width);
				this.height = Std.int(asset.height);				
			}else{
				this.width = 0;
				this.height = 0;
			}
		}else{
			this.width = width;
			this.height = height;
			assetContainer = AsWingUtils.createSprite(null, "assetContainer");
			maskShape = AsWingUtils.createShape(assetContainer, "maskShape");
			maskShape.graphics.beginFill(0xFF0000);
			maskShape.graphics.drawRect(0, 0, width, height);
			maskShape.graphics.endFill();
			if(asset != null){
				assetContainer.addChild(asset);
				asset.mask = maskShape;
				if(scale){
					asset.width = width;
					asset.height = height;
				}
			}
		}
	}
	
	public function getAsset():DisplayObject{
		return asset;
	}
	
	function setWidth(width:Int):Void{
		this.width = width;
	}
	
	function setHeight(height:Int):Void{
		this.height = height;
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:Int, y:Int):Void{
		var floor:DisplayObject = getDisplay(c);
		if(floor != null){
			floor.x = x;
			floor.y = y;
		}
	}
	
	public function getIconHeight(c:Component):Int{
		return height;
	}
	
	public function getIconWidth(c:Component):Int{
		return width;
	}
	
	public function getDisplay(c:Component):DisplayObject{
		if(assetContainer != null){
			return assetContainer;
		}else{
			return asset;
		}
	}
	
}
