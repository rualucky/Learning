package vn.meme.cloud.player.common
{
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.utils.CharacterUtil;
	
	public class PingUtils
	{
		public static var url : String = null;
		
		private var interval : uint;
		private var inited : Boolean;
		
		public function PingUtils()
		{
			inited = false;
		}
		
		public function start():void{
			clearInterval(interval);
			ping();
			interval = setInterval(ping,20000);
		}
		
		
		private function hash(value:String, displayKey : String):String{
			
			var length : int = 32,
				result: Array = [],
				sum:int = 1024,
				len:int = value.length,
				len2 : int = displayKey.length;
			var rsStr : String = "";
			
			for (var i:int = 0; i < length; i++) {
				result.push(0);
			}
			
			for (i = 0; i < len; i++) {
				sum += value.charCodeAt(i);
				result[i % length] = (sum % 256);
			}
			
			for (i = 0; i < sum; i++) {
				var index:int = result[i % length] + result[(i + 1) % length] + result[(i + 2) % length] + 
					value.charCodeAt(i % len) ^ displayKey.charCodeAt(i % len2) + sum % len;
				result[i % length] = displayKey.charCodeAt(index % len2);
			}
			
			for (i = 0; i < length; i++) {
				rsStr += String.fromCharCode(result[i]);
			}
			
			return rsStr;
		}
		
		private function getBasicInfo():Object{
			var vp : VideoPlayer = VideoPlayer.getInstance();
			var time : Number = new Date().time;
			var session : String = vp.playInfo.session;
			return {
				session : session,
				time : time,
				vid : vp.playInfo.vid,
				ref : vp.referer
			};
		}
		
		public function ping(ev:String = null, play:int = 0, sub : Object = null):void{
			if (!url) return;
			var loader : Loader = new Loader(),
				vp : VideoPlayer = VideoPlayer.getInstance(),
				obj : Object = getBasicInfo();
			
			obj['ev'] = ev==null?(inited?(vp.videoStage.playing ? "p" : "l") : "i") : ev;
			obj['signkey'] = hash(obj.session + " - " + obj['ev'] + " - " + obj['time'],VideoPlayer.VERSION);
			if (inited){
				obj['play'] = (play == 0) ? vp.videoStage.currentTime() : play;
			}
			if (vp.playInfo.source){
				obj['source'] = vp.playInfo.source;
			}
			var key:String;
			if (sub != null){
				for (key in sub){
					obj[key] = sub[key];
				}
			}
			
			inited = true;
			var arr : Array = [];
			for (key in obj){
				arr.push(key + "=" + obj[key]);
			} 
			var params : String = arr.join('&');
			
//			CommonUtils.log("HASH FLASH " + obj.session + "." + obj.vid + " " 
//				+hash(obj.session + "." + obj.vid,"01234656789abcdef"));
			
			var rs : Object = {
				signkey : hash(obj.session + "." + obj.vid,"01234656789abcdef"),
				params : params
			}
//			CommonUtils.log("Ping " + params);
			if (ExternalInterface.available){
				setTimeout(function():void{
					ExternalInterface.call("MeCloudVideoPlayer.ping",obj.vid,obj.session,rs);
				},500);
			}
		}
		
		
	}
}