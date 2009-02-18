/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.table;

import org.aswing.plaf.UIResource;

/**
 * @author iiley
 */
class GeneralTableCellFactoryUIResource extends GeneralTableCellFactory, implements UIResource {
	
	public function new(cellClass:Class<Dynamic>){
		super(cellClass);
	}
}
