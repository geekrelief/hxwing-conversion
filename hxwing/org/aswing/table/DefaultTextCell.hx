/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.table;
	
import org.aswing.Component;
import Import_org_aswing_geom;
import org.aswing.JLabel;
import org.aswing.JTable;
import org.aswing.AsWingConstants;

/**
 * Default table cell to render text
 * @author iiley
 */
class DefaultTextCell extends JLabel, implements TableCell {
	
	var value:Dynamic;
	
	public function new(){
		super();
		setHorizontalAlignment(AsWingConstants.LEFT);
		setOpaque(true);
	}
	
	/**
	 * Simpler this method to speed up performance
	 */
	public override function setComBounds(b:IntRectangle):Void{
		readyToPaint = true;
		if(!b.equals(bounds)){
			if(b.width != bounds.width || b.height != bounds.height){
				repaint();
			}
			bounds.setRect(b);
			locate();
			valid = false;
		}
	}
	
	/**
	 * Simpler this method to speed up performance
	 */
	public override function invalidate():Void {
		valid = false;
	}
	
	/**
	 * Simpler this method to speed up performance
	 */
	public override function revalidate():Void {
		valid = false;
	}
	
	//**********************************************************
	//				  Implementing TableCell
	//**********************************************************
	public function setCellValue(value:Dynamic) : Void {
		this.value = value;
		setText(value + "");
	}
	
	public function getCellValue():Dynamic{
		return value;
	}
	
	public function setTableCellStatus(table:JTable, isSelected:Bool, row:Int, column:Int):Void{
		if(isSelected){
			setBackground(table.getSelectionBackground());
			setForeground(table.getSelectionForeground());
		}else{
			setBackground(table.getBackground());
			setForeground(table.getForeground());
		}
		setFont(table.getFont());
	}
	
	public function getCellComponent() : Component {
		return this;
	}
	
	public override function toString():String{
		return "TextCell[label:" + super.toString() + "]\n";
	}
}
