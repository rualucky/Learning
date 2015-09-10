package vn.meme.cloud.player.listener
{
	import flash.display.StageDisplayState;
	
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnNormalScreen implements VideoPlayerEventListener
	{
		private static var instance:OnNormalScreen ;
		public static function getInstance():OnNormalScreen{
			return instance;
		}
		
		public function OnNormalScreen()
		{
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			vp.stage.displayState = StageDisplayState.NORMAL;
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			var ct : Controls = vp.controls;
			ct.fullscreenBtn.visible = true;
			ct.normalScreenBtn.visible = false;
			ct.normalScreenMode();
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.NORMALSCREEN;
		}
	}
}