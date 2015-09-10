package vn.meme.cloud.player.listener.ads
{
	import com.google.ads.ima.api.AdEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPlay;
	
	public class OnSkipped implements VideoPlayerEventListener
	{
		public function OnSkipped()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			CommonUtils.log('Ads Skipped');			
			//OnUserClose.getInstance().excuteLogic(vp,vs,ev);
			if (OnUserClose.getInstance().excuteLogic(vp,vs,ev)){
				OnUserClose.getInstance().updateView(vp);
			}
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
		}
		
		public function eventName():String
		{
			return AdEvent.SKIPPED;
		}
	}
}