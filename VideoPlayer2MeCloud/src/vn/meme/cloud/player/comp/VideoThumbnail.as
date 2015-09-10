package vn.meme.cloud.player.comp
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class VideoThumbnail extends VideoPlayerComponent
	{
		
		private var bm : Bitmap;
		
		public function VideoThumbnail(player:VideoPlayer)
		{
			super(player);
			addEventListener(MouseEvent.CLICK,function(ev:Event):void{
				CommonUtils.log('Click on thumb');
			});
		}
		
		public function setThumbnail(url:String):void{
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(ev:Event):void{
				receiveBitmap(Bitmap(LoaderInfo(ev.target).content));
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(er:IOErrorEvent):void{
				
			});
			loader.load(new URLRequest(url),new LoaderContext(true));
		}
		
		override public function initSize(ev:Event = null):void{
			if (bm){
				bm.width = player.videoStage.getStageWidth();
				bm.height = player.videoStage.getStageHeight();
			}
		}
		
		private function receiveBitmap(bm:Bitmap):void{
			while (numChildren > 0)
				removeChildAt(0);
			this.bm = bm;
			bm.smoothing = true;
			bm.width = player.videoStage.getStageWidth();
			bm.height = player.videoStage.getStageHeight();
			addChild(bm);
			
		}
	}
}