package com.jacobvarns.KabamChess 
{
	import com.greensock.loading.LoaderMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Jacob Varns
	 */
	public class ChessTile extends Sprite 
	{
		
		public var movable:Boolean = false;
		public var filled:Boolean = false;
		public var boardX:int = 0;
		public var boardY:int = 0;
		public var piece:ChessPiece;
		private var _bmpBurst:Bitmap;
		
		
		// **********************************************************************************/
		
		
		/**
		 * Creates a ChessTile to put on the board.
		 * 
		 * @param	nColor
		 * @param	nTileWidth
		 * @param	nX
		 * @param	nY
		 */
		public function ChessTile(nColor:int = 0, nTileWidth:int = 50, nX:int = 0, nY:int = 0) 
		{
			boardX = nX;
			boardY = nY;
			
			this.graphics.beginFill(nColor, 1);
			this.graphics.drawRect(0, 0, nTileWidth, nTileWidth);
			this.graphics.endFill();
			
			var bmpData:BitmapData = new BitmapData(50, 50,true,0);
			bmpData.draw(Sprite(LoaderMax.getContent("burst")));
			_bmpBurst = new Bitmap(bmpData);;
			_bmpBurst.visible = false;
			this.addChild(_bmpBurst);
		}// END FUNCTION ChessTile
		
		
		// **********************************************************************************/
		
		
		/**
		 * Highlights the tile.
		 * 
		 * @param	bHighlight		True to highlight, false to clear.
		 */
		public function highlight(bHighlight:Boolean = true):void
		{
			if (bHighlight)
			{
				_bmpBurst.visible = true;
			}
			else
			{
				_bmpBurst.visible = false;
			}
		}// END FUNCTION highlight
		
		
		// **********************************************************************************/
	}

}