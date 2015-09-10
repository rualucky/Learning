package vn.meme.cloud.player.common
{
	import com.hinish.spec.iab.vast.parsers.VASTParser;
	import com.hinish.spec.iab.vast.vos.InLine;
	import com.hinish.spec.iab.vast.vos.Linear;
	import com.hinish.spec.iab.vast.vos.VAST;
	import com.hinish.spec.iab.vast.vos.Wrapper;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import vn.meme.cloud.player.comp.WaitingLayer;

	public class VASTAdsManager
	{
		private	var myLoader : URLLoader;		
		private var myXML : XML;
		private var vastAd : VASTParser;
		private var ad : VAST;
		
		/*private static const instance : VASTAdsManager = new VASTAdsManager;
		public static function getInstance():VASTAdsManager{
			return instance;
		}*/
		
		public function VASTAdsManager()
		{
		} 
		
		public function request(adTag:String):void{
			myLoader = new URLLoader();			
			myLoader.load(new URLRequest(adTag));
			myLoader.addEventListener(Event.COMPLETE, loadedXML);	
			CommonUtils.log("Request ads");
		}
		
		private function loadedXML(e:Event):void{
				myXML = new XML(e.target.data);
				vastAd = new VASTParser();
				vastAd.setData(myXML);	
				ad = vastAd.parse();
				/*CommonUtils.log("*************************************");
				
				CommonUtils.log("ad ver: " + ad.version); 
				CommonUtils.log("ad len: " + ad.ads.length);
				CommonUtils.log("ad type: " + ad.ads[0]);
				
				if (ad.ads[0] is InLine) 
				{
					CommonUtils.log(" Type Linear");
					var inLine : InLine = ad.ads[0] as InLine;
					CommonUtils.log("Inline Title: " + inLine.title);
				}				 
				if (ad.ads[0] is Wrapper) {
					CommonUtils.log("Type Wrapper");
					var wrapper : Wrapper = ad.ads[0] as Wrapper;
					CommonUtils.log("Wrapper VastTadURI: " + wrapper.vastAdTagURI);
				}*/
				
				/*CommonUtils.log("ad 0 id: " + ad.ads[0].id);
				CommonUtils.log("ad adsystem value: " + ad.ads[0].adSystem.value);
				CommonUtils.log("ad adsystem ver: " + ad.ads[0].adSystem.version);
				CommonUtils.log("ad creatives len: " + ad.ads[0].creatives.length);
				CommonUtils.log("ad creative adId: " + ad.ads[0].creatives[0].adId);
				CommonUtils.log("ad creative id: " + ad.ads[0].creatives[0].id);
				CommonUtils.log("ad creative sequence: " + ad.ads[0].creatives[0].sequence);
				CommonUtils.log("ad creative source: " + ad.ads[0].creatives[0].source);
				
				CommonUtils.log("ad creative type: " + ad.ads[0].creatives[0].type)
				CommonUtils.log("ad extensions len:" + ad.ads[0].extensions.length);
				CommonUtils.log("ad error: " + ad.ads[0].error);
				CommonUtils.log("ad sequence: " + ad.ads[0].sequence)
				CommonUtils.log("ad imp len: " + ad.ads[0].impressions.length);
				CommonUtils.log("ad imp id: " + ad.ads[0].impressions[0].id);
				CommonUtils.log("ad imp uri: " + ad.ads[0].impressions[0].uri);
				
				CommonUtils.log("ads success");*/
			}
	}
}