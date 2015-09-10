package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.media.Video;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	
	import vn.meme.cloud.player.btn.BigPlay;
	import vn.meme.cloud.player.btn.Buffering;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.PingUtils;
	import vn.meme.cloud.player.comp.AdsLayer;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoPlayerComponent;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.VideoThumbnail;
	import vn.meme.cloud.player.comp.WaitingLayer;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.config.PlayInfo;
	import vn.meme.cloud.player.config.VideoQuality;
	import vn.meme.cloud.player.config.ads.AdInfo;
	import vn.meme.cloud.player.config.ads2.AdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnBigPlay;
	import vn.meme.cloud.player.listener.OnFullscreen;
	import vn.meme.cloud.player.listener.OnMouseMove;
	import vn.meme.cloud.player.listener.OnMute;
	import vn.meme.cloud.player.listener.OnNormalScreen;
	import vn.meme.cloud.player.listener.OnPause;
	import vn.meme.cloud.player.listener.OnPlay;
	import vn.meme.cloud.player.listener.OnPlaying;
	import vn.meme.cloud.player.listener.OnQuality;
	import vn.meme.cloud.player.listener.OnQualitySelect;
	import vn.meme.cloud.player.listener.OnResize;
	import vn.meme.cloud.player.listener.OnSeek;
	import vn.meme.cloud.player.listener.OnSignClick;
	import vn.meme.cloud.player.listener.OnVideoEnd;
	import vn.meme.cloud.player.listener.OnVolume;
	import vn.meme.cloud.player.listener.OnVolumeSlider;
	import vn.meme.cloud.player.listener.ads.OnAdsComplete;
	import vn.meme.cloud.player.listener.ads.OnAdsError;
	import vn.meme.cloud.player.listener.ads.OnContentPauseRequest;
	import vn.meme.cloud.player.listener.ads.OnContentResumeRequest;
	import vn.meme.cloud.player.listener.ads.OnSkipped;
	import vn.meme.cloud.player.listener.ads.OnUserClose;
	import vn.meme.cloud.player.listener.ads.OnVASTSkip;
	
	public class VideoPlayer extends Sprite
	{
		
		private static var instance:VideoPlayer ;
		public static function getInstance():VideoPlayer{
			return instance;
		}
		
		public static var VERSION : String = "CloudVideoPlayerVersion100";
		
		public var listener:Vector.<VideoPlayerEventListener>;
		public var components: Vector.<VideoPlayerComponent>;
		
		// components
		public var videoStage:VideoStage;
		public var ads : AdsLayer;
		public var controls : Controls;
		
		public var thumb : VideoThumbnail;
		public var wait : WaitingLayer;
		
		public var playInfo : PlayInfo;
		public var referer : String;
		public var source : String;
		
		public var pingUtils : PingUtils;
		public var buffering : Buffering; 
		
		public function VideoPlayer()
		{
		 	if (this.stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(ev:Event = null):void{
		
			var self : VideoPlayer = this;
			instance = this;
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			// common config
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.quality = StageQuality.BEST;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.showDefaultContextMenu = false;

			// context menu
			
			var contextMenu : ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			var sign:ContextMenuItem= new ContextMenuItem("Powered by MeCloud @2015 v1.02.20150508.1139");
			sign.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function():void{
				navigateToURL(new URLRequest('http://mecloud.vn/product'),"_blank");
			});
			contextMenu.customItems.push(sign);
			this.contextMenu = contextMenu;
			
			// setup listener
			this.listener = new Vector.<VideoPlayerEventListener>();
			this.setupEventListener(new OnPlay());
			this.setupEventListener(new OnQuality());
			this.setupEventListener(new OnPause());
			this.setupEventListener(new OnFullscreen());
			this.setupEventListener(new OnNormalScreen());
			this.setupEventListener(new OnResize());
			this.setupEventListener(new OnMouseMove());
			this.setupEventListener(new OnSeek());
			this.setupEventListener(new OnVolume());
			this.setupEventListener(new OnVolumeSlider());
			this.setupEventListener(new OnMute());
			this.setupEventListener(new OnSignClick());
			this.setupEventListener(new OnPlaying());
			this.setupEventListener(new OnVideoEnd());
			this.setupEventListener(new OnBigPlay());
			this.setupEventListener(new OnQualitySelect());
			
			
			// ad listener
			this.setupEventListener(new OnAdsError());
			this.setupEventListener(new OnAdsComplete());
			this.setupEventListener(new OnContentPauseRequest());
			this.setupEventListener(new OnContentResumeRequest());
			this.setupEventListener(new OnUserClose());
			this.setupEventListener(new OnSkipped());
			this.setupEventListener(new OnVASTSkip());
			
			// setup components
			this.components = new Vector.<VideoPlayerComponent>();
			this.setupComponent(videoStage = new VideoStage(this));
			this.setupComponent(thumb = new VideoThumbnail(this));
			this.setupComponent(controls = new Controls(this));
			
			this.setupComponent(wait = new WaitingLayer(this));
			this.setupComponent(ads = new AdsLayer(this));
			this.setupComponent(PlayerTooltip.getInstance());
			
			this.addChild(this.buffering=new Buffering(this));
			
			// on stage resize
			this.stage.addEventListener(Event.RESIZE,function(ev:Event):void{
				self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.RESIZE));
			});
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,function(ev:Event):void{
				self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.MOUSE_MOVE)); 
			});
			
			
			// get data
			if (ExternalInterface.available){
				var url:String = ExternalInterface.call("window.location.href.toString");
				referer = ExternalInterface.call("escape",url);
				url = ExternalInterface.call("document.referrer");
				source = ExternalInterface.call("escape",url);
				
				ExternalInterface.addCallback("importData",importData);
				var session: String = this.stage.loaderInfo.parameters['session'];
				ExternalInterface.call("MeCloudVideoPlayer.initFlash",session);
				
				
				if (url && url.indexOf("cloud.meme.vn/product/videoPlayer.html") > 0) {
					ExternalInterface.addCallback("setAdInfo",importAdData);
				}
			} else {
				referer = "";
			}
			
			this.stage.dispatchEvent(new Event(Event.RESIZE));
		
		}
		
		private function setupEventListener(l:VideoPlayerEventListener):void{
			
			this.addEventListener(l.eventName(),function(ev:VideoPlayerEvent):void{
				var vp : VideoPlayer = instance,
				vs : VideoStage = vp.videoStage;
				if (l.excuteLogic(vp,vs,ev))
					l.updateView(vp);
			});
			this.listener.push(l);
			
		}
		
		private function setupComponent(c:VideoPlayerComponent):void{
			this.addChild(c);
			this.components.push(c);
		}
		
		private function importData(data:*):void{
		
			if (data){
				playInfo = new PlayInfo(data);
				
				var vq : VideoQuality = playInfo.video[playInfo.defaultQuality?playInfo.defaultQuality:0];
				this.videoStage.setVideoUrl(vq.url);
				this.thumb.setThumbnail(playInfo.thumbnail);
				if (playInfo.duration)
					TimeDisplay.getInstance().setVideoLength(playInfo.duration);
				if (data.analyticsUrl)
					PingUtils.url = data.analyticsUrl;
				if(data.autoplay){
					dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAY));
				}
				if (!pingUtils)
					pingUtils = new PingUtils();
				pingUtils.start();
			}
		}
		
		private function importAdData(data:*):void{
			if (data && playInfo){
				CommonUtils.log("Receive new ads config");
				playInfo.ad = new AdInfo(data);
				playInfo.ad2 = new AdInfo2(data);
				restart();
			}
		}
		
		private function restart():void{
			this.videoStage.destroy();
			while (numChildren > 0)
				removeChildAt(0);
			this.components = new Vector.<VideoPlayerComponent>();
			this.setupComponent(videoStage = new VideoStage(this));
			this.setupComponent(thumb = new VideoThumbnail(this));
			this.setupComponent(controls = new Controls(this));
			
			this.setupComponent(wait = new WaitingLayer(this));
			this.setupComponent(ads = new AdsLayer(this));
			this.setupComponent(PlayerTooltip.getInstance());
			var vq : VideoQuality = playInfo.video[playInfo.defaultQuality?playInfo.defaultQuality:0];
			this.videoStage.setVideoUrl(vq.url);
			this.thumb.setThumbnail(playInfo.thumbnail);
		}
		
		
	}
}