package vn.meme.cloud.player.btn
{
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.controls.List;
	import fl.controls.ScrollBarDirection;
	import fl.controls.TileList;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	import fl.managers.StyleManager;
	
	import flash.display.Bitmap;
	import flash.display.FrameLabel;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.text.StyleSheet;
	import flash.text.TextColorType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	
	import flashx.textLayout.elements.ContainerFormattedElement;
	import flashx.textLayout.formats.BackgroundColor;
	import flashx.textLayout.formats.TextAlign;
	
	import mx.core.FlexSprite;
	
	import org.mangui.hls.HLS;
	import org.mangui.hls.model.Level;
	import org.osmf.net.StreamType;
	
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.comp.VideoStage;
	import vn.meme.cloud.player.comp.sub.PlayerTooltip;
	import vn.meme.cloud.player.config.PlayInfo;
	import vn.meme.cloud.player.event.VideoPlayerEvent;

	public class QualityListItem extends Sprite
	{
		
		public var tf : TextField;
		private var textFormat : TextFormat;
		private var te : TextEvent;
		private var myCSS : StyleSheet = new StyleSheet();		
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		private var vs : VideoStage;
		private var gr : Graphics;
		private var str : String;
		private var lstQuality:Sprite;
		private var listQuality : Sprite;
		private var tf5 : TextField;
				
		private var qualityHLSList : Vector.<Level>;
		private static var instance:QualityListItem = new QualityListItem();
		public static function getInstance():QualityListItem{
			return instance;
		}
		
		public function QualityListItem()
		{			
						
			super();
			listQuality = new Sprite();			
			addChild(listQuality);	
			myCSS = new StyleSheet();			
			textFormat = new TextFormat("Arial",12,0xaaaaaa); 
			textFormat.leading = 5; // space between each line in text field
			myCSS.setStyle("a:hover", {color:'#ffffff', fontWeight:'bold'});//, textDecoration:'underline'});				
			myCSS.setStyle(".selected", {color:'#ff8e38'});		//#ff8e38  #96d72d
			tf = new TextField();
			tf.defaultTextFormat = textFormat;			
			tf.wordWrap = true;
			tf.multiline = true;			
			
			tf.styleSheet = myCSS;
						
			tf.addEventListener(TextEvent.LINK, clickLink);
						
			this.alpha = 0.8;			
			addChild(tf);
			
			this.visible = false;
			
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);			
		}
		
		protected function onMouseOut(ev:MouseEvent = null):void{
			PlayerTooltip.getInstance().visible = false;		
			this.visible = false;		
			vp.wait.mouseEnabled = false;
		}
		
		private function clickLink(ev:TextEvent):void{	
			dispatchEvent(new VideoPlayerEvent(VideoPlayerEvent.SELECT_QUALITY, ev.text));
		}  
		
		public function show(playInfo : PlayInfo, urlCurrent:String):void{	
						
			var g : Graphics = listQuality.graphics;
			
			var len : int = playInfo.video.length;
			
			var qualityLength : int = 0;
			
			for (var j:int = 0; j<len; j++){
				if (qualityLength < playInfo.video[j].quality.length) qualityLength = playInfo.video[j].quality.length; 
			}
			
			if (qualityLength >=5){
					g.clear();				
					g.beginFill(0x000000);
					g.drawRect(-15,-30 - 20 * (len - 2),50,20 * len + 10);				
					g.endFill();
			} else {
				g.clear();				
				g.beginFill(0x000000);
				g.drawRect(-15,-30 - 20 * (len - 2),45,20 * len + 10);				
				g.endFill();			
			}		
			
			str = "";
			
			if(len == 1){
				str = "";
			} else {
				for (var i:int=0; i<len; i++){
					if (urlCurrent.localeCompare(playInfo.video[i].url) == 0){
					str += '<p class=\"selected\"><a href="event:' + playInfo.video[i].url + '">' + playInfo.video[i].quality + '</a></p>';
				} else {
					str += '<p><a href="event:' + playInfo.video[i].url + '">' + playInfo.video[i].quality + '</a></p>';
				}	
					
			}
			tf.htmlText = str;
			tf.x = -10; 
			tf.y = -5 - (len - 1) * 20;
			if(len == 1){
				this.visible = false;
			} else {
				this.visible = true;
				tf.visible = true;
				}
			}
		}
		
		public function showHLSQuality(playInfo : PlayInfo, urlCurrent:String):void{
			
			var g : Graphics = listQuality.graphics;
			
			var len : int = playInfo.video.length;
			
			var qualityLength : int = 0;
			
			for (var j:int = 0; j<len; j++){
				if (qualityLength < playInfo.video[j].quality.length) qualityLength = playInfo.video[j].quality.length; 
			}
			
			if (qualityLength >=5){
				g.clear();				
				g.beginFill(0x000000);
				g.drawRect(-15,-30 - 20 * (len - 2),50,20 * len + 10);				
				g.endFill();
			} else {
				g.clear();				
				g.beginFill(0x000000);
				g.drawRect(-15,-30 - 20 * (len - 2),45,20 * len + 10);				
				g.endFill();			
			}		
			
			str = "";
			
			if(len == 1){
				str = "";
			} else {
				for (var i:int=0; i<len; i++){
					if (urlCurrent.localeCompare(playInfo.video[i].url) == 0){
						str += '<p class=\"selected\"><a href="event:' + playInfo.video[i].url + '">' + playInfo.video[i].quality + '</a></p>';
					} else {
						str += '<p><a href="event:' + playInfo.video[i].url + '">' + playInfo.video[i].quality + '</a></p>';
					}						
				}
				tf.htmlText = str;
				tf.x = -10; 
				tf.y = -5 - (len - 1) * 20;
				if(len == 1){
					this.visible = false;
				} else {
					this.visible = true;
					tf.visible = true;
				}
			}
		}
		//use this function when url is one file m3u8 contain multiple child m3u8(quality, bitrate...)
		/*
		public function showHLSQuality(hls:HLS, urlCurrent:String):void{
		
			var g : Graphics = listQuality.graphics;
			
			var len : int = hls.levels.length;
			
			var qualityLength : int = 0;
			var text : String = "";
			for (var j:int = len - 1; j > -1; j--){		
				text = hls.levels[j].height +""+ Math.round(hls.levels[j].bitrate / 1000);
				if (qualityLength < text.length) qualityLength = text.length;				
			}
			if (qualityLength == 6){		
				g.clear();				
				g.beginFill(0x000000);
				g.drawRect(-35,-30 - 20 * (len - 2),95,20 * len + 10);				
				g.endFill();
			}		
			if (qualityLength == 7){		
				g.clear();				
				g.beginFill(0x000000);
				g.drawRect(-35,-30 - 20 * (len - 2),100,20 * len + 10);				
				g.endFill();
			}
			if (qualityLength == 8){		
				g.clear();				
				g.beginFill(0x000000);
				g.drawRect(-35,-30 - 20 * (len - 2),105,20 * len + 10);				
				g.endFill();
			}
			str = "";
			
			if (vp.videoStage.rawHLSQuality == 0){
				qualityHLSList = hls.levels;
				urlCurrent = hls.levels[(hls.currentLevel)].url;
			}	
			
			if (len == 1){
				str = "";
			} else {
				for (var i:int = len - 1; i > -1; i--){
					if(urlCurrent.match(qualityHLSList[i].url)){
						str += '<p class=\"selected\"><a href="event:' + qualityHLSList[i].url + '">' + qualityHLSList[i].height 
							+'p ' + Math.round(qualityHLSList[i].bitrate / 1000) + 'kbps</a></p>';											
					} else {
					str += '<p><a href="event:' + qualityHLSList[i].url + '">' + qualityHLSList[i].height 
						+'p ' + Math.round(qualityHLSList[i].bitrate / 1000) + 'kbps</a></p>';
					}
				}
			}
			
			if (qualityHLSList.length == 1){
				this.visible = false;
			} else {
				tf.height = qualityHLSList.length * 20;
				tf.x = -30; 
				tf.y = -5 - (len - 1) * 20;
			}
			if (str == ""){	
				this.visible = false;
			} else {
				this.visible = true;
				tf.htmlText = str;
			}
			
		}
		*/
		
	}
}