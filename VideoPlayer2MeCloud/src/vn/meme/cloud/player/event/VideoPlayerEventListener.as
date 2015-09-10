package vn.meme.cloud.player.event
{
	import vn.meme.cloud.player.comp.VideoStage;

	public interface VideoPlayerEventListener
	{
		function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean;
		function updateView(vp : VideoPlayer):void;
		function eventName():String;
	}
}