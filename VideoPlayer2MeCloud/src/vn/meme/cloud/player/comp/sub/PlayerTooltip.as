package vn.meme.cloud.player.comp.sub
{
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import vn.meme.cloud.player.comp.VideoPlayerComponent;
	
	public class PlayerTooltip extends VideoPlayerComponent
	{
		private static var instance:PlayerTooltip = new PlayerTooltip();
		public static function getInstance():PlayerTooltip{
			return instance;
		}
		
		private var tf : TextField;		
		
		public function PlayerTooltip()
		{
		
			super(VideoPlayer.getInstance());
			this.mouseEnabled = false;
			addChild(tf = new TextField());
			tf.defaultTextFormat = new TextFormat('Tahoma',12,0xaaaaaa);
			tf.mouseEnabled = false;
			tf.y = -23; 			
			this.visible = false;
		}
		
		public function show(v:String,x:int,y:int):void{
			
			if (x < 10)
				this.x = 10;
			else if (this.player.stage.stageWidth - x < 10)
				this.x = this.player.stage.stageWidth - 10;
			else
				this.x = x;
			
			this.y = y;
			tf.text = v;
			tf.width = tf.textWidth + 6;			
			redraw();
			this.visible = true;
		}
		
		private function redraw():void{
			tf.x = -tf.textWidth / 2 - 3;
			if (tf.x + this.x < 6)
				tf.x = 6 - this.x;
			else if (this.x + tf.x + tf.textWidth + 10 > this.player.stage.stageWidth){
				tf.x = this.player.stage.stageWidth - tf.textWidth - 10 - this.x;
			}
			with (this.graphics){
				clear();
				beginFill(0x555555);
				drawRoundRect(tf.x - 5,tf.y -1, tf.textWidth + 14, tf.textHeight + 7,6);
				endFill();
				beginFill(0x555555);
				moveTo(-3, tf.y + tf.textHeight + 6);
				lineTo(3, tf.y + tf.textHeight + 6);
				lineTo(0, 0);
				lineTo(-3, tf.y + tf.textHeight + 6);
				endFill();
			}
		}
		
	}
}