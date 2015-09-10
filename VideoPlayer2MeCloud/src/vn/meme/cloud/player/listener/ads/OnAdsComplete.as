package vn.meme.cloud.player.listener.ads
{
	import com.google.ads.ima.api.AdEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnAdsComplete implements VideoPlayerEventListener
	{
		public function OnAdsComplete()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			if(vs.isHslVideoEnd){
				vs.hls.stream.close();
			}
			CommonUtils.log("Ads complete!");
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
			return AdEvent.ALL_ADS_COMPLETED;
		}
	}
}