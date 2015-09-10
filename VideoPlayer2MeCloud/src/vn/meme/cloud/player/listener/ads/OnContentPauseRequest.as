package vn.meme.cloud.player.listener.ads
{
	import com.google.ads.ima.api.AdEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPause;
	
	public class OnContentPauseRequest implements VideoPlayerEventListener
	{
		public function OnContentPauseRequest()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			CommonUtils.log("Ads Content pause request!");
			OnPause.getInstance().excuteLogic(vp,vs,ev);
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			OnPause.getInstance().updateView(vp);
		}
		
		public function eventName():String
		{
			return AdEvent.CONTENT_PAUSE_REQUESTED;
		}
	}
}