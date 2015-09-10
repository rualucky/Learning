package vn.meme.cloud.player.listener
{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoPlayerComponent;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnResize implements VideoPlayerEventListener
	{
		
		private static var instance:OnResize ;
		public static function getInstance():OnResize{
			return instance;
		}
		
		public function OnResize(){
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			with (vp.graphics){
				beginFill(0x000000);
				drawRect(0,0,vp.stage.stageWidth,vp.stage.stageHeight);
				endFill();
			}
			
			vp.components.every(function(e:VideoPlayerComponent, index:int, 
										 vector:Vector.<VideoPlayerComponent>):Boolean{
				e.initSize();
				return true;
			});
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			if (vp.stage.displayState == StageDisplayState.FULL_SCREEN)
				OnFullscreen.getInstance().updateView(vp);
			else OnNormalScreen.getInstance().updateView(vp);
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.RESIZE;
		}
	}
}