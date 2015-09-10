package vn.meme.cloud.player.config.ads
{
	import vn.meme.cloud.player.common.CommonUtils;

	public class PositionedAdInfo
	{
		public static const PRE : String = 'pre';
		public static const MID : String = 'mid';
		public static const POST : String = 'post';
		
		//config 1
		public var index : BasicAdInfo;
		public var replace : Vector.<BasicAdInfo>;
		
		public var position : String;
		
		public function PositionedAdInfo(data:*, pos:String)
		{
			position = pos;
			//old config
			if (data.index){
				index = new BasicAdInfo(data.index);
			}
			if (data.replace && data.replace.length){
				replace = new Vector.<BasicAdInfo>();
				for (var j:int = 0; j < data.replace.length ; j++){
					var ad1 : BasicAdInfo = new BasicAdInfo(data.replace[j]);
					replace.push(ad1);
				}
			}
			
		}
		
	}
}