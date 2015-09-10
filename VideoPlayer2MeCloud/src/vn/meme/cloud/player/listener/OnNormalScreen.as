package vn.meme.cloud.player.listener
{
	import flash.display.StageDisplayState;
	
	import vn.meme.cloud.player.btn.Fullscreen;
	import vn.meme.cloud.player.btn.NormalScreen;
	import vn.meme.cloud.player.btn.SkipVAST;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.ads.AdsMoreInformation;
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
			Fullscreen.getInstance().visible = true;
			NormalScreen.getInstance().visible = false;
			Controls.getInstance().resetTiming(false);
			
			if (!vp.videoStage.playing){
				vp.wait.btnPauseAd.drawPauseAdFrame(vp.stage.stageWidth, vp.stage.stageHeight - 30);
				vp.wait.changePauseAdSize(vp);
			}
			var ct : Controls = vp.controls;
			ct.fullscreenBtn.visible = true;
			ct.normalScreenBtn.visible = false;
			ct.normalScreenMode();
			SkipVAST.getInstance().changePosition(vp);
			AdsMoreInformation.getInstance().changePosition(vp);
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.NORMALSCREEN;
		}
	}
}