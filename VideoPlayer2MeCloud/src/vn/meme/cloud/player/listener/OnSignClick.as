package vn.meme.cloud.player.listener
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnSignClick implements VideoPlayerEventListener
	{
		public function OnSignClick()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			navigateToURL(new URLRequest("http://mecloud.vn/product"), "_blank");
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SIGN_CLICK;
		}
	}
}