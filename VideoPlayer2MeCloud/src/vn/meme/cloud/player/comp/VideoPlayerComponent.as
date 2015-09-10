package vn.meme.cloud.player.comp
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	
	public class VideoPlayerComponent extends Sprite
	{
		
		protected var player : VideoPlayer;
		
		public function VideoPlayerComponent(player:VideoPlayer)
		{
			super();
			this.player = player;
			initSize();
			addEventListener(VideoPlayerEvent.RESIZE,initSize);
		}
		
		public function initSize(ev:Event = null):void{
		}
		
	}
}