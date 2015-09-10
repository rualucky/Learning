package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class VideoPlayerButton extends Sprite
	{
		public static const MOVER_FILTER : ColorMatrixFilter 
			= new ColorMatrixFilter( 	[0.7, 0, 0, 0, 0,
										 0, 0.7, 0, 0, 0,
										 0, 0, 0.7, 0, 0,
										 0, 0, 0, 1, 0] );
			
			public static const NORMAL_FILTER : ColorMatrixFilter 
			= new ColorMatrixFilter( 	[1, 0, 0, 0, 0,
				0, 1, 0, 0, 0,
				0, 0, 1, 0, 0,
				0, 0, 0, 1, 0] );
			
		private var eventName:String;
		
		public function VideoPlayerButton(eventName:String)
		{
			super();
			var self : VideoPlayerButton = this;
			this.buttonMode = true;
			this.eventName = eventName;
			this.addEventListener(MouseEvent.CLICK,function(ev:MouseEvent):void{
				self.dispatchEvent(new VideoPlayerEvent(eventName));
			});
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.alpha = 0.4;
		}
		
		
		public function invertBitmapColor(bm:Bitmap):Bitmap{
//			var bd:BitmapData= bm.bitmapData;
//			var invertTransform:ColorTransform = new ColorTransform(-1,-1,-1,1,255,255,255,0)
//			bd.colorTransform(bd.rect, invertTransform);
			bm.smoothing = true;
			return bm;
		}
		
		protected function onMouseOver(ev:MouseEvent = null):void{
			this.alpha = 1;
		}
		
		protected function onMouseOut(ev:MouseEvent = null):void{
			this.alpha = 0.4;
		}
	}
}