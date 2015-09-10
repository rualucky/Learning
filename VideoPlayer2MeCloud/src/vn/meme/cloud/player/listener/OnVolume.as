package vn.meme.cloud.player.listener
{
	import flash.net.SharedObject;
	
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnVolume implements VideoPlayerEventListener
	{
		public function OnVolume()
		{
		}
		
		public function excuteLogic(vp:VideoPlayer, vs:VideoStage, ev:VideoPlayerEvent):Boolean
		{
			var ct : Controls = vp.controls;
			vs.volumeOn();
			ct.volumeSlider.changeSlider(50);
			return true;
		}
		
		public function updateView(vp:VideoPlayer):void
		{
			vp.controls.mute.visible = false;
			vp.controls.volume.visible = true;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.VOLUME;
		}
	}
}