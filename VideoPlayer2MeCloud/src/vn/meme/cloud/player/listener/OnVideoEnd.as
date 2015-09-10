package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager2;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.config.ads2.PositionedAdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnVideoEnd implements VideoPlayerEventListener
	{
		private static var instance : OnVideoEnd;
		private var midAdIndex : Number;
		public static function getInstance():OnVideoEnd{
			return instance;
		}
		
		public function OnVideoEnd(){
			instance = this;
			midAdIndex = 0;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			vp.playInfo.ad2.mid[midAdIndex].midAdPosition = 0;
			vp.playInfo.ad2.mid[midAdIndex].timeAllowDisplayNextAd = 31;
			
			if (vp.playInfo.ad){
				if (vp.playInfo.ad.post && vp.playInfo.ad.post.index){
					VideoPlayerAdsManager.getInstance().request(vp.playInfo.ad.post);
				}				
			}	
			if (vp.playInfo.ad2){
				if (vp.playInfo.ad2.post && vp.playInfo.ad2.post.adtag){
					VideoPlayerAdsManager2.getInstance().adsDisplayed = 0;
					if(vp.playInfo.ad2.post.selectRule != PositionedAdInfo2.SELECT_RULE_RANDOM){
						VideoPlayerAdsManager2.getInstance().request(vp.playInfo.ad2.post,0);
					} else {
						VideoPlayerAdsManager2.getInstance().request(vp.playInfo.ad2.post,Math.floor(Math.random()*vp.playInfo.ad2.post.adtag.length));
					}
				}
			}
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
			if(vp.videoStage.checkHLS){
				OnPause.getInstance().updateView(vp);
			} else {
				TimeLine.getInstance().setPlay(1);
				OnPause.getInstance().updateView(vp);
			}
			CommonUtils.log('VIDEO ENDED');
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.VIDEO_END;
		}
	}
}