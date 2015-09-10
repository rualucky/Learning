package vn.meme.cloud.player.listener.ads
{
	import com.google.ads.ima.api.Ad;
	import com.hinish.spec.iab.vast.parsers.VASTParser;
	import com.hinish.spec.iab.vast.vos.Ad;
	import com.hinish.spec.iab.vast.vos.AdSystem;
	import com.hinish.spec.iab.vast.vos.VAST;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager2;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.config.ads2.PositionedAdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPlay;
	
	public class OnVASTSkip implements VideoPlayerEventListener
	{
		private static var instance : OnVASTSkip;
		public static function getInstance():OnVASTSkip{
			return instance;
		}
		public function OnVASTSkip()
		{
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			CommonUtils.log('Ads VAST skip');
			
			if (VideoPlayerAdsManager2) {
				VideoPlayerAdsManager2.getInstance().skip();
			}
				//vp.ads.visible = false;
				//OnPlay.getInstance().updateView(vp);
				//vs.play();
			
			
			if (VideoPlayerAdsManager)	{
				VideoPlayerAdsManager.getInstance().skip();
			}
			
			if (OnUserClose.getInstance().excuteLogic(vp,vs,ev)){
				OnUserClose.getInstance().updateView(vp);
			}
			
			if (VideoPlayerAdsManager.getInstance().currentAd.position == PositionedAdInfo.MID){
				OnContentResumeRequest.getInstance().excuteLogic(vp,vs,ev);
				return true;
			}
			
			if (VideoPlayerAdsManager2.getInstance().currentAd.position == PositionedAdInfo2.MID){
				OnContentResumeRequest.getInstance().excuteLogic(vp,vs,ev);
				return true;
			}
			
			return false;
			
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			if (VideoPlayerAdsManager.getInstance().currentAd.position == PositionedAdInfo.MID){
				OnContentResumeRequest.getInstance().updateView(vp);
				vp.ads.visible = false; 
			}
			if (VideoPlayerAdsManager2.getInstance().currentAd.position == PositionedAdInfo2.MID){
				OnContentResumeRequest.getInstance().updateView(vp);
				vp.ads.visible = false; 
			}
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SKIP_VAST;
		}
	}
}