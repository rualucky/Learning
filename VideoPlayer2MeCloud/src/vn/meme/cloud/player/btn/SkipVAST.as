package vn.meme.cloud.player.btn
{
	import com.google.ads.ima.api.AdEvent;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.TextAlign;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class SkipVAST extends VideoPlayerButton
	{
		
		[Embed(source="asset/btn-skip.png")]
		public static var asset:Class;
		
		private var textFormat : TextFormat;		
		private var tf : TextField;		
		private var bm : Bitmap;
		private var self;
		private static const SKIP_TIME : int = 6;
		private var skipCount : int;
		private var skipTimer : Timer = new Timer(1000, SKIP_TIME);
		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		private static const instance : SkipVAST = new SkipVAST;
		public static function getInstance():SkipVAST{
			return instance;
		}
		
		public function SkipVAST()
		{
			super(VideoPlayerEvent.SKIP_VAST);
			self = this;
			bm = this.invertBitmapColor((new asset()) as Bitmap);			
			bm.width = 15;
			bm.height = 20;
			bm.x = 83;
			bm.y = 7;
			addChild(bm);
			bm.visible = false;			
			
			tf = new TextField();			
			textFormat = new TextFormat("Arial",15,0xffffff);						
			tf.defaultTextFormat = textFormat;			
			tf.mouseEnabled = false;
			tf.wordWrap = true;		
			tf.width = 150;
			addChild(tf);

			tf.x = 10;
			tf.y = 5;
			
			var g : Graphics = this.graphics; 
			g.clear();
			g.beginFill(0xffffff, 0.226);
			g.drawRect(0,0,124,32);			
			g.drawRect(1,1,122,30);						
			g.endFill();
			g.beginFill(0x000000, 0.226);
			g.drawRect(1,1,122,30);
			g.endFill();
			
			alpha = 0.6;	
			
			if (vp.videoStage.width <= 480)
				this.x = vp.videoStage.width - 130;
			if (vp.videoStage.width > 480 && vp.videoStage.width <= 640)
				this.x = vp.videoStage.width - 85;
			if (vp.videoStage.width > 640)
				this.x = vp.videoStage.width - 130;
			
			this.y = vp.videoStage.height * 0.86;
			
			skipTimer.addEventListener(TimerEvent.TIMER, function():void{
				skipCount = SKIP_TIME - skipTimer.currentCount;	
				tf.text = "Bỏ qua trong " + skipCount;		
				if (skipCount > 0){
					mouseEnabled = false;
				}
				if (skipCount == 0){						
					skipTimer.reset();	
					mouseEnabled = true;
					bm.visible = true;
					tf.text = "Bỏ qua";	
					tf.x = 20;
				}
			});
			skipTimer.start();
		}
		
		public function changePosition(player:VideoPlayer):void{
			if (player.videoStage.width <= 480)
				VideoPlayerAdsManager2.getInstance().skipBtn.x = player.videoStage.width - 130;
			if (player.videoStage.width > 480 && player.videoStage.width <= 640)
				VideoPlayerAdsManager2.getInstance().skipBtn.x = player.videoStage.width - 85;
			if (player.videoStage.width > 640)
				VideoPlayerAdsManager2.getInstance().skipBtn.x = player.videoStage.width - 130;
			VideoPlayerAdsManager2.getInstance().skipBtn.y = player.videoStage.height * 0.86;
			
		}
		override protected function onMouseOver(ev:MouseEvent = null):void{
			this.alpha = 1;
		}
		
		override protected function onMouseOut(ev:MouseEvent = null):void{
			this.alpha = 0.6;
		}
	}
}