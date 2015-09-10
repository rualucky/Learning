package vn.meme.cloud.player.btn
{
	import fl.controls.List;
	import fl.motion.Color;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.GraphicElement;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.event.VideoPlayerEvent;
	import vn.meme.cloud.player.event.VideoPlayerEventListener;
	import vn.meme.cloud.player.listener.OnBigPlay;
	import vn.meme.cloud.player.listener.OnPlay;

	public class BigPlay extends VideoPlayerButton
	{
		[Embed(source="asset/btn-play.png")]
		public static var asset:Class;
		
//		[Embed source="FONT_SOURCE", fontName="FONT_NAME", mimeType="application/x-font-truetype" unicodeRange = "U+000D,U+0020-007E,U+00E0-00E3,U+00E8-00EA,U+00EC-00ED,U+00F2,U+00F4-00F5,U+00F9-00FA,U+00FD,U+0103,U+0111,U+0129,U+0169,U+01A1,U+1EA1,U+1EA3,U+1EA5,U+1EA7,U+1EA9,U+1EAB,U+1EAD,U+1EAF,U+1EB1,U+1EB3,U+1EB5,U+1EB7,U+1EB9,U+1EBB,U+1EBD,U+1EBF,U+1EC1,U+1EC3,U+1EC5,U+1EC9,U+1ECB,U+1ECD,U+1ED1,U+1ED3,U+1ED5,U+1ED7,U+1ED9,U+1EDB,U+1EDD,U+1EDF,U+1EE1,U+1EE3,U+1EE7,U+1EEB,U+1EEF,U+1EF1,U+1EF3,U+1EF5,U+1EF7,U+1EF9"]
		
//		[Embed(source='asset/calibrib.ttf'
//			,fontFamily ='Arial_Bold'
//			,fontStyle = 'normal'  // normal|italic
//			,fontWeight = 'bold'    // normal|bold
//			,mimeType = "application/x-font-truetype"
//			,unicodeRange="U+000D,U+0020-007E,U+00E0-00E3,U+00E8-00EA,U+00EC-00ED,U+00F2,U+00F4-00F5,U+00F9-00FA,U+00FD,U+0103,U+0111,U+0129,U+0169,U+01A1,U+1EA1,U+1EA3,U+1EA5,U+1EA7,U+1EA9,U+1EAB,U+1EAD,U+1EAF,U+1EB1,U+1EB3,U+1EB5,U+1EB7,U+1EB9,U+1EBB,U+1EBD,U+1EBF,U+1EC1,U+1EC3,U+1EC5,U+1EC9,U+1ECB,U+1ECD,U+1ED1,U+1ED3,U+1ED5,U+1ED7,U+1ED9,U+1EDB,U+1EDD,U+1EDF,U+1EE1,U+1EE3,U+1EE7,U+1EEB,U+1EEF,U+1EF1,U+1EF3,U+1EF5,U+1EF7,U+1EF9,U+01B0"
//			,embedAsCFF     = 'false'
//		)]
//		private const _bold:Class; 
		private var btn : Sprite;
		private var bm : Bitmap;
		private var textBm : Bitmap;
		
		public var tf : TextField;
		private var textFormat : TextFormat;
		
		private var nCount : int;
		private var myTimer1 : Timer;
		
		private static var instance:BigPlay = new BigPlay();
		public static function getInstance():BigPlay{
			return instance;
		}
		
		public function BigPlay()
		{
			
			super(VideoPlayerEvent.BIGPLAY); 
			bm = this.invertBitmapColor((new asset()) as Bitmap);			
			addChild(btn = new Sprite());
			btn.addChild(bm);			
			btn.alpha = 0.7;
			this.alpha = 1;
			tf = new TextField();
			tf.mouseEnabled = false;
			textFormat = new TextFormat("Arial",18,0xffffff,true);
			tf.defaultTextFormat = textFormat;
			tf.wordWrap = true;
			
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.sharpness = 400;
			tf.thickness = 100;
			addChild(tf);
		}
		
		public function init(isLarge:Boolean = true):void{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			if (vp.playInfo) tf.text = vp.playInfo.title; 
			var gr : Graphics = btn.graphics;			
			if (stage)
				normalDraw();			
		}
		
		private function normalDraw():void{
			var gr : Graphics = btn.graphics;				
			
			if (stage.stageWidth >= 480)
				bm.width = Math.min(stage.stageWidth / 20,28);
			else bm.width = Math.max(stage.stageWidth / 20,14);
			bm.height = bm.width;
			var w : int = 20 + (stage.stageWidth >= 480) ? Math.min(stage.stageWidth / 5,80) : Math.max(stage.stageWidth / 5,50),
				h : int = 20 + (stage.stageWidth >= 480) ? Math.min(stage.stageWidth / 8,60) : Math.max(stage.stageWidth / 8,40);
						
			btn.x = -stage.stageWidth / 2 + 60;
			btn.y = -stage.stageHeight / 2 + 60;
			if(stage.stageWidth > 1000) btn.y = btn.y + 30;			
			
			bm.x = (w - bm.width) / 2;
			bm.y = (h - bm.height) / 2;
			
			gr.clear();				
			gr.beginFill(0x248FDB, 1);
			gr.drawRoundRect(0,0,w,h,Math.floor(w/3));			
			gr.drawRoundRect(3,3,w-6,h-6,Math.floor(w/3)-3);						
			gr.endFill();
			
			gr.beginFill(0x248FDB,0.7);				
			gr.drawRoundRect(3,3,w-6,h-6,Math.floor(w/3)-3); 
			gr.endFill();
		
			tf.x = -stage.stageWidth / 2 + 150;			
			tf.y = -stage.stageHeight / 2 + 60;
			if (stage.stageWidth > 1000) tf.y = -stage.stageHeight / 2 + 90;
			textFormat.size = bm.width / 1.2;
			tf.setTextFormat(textFormat);		  
		   
			if (stage)
				tf.width = stage.stageWidth - w - 60;
		}
			
		private function hoverDraw():void{
			var gr : Graphics = btn.graphics;			
						
			if (stage.stageWidth >= 480)
				bm.width = Math.min(stage.stageWidth / 20,28);
			else bm.width = Math.max(stage.stageWidth / 20,14);
			bm.height = bm.width;
			var w : int = 20 + (stage.stageWidth >= 480) ? Math.min(stage.stageWidth / 5,80) : Math.max(stage.stageWidth / 5,50),
				h : int = 20 + (stage.stageWidth >= 480) ? Math.min(stage.stageWidth / 8,60): Math.max(stage.stageWidth / 8,40);
			
			btn.x = -stage.stageWidth / 2 + 60;
			btn.y = -stage.stageHeight / 2 + 60;
			if(stage.stageWidth > 1000) btn.y = btn.y + 30;	
			
			bm.x = (w - bm.width) / 2;
			bm.y = (h - bm.height) / 2;
		 
			gr.clear();
			gr.beginFill(0xFFFFFF, 1);			
			gr.drawRoundRect(0,0,w,h,Math.floor(w/3));
			gr.drawRoundRect(3,3,w-6,h-6,Math.floor(w/3)-3);
			gr.endFill();
			
			gr.beginFill(0x248FDB,0.7);
			gr.drawRoundRect(3,3,w-6,h-6,Math.floor(w/3)-3);
			gr.endFill();
							
			tf.x = -stage.stageWidth / 2 + 150;			
			tf.y = -stage.stageHeight / 2 + 60;
			if (stage.stageWidth > 1000) tf.y = -stage.stageHeight / 2 + 90;
			
			textFormat.size = bm.width / 1.2;
			tf.setTextFormat(textFormat);
			if (stage)
				tf.width = stage.stageWidth - w - 60;		
		}
								
		override protected function onMouseOver(ev:MouseEvent = null):void{
			btn.filters = [new DropShadowFilter(0,0,0xffffff,1,30,30,2)];
			tf.filters = [new DropShadowFilter(0,0,0,1,3,3)];
			btn.alpha = 1;
			hoverDraw();
		}		
		
		override protected function onMouseOut(ev:MouseEvent = null):void{
			btn.filters = [];
			tf.filters = [];
			btn.alpha = 0.7;
			normalDraw();
		}	
	}
}