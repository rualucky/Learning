package vn.meme.cloud.player.common
{
	import flash.external.ExternalInterface;
	
	public class CommonUtils
	{
		public function CommonUtils()
		{
		}
		
		public static function log(value:*):void{
			if (ExternalInterface.available)
				ExternalInterface.call("console.log","[Video Player - Flash]",value);
		}
		
		private static var time : Number = 0;
		public static function freeze():Boolean{
			var current : Number = (new Date()).time;
			if (current - time > 400){
				time = current;
				return true;
			}
			return false;
		}
	}
}