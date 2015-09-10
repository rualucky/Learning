package vn.meme.cloud.player.btn
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.listener.OnMouseMove;

	public class VolumeSlider extends VideoPlayerButton
	{
		private var btn : Sprite;
		private var gr : Graphics;
		protected var volumeX : SharedObject = SharedObject.getLocal("volumeX");
		public function VolumeSlider()
		{
			super(VideoPlayerEvent.VOLUME_SLIDER);
			if ((volumeX.data.my_x == null) || (volumeX.data.my_x == undefined)){
				volumeX.flush();				
				gr = this.graphics;			
				gr.clear();
				gr.beginFill(0xffffff, 0);
				gr.drawRect(0, -15, 60, 45);
				gr.endFill();
				gr.beginFill(0x3ea9f5, 1); //0x259073
				gr.drawRect(0, 0, 25, 5);
				gr.endFill();			
				gr.beginFill(0xffffff);
				gr.drawRoundRect(25, -5, 5, 15, 5, 5);
				gr.endFill();			
				gr.beginFill(0x0, 0.4);
				gr.drawRect(30, 0, 25, 5);
				gr.endFill();
			} else {
				this.changeSlider(volumeX.data.my_x);				
			}		
			this.alpha = 1;					
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
	
		
		protected function onMouseDown(ev:MouseEvent):void{	
			this.alpha == 1;			
			changeSlider(ev.localX);

//			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);			
		}
		
		protected function onMouseUp(ev:MouseEvent):void{			
//			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
		}
		
		protected function onMouseMove(ev:MouseEvent):void{
			this.alpha = 1;
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;
			ct.volume.resetHide();
			if (ev.buttonDown){
				changeSlider(ev.localX);			
				var vs : VideoStage = vp.videoStage; 
				if (ev.localX <= 5) {
					ct.mute.visible = true;
					ct.volume.visible = false;
					vs.mute();				
				} else if (ev.localX >= 50) {
					ct.mute.visible = false;
					ct.volume.visible = true;
					vs.volumeOn();
					} else {
						ct.mute.visible = false;
						ct.volume.visible = true;
						vs.volumeSlider(ev.localX);
				}
			}
		}
		
		override protected function onMouseOver(ev:MouseEvent = null):void{
			this.alpha = 1;			
//			if (!ev.buttonDown){
//				removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);				
//			}		
		}
		
		override protected function onMouseOut(ev:MouseEvent = null):void{
			this.alpha = 0.6;	
			
//			setTimeout(hideVolumeSlider, 2000);
		}
		
		protected function hideVolumeSlider():void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var ct : Controls = vp.controls;	
			if (ct.volume.alpha != 1){
				ct.volumeSlider.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				ct.timeDisplay.y = 8;
				ct.timeDisplay.x = 65;
				ct.volumeSlider.visible = false;
			}
		}
		
		public function changeSlider(x:int):void{	
			
			volumeX.data.my_x = x;
			
			gr = this.graphics;			
			gr.clear();
			
			gr.beginFill(0xffffff, 0);
			gr.drawRect(0, -15, 60, 45);
			gr.endFill();
			
			gr.beginFill(0x3ea9f5, 1);
			if (x <= 5) {
				gr.clear();
			} else if (x >= 50){
				gr.drawRect(0, 0, 50, 5);
			} else {
				gr.drawRect(0, 0, x, 5);	
			}			
			gr.endFill();
			
			gr.beginFill(0xffffff);
			if (x <= 5){
				//gr.drawRect(0, -5, 5, 15); 
				gr.drawRoundRect(0, -5, 5, 15, 5, 5);
			} else if (x >= 50){
				//gr.drawRect(50, -5, 5, 15);
				gr.drawRoundRect(50, -5, 5, 15, 5, 5);
			} else {
				//gr.drawRect(x, -5, 5, 15);
				gr.drawRoundRect(x, -5, 5, 15, 5, 5);
			}
			gr.endFill();
			
			gr.beginFill(0x0, 0.4);
			if (x <= 5) {
				gr.drawRect(5, 0, 50, 5);
			} else if (x >= 50){
				gr.endFill();
			} else {
				gr.drawRect(x + 5, 0, 50 - x, 5);
			}
			gr.endFill();				
		}		
	}
}