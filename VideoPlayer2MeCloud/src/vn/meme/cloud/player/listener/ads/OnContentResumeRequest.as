package vn.meme.cloud.player.listener.ads
{
	import com.google.ads.ima.api.AdEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager2;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.config.ads2.PositionedAdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPlay;
	
	public class OnContentResumeRequest implements VideoPlayerEventListener
	{
		private static var instance : OnContentResumeRequest;
		public static function getInstance():OnContentResumeRequest{
			return instance;
		}
		
		public function OnContentResumeRequest()
		{
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			CommonUtils.log("Ads Content resume request!");
			var ads : VideoPlayerAdsManager = VideoPlayerAdsManager.getInstance();
			var ads2 : VideoPlayerAdsManager2 = VideoPlayerAdsManager2.getInstance();
			
			if (vs.isEnd() && ((ads.currentAd.position == PositionedAdInfo.POST) || (ads2.currentAd.position == PositionedAdInfo2.POST))){
				vp.wait.showButton();
				return false;
			} else if ((ads.currentAd.position == PositionedAdInfo.MID) || (ads2.currentAd.position == PositionedAdInfo2.MID)) {
				vs.resume(); 
				return true;
			} else {
				vs.play();
				return true;
			}
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			if (vp.videoStage.isHslVideoEnd){
			} else{
				OnPlay.getInstance().updateView(vp);
			}
		}
		
		public function eventName():String
		{
			return AdEvent.CONTENT_RESUME_REQUESTED;
		}
	}
}