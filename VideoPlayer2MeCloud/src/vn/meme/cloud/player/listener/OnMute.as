package vn.meme.cloud.player.listener
{
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnMute implements VideoPlayerEventListener
	{
		public function OnMute()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ct : Controls = vp.controls;
			vs.mute();
			ct.volumeSlider.changeSlider(0);
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			vp.controls.mute.visible = true;
			vp.controls.volume.visible = false;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.MUTE;
		}
	}
}