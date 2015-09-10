package vn.meme.cloud.player.listener
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager2;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.config.PlayInfo;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.config.ads2.PositionedAdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnPlaying implements VideoPlayerEventListener
	{
		
		private var timer : Timer;
		
		private var adRepeat : Number;
		private var midAdIndex : Number;
		private var videoCurrentTime : Number;
		private var midAdPosition : Number;
		private var adIndex : Number = 0;
		private var ab : Number = 0;
		public function OnPlaying()
		{
			midAdIndex = 0;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			videoCurrentTime = vs.currentTime() / 1000;
			
			if (VideoPlayerAdsManager2.getInstance().currentAd.position == PositionedAdInfo2.MID){
				if(VideoPlayerAdsManager2.getInstance().currentAd.delay == Math.round(videoCurrentTime)){
					VideoPlayerAdsManager2.getInstance().currentAd.playFirstMidAd++;
				}
			}
				
				if (videoCurrentTime > (vp.playInfo.ad2.mid[midAdIndex].freeSeekTime + vp.playInfo.ad2.mid[midAdIndex].delay + vp.playInfo.ad2.mid[midAdIndex].interval * vp.playInfo.ad2.mid[midAdIndex].midAdPosition) && vs.playing){
					//vp.playInfo.ad2.mid[midAdIndex].nextAdPosition++;
					vp.playInfo.ad2.mid[midAdIndex].midAdPosition++;
				/*	vp.playInfo.ad2.mid[midAdIndex].nextAds.push(vp.playInfo.ad2.mid[midAdIndex].midAdPosition);
					setTimeout(function():void{
						CommonUtils.log('mid ad pos ' + vp.playInfo.ad2.mid[midAdIndex].midAdPosition); 
						CommonUtils.log(vp.playInfo.ad2.mid[midAdIndex].nextAds);
					}, 5000);*/
					if (VideoPlayerAdsManager2.getInstance().adsDisplayed < vp.playInfo.ad2.mid[midAdIndex].maxDisplay){
						if (vp.playInfo.ad2.mid[midAdIndex].displayRule == PositionedAdInfo2.DISPLAY_RULE_NOT_DUPLICATE){
							
							for (var m:int =0; m < VideoPlayerAdsManager2.getInstance().midAdsInfoSuccess.length; m++){
								for (var n:int = 0; n < vp.playInfo.ad2.mid[midAdIndex].adtag.length; n++)
									if(VideoPlayerAdsManager2.getInstance().midAdsInfoSuccess[m] == vp.playInfo.ad2.mid[midAdIndex].adtag[n].adtagId)
										vp.playInfo.ad2.mid[midAdIndex].adtag.splice(n, 1);
							}
							if(vp.playInfo.ad2.mid[midAdIndex].selectRule != PositionedAdInfo2.SELECT_RULE_RANDOM){
								if(!vp.playInfo.ad2.mid[midAdIndex].lastMidAdsPlayed && vp.playInfo.ad2.mid[midAdIndex].timeAllowDisplayNextAd ==0){
									adIndex = 0;
								} else {
									adIndex = adIndex + 1;	
								}							
							} else {
								adIndex = Math.floor(Math.random()*vp.playInfo.ad2.mid[midAdIndex].adtag.length);
							}
						} else {
							if(vp.playInfo.ad2.mid[midAdIndex].selectRule != PositionedAdInfo2.SELECT_RULE_RANDOM){
								if(!vp.playInfo.ad2.mid[midAdIndex].lastMidAdsPlayed && vp.playInfo.ad2.mid[midAdIndex].timeAllowDisplayNextAd == 0){
									adIndex = 0;
								} else {
									adIndex = adIndex + 1;	
								}
							} else {
								adIndex = Math.floor(Math.random()*vp.playInfo.ad2.mid[midAdIndex].adtag.length);
							}
						}
						
					/*	CommonUtils.log('Error: ' + VideoPlayerAdsManager2.getInstance().adsInfoError.length);
						CommonUtils.log('Suc: ' + VideoPlayerAdsManager2.getInstance().adsInfoSuccess.length);
						CommonUtils.log('Error: ' + VideoPlayerAdsManager2.getInstance().adsInfoError);
						CommonUtils.log('Suc: ' + VideoPlayerAdsManager2.getInstance().adsInfoSuccess);
						CommonUtils.log('KA ' + VideoPlayerAdsManager2.getInstance().currentAd.playFirstMidAd);
						*/
						/*if (VideoPlayerAdsManager2.getInstance().adsInfoError.length == 0 
							&& VideoPlayerAdsManager2.getInstance().adsInfoSuccess.length == 0 
							&& VideoPlayerAdsManager2.getInstance().currentAd.playFirstMidAd == 0){*/
					/*	if (VideoPlayerAdsManager2.getInstance().currentAd.playFirstMidAd == 0){
							VideoPlayerAdsManager2.getInstance().currentAd.playFirstMidAd++;
							if(vp.playInfo.ad2.mid[midAdIndex].selectRule != PositionedAdInfo2.SELECT_RULE_RANDOM){
								adIndex = 0;
							} else {
								adIndex = Math.floor(Math.random()*vp.playInfo.ad2.mid[midAdIndex].adtag.length);
							}
							VideoPlayerAdsManager2.getInstance().request(vp.playInfo.ad2.mid[midAdIndex],adIndex);
							
						} else {*/
						if (vp.playInfo.ad2.mid[midAdIndex].timeAllowDisplayNextAd == 31){
							VideoPlayerAdsManager2.getInstance().request(vp.playInfo.ad2.mid[midAdIndex],adIndex);
						}
						//}
					}
				}
					
			
			return true;
		}
			
		public function updateView(vp:VideoPlayer):void
		{
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.PLAYING;
		}
	}
}