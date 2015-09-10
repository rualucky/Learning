package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnSeek implements VideoPlayerEventListener
	{
		private static var instance:OnSeek ;
		public static function getInstance():OnSeek{
			return instance;
		}
		
		public function OnSeek()
		{
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			if (ev.data) {
				if(vs.checkHLS){
					if (!vs.playing){
						TimeDisplay.getInstance().text.text = TimeDisplay.toTimeDisplay(ev.data) + ' / ' + TimeDisplay.toTimeDisplay(vs.durationHLS);;	
					}										
					TimeLine.getInstance().redrawHLSPlayLayer(ev.data, vs.durationHLS);
					vs.hls.stream.seek(ev.data);
					if(!vs.playing){
						vs.hls.stream.pause();
					}
				} else {
				vs.seek(ev.data);
				}
			}
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			if (!vs.checkHLS){
			var vs:VideoStage = vp.videoStage,
				len:Number = vs.getLength() / 1000,
				startPosition:Number = vs.getStartPosition();
			var playTime:Number = vs.currentTime() / 1000;
			TimeLine.getInstance().setPlay( (playTime + startPosition * 1000)/len);
			TimeDisplay.getInstance().setPlayTime((playTime + startPosition * 1000)*1000);
			}
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SEEK;
		}
	}
}