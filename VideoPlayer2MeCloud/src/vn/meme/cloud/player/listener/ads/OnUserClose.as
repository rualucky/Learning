package vn.meme.cloud.player.listener.ads
{
	import com.google.ads.ima.api.AdEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager2;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.ads.AdsTimeTitle;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.config.ads2.BasicAdInfo2;
	import vn.meme.cloud.player.config.ads2.PositionedAdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPause;
	import vn.meme.cloud.player.listener.OnPlay;
	
	public class OnUserClose implements VideoPlayerEventListener
	{
		private static var instance : OnUserClose;
		public static function getInstance():OnUserClose{
			return instance;
		}
		
		public function OnUserClose()
		{
			instance = this;
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ads2 : VideoPlayerAdsManager2 = VideoPlayerAdsManager2.getInstance();
			
			//if (adsTimeTitle.loadAdsTimer.running) adsTimeTitle.loadAdsTimer.reset();
			
			//AD 2
			if (ads2.currentAd && ads2.currentAd.adtag){ 
				var displayed : Number = VideoPlayerAdsManager2.getInstance().adsDisplayed;
				var index : Number = VideoPlayerAdsManager2.getInstance().index;
				var retry : Number = VideoPlayerAdsManager2.getInstance().adsRetry;
				var repeat : Number = VideoPlayerAdsManager2.getInstance().adsRepeat;
				
		//		CommonUtils.log('displayed : ' + displayed);
		//		CommonUtils.log('max displayed : ' + ads2.currentAd.maxDisplay);
				CommonUtils.log('Ads2 Close ' + ads2.currentAd.position + "roll");				
			
				if (ads2.currentAd.position != PositionedAdInfo2.MID){
					vp.ads.visible = false;
				}
				
				if ((ads2.currentAd.position == PositionedAdInfo2.PRE) || (ads2.currentAd.position == PositionedAdInfo2.POST)){
					
				/*	if (displayed == ads2.currentAd.maxDisplay || repeat == VideoPlayerAdsManager2.MAX_RETRY || displayed == ads2.currentAd.adtag.length){
							if (ads2.currentAd.position == PositionedAdInfo2.POST){
								VideoPlayerAdsManager2.getInstance().adsDisplayed = 0;
								VideoPlayerAdsManager2.getInstance().adsRetry = 0;
								vp.wait.showButton();
							}
							if (ads2.currentAd.position == PositionedAdInfo2.PRE){
								VideoPlayerAdsManager2.getInstance().adsDisplayed = 0;
								vs.play();
								return true;
							}
					} 		*/
					
					if(displayed < ads2.currentAd.maxDisplay && repeat < VideoPlayerAdsManager2.MAX_RETRY){ 
						if(index >= ads2.currentAd.adtag.length) index = 0;
						if (ads2.currentAd.displayRule == PositionedAdInfo2.DISPLAY_RULE_NOT_DUPLICATE){
							
							var adsSuccess : Vector.<Number> = VideoPlayerAdsManager2.getInstance().adsSuccess;
							var adsError : Vector.<Number> = VideoPlayerAdsManager2.getInstance().adsError;
							var adsInfoError : Vector.<BasicAdInfo2> = VideoPlayerAdsManager2.getInstance().adsInfoError;
							var adsInfoSuccess : Vector.<BasicAdInfo2> = VideoPlayerAdsManager2.getInstance().adsInfoSuccess;
							
							//VideoPlayerAdsManager2.getInstance().removeDuplicateItem(adsInfoError);
							
							if(adsInfoError.length + adsInfoSuccess.length == ads2.currentAd.adtag.length){
								VideoPlayerAdsManager2.getInstance().adsDisplayed = 0;
								ads2.currentAd.adtag.length = 0;
								VideoPlayerAdsManager2.getInstance().adsCountPlay = 0;
								for ( var k:int=0;k<adsInfoError.length; k++){
									ads2.currentAd.adtag.push(adsInfoError[k]);
								}
								
							}
							
							for (var i:int=0; i<ads2.currentAd.adtag.length; i++){
								if(adsSuccess.indexOf(i) >= 0 ){ 
									//ads2.currentAd.adtag.splice(i,1);
									if (ads2.currentAd.adtag.length == 1){
										if (ads2.currentAd.position == PositionedAdInfo2.POST){
											VideoPlayerAdsManager2.getInstance().adsDisplayed = 0;
											VideoPlayerAdsManager2.getInstance().adsRetry = 0;
											vp.wait.showButton();
										}
										if (ads2.currentAd.position == PositionedAdInfo2.PRE){
											VideoPlayerAdsManager2.getInstance().adsDisplayed = 0;
						//					CommonUtils.log('111111111111111111111111111');
											vs.play();
											return true;
										}
									} else {
										index = i + 1;
										
									}
								}
							}
							
							if (ads2.currentAd.adtag.length == 0){
								if (ads2.currentAd.position == PositionedAdInfo2.POST){
									VideoPlayerAdsManager2.getInstance().adsDisplayed = 0;
									VideoPlayerAdsManager2.getInstance().adsRetry = 0;
									vp.wait.showButton();
								}
								if (ads2.currentAd.position == PositionedAdInfo2.PRE){
									VideoPlayerAdsManager2.getInstance().adsDisplayed = 0;
					//				CommonUtils.log('22222222222222222222222222222222222');
									vs.play();
									return true;
								}
							} else {
								if(ads2.currentAd.selectRule != PositionedAdInfo2.SELECT_RULE_RANDOM){
									VideoPlayerAdsManager2.getInstance().request(ads2.currentAd,index);
									} else {
										VideoPlayerAdsManager2.getInstance().request(ads2.currentAd,Math.floor(Math.random()*ads2.currentAd.adtag.length));
									}
							}
						} else {
							if(ads2.currentAd.selectRule != PositionedAdInfo2.SELECT_RULE_RANDOM){
								VideoPlayerAdsManager2.getInstance().request(ads2.currentAd,index);	
							} else {
								VideoPlayerAdsManager2.getInstance().request(ads2.currentAd,Math.floor(Math.random()*ads2.currentAd.adtag.length));
							}
						}
					} else {
						if (ads2.currentAd.position == PositionedAdInfo2.POST){
							VideoPlayerAdsManager2.getInstance().adsDisplayed = 0;
							VideoPlayerAdsManager2.getInstance().adsRetry = 0;
							vp.wait.showButton();
						}
						if (ads2.currentAd.position == PositionedAdInfo2.PRE){
							VideoPlayerAdsManager2.getInstance().adsDisplayed = 0;
							VideoPlayerAdsManager2.getInstance().skip();
						//	CommonUtils.log('333333333333333333333333333333333333333');
							vs.play();
							return true;
						}
					}
				}
				
				if (ads2.currentAd.position == PositionedAdInfo2.MID){
					if (ads2.isVast){
						VideoPlayerAdsManager2.getInstance().skipBtn.visible = false;
						VideoPlayerAdsManager2.getInstance().adsMoreInformation.visible = false;
						VideoPlayerAdsManager2.getInstance().adsTimeTitle.visible = false;
						OnPlay.getInstance().excuteLogic(vp,vs,ev);
						OnPlay.getInstance().updateView(vp);
					}
					if (ads2.isLinear && !ads2.isVast){
						OnPlay.getInstance().excuteLogic(vp,vs,ev);
						OnPlay.getInstance().updateView(vp);
					}
				}
			}
			return false;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			OnPlay.getInstance().updateView(vp);
		}
		
		public function eventName():String
		{
			return AdEvent.USER_CLOSED;
		}
	}
}