package vn.meme.cloud.player.comp.sub
{
	import fl.video.VideoScaleMode;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoPlayerComponent;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class TimeLine extends VideoPlayerComponent
	{
		private static var instance:TimeLine ;
		public static function getInstance():TimeLine{
			return instance;
		}
		
		private var bufferedLayer : Sprite;
		private var playLayer : Sprite;
		private var adsLayer : Sprite;
		
		private var play : Number;
		private var load : Number;
		
		private var timing : uint;
		private var sizeTiming: uint;
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		private var vs : VideoStage = vp.videoStage;
		
		private var timeClicked : Number;
		private var timeHover : Number;
		
		public function TimeLine(player:VideoPlayer)
		{
			this.play = 0;
			this.load = 0;
			sizeTiming = 0;
			addChild(bufferedLayer = new Sprite());
			addChild(playLayer = new Sprite());
			addChild(adsLayer = new Sprite());
			super(player);
			instance = this;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(ev:MouseEvent):void{
			if (vs.checkHLS){		
					this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SEEK, timeHover));
			} else {			
			var time : int = (ev.localX / this.width ) * player.videoStage.getLength() / 1000;
			this.dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SEEK,(ev.localX / player.stage.stageWidth) * player.videoStage.getLength() / 1000));
			}
		}
		
		private function onMouseOver(ev:MouseEvent):void{	
			if (vs.checkHLS){
					PlayerTooltip.getInstance().show(TimeDisplay.toTimeDisplay((ev.localX /player.stage.stageWidth ) * vs.returnHLSRawDuration()),
						ev.stageX, localToGlobal(new Point(0,-4)).y);
					sizeTiming = setInterval(larging,50);					
			} else {
				clearTimeout(timing);
				clearInterval(sizeTiming);
				sizeTiming = setInterval(larging,50);
			}
		}
		
		private function onMouseOut(ev:MouseEvent):void{
			clearTimeout(timing);
			timing = setTimeout(normalMode,3000);
			PlayerTooltip.getInstance().visible = false;
		}
		
		private function onMouseMove(ev:MouseEvent):void{
			
			if (player.videoStage.isReady && (player.videoStage.playing || player.videoStage.getLength() || !player.videoStage.playing)){				
				if(vs.checkHLS){					
					PlayerTooltip.getInstance().show(TimeDisplay.toTimeDisplay((ev.localX /player.stage.stageWidth ) * vs.returnHLSRawDuration()),
						ev.stageX, localToGlobal(new Point(0,-4)).y);
					timeHover = (ev.localX /player.stage.stageWidth ) * vs.returnHLSRawDuration();
				} else {				
				PlayerTooltip.getInstance().show(TimeDisplay.toTimeDisplay((ev.localX /player.stage.stageWidth ) * player.videoStage.getLength() / 1000),
					ev.stageX, localToGlobal(new Point(0,-4)).y);
				clearTimeout(timing);				
				}				
			}
		}
		
		private function normalMode():void{
			this.scaleY = 1;
		}
		
		private function larging():void{
			if (this.scaleY >= 2){
				this.scaleY = 2;
				clearInterval(sizeTiming);
			} else {
				this.scaleY += 0.166666666;
			}
		}
		
		override public function initSize(ev:Event = null):void{
			this.y = 2;
			this.x = 0;
			redraw();
		}
		
		public function setPlay(play:Number):void{
			this.play = play;
			redrawPlayLayer();
		}
		
		public function setBuffered(load:Number):void{
			this.load = load;
			redrawBuffered();
		}
		
		private function redraw():void{
			var self : TimeLine = this;
			with (graphics){
				clear();				
				beginFill(0x4f4f4f); //0x4f4f4f
				drawRect(0,-2,player.stage.stageWidth,3);
				endFill();
			}
			redrawBuffered();
			redrawPlayLayer();
		}
		
		private function redrawBuffered():void{
			var self : TimeLine = this;
			if (self.load && self.load != 0){
				with (bufferedLayer.graphics){
					clear();
					beginFill(0x777777); //0x777777
					drawRect(0,-2,player.stage.stageWidth * self.load,3);
					endFill();
				}
			}
		}
		
		private function redrawPlayLayer():void{
			var self : TimeLine = this;
			if (self.play && self.play != 0){
				with (playLayer.graphics){
					clear();
					beginFill(0x3ea9f5); 
					drawRect(0,-2,player.stage.stageWidth * self.play,3);
					endFill();
				}
			}
		}  
		
		public function redrawHLSPlayLayer(time:Number, duration:Number):void{
			var rate : Number = time / duration;
			with (playLayer.graphics){
				clear();
				beginFill(0x3ea9f5); 
				drawRect(0,-2,player.stage.stageWidth * rate,3);
				endFill();
			}
		}
		
		public function drawAdPoint(firstPosition:int, otherPosition:int, numberPosition:int):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var i : int = 0;
			var rate : Number = (vp.stage.stageWidth / (vp.videoStage.getLength() / 1000));
			firstPosition = firstPosition + 3;
			with (adsLayer.graphics){
				clear();
				beginFill(0xf6ba00); 
				drawRect(firstPosition*rate,-2,5,3);				
				while (i <= numberPosition){
					i++;
					drawRect((firstPosition + otherPosition*i - 3)*rate,-2,5,3);
				}
				endFill();
			}
		}
		
	}
}