package vn.meme.cloud.player.listener.ads
{
	import com.google.ads.ima.api.AdErrorEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnAdsError implements VideoPlayerEventListener
	{
		public function OnAdsError()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ads : VideoPlayerAdsManager =  VideoPlayerAdsManager.getInstance();
			CommonUtils.log(vp.playInfo.ad);
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
			return AdErrorEvent.AD_ERROR;
		}
	}
}