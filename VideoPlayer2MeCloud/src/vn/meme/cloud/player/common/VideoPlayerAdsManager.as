/*
package vn.meme.cloud.player.common
{
	import com.google.ads.ima.api.AdErrorEvent;
	import com.google.ads.ima.api.AdEvent;
	import com.google.ads.ima.api.AdsLoader;
	import com.google.ads.ima.api.AdsManager;
	import com.google.ads.ima.api.AdsManagerLoadedEvent;
	import com.google.ads.ima.api.AdsRenderingSettings;
	import com.google.ads.ima.api.AdsRequest;
	import com.google.ads.ima.api.ViewModes;
	import com.google.utils.Url;
	import com.hinish.spec.iab.vpaid.AdMovieClipBase;
	
	import fl.video.VideoScaleMode;
	
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.btn.SkipVAST;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.ads.AdsMoreInformation;
	import vn.meme.cloud.player.comp.sub.ads.AdsTimeTitle;
	import vn.meme.cloud.player.config.ads.AdInfo;
	import vn.meme.cloud.player.config.ads.BasicAdInfo;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPlay;
	import vn.meme.cloud.player.listener.ads.OnContentResumeRequest;
	import vn.meme.cloud.player.listener.ads.OnUserClose;
	import vn.meme.cloud.player.listener.ads.OnVASTSkip;
	
	public class VideoPlayerAdsManager
	{
		private static const instance : VideoPlayerAdsManager = new VideoPlayerAdsManager;
		public static function getInstance():VideoPlayerAdsManager{
			return instance;
		}
		
		private var adsLoader : AdsLoader;
		private var adsManager : AdsManager;
		private var loading : Boolean;
		public var skipBtn : SkipVAST;
		public var adsTimeTitle : AdsTimeTitle;
		public var adsMoreInformation : AdsMoreInformation;
		
		// ad info
		public var currentAd : PositionedAdInfo;
		private var fallbackPos : int;		
		
		private var adsXml : XML;
		private var adsURLLoader : URLLoader = new URLLoader(); 
		
		
		public function VideoPlayerAdsManager()
		{			
			adsLoader = new AdsLoader(); 
			adsLoader.loadSdk();
			adsLoader.settings.numRedirects = 10;
			adsLoader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED,
				adsManagerLoadedHandler);
			adsLoader.addEventListener(AdErrorEvent.AD_ERROR, adsLoadErrorHandler);
			
			loading = false;						
		}
		
		private function adsManagerLoadedHandler(event:AdsManagerLoadedEvent):void{
			// Publishers can modify the default preferences through this object.
			var adsRenderingSettings:AdsRenderingSettings =
				new AdsRenderingSettings();
			
			// In order to support ad rules, ads manager requires an object that
			// provides current playhead position for the content.
			var contentPlayhead:Object = {};
			contentPlayhead.time = function():Number {
				return VideoPlayer.getInstance().videoStage.currentTime(); // convert to milliseconds.
			};
			
			// Get a reference to the AdsManager object through the event object.
			adsManager = event.getAdsManager(contentPlayhead, adsRenderingSettings);
			if (adsManager) {
				// Add required ads manager listeners.
				// ALL_ADS_COMPLETED event will fire once all the ads have played. There
				// might be more than one ad played in the case of ad pods and ad rules.
				adsManager.addEventListener(AdEvent.ALL_ADS_COMPLETED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.ALL_ADS_COMPLETED,ev,false));
					});
				
				// If ad is linear, it will fire content pause request event.
				adsManager.addEventListener(AdEvent.CONTENT_PAUSE_REQUESTED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.CONTENT_PAUSE_REQUESTED,ev,false));
					});
				
				// When ad finishes or if ad is non-linear, content resume event will be
				// fired. For example, if ad rules response only has post-roll, content
				// resume will be fired for pre-roll ad (which is not present) to signal
				// that content should be started or resumed.
				adsManager.addEventListener(AdEvent.CONTENT_RESUME_REQUESTED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.CONTENT_RESUME_REQUESTED,ev,false));
					});
				// All AD_ERRORs indicate fatal failures. You can discard the AdsManager and
				// resume your content in this handler.
				adsManager.addEventListener(AdErrorEvent.AD_ERROR,adsLoadErrorHandler);
				
				adsManager.addEventListener(AdEvent.USER_CLOSED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.USER_CLOSED,ev,false));
					});
				
				adsManager.addEventListener(AdEvent.SKIPPED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.SKIPPED,ev,false));
					});
				adsManager.addEventListener(AdEvent.USER_MINIMIZED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.SKIPPED,ev,false));
					});
				
				adsManager.addEventListener(AdEvent.IMPRESSION,
					function(ev:AdEvent):void{
						var adInfo : BasicAdInfo = (fallbackPos == -1) ? currentAd.adtag[0] : currentAd.adtag[fallbackPos],
						isVAST : Boolean = (adInfo.adType.match('VAST') || adInfo.adType.match('vast')),
						isSkippAbleVideo : Boolean = (adInfo.adtagUrl.search("skippable") == -1) ? false : true;
						
						CommonUtils.log("Ad impress " + fallbackPos);
						CommonUtils.log('AD URL: ' + adInfo.adtagUrl);
						CommonUtils.log('AD ID: ' + adInfo.adtagId);
						
						player.pingUtils.ping("ai",0,{
							adtag : fallbackPos == -1 ? currentAd.adtag[0].adtagId : currentAd.adtag[fallbackPos].adtagId,
							pos : currentAd.position 
						});
						
						//display ads time, skip button component
						if (isVAST){
							if(!isSkippAbleVideo){								
								skipBtn = new SkipVAST();
								adsTimeTitle = new AdsTimeTitle();
								adsMoreInformation = new AdsMoreInformation();								
								player.ads.addChild(skipBtn);
								player.ads.addChild(adsTimeTitle);
								player.ads.addChild(adsMoreInformation);
								adsMoreInformation.mouseEnabled = false;
							}
						}
					});
				
				adsManager.addEventListener(AdEvent.CLICKED,
					function(ev:AdEvent):void{
						CommonUtils.log("Ad click ");
						player.pingUtils.ping("ac",0,{
							adtag : fallbackPos == -1 ? currentAd.adtag[0].adtagId : currentAd.adtag[fallbackPos].adtagId,
							pos : currentAd.position 
						});
					});
				// If your video player supports a specific version of VPAID ads, pass
				// in the version. If your video player does not support VPAID ads yet,
				// just pass in 1.0.
				adsManager.handshakeVersion("1.0");
				
				// Init should be called before playing the content in order for ad rules
				// ads to function correctly.
				var player : VideoPlayer = VideoPlayer.getInstance(),
					videoPlayer : VideoStage = player.videoStage,
					adInfo : BasicAdInfo = (fallbackPos == -1)? currentAd.adtag[0] : currentAd.adtag[fallbackPos],
					isVAST : Boolean = (currentAd.adtag[0].adType == 'vast' || currentAd.adtag[0].adType== 'VAST'),
					isMid : Boolean = currentAd.position == PositionedAdInfo.MID,
					w : Number = isMid && !isVAST ? videoPlayer.getStageWidth() : player.stage.stageWidth,
					h : Number = isMid && !isVAST ? videoPlayer.getStageHeight() : player.stage.stageHeight,
					adsH : Number = isMid && !isVAST ? 180 : h;
				
				adsManager.init(w,adsH,
					isMid ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
				
				while (player.ads.numChildren > 0)
					player.ads.removeChildAt(0);
				player.ads.addChild(adsManager.adsContainer);
				player.ads.visible = true;
				if (isMid && !isVAST){
					if (VideoPlayer.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN)
						player.ads.y = (h - adsH) - 30;
					else 
						player.ads.y = (h - adsH);
				} else 
					player.ads.y =  0;
				if (currentAd.position == PositionedAdInfo.POST){
					player.wait.hideButton();
				}								
				
				player.ads.resetScale();
				
				// Start the ad playback.
				adsManager.start();		
			}
			loading = false;
		}
				
		private function adsLoadErrorHandler(event:AdErrorEvent):void{
			if (currentAd && currentAd.adtag.length && fallbackPos < currentAd.adtag.length-1){
				fallbackPos++;
				requestAds(currentAd.adtag[fallbackPos].adtagUrl);
				return;
			}
			loading = false;
			VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdErrorEvent.AD_ERROR,event));
		}
		
		private function requestAds(adTag:String):void {
			if (adsManager)
				adsManager.destroy();
			
			var player : VideoPlayer = VideoPlayer.getInstance(),
				videoPlayer : VideoStage = player.videoStage,
				isMid : Boolean = currentAd.position == PositionedAdInfo.MID, 
				w : Number = isMid ? videoPlayer.getStageWidth() : player.stage.stageWidth,
				h : Number = isMid ? videoPlayer.getStageHeight() : player.stage.stageHeight;
			// The AdsRequest encapsulates all the properties required to request ads.
			
			var adsRequest:AdsRequest = new AdsRequest();
			adsRequest.adTagUrl = adTag; 
			if (!isMid){
				adsRequest.linearAdSlotWidth = w;
				adsRequest.linearAdSlotHeight = h;
			} else {
				adsRequest.linearAdSlotWidth = 0;
				adsRequest.linearAdSlotHeight = 0;
			}
			adsRequest.nonLinearAdSlotWidth = w;
			adsRequest.nonLinearAdSlotHeight = isMid ? 180 : h;
			
			// Instruct the AdsLoader to request ads using the AdsRequest object.
			adsLoader.requestAds(adsRequest);
		}
		
		public function request(ad:PositionedAdInfo):void {
			currentAd = ad;
			loading = true;
			fallbackPos = -1;
			requestAds(ad.adtag[0].adtagUrl);
		}
		
		public function refreshAds():void{
			loading = true;
			fallbackPos = -1;
			requestAds(currentAd.adtag[0].adtagUrl);
		}
		
		public function isLoading():Boolean{
			return loading;
		}
		
		public function updateSize(w:Number,h:Number):void{
			if (adsManager){
				var player : VideoPlayer = VideoPlayer.getInstance(),
					videoPlayer : VideoStage = player.videoStage,
					adInfo : BasicAdInfo = (fallbackPos == -1)? currentAd.adtag[0] : currentAd.adtag[fallbackPos],
					isVAST : Boolean = (currentAd.adtag[0].adType== 'vast' || currentAd.adtag[0].adType== 'VAST'),
					isMid : Boolean = currentAd.position == PositionedAdInfo.MID,
					w : Number = isMid && !isVAST? videoPlayer.getStageWidth() : player.stage.stageWidth,
					h : Number = isMid && !isVAST? videoPlayer.getStageHeight() : player.stage.stageHeight,
					adsH : Number = isMid && !isVAST? 180 : h;
				adsManager.adsContainer.width = w;
				adsManager.adsContainer.height = adsH;
				if (isVAST){
					skipBtn.x = player.width - 35;
					skipBtn.y = (player.width * 9 / 16) - 122 ;
				} 
			}
		}
		
		public function skip():void{
			if (adsManager) {
				adsManager.volume = 0;
				adsManager.destroy();
				adsManager = null;
			}
		}
	}
}*/


package vn.meme.cloud.player.common
{
	import com.google.ads.ima.api.AdErrorEvent;
	import com.google.ads.ima.api.AdEvent;
	import com.google.ads.ima.api.AdsLoader;
	import com.google.ads.ima.api.AdsManager;
	import com.google.ads.ima.api.AdsManagerLoadedEvent;
	import com.google.ads.ima.api.AdsRenderingSettings;
	import com.google.ads.ima.api.AdsRequest;
	import com.google.ads.ima.api.ViewModes;
	import com.google.utils.Url;
	
	import fl.video.VideoScaleMode;
	
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.btn.SkipVAST;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.ads.AdsMoreInformation;
	import vn.meme.cloud.player.comp.sub.ads.AdsTimeTitle;
	import vn.meme.cloud.player.config.ads.AdInfo;
	import vn.meme.cloud.player.config.ads.BasicAdInfo;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.config.ads2.BasicAdInfo2;
	import vn.meme.cloud.player.config.ads2.PositionedAdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnPlay;
	
	public class VideoPlayerAdsManager
	{
		private static const instance : VideoPlayerAdsManager = new VideoPlayerAdsManager;
		public static function getInstance():VideoPlayerAdsManager{
			return instance;
		}
		
		private var adsLoader : AdsLoader;
		private var adsManager : AdsManager;
		private var loading : Boolean;
		public var skipBtn : SkipVAST;
		public var adsTimeTitle : AdsTimeTitle;
		public var adsMoreInformation : AdsMoreInformation;
		
		// ad info
		public var currentAd : PositionedAdInfo;
		public var currentAd2 : PositionedAdInfo2;
		private var fallbackPos : int;		
		
		private var adsXml : XML;
		private var adsURLLoader : URLLoader = new URLLoader(); 
		
		
		public function VideoPlayerAdsManager()
		{			
			adsLoader = new AdsLoader(); 
			adsLoader.loadSdk();
			adsLoader.settings.numRedirects = 10;
			adsLoader.addEventListener(AdsManagerLoadedEvent.ADS_MANAGER_LOADED,
				adsManagerLoadedHandler);
			adsLoader.addEventListener(AdErrorEvent.AD_ERROR, adsLoadErrorHandler);
			
			loading = false;						
		}
		
		private function adsManagerLoadedHandler(event:AdsManagerLoadedEvent):void{
			// Publishers can modify the default preferences through this object.
			var adsRenderingSettings:AdsRenderingSettings =
				new AdsRenderingSettings();
			
			// In order to support ad rules, ads manager requires an object that
			// provides current playhead position for the content.
			var contentPlayhead:Object = {};
			contentPlayhead.time = function():Number {
				return VideoPlayer.getInstance().videoStage.currentTime(); // convert to milliseconds.
			};
			
			// Get a reference to the AdsManager object through the event object.
			adsManager = event.getAdsManager(contentPlayhead, adsRenderingSettings);
			if (adsManager) {
				// Add required ads manager listeners.
				// ALL_ADS_COMPLETED event will fire once all the ads have played. There
				// might be more than one ad played in the case of ad pods and ad rules.
				adsManager.addEventListener(AdEvent.ALL_ADS_COMPLETED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.ALL_ADS_COMPLETED,ev,false));
					});
				
				// If ad is linear, it will fire content pause request event.
				adsManager.addEventListener(AdEvent.CONTENT_PAUSE_REQUESTED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.CONTENT_PAUSE_REQUESTED,ev,false));
					});
				// When ad finishes or if ad is non-linear, content resume event will be
				// fired. For example, if ad rules response only has post-roll, content
				// resume will be fired for pre-roll ad (which is not present) to signal
				// that content should be started or resumed.
				adsManager.addEventListener(AdEvent.CONTENT_RESUME_REQUESTED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.CONTENT_RESUME_REQUESTED,ev,false));
					});
				// All AD_ERRORs indicate fatal failures. You can discard the AdsManager and
				// resume your content in this handler.
				adsManager.addEventListener(AdErrorEvent.AD_ERROR,adsLoadErrorHandler);
				
				adsManager.addEventListener(AdEvent.USER_CLOSED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.USER_CLOSED,ev,false));
					});
				
				adsManager.addEventListener(AdEvent.SKIPPED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.SKIPPED,ev,false));
					});
				
				adsManager.addEventListener(AdEvent.USER_MINIMIZED,
					function(ev:AdEvent):void{
						VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdEvent.SKIPPED,ev,false));
					});
				
				adsManager.addEventListener(AdEvent.IMPRESSION,
					function(ev:AdEvent):void{
						var adInfo : BasicAdInfo = (fallbackPos == -1)? currentAd.index : currentAd.replace[fallbackPos],
						isVAST : Boolean = adInfo.type == 'vast',
						isSkippAbleVideo : Boolean = (adInfo.adtag.search("skippable") == -1) ? false : true;
						
						CommonUtils.log("Ad impress " + fallbackPos);
						
						player.pingUtils.ping("ai",0,{
							adtag : fallbackPos == -1 ? currentAd.index.adtagId : currentAd.replace[fallbackPos].adtagId,
							pos : currentAd.position 
						});
						
						//test vast
						//var abc : VASTHandler = new VASTHandler();
						//abc.setData(adInfo.adtag);
						
						//display ads time, skip button component
						if (isVAST){
							if(!isSkippAbleVideo){								
								skipBtn = new SkipVAST();
								adsTimeTitle = new AdsTimeTitle();
								adsMoreInformation = new AdsMoreInformation();								
								player.ads.addChild(skipBtn);
								player.ads.addChild(adsTimeTitle);
								player.ads.addChild(adsMoreInformation);
								adsMoreInformation.mouseEnabled = false;
								
							}
						}						
					});
				
				adsManager.addEventListener(AdEvent.CLICKED,
					function(ev:AdEvent):void{
						CommonUtils.log("Ad click ");
						player.pingUtils.ping("ac",0,{
							adtag : fallbackPos == -1 ? currentAd.index.adtagId : currentAd.replace[fallbackPos].adtagId,
							pos : currentAd.position 
						});
					});
				// If your video player supports a specific version of VPAID ads, pass
				// in the version. If your video player does not support VPAID ads yet,
				// just pass in 1.0.
				adsManager.handshakeVersion("1.0");
				
				// Init should be called before playing the content in order for ad rules
				// ads to function correctly.
				var player : VideoPlayer = VideoPlayer.getInstance(),
					videoPlayer : VideoStage = player.videoStage,
					adInfo : BasicAdInfo = (fallbackPos == -1) ? currentAd.index : currentAd.replace[fallbackPos],
					isVAST : Boolean = adInfo.type == 'vast',
					isMid : Boolean = currentAd.position == PositionedAdInfo.MID,
					w : Number = isMid && !isVAST ? videoPlayer.getStageWidth() : player.stage.stageWidth,
					h : Number = isMid && !isVAST ? videoPlayer.getStageHeight() : player.stage.stageHeight,
					adsH : Number = isMid && !isVAST ? 180 : h;
				
				adsManager.init(w,adsH,
					isMid ? ViewModes.NORMAL : ViewModes.FULLSCREEN);
				
				while (player.ads.numChildren > 0)
					player.ads.removeChildAt(0);
				player.ads.addChild(adsManager.adsContainer);
				player.ads.visible = true;
				if (isMid && !isVAST){
					if (VideoPlayer.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN)
						player.ads.y = (h - adsH) - 30;
					else 
						player.ads.y = (h - adsH);
				} else 
					player.ads.y =  0;
				if (currentAd.position == PositionedAdInfo.POST){
					player.wait.hideButton();
				}								
				
				player.ads.resetScale();
				
				// Start the ad playback.
				adsManager.start();				
			}
			loading = false;
		}
		
		private function adsLoadErrorHandler(event:AdErrorEvent):void{
			if (currentAd.replace && currentAd.replace.length && fallbackPos < currentAd.replace.length-1){
				fallbackPos++;
				requestAds(currentAd.replace[fallbackPos].adtag);
				return;
			}
			/*else {
				var vp : VideoPlayer = VideoPlayer.getInstance();
				CommonUtils.log("Update play view");			
				var ct : Controls = vp.controls;
				ct.pauseBtn.visible = true;
				ct.playBtn.visible = false;
				vp.thumb.visible = false;
				vp.wait.visible = false;
				vp.videoStage.play();
			}*/
			
			loading = false;
			VideoPlayer.getInstance().dispatchEvent(new VideoPlayerEvent(AdErrorEvent.AD_ERROR,event));
		}
		
		private function requestAds(adTag:String):void {
			if (adsManager)
				adsManager.destroy();
			
			var player : VideoPlayer = VideoPlayer.getInstance(),
				videoPlayer : VideoStage = player.videoStage,
				isMid : Boolean = currentAd.position == PositionedAdInfo.MID,
				w : Number = isMid ? videoPlayer.getStageWidth() : player.stage.stageWidth,
				h : Number = isMid ? videoPlayer.getStageHeight() : player.stage.stageHeight;
			
			// The AdsRequest encapsulates all the properties required to request ads.
			var adsRequest:AdsRequest = new AdsRequest();
			adsRequest.adTagUrl = adTag; 
			if (!isMid){
				adsRequest.linearAdSlotWidth = w;
				adsRequest.linearAdSlotHeight = h;
			} else {
				adsRequest.linearAdSlotWidth = 0;
				adsRequest.linearAdSlotHeight = 0;
			}
			adsRequest.nonLinearAdSlotWidth = w;
			adsRequest.nonLinearAdSlotHeight = isMid ? 180 : h;
			// Instruct the AdsLoader to request ads using the AdsRequest object.
			adsLoader.requestAds(adsRequest);
		}
		
		public function request(ad:PositionedAdInfo):void {
				currentAd = ad;
				loading = true;
				fallbackPos = -1;
				requestAds(ad.index.adtag);	
				CommonUtils.log('index fired');
		}
		
		public function refreshAds():void{
			loading = true;
			fallbackPos = -1;
			requestAds(currentAd.index.adtag);
		}
		
		public function isLoading():Boolean{
			return loading;
		}
		
		public function updateSize(w:Number,h:Number):void{
			if (adsManager){
				var player : VideoPlayer = VideoPlayer.getInstance(),
					videoPlayer : VideoStage = player.videoStage,
					adInfo : BasicAdInfo = (fallbackPos == -1)? currentAd.index : currentAd.replace[fallbackPos],
					isVAST : Boolean = adInfo.type == 'vast',
					isMid : Boolean = currentAd.position == PositionedAdInfo.MID,
					w : Number = isMid && !isVAST? videoPlayer.getStageWidth() : player.stage.stageWidth,
					h : Number = isMid && !isVAST? videoPlayer.getStageHeight() : player.stage.stageHeight,
					adsH : Number = isMid && !isVAST? 180 : h;
				adsManager.adsContainer.width = w;
				adsManager.adsContainer.height = adsH;
				if (isVAST){
					skipBtn.x = player.width - 35;
					skipBtn.y = (player.width * 9 / 16) - 122 ;
					
				} 
			}
		}
		
		public function skip():void{
			if (adsManager) {
				adsManager.volume = 0;
				adsManager.destroy();
				adsManager = null;
			}
		}
	}
}
