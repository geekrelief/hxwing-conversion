/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.table.sorter;

import org.aswing.table.TableCell;
import org.aswing.table.TableCellFactory;

/**
 * @author iiley
 */
class SortableHeaderRenderer implements TableCellFactory {
	
	
	
	var tableSorter:TableSorter;
	var originalRenderer:TableCellFactory;
	
	public function new(originalRenderer:TableCellFactory, tableSorter:TableSorter){
		this.originalRenderer = originalRenderer;
		this.tableSorter = tableSorter;
	}
	
	public function createNewCell(isHeader : Bool) : TableCell {
		return new SortableTextHeaderCell(tableSorter);
	}
	
	public function getTableCellFactory():TableCellFactory{
		return null;
	}
}
