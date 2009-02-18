/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import org.aswing.graphics.Graphics2D;
import flash.display.DisplayObject;
import flash.display.Loader;
import Import_flash_events;
import flash.net.URLRequest;
import flash.display.Sprite;
import flash.system.LoaderContext;

/**
 * LoadIcon allow you load extenal image/animation to be the icon content.
 * @author senkay
 */
class LoadIcon extends AssetIcon {
	
	
	
	var loader:Loader;
	var owner:Component;
	var urlRequest:URLRequest;
	var context:LoaderContext;
	var needCountSize:Bool;
	
	/**
	 * Creates a LoadIcon with specified url/URLRequest, width, height.
	 * @param url the url/URLRequest for a asset location.
	 * @param width (optional)the width of this icon.(miss this param mean use image width)
	 * @param height (optional)the height of this icon.(miss this param mean use image height)
	 * @param scale (optional)whether scale the extenal image/anim to fit the size 
	 * 		specified by front two params, default is false
	 */
	public function new(url:Dynamic, ?width:Int=-1, ?height:Int=-1, ?scale:Bool=false, ?context:LoaderContext=null){
		super(getLoader(), width, height, false);
		this.scale = scale;
		if(Std.is( url, URLRequest)){
			urlRequest = url;
		}else{
			urlRequest = new URLRequest(url);
		}
		this.context = context;
		needCountSize = (width == -1 || height == -1);
		getLoader().load(urlRequest, context);
	}
	
	/**
	 * Return the loader
	 * @return this loader
	 */
	public function getLoader():Loader{
		if (loader == null){
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __onLoadError);
		}
		return loader;
	}
	
	/**
	 * when the loader init updateUI
	 */
	function __onComplete(e:Event):Void{
		if(needCountSize){
			setWidth(Std.int(loader.width));
			setHeight(Std.int(loader.height));
		}
		if(scale){
			loader.width = width;
			loader.height = height;
		}
		if(owner != null){
			owner.repaint();
			owner.revalidate();	
		}
	}
	
	function __onLoadError(e:IOErrorEvent):Void{
		//do nothing
	}
	

	public override function updateIcon(c:Component, g:Graphics2D, x:Int, y:Int):Void{
		super.updateIcon(c, g, x, y);
		owner = c;
	}
	
	public override function getIconHeight(c:Component):Int{
		owner = c;
		return super.getIconHeight(c);
	}
	
	public override function getIconWidth(c:Component):Int{
		owner = c;
		return super.getIconWidth(c);
	}
	
	public override function getDisplay(c:Component):DisplayObject{
		owner = c;
		return super.getDisplay(c);
	}
	
	public function clone():LoadIcon{
		return new LoadIcon(urlRequest, needCountSize ? -1 : width, needCountSize ? -1 : height, scale, context);
	}
}
