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
		
		public function OnPlaying()
		{
			midAdIndex = 0;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			videoCurrentTime = vs.currentTime() / 1000;
			//CommonUtils.log(vs.netstream.bufferLength / vs.netstream.bufferTime *10);
			/*if (vp.playInfo.ad2.mid && vp.playInfo.ad2.mid.length){
				if(vp.playInfo.ad2.mid[midAdIndex].count == 0){
					vp.playInfo.ad2.mid[midAdIndex].getMidAdsPositions(vp,midAdIndex);
					vp.playInfo.ad2.mid[midAdIndex].count++;
					CommonUtils.log(vp.playInfo.ad2.mid[midAdIndex].nextAds);
				}
			}*/
			/*if (vp.playInfo.ad2.mid && vp.playInfo.ad2.mid.length){
				
				var count : Number = vp.playInfo.ad2.mid[midAdIndex].count;							
				if (count == 0){
				adRepeat = Math.floor(((vp.videoStage.getLength()/1000)-vp.playInfo.ad2.mid[midAdIndex].delay)/vp.playInfo.ad2.mid[midAdIndex].interval);
				vp.playInfo.ad2.mid[midAdIndex].nextAds;
				
				if(vp.playInfo.ad2.mid[midAdIndex].nextAds.length < adRepeat){
				var i:int = 0;
				var nextAd : Number;
				while(i < adRepeat+1){
				nextAd = (vp.playInfo.ad2.mid[midAdIndex].delay) + vp.playInfo.ad2.mid[midAdIndex].interval*i;
				if(nextAd < vp.videoStage.getLength()/1000){
					vp.playInfo.ad2.mid[midAdIndex].nextAds.push(nextAd);
				}
				i++;
				}
				}
				CommonUtils.log(vp.playInfo.ad2.mid[midAdIndex].nextAds);
				vp.playInfo.ad2.mid[midAdIndex].count++;
				}
			}*/
			
			/*if(vs.checkHLS){
				if(!vs.isHslVideoEnd){
					VideoPlayerAdsManager.getInstance().request(vp.playInfo.ad.mid);
				}
			}*/
		/*	try {		
				//ad 1
				if (ev.data && vp.playInfo.ad && vp.playInfo.ad.mid && !vp.ads.visible 
					&& !VideoPlayerAdsManager.getInstance().isLoading()
					&& VideoPlayerAdsManager.getInstance().currentAd
					&& VideoPlayerAdsManager.getInstance().currentAd.position != PositionedAdInfo.MID
					&& !vs.isEnd()){
					if (vp.playInfo.ad.mid && vp.playInfo.ad.mid.index){
						//if (ev.data > vp.playInfo.ad.mid.index){
							VideoPlayerAdsManager.getInstance().request(vp.playInfo.ad.mid);
						//}
					}
				}
			} catch (err : Error){
				CommonUtils.log('Playing error: ' + err.getStackTrace());
			}*/
				//begin ad 2 *****************************************************
				if (ev.data && vp.playInfo.ad2 && vp.playInfo.ad2.mid && !vp.ads.visible 
					&& !VideoPlayerAdsManager2.getInstance().isLoading()
					&& VideoPlayerAdsManager2.getInstance().currentAd
					&& VideoPlayerAdsManager2.getInstance().currentAd.position != PositionedAdInfo2.MID
					&& !vs.isEnd()){
					
					if (vp.playInfo.ad2.mid && vp.playInfo.ad2.mid.length){
						
						/*var count : Number = vp.playInfo.ad2.mid[midAdIndex].count;							
						if (count == 0){
						adRepeat = Math.floor(((vp.videoStage.getLength()/1000)-vp.playInfo.ad2.mid[midAdIndex].delay)/vp.playInfo.ad2.mid[midAdIndex].interval);
						arrNextAd = vp.playInfo.ad2.mid[midAdIndex].nextAds;
						
						if(arrNextAd.length < adRepeat){
							var i:int = 0;
							var nextAd : Number;
							while(i < adRepeat+1){
								nextAd = (vp.playInfo.ad2.mid[midAdIndex].delay) + vp.playInfo.ad2.mid[midAdIndex].interval*i;
								if(nextAd < vp.videoStage.getLength()/1000){
									arrNextAd.push(nextAd);
								}
								i++;
							}
						}
						CommonUtils.log(arrNextAd);
						vp.playInfo.ad2.mid[midAdIndex].count++;
						}*/
						//TimeLine.getInstance().drawAdPoint(vp.playInfo.ad2.mid[midAdIndex].delay, vp.playInfo.ad2.mid[midAdIndex].interval, adRepeat);
					}
				}
				
				//mid ad gan nhat
				/*for(var j:int=0; j<arrNextAd.length; j++){
					if(arrNextAd[j] < videoCurrentTime && videoCurrentTime < arrNextAd[j+1] ){
						if((arrNextAd[j+1] - videoCurrentTime) <= (videoCurrentTime - (arrNextAd[j]))){
							midAdPosition = j+1;
						} else {
							midAdPosition = j;
						}
					}
				}*/
				
				// end ad 2 ****************************************************
				//if (videoCurrentTime > vp.playInfo.ad2.mid[midAdIndex].nextAds[nextAdPosition] && vs.playing){
				if (videoCurrentTime > (vp.playInfo.ad2.mid[midAdIndex].delay + vp.playInfo.ad2.mid[midAdIndex].interval * vp.playInfo.ad2.mid[midAdIndex].midAdPosition) && vs.playing){
					//vp.playInfo.ad2.mid[midAdIndex].nextAdPosition++;
					vp.playInfo.ad2.mid[midAdIndex].midAdPosition++;
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
						
						if (vp.playInfo.ad2.mid[midAdIndex].timeAllowDisplayNextAd == 31){
							VideoPlayerAdsManager2.getInstance().request(vp.playInfo.ad2.mid[midAdIndex],adIndex);
						}
						
						//VideoPlayerAdsManager2.getInstance().request(vp.playInfo.ad2.mid[midAdIndex],adIndex);
						
						/*if(vp.playInfo.ad2.mid[midAdIndex].timeAllowDisplayNextAd == 0){ //&& !vp.playInfo.ad2.mid[midAdIndex].lastMidAdsPlayed){
							VideoPlayerAdsManager2.getInstance().request(vp.playInfo.ad2.mid[midAdIndex],adIndex);
							CommonUtils.log('11111111111111111111111111111111111');
						} else {
							if (vp.playInfo.ad2.mid[midAdIndex].timeAllowDisplayNextAd == 31){
								vp.playInfo.ad2.mid[midAdIndex].timeAllowDisplayNextAd = 0;
								VideoPlayerAdsManager2.getInstance().request(vp.playInfo.ad2.mid[midAdIndex],adIndex);
								CommonUtils.log('22222222222222222222222222222222222222');
							}
						}*/
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