/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.table;

import org.aswing.JTable;
import org.aswing.UIManager;
import org.aswing.AsWingConstants;

/**
 * Default table header cell to render text
 * @author iiley
 */
class DefaultTextHeaderCell extends DefaultTextCell {
	
	
	
	public function new() {
		super();
		setHorizontalAlignment(AsWingConstants.CENTER);
		setBorder(UIManager.getBorder("TableHeader.cellBorder"));
		setBackgroundDecorator(UIManager.getGroundDecorator("TableHeader.cellBackground"));
		setOpaque(false);
	}
	
	public override function setTableCellStatus(table:JTable, isSelected:Bool, row:Int, column:Int):Void{
		var header:JTableHeader = table.getTableHeader();
		if(header != null){
			setBackground(header.getBackground());
			setForeground(header.getForeground());
			setFont(header.getFont());
		}
	}
}
