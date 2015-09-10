package com.hinish.spec.xs
{
	import vn.meme.cloud.player.common.CommonUtils;

    /**
     * Represents an XML Schema time object. 
     *
     * @langversion 3.0
     * @playerversion Flash 10
     */
    public class Time extends Object
    {
        public function Time(value:String)
        {
			if (value.length > 0){			
			var parts:Array = value.split(":");
            hours = uint(parts[0]);
            minutes = uint(parts[1]);
            parts = parts[2].split(".");
            seconds = uint(parts[0]);
            milliseconds = uint(parts[1]);
			CommonUtils.log("Duration: " + value);
			}
        }
        public var hours:uint;
        public var minutes:uint;
        public var seconds:uint;
        public var milliseconds:uint;

        public function toString():String
        {
            return (hours < 10 ? "0" : "") + hours + ":" + (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds + "." + (milliseconds < 100 ? "0" : "") + (milliseconds < 10 ? "0" : "") + milliseconds;
        }
    }
}
