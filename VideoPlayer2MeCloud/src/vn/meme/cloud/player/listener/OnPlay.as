package vn.meme.cloud.player.listener
{
	import flash.net.NetStream;
	import flash.net.SharedObject;
	
	import vn.meme.cloud.player.btn.ProductSign;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.common.VASTAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager;
	import vn.meme.cloud.player.common.VideoPlayerAdsManager2;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.config.ads2.PositionedAdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	
	public class OnPlay implements VideoPlayerEventListener
	{
		
		private static var instance:OnPlay ;
		
		public static function getInstance():OnPlay{
			return instance;
		}
		 
		public function OnPlay(){
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean
		{
			if (vs.currentTime() == 0 || vs.isEnd() || vs.isHslVideoEnd){
				if (vp.playInfo && vp.playInfo.ad2){
					if (vp.playInfo.ad2.pre && vp.playInfo.ad2.pre.adtag && vp.playInfo.ad2.pre.adtag.length){
						vp.wait.show('Đang tải quảng cáo ...');
							if(vp.playInfo.ad2.pre.selectRule != PositionedAdInfo2.SELECT_RULE_RANDOM){
								VideoPlayerAdsManager2.getInstance().request(vp.playInfo.ad2.pre,0);
							} else {
								VideoPlayerAdsManager2.getInstance().request(vp.playInfo.ad2.pre,Math.floor(Math.random()*vp.playInfo.ad2.pre.adtag.length));
							}	
						return false;
					} 
					
				}
				if (vs.playing){
					vs.resume();
				} else {
					vs.play();	
				}
			}
			else {
				vs.resume();
			}
			
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			CommonUtils.log("Update play view");			
			var ct : Controls = vp.controls;
			ct.pauseBtn.visible = true;
			ct.playBtn.visible = false;
			vp.thumb.visible = false;
			vp.wait.visible = false;
		}
		
		public function eventName():String
		{
			return VideoPlayerEvent.PLAY;
		}
	}
}