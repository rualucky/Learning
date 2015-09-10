package vn.meme.cloud.player.comp
{
	import com.google.ads.ima.api.AdsLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager2;
	
	public class AdsLayer extends VideoPlayerComponent
	{
		
		private var loader : AdsLoader;
		
		public function AdsLayer(player:VideoPlayer)
		{
			super(player);
			visible = false;
		}
		
		override public function initSize(ev:Event = null):void{
			if (visible){
			//	if (VideoPlayerAdsManager) VideoPlayerAdsManager.getInstance().updateSize(player.stage.stageWidth,player.stage.stageHeight);
				if (VideoPlayerAdsManager2) VideoPlayerAdsManager2.getInstance().updateSize(player.stage.stageWidth,player.stage.stageHeight);
			}
				
		}
		
		public function resetScale():void{
			
		}
	}
}