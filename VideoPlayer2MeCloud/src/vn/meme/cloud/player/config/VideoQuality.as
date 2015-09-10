package vn.meme.cloud.player.config
{
	public class VideoQuality
	{
		
		public var quality : String;
		public var url : String;
		
		public function VideoQuality(data:*)
		{
			if (data.url)
				this.url = data.url;
			if (data.quality)
				this.quality = data.quality;
		}	
		
		public function getQuality():String{
			return this.quality;
		}
	}
}