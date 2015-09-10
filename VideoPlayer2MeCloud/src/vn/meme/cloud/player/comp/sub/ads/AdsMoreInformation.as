package vn.meme.cloud.player.comp.sub.ads
{
	
	import com.google.ads.ima.api.AdsManager;
	import com.google.ads.ima.api.AdsManagerLoadedEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager2;
	
	public class AdsMoreInformation extends Sprite
	{
		
		private static const instance : AdsMoreInformation = new AdsMoreInformation;
		public static function getInstance():AdsMoreInformation{
			return instance;
		}
		
		private var self;
		private var textFormat : TextFormat;		
		public var tf : TextField;
		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		public function AdsMoreInformation()
		{
			self = this;
			tf = new TextField();			
			textFormat = new TextFormat("Arial",12,0xffffff);						
			tf.defaultTextFormat = textFormat;
			tf.wordWrap = true;		
			tf.mouseEnabled = false;
			tf.width = 150;
			tf.text = "Tìm hiểu thêm >>";
			addChild(tf);
			
			tf.x = 10;
			tf.y = 5;
						
			var g : Graphics = this.graphics; 
			g.clear();
			g.beginFill(0xffffff, 0.226);
			g.drawRect(0,0,119,29);			
			g.drawRect(1,1,117,27);						
			g.endFill();
			g.beginFill(0x000000, 0.226);
			g.drawRect(1,1,117,27);
			g.endFill();
			
			alpha = 0.6;
			
			this.x = 5;
			
			if (vp.videoStage.width <= 640){
				this.y = vp.videoStage.height - 10;	
			} else {
				this.y = vp.videoStage.height - 40;
			}
			
		}
		
		public function changePosition(player:VideoPlayer):void{
			if (player.videoStage.width <= 640){
				VideoPlayerAdsManager2.getInstance().adsMoreInformation.y = player.videoStage.height - 10;	
			} else {
				VideoPlayerAdsManager2.getInstance().adsMoreInformation.y = player.videoStage.height - 40;
			}
		}
	}
}