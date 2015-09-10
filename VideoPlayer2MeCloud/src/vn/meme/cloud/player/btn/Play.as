package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Play extends VideoPlayerButton
	{
		[Embed(source="asset/btn-play.png")]
		public static var asset:Class;
		
		public function Play()
		{
			super(VideoPlayerEvent.PLAY);	
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			super.onMouseOver(ev);			
			//var point : Point = localToGlobal(new Point(8, -4));			
			//PlayerTooltip.getInstance().show("Chơi", point.x, point.y);			
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			super.onMouseOut(ev);
			//PlayerTooltip.getInstance().visible = false;
		}
			
		
	}
}