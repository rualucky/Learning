package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Volume extends VideoPlayerButton
	{
		[Embed(source="asset/btn-volume.png")]
		public static var asset:Class;
		
		private var timeout:int;
		
		public function Volume()
		{
			super(VideoPlayerEvent.MUTE);
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
			timeout = 0;
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			
			setTimeout(showVolumeSlider, 0);						
			super.onMouseOver(ev);			
			var point : Point = localToGlobal(new Point(8, -4));			
			PlayerTooltip.getInstance().show("Âm thanh: đang bật", point.x, point.y);
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.volumeSlider.alpha = 0.6;
			resetHide();
			super.onMouseOut(ev);			
			PlayerTooltip.getInstance().visible = false;
		}
		
		protected function showVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.timeDisplay.y = 8;
			ct.timeDisplay.x = 128;
			ct.volumeSlider.visible = true;
			ct.volumeSlider.alpha = 1;
		}
		
		protected function hideVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			if (ct.volumeSlider.alpha != 1){
				ct.timeDisplay.y = 8;
				ct.timeDisplay.x = 65;
				ct.volumeSlider.visible = false;
			}
		}
		
		public function resetHide():void{
			if (timeout) clearTimeout(timeout);
			timeout = setTimeout(hideVolumeSlider, 2000);
		}
	}
}