package vn.meme.cloud.player.btn
{
		
	import fl.controls.List;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import vn.meme.cloud.player.comp.Controls;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class Quality extends VideoPlayerButton
	{
		[Embed(source="asset/btn-setting.png")]
		public static var asset:Class; 
		
		public function Quality()
		{
			super(VideoPlayerEvent.SHOW_QUALITY);
			addChild(this.invertBitmapColor((new asset()) as Bitmap));
		}
		
		protected override function onMouseOver(ev:MouseEvent = null):void{
			super.onMouseOver(ev);
			
			/**
			 * display playertooltip:  
			 */
			
			var player : VideoPlayer = VideoPlayer.getInstance(),
				point : Point = localToGlobal(new Point(8,-4));			
			
			var str : String = "";
			var lst : List = new List();
			
			if (player.playInfo.video.length > 1){				
				for(var i : int;i<player.playInfo.video.length; i++)
				{
					str += player.playInfo.video[i].quality + " ";
					lst.addItem(player.playInfo.video[i]);
				}
				
				PlayerTooltip.getInstance().show("Đổi chất lượng video", point.x, point.y);				
				
			} else {
				if (player.playInfo.video.length == 1){
					if (player.playInfo.video[0].quality != null){ 
					PlayerTooltip.getInstance().show("Video chỉ hỗ trợ chất lượng " + player.playInfo.video[0].quality,
						point.x, point.y);
					} else {
						PlayerTooltip.getInstance().show("Đổi chất lượng video",
							point.x, point.y);
					}
				}
			}
		}
		
		protected override function onMouseOut(ev:MouseEvent = null):void{
			super.onMouseOut(ev);
			PlayerTooltip.getInstance().visible = false;			
		}
	}
}