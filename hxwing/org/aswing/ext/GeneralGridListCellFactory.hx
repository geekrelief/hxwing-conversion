/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.ext;

/**
 * General factory to generate instance by a class
 */
class GeneralGridListCellFactory implements GridListCellFactory {
	
	
	
	var cellClass:Class;
	
	public function new(cellClass:Class){
		this.cellClass = cellClass;
	}

	public function createNewGridListCell():GridListCell{
		return cast( new cellClass(), GridListCell);
	}
	
}
