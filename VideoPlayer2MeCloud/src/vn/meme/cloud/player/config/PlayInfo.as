package vn.meme.cloud.player.config
{
	import vn.meme.cloud.player.common.CommonUtils;
	import vn.meme.cloud.player.config.ads.AdInfo;
	import vn.meme.cloud.player.config.ads2.AdInfo2;

	public class PlayInfo
	{
		public var vid : String;
		public var title : String;
		public var thumbnail : String;
		public var video : Vector.<VideoQuality>; 
		public var ad : AdInfo;
		public var ad2 : AdInfo2;
		public var defaultQuality : int;
		public var session : String;
		public var duration : Number;
		public var source : String;
		public var optionVideoEnd: String;
		public var logoMain : String;
		
		public function PlayInfo( data : *)
		{
			if (data.vid)
				this.vid = data.vid;
			if (data.thumbnail)
				this.thumbnail = data.thumbnail;
			if (data.video && data.video.length){
				video = new Vector.<VideoQuality>();
				for (var i :int = 0; i < data.video.length; i++){
					var vq :VideoQuality = new VideoQuality(data.video[i]);
					video.push(vq);
				}
			}
			
			if (data.title)
				this.title = data.title;
			
			if (data.ad){
				/*if (data.ad.pre.index || data.ad.mid.index || data.ad.post.index){
					ad = new AdInfo(data.ad);	
				}
				if (data.ad.pre.adtag || data.ad.mid.adtag || data.ad.mid.adtag || data.ad.pausead.adtag){
					ad2 = new AdInfo2(data.ad);
				}
				CommonUtils.log(data.ad);*/
				ad2 = new AdInfo2(data.ad);
			} 
			// CommonUtils.log('*************');
			// CommonUtils.log(data.ad + ' ' + data.ad.length);
			// CommonUtils.log(ad);
			// CommonUtils.log(ad2);
			 
			if (data.defaultQuality)
				defaultQuality = parseInt(new String(data.defaultQuality));
			else data.defaultQuality = 0;
			
			if (data.session)
				session = data.session;
			
			if (data.duration)
				duration = data.duration;
			
			if (data.optionVideoEnd)
				optionVideoEnd = data.optionVideoEnd;
			
			if (data.logoMain)
				logoMain = data.logoMain;
			
		}
	}
}