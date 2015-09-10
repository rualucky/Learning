package vn.meme.cloud.player.config.ads2
{
	import vn.meme.cloud.player.common.CommonUtils;

	public class BasicAdInfo2
	{
		//config 2
		public var adtagUrl : String;
		public var skippable : Boolean;
		public var skipTime : int;
		public var adType : String;
		public var adtagId : int;
		public var url : String;
		public var fileLink : String;
		
		public function BasicAdInfo2(data:*){
			//config 2
			if (data.adtagUrl)
				this.adtagUrl = data.adtagUrl;
			if (data.skippable)
				this.skippable = data.skippable;
			if (data.skipTime)
				this.skipTime = data.skipTime;
			if (data.adType)
				this.adType = data.adType;
			if (data.adtagId)
				this.adtagId = data.adtagId;
			if (data.url)
				this.url = data.url;
			if (data.fileLink)
				this.fileLink = data.fileLink;
			
		}
		
	}
}