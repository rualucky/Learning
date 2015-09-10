package vn.meme.cloud.player.comp
{
	import fl.controls.ComboBox;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.mangui.hls.HLS;
	import org.mangui.hls.constant.HLSLoaderTypes;
	import org.mangui.hls.constant.HLSPlayStates;
	import org.mangui.hls.event.HLSError;
	import org.mangui.hls.event.HLSEvent;
	import org.mangui.hls.event.HLSLoadMetrics;
	import org.mangui.hls.event.HLSMediatime;
	import org.mangui.hls.event.HLSPlayMetrics;
	import org.mangui.hls.model.Level;
	import org.mangui.hls.stream.HLSNetStream;
	import org.mangui.hls.utils.Log;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.PingUtils;
	import vn.meme.cloud.player.common.VASTAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.sub.TimeDisplay;
	import vn.meme.cloud.player.comp.sub.TimeLine;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.listener.OnPause;
	
	public class VideoStage extends VideoPlayerComponent
	{		
		public var hls : HLS = null;
		public var checkHLS : Boolean = false;
		private var video : Video;
		public var netstream : NetStream;
		private var connection : NetConnection;
		public var url : String;	
		
		private var stageWidth : int;
		private var stageHeight : int;
		
		private var playTime : int;
		private var videoLength : int;
		private var startPosition : Number;		
		private var nextStartPosition : Number;
		public var end : Boolean;
		private var isPlaying : Boolean;
		
		private var timing : int;
		private var bufferedTiming : int;
		
		private var wRatio : int;
		private var hRatio : int;
		
		private var pingSV : Boolean;
		
		private var clicked : Number;
		private var clickTiming : uint;
				
		private var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		
		public var rawHLSQuality : Number = -1;
		public var rawHSLDuration : Number;
		public var durationHLS : Number;
		public var isHslVideoEnd : Boolean = false;
		
		public var playerWidth : Number;
		public var playerHeight : Number;
		
		public var _isBuffering : Boolean = false;
		private var isBufferTimeLine : uint = 0;
		private var pcn : Number;
		/**
		* contrucstor
		*/
		public function VideoStage(player:VideoPlayer)
		{
			super(player);
			playTime = 0;
			timing = 0;
			startPosition = 0;
			nextStartPosition = 0;
			videoLength = 0;
			end = false;
			isPlaying = false;
			wRatio = 16;
			hRatio = 9;
			pingSV = false;
			var self : * = this;
			addEventListener(MouseEvent.CLICK,function(ev:Event):void{
				if (isPlaying){
					var t : Number = new Date().time;
					CommonUtils.log("Date().time: " + t);
					if (t - clicked < 200){
						if (CommonUtils.freeze()){							
							self.dispatchEvent(new VideoPlayerEvent(
								stage.displayState == StageDisplayState.NORMAL ? VideoPlayerEvent.FULLSCREEN : VideoPlayerEvent.NORMALSCREEN));
						}
						clearTimeout(clickTiming);
					} else {
						clickTiming = setTimeout(function():void{
							if (CommonUtils.freeze()){
								self.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PAUSE));
							}
						},200);
					}
					clicked = t;
				}
			});
		}
		
		override public function initSize(ev:Event = null):void{
			this.stageWidth = player.stage.stageWidth;
			if (player.stage.displayState == StageDisplayState.NORMAL)
				this.stageHeight = player.stage.stageHeight - Controls.HEIGHT;
			else this.stageHeight = player.stage.stageHeight;
			if (video){
				setUpVideoSize();
			}
		}
		
		private function setUpVideoSize():void{
			var r : Number = this.stageWidth / this.stageHeight;
			if ( Math.abs(r - (wRatio/hRatio)) < 0.05){
				video.width = this.stageWidth;
				video.height = this.stageHeight;
				video.x = 0;
				video.y = 0;
				return;
			} 
			
			if ( r > wRatio/hRatio){
				video.height = this.stageHeight;
				video.width = this.stageHeight * wRatio/hRatio;
				video.x = (this.stageWidth - video.width) / 2;
				video.y = 0;
				return;
			}
			
			video.width = this.stageWidth;
			video.height = this.stageWidth * hRatio/wRatio;
			video.x = 0;
			video.y = (this.stageHeight - video.height) / 2;
		}
				
		public function setVideoUrl(url:String):void{
			
			playerWidth = this.stage.width;
			playerHeight = this.stage.height;
			
			if (url.match(".m3u8")){
				
				CommonUtils.log("HLS Type " + url);	

			} else {
				CommonUtils.log("Init Video URL " + url);
			}
			
			
			// stop old
			if (video && this.contains(video)){
				removeChild(video);
			}
			if (netstream){
				netstream.close();
			}
			if (connection){
				connection.close();
			}
			
			// start new
			this.url = url;
			rawHLSQuality += 1;
			
			if(url.match(".m3u8")){
				
				checkHLS = true;
				hls = new HLS();
				hls.stage = this.stage;
				video = new Video(this.stageWidth,this.stageHeight);
				
				addChild(video);
				video.x = 0;
				video.y = 0;
			
				video.smoothing = true;
				video.attachNetStream(hls.stream);
				
			} else {
				
				video = new Video(this.stageWidth,this.stageHeight);
				setUpVideoSize();
				createNetstream();
				video.attachNetStream(netstream);
				video.smoothing = true;
				addChild(video);
				
			}
			
		}
		
		private function createNetstream():void{
			if (netstream) netstream.close();
			
			connection = new NetConnection();
			connection.connect(null);
			netstream = new NetStream(connection);
			netstream.client = {
				onCuePoint : function(infoObject:Object):void {
				},
				onMetaData : function (infoObject:Object):void {
					if (!infoObject) return;
					if (infoObject.duration){
						CommonUtils.log("New duration " + infoObject.duration + " " + videoLength);
						if (videoLength == 0){
							videoLength = (startPosition + infoObject.duration) * 1000 + 1;
							TimeDisplay.getInstance().setVideoLength(videoLength);							
						} else {
							if (nextStartPosition != 0){
								nextStartPosition = (videoLength - (infoObject.duration * 1000)) / 1000;
							}
						}
					}
					startPosition = nextStartPosition;
					timing = setInterval(onPlaying,10);
					if (netstream.bytesLoaded < netstream.bytesTotal){
						bufferedTiming = setInterval(onBuffered,16); 
					}
					
					if (infoObject.width && infoObject.height){
						wRatio = infoObject.width;
						hRatio = infoObject.height;
						setUpVideoSize();
					}
				}
			};
			netstream.addEventListener(NetStatusEvent.NET_STATUS, statusChanged); 
			
			var st : SoundTransform;
			if (volumeX.data.my_x == undefined || volumeX.data.my_x == null){
				st = new SoundTransform(0.5);
			} else if (volumeX.data.my_x <= 5) {
				st = new SoundTransform(0);
			} else {
				st = new SoundTransform(volumeX.data.my_x * 2 / 100);
			}
			netstream.soundTransform = st;
		}
		
		private function freeSeek(offset:Number = 0):void{
			end = false;
			isPlaying = true;
			if (offset == 0){
				nextStartPosition = 0;
				startPosition = 0;
				playTime = 0;
				createNetstream();
				video.attachNetStream(netstream);
				netstream.play(url);
			} else {
				nextStartPosition = offset;
				playTime = 0;
				netstream.play(url + "&start=" +offset);
			}
			pingSV = true;
		}
		
		public function returnHLSRawDuration():int{
			return hls.levels[(hls.startLevel)].duration;
		}
		
		public function manifestHandler(event : HLSEvent):void{			
			durationHLS = event.levels[(hls.startLevel)].duration;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			vp.videoStage.volumeSlider(volumeX.data.my_x); 
			ct.pauseBtn.visible = true;
			ct.playBtn.visible = false;
			vp.thumb.visible = false;
			vp.wait.visible = false;
			TimeDisplay.getInstance().timer.start();
			TimeDisplay.getInstance().setHLSPlayTime(returnHLSRawDuration());	
			hls.stream.play(null, -1);	
		
			if (hls.levels[(hls.currentLevel)].width < hls.levels[(hls.currentLevel)].height){
				vp.videoStage.width = hls.levels[(hls.currentLevel)].width;
				vp.videoStage.x = hls.levels[(hls.currentLevel)].width + Math.round((playerWidth%hls.levels[(hls.currentLevel)].width)) / 2;
				vp.videoStage.height = hls.levels[(hls.currentLevel)].height - 30;
			}
			onHLSPlaying();
		}
		
		private function onHLSPlaying():void{
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYING,hls.position));
		}
		
		public function onHLSEnd():void{			
			/*var vp : VideoPlayer = VideoPlayer.getInstance();
			isHslVideoEnd = true;
			hls.stream.pause();
			VideoPlayerAdsManager.getInstance().request(vp.playInfo.ad.post);
			hls.removeEventListener(HLSEvent.MANIFEST_LOADED, manifestHandler);
			*/
			isHslVideoEnd = true; 
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_END));
		}
		
		public function play():void{
			netstream.bufferTime = 10;
			if (checkHLS){
				isHslVideoEnd = false;
				playTime = 0;
				end = false;
				isPlaying = true;
				pingSV = true;
				hls.addEventListener(HLSEvent.MANIFEST_LOADED, manifestHandler); 
				hls.load(url);	
			}
			if (url && !checkHLS){
				CommonUtils.log("Play video " + url);
			
				netstream.play(url);
				playTime = 0;
				end = false;
				isPlaying = true;
				pingSV = true;
			}
		}
		
		public function seek(offset:Number = 0):void{
			if (netstream){
				player.pingUtils.ping("ev",playTime);
				// if loaded
				if (offset >= startPosition &&  
					(videoLength - startPosition) * (netstream.bytesLoaded / netstream.bytesTotal) >= offset * 1000){
					netstream.seek(offset - startPosition);
					pingSV = true;
//					CommonUtils.log("Seek " +offset + " " + startPosition);
				} 
				// if not loaded, free seek
				else {
					freeSeek(offset);
				}
				playTime = offset * 1000;
			}
		}
		
		public function pause():void{
			if (checkHLS){		
					isPlaying = false;
					TimeDisplay.getInstance().timer.stop(); 
					hls.stream.pause();	
					playTime = hls.stream.time;				
					CommonUtils.log("stream time pause: " + playTime);
								
			} else {
				isPlaying = false;
				netstream.pause();
				clearInterval(timing);
				player.pingUtils.ping("ev");
			}
		}
		
		public function resume():void{
			CommonUtils.log("Resume video " + end);
			if (checkHLS){			
					TimeDisplay.getInstance().timer.start();
					hls.stream.resume();
					isPlaying = true;
					CommonUtils.log("stream time resume: " + playTime);				
			} else {
			if (end) {
				playTime = 0;
				if (startPosition == 0)
					netstream.seek(0);
				else {
					freeSeek(0);
					return;
				}
			}  
			
			netstream.resume();
			timing = setInterval(onPlaying,10);
			end = false;
			isPlaying = true;
			pingSV = true;
			}
		}
		
		private function onPlaying():void{
//			if (netstream.time * 1000 > playTime && netstream.time * 1000 < playTime + 500){
			if (netstream.bytesLoaded > 0 && pingSV){
				player.pingUtils.ping("sv");
				pingSV = false;
			}
			playTime = netstream.time * 1000;
//			}
			var rate : Number = (playTime + startPosition * 1000)/ videoLength;
									
//			CommonUtils.log("Time rate " + rate + " " + startPosition + " " + playTime + " " + videoLength);
			TimeLine.getInstance().setPlay(rate);
			TimeDisplay.getInstance().setPlayTime(playTime + startPosition * 1000);
			
			if(this.isBuffering){
				VideoPlayer.getInstance().buffering.visible=true;
			} else {
				VideoPlayer.getInstance().buffering.visible=false;
			}
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.PLAYING,playTime/1000));
		}
		
		private function onBuffered():void{
			TimeLine.getInstance().setBuffered(startPosition * 1000 / videoLength + netstream.bytesLoaded / netstream.bytesTotal);
			if (netstream.bytesLoaded >= netstream.bytesTotal){
				
				clearInterval(bufferedTiming);
			}
		}
		
		private function statusChanged(stats:NetStatusEvent):void {
			CommonUtils.log(stats.info.code);
			if (stats.info.code == 'NetStream.Play.Stop') {
				clearInterval(isBufferTimeLine);
				isBufferTimeLine = 0;
				onEnd();
			}
			if (stats.info.code == 'NetStream.Play.Start') {
				if(isBufferTimeLine == 0)
					isBufferTimeLine = setInterval(bufferingCron,10);
			}
			if (stats.info.code == 'NetStream.Buffer.Full'){
			}
		}
		
		private function bufferingCron(){
			if(netstream.bytesLoaded >= netstream.bytesTotal) return _isBuffering = false;
			pcn = netstream.bufferLength / netstream.bufferTime;
			if(pcn > 0.95){
				_isBuffering = false; return;
			}
			if(pcn < 0.95 && pcn > 0.25 && !_isBuffering){
				_isBuffering = false; return;
			}
			if(pcn < 0.95 && pcn > 0.25 && _isBuffering){
				_isBuffering = true; return;
			}
			if(pcn < 0.25){
				_isBuffering = true; return;
			}
		}
		
		public function get isBuffering():Boolean{
			return _isBuffering;
		}
		
		private function onEnd():void{
			clearInterval(timing);
			playTime = videoLength;
			end = true;
			isPlaying = false;
			player.pingUtils.ping("ev");
			netstream.pause();
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.VIDEO_END));
		}
		
		public function currentTime():Number{
			return playTime + startPosition * 1000;
		}
		
		public function getLength():Number{
			return videoLength;
		}
		
		public function get playing():Boolean{
			return isPlaying;
		}
		
		public function get isReady():Boolean{
			return !!url;
		}
		
		public function getStartPosition():Number{
			return startPosition;
		}
		
		public function getStageWidth():Number{
			return this.stageWidth;
		}
		 
		public function getStageHeight():Number{
			return this.stageHeight;
		}
		
		public function mute():void{
			var st : SoundTransform = new SoundTransform(0);
			if (checkHLS){
				hls.stream.soundTransform = st;
			} else {				
				netstream.soundTransform = st;
			}
		}
		
		public function volumeOn():void{
			var st : SoundTransform = new SoundTransform(1);
			if (checkHLS){
				hls.stream.soundTransform = st; 
			} else {
				netstream.soundTransform = st;
			}
		}
		
		public function volumeSlider(sliderX:int):void{
			var st : SoundTransform = new SoundTransform(sliderX * 2 / 100);
			if (checkHLS){
				hls.stream.soundTransform = st;
			} else {
				netstream.soundTransform = st;
			}
		}
		
		public function destroy():void{
			mute();
			netstream.close();
		}
		
		public function isEnd():Boolean{
			return end;
		}		
		
		public function returnHLSQualityList():Vector.<Level>{
			if (rawHLSQuality == 0){
				return hls.levels;
			} else {
			 return null;
			} 
		}
		
	}
}