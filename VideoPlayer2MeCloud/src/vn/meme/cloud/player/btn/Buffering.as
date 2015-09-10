package vn.meme.cloud.player.btn
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class Buffering extends Sprite
	{
		
		private var tf : TextField;
		private var vp : VideoPlayer;
		private var textFormat : TextFormat;
		private var timeLine : uint = 0;
		private var netStream : NetStream;
		private var pc : int;
		
		public function Buffering(vp : VideoPlayer)
		{
			addChild(tf = new TextField());
			textFormat = new TextFormat("Tahoma",16,0xffffff);
			textFormat.align = TextFormatAlign.CENTER;
			tf.defaultTextFormat = textFormat;
			tf.mouseEnabled = false;
			tf.filters = [new DropShadowFilter(0,0)];
			tf.visible = true;
			tf.text = "Buffering";
			tf.width = 150;
			this.vp = vp;
			vp.stage.addEventListener(Event.RESIZE,onInitResize);
			super.visible=false;
		}
		
		private function onInitResize(ev:Event):void{
			CommonUtils.log("Resize......");
			this.x=(vp.stage.stageWidth/2)-this.width/2;
			this.y=(vp.stage.stageHeight/2)-this.height/2;
		}
		
		public override function set visible(status:Boolean):void{
			if(super.visible!=status){
				if(status)
					timeLine=setInterval(drawStatus,50);
				else removeTimeLine();
			}
			super.visible=status;
		}
		
		private function removeTimeLine():void{
			clearInterval(timeLine);
			timeLine = 0;
		}
		
		private function drawStatus():void{
			CommonUtils.log('draw status...');
			netStream = VideoPlayer.getInstance().videoStage.netstream;
			if (!netStream) return;
			pc = int(netStream.bufferLength / netStream.bufferTime * 100);
			if (pc < 100){
				tf.text = "Buffering " + pc + "%";
			}
		}
	}
}