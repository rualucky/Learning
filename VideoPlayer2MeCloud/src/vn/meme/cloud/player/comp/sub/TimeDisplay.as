package vn.meme.cloud.player.comp.sub
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import org.mangui.hls.event.HLSEvent;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.VideoPlayerComponent;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.listener.OnPause;
	import vn.meme.cloud.player.listener.OnPlay;
	import vn.meme.cloud.player.listener.OnVideoEnd;
	
	public class TimeDisplay extends VideoPlayerComponent
	{
		private static var instance:TimeDisplay ;
		public static function getInstance():TimeDisplay{
			return instance;
		}
		
		private var videoLength : int;
		private var time : int;
		
		public var text : TextField;	
		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		private var vs : VideoStage = vp.videoStage;
		public var timer : Timer = new Timer(1000);
		public var countTime : int;
		
		public function TimeDisplay(player:VideoPlayer)
		{ 
			super(player);
			instance = this;			
			addChild(text = new TextField());
			text.mouseEnabled = false;
			var tf : TextFormat = new TextFormat('Arial',13,0xaaaaaa); 
			text.defaultTextFormat = tf;
			text.text = '0:00 / 0:00';			
		}
		
		override public function initSize(ev:Event = null):void{
			
		}
		
		public function setVideoLength(vl:Number):void{			
			videoLength = vl / 1000;			
			updateView();
		}
		
		public function setPlayTime(t:Number):void{
			time = t / 1000;
			updateView();
		}
		
		public static function toTimeDisplay(time:int):String{			
			if (time <= 0)
				return '0:00';
			var v : String = '',t:int = time;
			if (time > 3600){
				v = v.concat( int(t / 3600) + ':');
				t = t % 3600;
			}
			if (time > 3600 && t < 600) v = v.concat('0');
			v = v.concat(int(t / 60) + ':');
			t = t % 60;
			if (t < 10) v = v.concat('0');
			v = v.concat(t);
			return v;
		}
		
		private function updateView():void{
			
			if (time > videoLength){
				time = videoLength;
			}		
			text.text = toTimeDisplay(time) + ' / ' + toTimeDisplay(videoLength);			
			text.width = text.textWidth + 20;			
		}
		
		/**
		 * HLS
		 */ 	 
		    
		public function setHLSPlayTime(duration:Number):void{			
			text.width = text.textWidth + 100;								  
			timer.addEventListener(TimerEvent.TIMER, function():void{	
				TimeLine.getInstance().setBuffered(vs.hls.position / vs.hls.stream.bufferLength);
				TimeLine.getInstance().redrawHLSPlayLayer(vs.hls.position, duration);
				text.text = toTimeDisplay(vs.hls.position) + ' / ' + toTimeDisplay(duration);
				if (Math.floor(vs.hls.position + 0.2) >= duration) { 
					text.text = toTimeDisplay(duration) + ' / ' + toTimeDisplay(duration);					
					timer.reset();
					vs.onHLSEnd();
				}  
			});			
		}
	
	}
}