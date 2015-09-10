package vn.meme.cloud.player.config.ads2
{
	import vn.meme.cloud.player.common.CommonUtils;

	public class PositionedAdInfo2
	{
		public static const PRE : String = 'pre';
		public static const MID : String = 'mid';
		public static const POST : String = 'post';
		public static const PAUSE_AD : String = 'pausead';
		public static const DISPLAY_RULE_NOT_DUPLICATE : String = 'NOT_DUPLICATE';
		public static const DISPLAY_RULE_FULL_TIME : String = 'FULL_TIME';
		public static const DISPLAY_RULE_FULL_COUNT : String = 'FULL_COUNT';
		public static const SELECT_RULE_LINEAR : String = 'LINEAR';
		public static const SELECT_RULE_RANDOM : String = 'RANDOM';
		public static const SELECT_RULE_ROUNDING : String = 'ROUNDING';
		
		//config 2
		public var adtag : Vector.<BasicAdInfo2>;
		public var displayRule : String;
		public var maxDisplay : int;	
		public var selectRule : String;
		public var position : String;
		public var interval : Number = 0;
		public var delay : Number = 0;
		
		public var pauseAdIndex : Number;
		public var nextAds : Vector.<Number>;
		public var nextAdPosition : Number;
		public var timeAllowDisplayNextAd : Number;
		public var lastMidAdsPlayed : Number;
		public var count : Number = 0;
		public var midAdPosition : Number;
		
		public function PositionedAdInfo2(data:*, pos:String)
		{
			position = pos;
			
			if(data.maxDisplay){
				maxDisplay = data.maxDisplay;
			} else {
				maxDisplay = 1;
			}
			if(data.displayRule){
				displayRule = data.displayRule;
			}
			if(data.selectRule){
				selectRule = data.selectRule;
			}
			if(data.adtag && data.adtag.length){
				adtag = new Vector.<BasicAdInfo2>();
				for (var i:int = 0; i < data.adtag.length; i++){
					var ad : BasicAdInfo2 = new BasicAdInfo2(data.adtag[i]);
					adtag.push(ad);
				}
			}
			
			if (data.interval){
				interval = data.interval;
			} else {
				interval = 35;
			}
			if (data.delay){
				delay = data.delay;
			} else {
				delay = 15;
			}
			
			nextAds = new Vector.<Number>();
			nextAdPosition = 0;
			timeAllowDisplayNextAd = 31;
			pauseAdIndex = 0;
			midAdPosition = 0;
			
		}
			
	}
}