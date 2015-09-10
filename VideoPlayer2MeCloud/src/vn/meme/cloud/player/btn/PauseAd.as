package vn.meme.cloud.player.btn
{
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import vn.meme.cloud.player.config.ads2.BasicAdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class PauseAd extends Sprite
	{
		
		private var txFrame : Sprite;
	 	public var tf : TextField;
		private var textFormat : TextFormat;
		private var g : Graphics;
		
		private static var instance:PauseAd = new PauseAd();
		public static function getInstance():PauseAd{
			return instance;
		}
		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		
		public function PauseAd()
		{
			tf = new TextField();	
			txFrame = new Sprite();
			textFormat = new TextFormat("Arial",11,0xffffff);						
			tf.defaultTextFormat = textFormat;
			tf.wordWrap = true;		
			tf.mouseEnabled = false;
			tf.width = 150;
			tf.text = "Bạn đang xem quảng cáo";
			addChild(tf);
			
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xAAAAAA);
			g.drawRect(0, 0, vp.stage.stageWidth, vp.stage.stageHeight - 30);
			g.endFill();
		}
		
		public function drawPauseAdFrame(width : Number, height : Number) : void{
			var g : Graphics = this.graphics;
			g.clear();
			g.beginFill(0xAAAAAA);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
	}
}