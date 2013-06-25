package citrus.core.starling {

	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import citrus.core.CitrusEngine;
	import citrus.core.State;
	
	import starling.core.Starling;

	/**
	 * Extends this class if you create a Starling based game. Don't forget to call <code>setUpStarling</code> function.
	 * 
	 * <p>CitrusEngine can access to the Stage3D power thanks to the <a href="http://starling-framework.org/">Starling Framework</a>.</p>
	 */
	public class StarlingCitrusEngine extends CitrusEngine
	{
		protected var _starling:Starling;
		public function StarlingCitrusEngine() 
		{
			super();
		}

		override public function destroy():void {

			super.destroy();

			if (_state) {

				if (_starling) {

					_starling.stage.removeChild(_state as StarlingState);
					
					// Remove Box2D or Nape debug view
					var debugView:DisplayObject = _starling.nativeStage.getChildByName("debug view");
					if (debugView)
						 _starling.nativeStage.removeChild(debugView);		
					
					_starling.root.dispose();
					_starling.dispose();
				}
			}
		}

		public function get starling():Starling {
			return _starling;
		}

		override protected function handleEnterFrame(e:flash.events.Event):void {

			if (_newState) {
				
				if (_starling.isStarted && _starling.context) {
					
					if (_state) {
						
						if (_state is StarlingState) {
						
							_state.destroy();
							_starling.stage.removeChild(_state as StarlingState);
							
							// Remove Box2D or Nape debug view
							var debugView:DisplayObject = _starling.nativeStage.getChildByName("debug view");
							if (debugView)
								 _starling.nativeStage.removeChild(debugView);
								 
						} else {
							
							_state.destroy();
							removeChild(_state as State);
						}
						
					}
					
					if (_newState is StarlingState) {
						
						_state = _newState;
						_newState = null;
			
//						_starling.stage.addChildAt(_state as StarlingState, _stateDisplayIndex);
						_state.initialize();
					}
				}
			
			}
			
			super.handleEnterFrame(e);
		}
		
		override protected function handleStageDeactivated(e:flash.events.Event):void {
			
			if (_playing && _starling)
				_starling.stop();
				
			super.handleStageDeactivated(e);
		}

		override protected function handleStageActivated(e:flash.events.Event):void {
			
			if (_starling && !_starling.isStarted)
				_starling.start();
			
			super.handleStageActivated(e);
		}

	}
}



import starling.display.Sprite;
/**
 * RootClass is the root of Starling, it is never destroyed and only accessed through <code>_starling.stage</code>.
 */
internal class RootClass extends Sprite {

	public function RootClass() {
	}
}
