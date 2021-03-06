/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

	
/**
 * A collection of constants generally used for positioning and orienting
 * components on the screen.
 * 
 * @author iiley
 */
class AsWingConstants {
		
		public static var NONE:Int = -1;

        /** 
         * The central position in an area. Used for
         * both compass-direction constants (NORTH, etc.)
         * and box-orientation constants (TOP, etc.).
         */
        public static var CENTER:Int  = 0;

        // 
        // Box-orientation constant used to specify locations in a box.
        //
        /** 
         * Box-orientation constant used to specify the top of a box.
         */
        public static var TOP:Int     = 1;
        /** 
         * Box-orientation constant used to specify the left side of a box.
         */
        public static var LEFT:Int    = 2;
        /** 
         * Box-orientation constant used to specify the bottom of a box.
         */
        public static var BOTTOM:Int  = 3;
        /** 
         * Box-orientation constant used to specify the right side of a box.
         */
        public static var RIGHT:Int   = 4;

        // 
        // Compass-direction constants used to specify a position.
        //
        /** 
         * Compass-direction North (up).
         */
        public static var NORTH:Int      = 1;
        /** 
         * Compass-direction north-east (upper right).
         */
        public static var NORTH_EAST:Int = 2;
        /** 
         * Compass-direction east (right).
         */
        public static var EAST:Int       = 3;
        /** 
         * Compass-direction south-east (lower right).
         */
        public static var SOUTH_EAST:Int = 4;
        /** 
         * Compass-direction south (down).
         */
        public static var SOUTH:Int      = 5;
        /** 
         * Compass-direction south-west (lower left).
         */
        public static var SOUTH_WEST:Int = 6;
        /** 
         * Compass-direction west (left).
         */
        public static var WEST:Int       = 7;
        /** 
         * Compass-direction north west (upper left).
         */
        public static var NORTH_WEST:Int = 8;

        //
        // These constants specify a horizontal or 
        // vertical orientation. For example, they are
        // used by scrollbars and sliders.
        //
        /** 
         * Horizontal orientation. Used for scrollbars and sliders.
         */
        public static var HORIZONTAL:Int = 0;
        /** 
         * Vertical orientation. Used for scrollbars and sliders.
         */
        public static var VERTICAL:Int   = 1;
}
