/**
 *  author: Alva sun
 *  site : www.alvas.cn
 * 
 *  need AsWingA3
 *  2007-05-07
 */

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.aswing.BorderLayout;
	import org.aswing.FlowLayout;
	import org.aswing.GridLayout;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.border.EmptyBorder;
	import org.aswing.geom.IntDimension;
	
	import flash.Lib;
	import flash.display.StageScaleMode;

	class AsWingApplication extends Sprite
	{
		private static var labelPrefix : String = "Number of button clicks: ";
	    private var numClicks : Int ;
	    private var label : JLabel;
		private var button : JButton;

        public static function main(){
			new AsWingApplication();
        }
		
		public function new(){
			// initialized members
			numClicks = 0;
			super();
			createUI();
		}
		
		private function createUI() : Void{
			var frame : JFrame = new JFrame( this, "AsWingApplication" );
			frame.getContentPane().append( createCenterPane() );
			frame.setSize(new IntDimension( 200, 120 ) );
			flash.Lib.current.stage.addChild(this);
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			frame.show();
		}
		
		private function createCenterPane() : JPanel{
			var pane : JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
			label = new JLabel(labelPrefix+"0");
			button = new JButton("I'm a AsWing button!");
			pane.append(button);
			pane.append(label);
			pane.setBorder(new EmptyBorder(null, new Insets(10,5,10,5)));
			initHandlers();
			return pane;
		}
		
		private function initHandlers() : Void{
			//button.addActionListener( __pressButton );
			button.addEventListener(MouseEvent.MOUSE_UP, __pressButton);
		}
		
		private function __pressButton( e : Event ) : Void{
			numClicks++;
			label.setText(labelPrefix+numClicks);
			//label.revalidate();
		}
	}
