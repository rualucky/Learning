package vn.meme.cloud.player.btn
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Mute extends VideoPlayerButton
	{
		[Embed(source="asset/btn-volume-mute.png")]
		public static var asset:Class;
		
		public function Mute()
		{
			super(VideoPlayerEvent.VOLUME);
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
		}
		
		protected override function onMouseOver(ev:MouseEvent=null):void{
			
			setTimeout(showVolumeSlider, 0);
			super.onMouseOver(ev);			
			var point : Point = localToGlobal(new Point(8, -4));
			
			PlayerTooltip.getInstance().show("Âm thanh: đang tắt", point.x, point.y);
		}
		
		protected override function onMouseOut(ev:MouseEvent=null):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.volumeSlider.alpha = 0.6;
			setTimeout(hideVolumeSlider, 1000);
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
	}
}