package vn.meme.cloud.player.comp
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.*;
	import flash.utils.Timer;
	
	import vn.meme.cloud.player.common.CommonUtils;

	public class BufferedLayer extends Sprite
	{
		
		private var g : Graphics;
		private var vp : VideoPlayer = VideoPlayer.getInstance();
		private var vs : VideoStage = vp.videoStage;
		private var xx : int;
		private var yy : int;
		
		private static const SECONDS :int = 600;
		private var myTimer : Timer = new Timer(0, SECONDS);
		private var skipCount : int;
		private var d : int;
		
		private var img : Sprite;
		
		public function BufferedLayer()
		{
			CommonUtils.log("W: " + vp.width + "; H: " + vp.height);
			CommonUtils.log("w: " + vs.width + ", h: " + vs.height);
			CommonUtils.log("w: " + vs.stage.width+ ", h: " + vs.stage.height);
			
			//xx = vp.width / 2;
			//yy = vp.height / 2;
			xx = 277;
			yy = (Math.sqrt(Math.pow(23, 2) - Math.pow(xx - 300, 2)) + 100);			
			d = vp.width / 2 - 50;
			img = new Sprite();
			var gr : Graphics = img.graphics;
			var gr1 : Graphics;
			var gr2 : Graphics;
			var gr3 : Graphics;
			var gr4 : Graphics;
			var gr5 : Graphics;
			var gr6 : Graphics;
			var gr7 : Graphics;
			var gr8 : Graphics;
			var gr9 : Graphics;
			var gr10 : Graphics;
			var gr11 : Graphics;
			var gr12 : Graphics;
			
			gr.clear();
			gr.beginFill(0x3ea9f5, 1);	
			gr.drawCircle(300, 100, 5);
			drawCircle1(gr, 277);
			drawCircle1(gr, 280);
			drawCircle2(gr, 280);
			drawCircle1(gr, 288);
			drawCircle2(gr, 288);
			drawCircle1(gr, 300);
			drawCircle2(gr, 300);
			drawCircle1(gr, 312);
			drawCircle2(gr, 312);
			drawCircle1(gr, 320);
			drawCircle2(gr, 320);
			drawCircle1(gr, 323);			
			
			gr.beginFill(0x3ea9f5, 1);
			gr.drawCircle(300, 100, 5);
			gr.beginFill(0x3ea9f5, 0.8);
			gr.drawCircle(350, 100, 5);
			gr.beginFill(0x3ea9f5, 0.6);
			gr.drawCircle(325, 75, 5);
			gr.beginFill(0x3ea9f5, 0.4);
			gr.drawCircle(325, 125, 5);
			
			//gr.drawCircle(xx, yy, 25);
			//gr.drawCircle(xx, yy, 20);
			
			gr.endFill();
			addChild(img);
			
			
			g = this.graphics;				
			/*
			g.lineStyle(5, 0xffffff, 1);
			g.moveTo(320, 140);
			g.curveTo(350, 140, 350, 170); */
			/*myTimer.addEventListener(TimerEvent.TIMER, function():void{
				if ( d <= vp.width / 2 + 50){
					d = d + 1;
					drawNormal(d);
				}
			});
			myTimer.start();*/
		}
		
		private function drawCircle1(gr : Graphics, x : int) : void{
			var y : int = Math.sqrt(Math.pow(23, 2) - Math.pow(x - 300, 2)) + 100;
			gr.drawCircle(x, y, 5);
			
		}
		
		private function drawCircle2(gr : Graphics, x : int) : void{
			var y : int = - Math.sqrt(Math.pow(23, 2) - Math.pow(x - 300, 2)) + 100;
			gr.drawCircle(x, y , 5);
		}
		
		private function drawNormal(x : int) : void{
			g.clear();
			g.beginFill(0xFF0000, 1)
			//g.drawCircle(x, 140, 5);
			g.drawCircle(x, (Math.sqrt(Math.pow(33, 2) - Math.pow(x - vp.width/2, 2)) + 123 / 2), 5);
			if ((x >= (vp.width / 2 - 33)) && (x <= (vp.width / 2 + 33)))
				CommonUtils.log("W: " + vp.width + ", H: " + vp.height);
			g.endFill();	
			
		}
		
	}
}