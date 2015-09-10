package vn.meme.cloud.player.listener
{
	import flash.display.StageDisplayState;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnMouseMove implements VideoPlayerEventListener
	{
		private static var instance:OnMouseMove ;
		public static function getInstance():OnMouseMove{
			return instance;
		}
		
		public function OnMouseMove()
		{
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ct : Controls = vp.controls;
			if (vp.stage.displayState == StageDisplayState.FULL_SCREEN){
				ct.resetTiming();
			}
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.MOUSE_MOVE;
		}
	}
}