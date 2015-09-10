package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnBigPlay implements VideoPlayerEventListener
	{
		public function OnBigPlay()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			for (var i:uint = 0; i < vp.playInfo.video.length; i++){
				CommonUtils.log(vp.playInfo.video[i].url);
				CommonUtils.log(vp.playInfo.video[i].quality);
			}						
		//	if (vs.playing){
		//		if (OnPause.getInstance().excuteLogic(vp,vs,ev))
		//			OnPause.getInstance().updateView(vp);
		//	} else {
				if (OnPlay.getInstance().excuteLogic(vp,vs,ev))
					OnPlay.getInstance().updateView(vp);
		//	}
			return false;
			
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.BIGPLAY;
		}
	}
}