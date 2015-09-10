package vn.meme.cloud.player.listener
{
	import flash.media.Video;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnQualitySelect implements VideoPlayerEventListener
	{
		public function OnQualitySelect()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{	
			var url: String = ev.data,
				time:Number = vs.currentTime()/1000;
			if (vs.checkHLS){
				time = vs.hls.position;
			}
			/* use this when url m3u8 response multiple child m3u8
			var HLSTime : Number;			
			if (vs.checkHLS){
				HLSTime = vs.hls.position;
				vs.hls.stream.close();
				vs.setVideoUrl(url);
				CommonUtils.log("hsl time: " + HLSTime);
				CommonUtils.log("hls url: " + url)
				CommonUtils.log("level: " + vs.hls.loadLevel);
				vs.hls.load(url);
				vs.hls.stream.play(null, HLSTime);
				vp.controls.qualityList.visible = false;
			} else {*/
			vs.setVideoUrl(url);
			
			if (vs.currentTime() == 0 || vs.isEnd()){
				if (vp.playInfo && vp.playInfo.ad){
					if (vp.playInfo.ad.pre && vp.playInfo.ad.pre.index){
						vp.wait.show('Đang tải quảng cáo ...');
						VideoPlayerAdsManager.getInstance().request(vp.playInfo.ad.pre);				
						return false;
					}					
				}
				vs.play();
			} else {
				if(vs.checkHLS){
					vs.hls.stream.seek(time);
				} else {
					vs.seek(time);
				}
			}
			
			return true;
			
		}
		
		public function updateView(vp:VideoPlayer):void
		{			
			if(vp.videoStage.checkHLS){
				vp.controls.qualityList.visible = false;
			}
			CommonUtils.log("Update play view");			
			var ct : Controls = vp.controls;
			ct.pauseBtn.visible = true;
			ct.playBtn.visible = false;
			vp.thumb.visible = false;
			vp.wait.visible = false;
			vp.controls.qualityList.visible = false;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.SELECT_QUALITY;
		}
	}
}