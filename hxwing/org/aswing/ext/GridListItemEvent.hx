/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.ext;

import Import_flash_events;

import Import_org_aswing;

/**
 * The event for items of List.
 * @author iiley
 */
class GridListItemEvent extends MouseEvent {
	
	/**
     *  The <code>GridListItemEvent.ITEM_CLICK</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>itemClick</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>getValue()</code></td><td>the value of this item</td></tr>
     *     <tr><td><code>getCell()</code></td><td>the cell(cell renderer) of this item</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>comp.addEventListener()</code> to register an event listener,
     *       comp is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType itemClick
	 */
	
	
	/**
     *  The <code>GridListItemEvent.ITEM_CLICK</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>itemClick</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>getValue()</code></td><td>the value of this item</td></tr>
     *     <tr><td><code>getCell()</code></td><td>the cell(cell renderer) of this item</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>comp.addEventListener()</code> to register an event listener,
     *       comp is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType itemClick
	 */
	public static var ITEM_CLICK:String = "itemClick";

	/**
     *  The <code>GridListItemEvent.ITEM_DOUBLE_CLICK</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>itemDoubleClick</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>getValue()</code></td><td>the value of this item</td></tr>
     *     <tr><td><code>getCell()</code></td><td>the cell(cell renderer) of this item</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>comp.addEventListener()</code> to register an event listener,
     *       comp is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType itemDoubleClick
	 */
	public static var ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
	
	/**
     *  The <code>GridListItemEvent.ITEM_MOUSE_DOWN</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>itemMouseDown</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>getValue()</code></td><td>the value of this item</td></tr>
     *     <tr><td><code>getCell()</code></td><td>the cell(cell renderer) of this item</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>comp.addEventListener()</code> to register an event listener,
     *       comp is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType itemMouseDown
	 */
	public static var ITEM_MOUSE_DOWN:String = "itemMouseDown";
	
	/**
     *  The <code>GridListItemEvent.ITEM_ROLL_OVER</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>itemRollOver</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>getValue()</code></td><td>the value of this item</td></tr>
     *     <tr><td><code>getCell()</code></td><td>the cell(cell renderer) of this item</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>comp.addEventListener()</code> to register an event listener,
     *       comp is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType itemRollOver
	 */
	public static var ITEM_ROLL_OVER:String = "itemRollOver";
	
	/**
     *  The <code>ListItemEvent.ITEM_ROLL_OUT</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>itemRollOut</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>getValue()</code></td><td>the value of this item</td></tr>
     *     <tr><td><code>getCell()</code></td><td>the cell(cell renderer) of this item</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>comp.addEventListener()</code> to register an event listener,
     *       comp is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType itemRollOut
	 */
	public static var ITEM_ROLL_OUT:String = "itemRollOut";
	
	/**
     *  The <code>ListItemEvent.ITEM_RELEASE_OUT_SIDE</code> constant defines the value of the
     *  <code>type</code> property of the event object for a <code>itemReleaseOutSide</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>getValue()</code></td><td>the value of this item</td></tr>
     *     <tr><td><code>getCell()</code></td><td>the cell(cell renderer) of this item</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>comp.addEventListener()</code> to register an event listener,
     *       comp is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *  </table>
     *
     *  @eventType itemReleaseOutSide
	 */
	public static var ITEM_RELEASE_OUT_SIDE:String = "itemReleaseOutSide";	
	
	var value:Dynamic;
	var index:Int;
	var cell:GridListCell;
	
	public function new(type:String, value:Dynamic, index:Int, cell:GridListCell, e:MouseEvent){
		super(type, false, false, e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown);
		this.value = value;
		this.index = index;
		this.cell = cell;
	}
	
	public function getValue():Dynamic{
		return value;
	}
	
	public function getCell():GridListCell{
		return cell;
	}
	
	public function getIndex():Int{
		return index;
	}
	
	public override function clone():Event{
		return new GridListItemEvent(type, value, index, cell, this);
	}
}
