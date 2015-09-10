/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package org.mangui.basic {
    import flash.display.Sprite;
    import flash.media.Video;
    
    import org.mangui.hls.HLS;
    import org.mangui.hls.event.HLSEvent;
    import org.mangui.hls.stream.HLSNetStream;
    
    import vn.meme.cloud.player.common.CommonUtils;
    

    public class Player extends Sprite {
        private var hls : HLS = null;
        private var video : Video = null;

        public function Player() {
			//connection
			//netStream
			//video
			CommonUtils.log("sdlkfjlsdfjlskdfjlskdjflsdkfjkldkkkkkkkkkkkk");
            hls = new HLS();
            hls.stage = this.stage;
            video = new Video();
		
            addChild(video);
            video.x = 0;
            video.y = 0;
            video.smoothing = true;
            video.attachNetStream(hls.stream);
           	hls.addEventListener(HLSEvent.MANIFEST_LOADED, manifestHandler);
            //hls.load("http://123.30.135.217/video/phim/index.m3u8");
			hls.load("http://www.streambox.fr/playlists/test_001/stream.m3u8");
        }

        public function manifestHandler(event : HLSEvent) : void {
			//event.levels
            hls.stream.play(null, -1);
        };
    }
}
