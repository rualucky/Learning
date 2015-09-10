package vn.meme.cloud.player.listener
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.btn.PauseAd;
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.config.ads.PositionedAdInfo;
	import vn.meme.cloud.player.config.ads2.PositionedAdInfo2;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.ads.OnUserClose;
	
	public class OnPause implements VideoPlayerEventListener
	{
		private static var instance:OnPause ;
		private var frame : Sprite = new Sprite();
		public static function getInstance():OnPause{
			return instance;
		}
		
		public function OnPause(){
			instance = this;
		}
		
		public function excuteLogic(vp : VideoPlayer, vs : VideoStage, ev:VideoPlayerEvent):Boolean{
//			CommonUtils.log("Excute pause");
			vs.pause();
			return true;
		}
		
		public function updateView(vp : VideoPlayer):void{
			var ct : Controls = vp.controls;
			ct.pauseBtn.visible = false;
			ct.playBtn.visible = true;
			if (!vp.wait.visible){
				if(vp.playInfo.ad2.pausead && vp.playInfo.ad2.pausead.adtag.length){
					var pauseAdIndex : Number = vp.playInfo.ad2.pausead.pauseAdIndex;
					
					vp.wait.btnPauseAd.tf.x = vp.stage.stageWidth - 134;
					vp.wait.btnPauseAd.tf.y = vp.stage.stageHeight - 50;
					var g : Graphics = frame.graphics;
					g.clear();
					g.beginFill(0x000000,0.4);
					g.drawRoundRect(vp.wait.btnPauseAd.tf.x-1,vp.wait.btnPauseAd.tf.y+2,130,15,9);
					g.endFill();
					vp.wait.btnPauseAd.addChild(frame);
					var frameIndex : Number = vp.wait.btnPauseAd.getChildIndex(frame);
					var tfIndex : Number = vp.wait.btnPauseAd.getChildIndex(vp.wait.btnPauseAd.tf);
					vp.wait.btnPauseAd.setChildIndex(frame, tfIndex);
					vp.wait.btnPauseAd.setChildIndex(vp.wait.btnPauseAd.tf, frameIndex);
					
					if (vp.playInfo.ad2.pausead.displayRule == PositionedAdInfo2.DISPLAY_RULE_NOT_DUPLICATE){
						if (vp.playInfo.ad2.pausead.selectRule != PositionedAdInfo2.SELECT_RULE_RANDOM){
							vp.wait.setPauseAd(vp.playInfo.ad2.pausead.adtag[pauseAdIndex]);
							vp.playInfo.ad2.pausead.pauseAdIndex++;
						} else {
							vp.wait.setPauseAd(vp.playInfo.ad2.pausead.adtag[Math.floor(Math.random()*vp.playInfo.ad2.pausead.adtag.length)]);
						}		
					} else {
						if (vp.playInfo.ad2.pausead.selectRule != PositionedAdInfo2.SELECT_RULE_RANDOM){
							vp.wait.setPauseAd(vp.playInfo.ad2.pausead.adtag[pauseAdIndex]);
						} else {
							vp.wait.setPauseAd(vp.playInfo.ad2.pausead.adtag[Math.floor(Math.random()*vp.playInfo.ad2.pausead.adtag.length)]);
						}	
					}
					
				} 
				if(vp.playInfo.ad2.pausead && vp.playInfo.ad2.pausead.adtag){
					vp.wait.showPlay();
				} else {
					vp.wait.showBigPlay();
				}
						
			} 
				
			
		}
		
		public function eventName():String{
			return VideoPlayerEvent.PAUSE;
		}
	}
}