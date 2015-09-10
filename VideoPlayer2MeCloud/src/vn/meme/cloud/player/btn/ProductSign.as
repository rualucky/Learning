package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.media.Video;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class ProductSign extends VideoPlayerButton
	{
		
		[Embed(source="asset/logo-player.png")]
		public static var asset:Class;
		
		[Embed(source="asset/logo_hover.png")]
		public static var asset_hover:Class;
		
		public var main : Bitmap;
		private var hover : Bitmap;
		
		public function ProductSign()
		{			
			super(VideoPlayerEvent.SIGN_CLICK);
			main = new asset() as Bitmap;
			main.smoothing = true;
			hover = new asset_hover() as Bitmap;
			hover.smoothing = true;
			hover.visible = false;
			addChild(main);
			addChild(hover);
			this.alpha = 1;
		}
		
		protected override function onMouseOver(ev:MouseEvent = null):void{
			hover.visible = true;
			main.visible = false;
		}
		
		protected override function onMouseOut(ev:MouseEvent = null):void{
			main.visible = true;
			hover.visible = false;
		}
	}
}