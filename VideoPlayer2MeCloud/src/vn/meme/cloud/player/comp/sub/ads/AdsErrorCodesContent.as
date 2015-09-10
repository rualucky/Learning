package vn.meme.cloud.player.comp.sub.ads
{
	import vn.meme.cloud.player.common.CommonUtils;

	public class AdsErrorCodesContent
	{
		public static const ADS_PLAYER_LOAD_FAILED : String = 'ADS_PLAYER_LOAD_FAILED';
		public static const ADS_REQUEST_FAILED : String = 'ADS_REQUEST_FAILED';
		public static const API_ERROR : String = 'API_ERROR';
		public static const COMPANION_AD_LOADING_FAILED : String = 'COMPANION_AD_LOADING_FAILED';
		public static const COMPANION_COULD_NOT_BE_RENDERED : String = 'COMPANION_COULD_NOT_BE_RENDERED';
		public static const COMPANION_DIMENSIONS_ERROR : String = 'COMPANION_DIMENSIONS_ERROR';
		public static const COMPANION_HAS_UNSUPPORTED_TYPE : String = 'COMPANION_DIMENSIONS_ERROR';
		public static const EXPECTED_DIFFERENT_VAST_AD_SIZE : String = 'EXPECTED_DIFFERENT_VAST_AD_SIZE';
		public static const GENERAL_COMPANIONS_ERROR : String = 'GENERAL_COMPANIONS_ERROR';
		public static const GENERAL_LINEAR_ERROR : String = 'GENERAL_LINEAR_ERROR';
		public static const GENERAL_NONLINEAR_ERROR : String = 'GENERAL_NONLINEAR_ERROR';
		public static const GENERAL_VPAID_ERROR : String = 'GENERAL_VPAID_ERROR';
		public static const GENERAL_WRAPPER_ERROR : String = 'GENERAL_WRAPPER_ERROR';
		public static const IMA_SDK_ERROR_CODE : String = 'IMA_SDK_ERROR_CODE';
		public static const INVALID_ADX_EXTENSION : String = 'INVALID_ADX_EXTENSION';
		public static const INVALID_ARGUMENTS : String = 'INVALID_ARGUMENTS';
		public static const LINEAR_FILE_DISPLAY_ERROR : String = 'LINEAR_FILE_DISPLAY_ERROR';
		public static const LINEAR_FILE_DURATION_ERROR : String = 'LINEAR_FILE_DURATION_ERROR';
		public static const LINEAR_FILE_LOAD_TIMEOUT : String = 'LINEAR_FILE_LOAD_TIMEOUT';
		public static const LINEAR_FILE_NOT_FOUND : String = 'LINEAR_FILE_NOT_FOUND';
		public static const NONLINEAR_DIMENSIONS_ERROR : String = 'NONLINEAR_DIMENSIONS_ERROR';
		public static const NO_ADS_FOUND : String = 'NO_ADS_FOUND';
		public static const PLAYLIST_MALFORMED_RESPONSE : String = 'PLAYLIST_MALFORMED_RESPONSE';
		public static const UNDEFINED_ERROR : String = 'UNDEFINED_ERROR';
		public static const UNEXPECTED_VAST_AD : String = 'UNEXPECTED_VAST_AD';
		public static const VAST_INLINE_EXPECTED : String = 'VAST_INLINE_EXPECTED';
		public static const VAST_INVALID_URL : String = 'VAST_INVALID_URL';
		public static const VAST_LINEAR_ASSET_MISMATCH : String = 'VAST_LINEAR_ASSET_MISMATCH';
		public static const VAST_LINEAR_CREATIVE_NOT_FOUND : String = 'VAST_LINEAR_CREATIVE_NOT_FOUND';
		public static const VAST_LOAD_TIMEOUT : String = 'VAST_LOAD_TIMEOUT';
		public static const VAST_MALFORMED_RESPONSE : String = 'VAST_MALFORMED_RESPONSE';
		public static const VAST_MEDIA_ERROR : String = 'VAST_MEDIA_ERROR';
		public static const VAST_NONLINEAR_ASSET_MISMATCH : String = 'VAST_NONLINEAR_ASSET_MISMATCH';
		public static const VAST_NON_LINEAR_CREATIVE_NOT_FOUND : String = 'VAST_NON_LINEAR_CREATIVE_NOT_FOUND';
		public static const VAST_PARSING_ERROR : String = 'VAST_PARSING_ERROR';
		public static const VAST_SCHEMA_VALIDATION_FAILED : String = 'VAST_SCHEMA_VALIDATION_FAILED';
		public static const VAST_TOO_MANY_REDIRECTS : String = 'VAST_TOO_MANY_REDIRECTS';
		public static const WRONG_VAST_AD_DURATION_OR_SIZE : String = 'WRONG_VAST_AD_DURATION_OR_SIZE';
		public static const WRONG_VAST_AD_LINEARITY : String = 'WRONG_VAST_AD_LINEARITY';

		private var errorContent : String;
		
		private static const instance : AdsErrorCodesContent = new AdsErrorCodesContent;
		public static function getInstance():AdsErrorCodesContent{
			return instance;
		}
		
		public function AdsErrorCodesContent()
		{
		}
		
		public function getAdErrorContent(errorCode:Number):void{
			switch(errorCode)
			{
				case 100:
				{
					errorContent = VAST_MALFORMED_RESPONSE;
					break;
				}
				case 101:
				{
					errorContent = VAST_SCHEMA_VALIDATION_FAILED;
					break;
				}
				case 102:
				{
					errorContent = VAST_PARSING_ERROR;
					break;
				}
				case 200:
				{
					errorContent = UNEXPECTED_VAST_AD;
					break;
				}
				case 201:
				{
					errorContent = WRONG_VAST_AD_LINEARITY;
					break;
				}
				case 202:
				{
					errorContent = WRONG_VAST_AD_DURATION_OR_SIZE;
					break;
				}
				case 203:
				{
					errorContent = EXPECTED_DIFFERENT_VAST_AD_SIZE;
					break;
				}
				case 204:
				{
					errorContent = VAST_INLINE_EXPECTED;
					break;
				}
				case 300:
				{
					errorContent = GENERAL_WRAPPER_ERROR;
					break;
				}
				case 301:
				{
					errorContent = VAST_LOAD_TIMEOUT;
					break;
				}
				case 302:
				{
					errorContent = VAST_TOO_MANY_REDIRECTS;
					break;
				}
				case 303:
				{
					errorContent = VAST_INVALID_URL;
					break;
				}
				case 400:
				{
					errorContent = GENERAL_LINEAR_ERROR;
					break;
				}
				case 401:
				{
					errorContent = LINEAR_FILE_NOT_FOUND;
					break;
				}
				case 402:
				{
					errorContent = LINEAR_FILE_LOAD_TIMEOUT;
					break;
				}
				case 403:
				{
					errorContent = VAST_LINEAR_ASSET_MISMATCH;
					break;
				}
				case 405:
				{
					errorContent = LINEAR_FILE_DISPLAY_ERROR;
					break;
				}
				case 406:
				{
					errorContent = LINEAR_FILE_DURATION_ERROR;
					break;
				}
				case 500:
				{
					errorContent = GENERAL_NONLINEAR_ERROR;
					break;
				}
				case 501:
				{
					errorContent = NONLINEAR_DIMENSIONS_ERROR;
					break;
				}
				case 502:
				{
					errorContent = VAST_MEDIA_ERROR;
					break;
				}
				case 503:
				{
					errorContent = VAST_NONLINEAR_ASSET_MISMATCH;
					break;
				}
				case 600:
				{
					errorContent = GENERAL_COMPANIONS_ERROR;
					break;
				}
				case 601:
				{
					errorContent = COMPANION_DIMENSIONS_ERROR;
					break;
				}
				case 602:
				{
					errorContent = COMPANION_COULD_NOT_BE_RENDERED;
					break;
				}
				case 603:
				{
					errorContent = COMPANION_AD_LOADING_FAILED;
					break;
				}
				case 604:
				{
					errorContent = COMPANION_HAS_UNSUPPORTED_TYPE;
					break;
				}
				case 901:
				{
					errorContent = GENERAL_VPAID_ERROR;
					break;
				}
				case 1000:
				{
					errorContent = IMA_SDK_ERROR_CODE;
					break;
				}
				case 1001:
				{
					errorContent = NO_ADS_FOUND;
					break;
				}
				case 1002:
				{
					errorContent = VAST_LINEAR_CREATIVE_NOT_FOUND;
					break;
				}
				case 1003:
				{
					errorContent = VAST_NON_LINEAR_CREATIVE_NOT_FOUND;
					break;
				}
				case 1004:
				{
					errorContent = PLAYLIST_MALFORMED_RESPONSE;
					break;
				}
				case 1101:
				{
					errorContent = INVALID_ARGUMENTS;
					break;
				}
				case 1102:
				{
					errorContent = API_ERROR;
					break;
				}
				case 1103:
				{
					errorContent = ADS_REQUEST_FAILED;
					break;
				}
				case 1104:
				{
					errorContent = ADS_PLAYER_LOAD_FAILED;
					break;
				}
				case 1105:
				{
					errorContent = INVALID_ADX_EXTENSION;
					break;
				}
				default:
				{
					//  errorCode == 900
					errorContent = UNDEFINED_ERROR; 
					break;
				}
			}
			CommonUtils.log('Error Code: ' + errorCode + ' ' + errorContent);
		}
	
	}
}

