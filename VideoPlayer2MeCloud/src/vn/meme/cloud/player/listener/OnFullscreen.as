package vn.meme.cloud.player.listener
{
	import flash.display.StageDisplayState;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnFullscreen implements VideoPlayerEventListener
	{
		private static var instance:OnFullscreen ;
		public static function getInstance():OnFullscreen{
			return instance;
		}
		
		public function OnFullscreen()
		{
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
			vp.stage.displayState = StageDisplayState.FULL_SCREEN;
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			var ct : Controls = vp.controls;
			ct.fullscreenBtn.visible = false;
			ct.normalScreenBtn.visible = true;
			ct.fullscreenMode();
			if (vp.ads.visible){
				vp.ads.visible = false;
				VideoPlayerAdsManager.getInstance().refreshAds();
			}
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.FULLSCREEN;
		}
	}
}