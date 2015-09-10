package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class NormalScreen extends VideoPlayerButton
	{
		[Embed(source="asset/btn-fullscreen-exit.png")]
		public static var asset:Class;

		private static var instance:NormalScreen ;
		public static function getInstance():NormalScreen{
			return instance;
		}
		
		public function NormalScreen()
		{
			super(VideoPlayerEvent.NORMALSCREEN);
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
			instance = this;
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);
			
			var point : Point = localToGlobal(new Point(8, -4));
			
			PlayerTooltip.getInstance().show("Trở về bình thường", point.x, point.y);
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			PlayerTooltip.getInstance().visible = false;
		}
	}
}