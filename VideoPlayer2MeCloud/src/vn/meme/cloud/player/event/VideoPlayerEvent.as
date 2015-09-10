package vn.meme.cloud.player.event
{
	import flash.events.Event;
	
	public class VideoPlayerEvent extends Event
	{
		public static const PLAY : String = "vn.meme.cloud.player.event.PLAY";
		public static const PLAYING : String = "vn.meme.cloud.player.event.PLAYING";
		public static const PAUSE : String = "vn.meme.cloud.player.event.PAUSE";
		public static const BIGPLAY : String = "vn.meme.cloud.player.event.BIGPLAY";
		public static const VOLUME : String = "vn.meme.cloud.player.event.VOLUME";
		public static const MUTE : String = "vn.meme.cloud.player.event.MUTE";
		public static const UNMUTE : String = "vn.meme.cloud.player.event.UNMUTE";
		public static const SEEK : String = "vn.meme.cloud.player.event.SEEK";
		public static const FULLSCREEN : String = "vn.meme.cloud.player.event.FULLSCREEN";
		public static const NORMALSCREEN : String = "vn.meme.cloud.player.event.NORMALSCREEN";
		public static const RESIZE : String = "vn.meme.cloud.player.event.RESIZE";
		public static const SHOW_QUALITY : String = "vn.meme.cloud.player.event.SHOW_QUALITY";
		public static const SELECT_QUALITY : String = "vn.meme.cloud.player.event.SELECT_QUALITY";
		public static const MOUSE_MOVE : String = "vn.meme.cloud.player.event.MOUSE_MOVE";
		public static const SIGN_CLICK : String = "vn.meme.cloud.player.event.SIGN_CLICK";
		public static const VIDEO_END : String = "vn.meme.cloud.player.event.VIDEO_END";
		public static const SKIP_VAST : String = "vn.meme.cloud.player.event.SKIP_VAST";
		public static const VOLUME_SLIDER : String = "vn.meme.cloud.player.event.VOLUME_SLIDER";
		public static const PAUSEAD : String = "vn.meme.cloud.player.event.PAUSEAD";
		public var data : *;
		
		public function VideoPlayerEvent(type:String, _data:* = null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = _data;
		}
	}
}