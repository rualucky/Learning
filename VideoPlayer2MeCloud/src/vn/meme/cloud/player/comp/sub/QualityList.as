package vn.meme.cloud.player.comp.sub
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import vn.meme.cloud.player.comp.VideoPlayerComponent;
	
	public class QualityList extends VideoPlayerComponent
	{
		private static var instance:QualityList = new QualityList();
		public static function getInstance():QualityList{
			return instance;
		}
		
		public function QualityList()
		{
			super(VideoPlayer.getInstance());
			this.visible = false;
		}
		
		public function show(_x:int,_y:int):void{
			var gr : Graphics = this.graphics,
				num : int = player.playInfo.video.length;
			gr.clear();
			gr.beginFill(0xffffff,0.2);
			gr.drawRect(-32,-(4 + 24 * num),64,(4 + 24 * num));
			gr.drawRect(-30,-(2 + 24 * num),60,24 * num);
			gr.endFill();
			gr.beginFill(0x0,0.8);
			gr.drawRect(-30,-(2 + 24 * num),60,24 * num);
			gr.endFill();
		}
	}
}