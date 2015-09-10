package vn.meme.cloud.player.config.ads2
{
	import vn.meme.cloud.player.common.CommonUtils;

	public class AdInfo2
	{
		public var pre : PositionedAdInfo2;
		public var mid : Vector.<PositionedAdInfo2>;
		public var post : PositionedAdInfo2;
		public var pausead : PositionedAdInfo2;
		
		public function AdInfo2(data:*)
		{
			if (data.pre)
				pre = new PositionedAdInfo2(data.pre,PositionedAdInfo2.PRE);
			
			if (data.mid && data.mid.length){
				mid = new Vector.<PositionedAdInfo2>();
				for(var i:int = 0; i<data.mid.length; i++){
					var midInfo : PositionedAdInfo2 = new PositionedAdInfo2(data.mid[i],PositionedAdInfo2.MID);
					mid.push(midInfo);
				}
			}
			if (data.post)
				post = new PositionedAdInfo2(data.post,PositionedAdInfo2.POST);
			if (data.pausead){
				pausead = new PositionedAdInfo2(data.pausead, PositionedAdInfo2.PAUSE_AD);
			}			
		}
		
	}
}