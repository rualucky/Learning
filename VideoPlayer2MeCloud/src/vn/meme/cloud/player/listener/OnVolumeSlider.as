package vn.meme.cloud.player.listener
{	
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnVolumeSlider implements VideoPlayerEventListener
	{
		
		private var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		
		public function OnVolumeSlider()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ct : Controls = vp.controls;			
			ct.volumeSlider.changeSlider(ct.volumeSlider.mouseX);	
			volumeX.data.my_x = ct.volumeSlider.mouseX;
			volumeX.flush();
			
			if (ct.volumeSlider.mouseX <= 5){	
				ct.mute.visible = true;
				ct.volume.visible = false;
				vs.mute();
			} else {
				ct.mute.visible = false;
				ct.volume.visible = true;				
				vs.volumeSlider(ct.volumeSlider.mouseX);				
			}
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
		
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.VOLUME_SLIDER;
		}
	}
}