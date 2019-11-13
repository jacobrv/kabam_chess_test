package com.jacobvarns.KabamChess 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Jacob Varns
	 */
	public class ChessPiece extends Sprite 
	{
		public static const KNIGHT:int = 0;
		public static const BISHOP:int = 1;
		public static const QUEEN:int = 2;
		
		private static var _queue:LoaderMax;
		private static var _bImageError:Boolean = false;
		private static var _destroySound:Sound = new Sound(new URLRequest("sounds/destroy.mp3"));
		
		public static var IMAGES_LOADED:Boolean = false;
		
		private var _nType:int = 0;
		
		private var _nWidth:int = 0;
		private var _nBoardWidth:int = 8;
		public var boardX:int = 0;
		public var boardY:int = 0;
		public var color:int = 0;
		
		private var _bBreak:Boolean = false;
		private var _bmp:Sprite;
		
		
		// **********************************************************************************/
		
		
		/**
		 * Creats a ChessPiece
		 * 
		 * @param	nType
		 * @param	nColor
		 * @param	nWidth
		 */
		public function ChessPiece(nType:int = 0, nColor:int = 0, nWidth:int=50) 
		{
			_nWidth = nWidth;
			_nType = nType;
			color = nColor;
			var sColor:String = nColor ? "black" : "white";
			switch(nType)
			{
				case KNIGHT:
					_bmp = LoaderMax.getContent("knight_"+sColor);
					break;
				case BISHOP:
					_bmp = LoaderMax.getContent("bishop_"+sColor);
					break;
				case QUEEN:
					_bmp = LoaderMax.getContent("queen_"+sColor);
					break;
			}
			this.addChild(_bmp);
		}// END FUNCTION ChessPiece
		
		
		// **********************************************************************************/
		
		
		/**
		 * Returns the type.
		 */
		public function get type():int
		{
			return _nType;
		}// END FUNCTION get type
		
		
		// **********************************************************************************/
		
		
		/**
		 * Check what tiles this piece can move to.
		 * 
		 * @param	vTiles
		 * @return
		 */
		public function checkMoves(vTiles:Vector.<ChessTile>):Vector.<Point>
		{
			switch(_nType)
			{
				case KNIGHT:
					return checkMovesKnight(vTiles);
				case BISHOP:
					return checkMovesBishop(vTiles);
				case QUEEN:
					return checkMovesQueen(vTiles);
			}
			return null;
		}// END FUNCTION checkMoves
		
		
		// **********************************************************************************/
		
		
		/**
		 * Get a specific tile from the list.
		 * 
		 * @param	vTiles
		 * @param	nX
		 * @param	nY
		 * @return
		 */
		private function getTile(vTiles:Vector.<ChessTile>, nX:int, nY:int):ChessTile
		{
			if (nX >= _nBoardWidth || nX < 0 || nY >= _nBoardWidth || nY < 0)
				return null;
				
			return vTiles[(nX * _nBoardWidth) + nY];
		}// END FUNCTION getTile
		
		
		// **********************************************************************************/
		
		
		/**
		 * Check for all tiles the Knight can move to.
		 * 
		 * @param	vTiles
		 * @return
		 */
		private function checkMovesKnight(vTiles:Vector.<ChessTile>):Vector.<Point>
		{
			var i:int = 0;
			var tile:Point;
			var points:Vector.<Point> = new Vector.<Point>();
			var nX:int = boardX;
			var nY:int = boardY;
			var moves:Array = [new Point(2, 1), new Point( -2, 1), new Point(2, -1), new Point( -2, -1), new Point(1, 2), new Point(1, -2), new Point( -1, 2), new Point( -1, -2)];
			
			for (i = 0; i < moves.length; i++)
			{
				tile = checkTile(vTiles,nX+moves[i].x, nY+moves[i].y);
				if (tile)
					points.push(tile);
			}
			return points;
		}// END FUNCTION checkMovesKnight
		
		
		// **********************************************************************************/
		
		
		/**
		 * Check for all tiles the Bishop can move to.
		 * 
		 * @param	vTiles
		 * @return
		 */
		private function checkMovesBishop(vTiles:Vector.<ChessTile>):Vector.<Point>
		{
			var i:int = 0;
			var tile:Point;
			var points:Vector.<Point> = new Vector.<Point>();
			var nX:int = boardX;
			var nY:int = boardY;
			
			_bBreak = false;
			nX = boardX + 1;
			nY = boardY + 1;
			while (nX < 8 && nY < 8 && !_bBreak)
			{
				tile = checkTile(vTiles,nX++, nY++);
				if (tile)
					points.push(tile);
			}
			nX = boardX-1;
			nY = boardY+1;
			_bBreak = false;
			while (nX >= 0 && nY < 8 && !_bBreak)
			{
				tile = checkTile(vTiles,nX--, nY++);
				if (tile)
					points.push(tile);
			}
			nX = boardX+1;
			nY = boardY-1;
			_bBreak = false;
			while (nX < 8 && nY >= 0 && !_bBreak)
			{
				tile = checkTile(vTiles,nX++, nY--);
				if (tile)
					points.push(tile);
			}
			nX = boardX-1;
			nY = boardY-1;
			_bBreak = false;
			while (nX >= 0 && nY >= 0 && !_bBreak)
			{
				tile = checkTile(vTiles,nX--, nY--);
				if (tile)
					points.push(tile);
			}
			return points;
		}// END FUNCTION checkMovesBishop
		
		
		// **********************************************************************************/
		
		
		/**
		 * Check for all tiles the Queen can move too.
		 * 
		 * @param	vTiles
		 * @return
		 */
		private function checkMovesQueen(vTiles:Vector.<ChessTile>):Vector.<Point>
		{
			var i:int = 0;
			var tile:Point;
			var points:Vector.<Point> = new Vector.<Point>();
			var nX:int = boardX;
			var nY:int = boardY;
			
			points = checkMovesBishop(vTiles);
			
			_bBreak = false;
			nX = boardX+1;
			nY = boardY;
			while (nX < 8 && !_bBreak)
			{
				tile = checkTile(vTiles,nX++, nY);
				if (tile)
					points.push(tile);
			}
			nX = boardX-1;
			nY = boardY;
			_bBreak = false;
			while (nX >= 0 && !_bBreak)
			{
				tile = checkTile(vTiles,nX--, nY);
				if (tile)
					points.push(tile);
			}
			nX = boardX;
			nY = boardY-1;
			_bBreak = false;
			while (nY >= 0 && !_bBreak)
			{
				tile = checkTile(vTiles,nX, nY--);
				if (tile)
					points.push(tile);
			}
			nX = boardX;
			nY = boardY+1;
			_bBreak = false;
			while (nY < 8 && !_bBreak)
			{
				tile = checkTile(vTiles,nX, nY++);
				if (tile)
					points.push(tile);
			}
			return points;
		}// END FUNCTION checkMovesQueen
		
		
		// **********************************************************************************/
		
		
		/**
		 * Check if this tile can be moved to with the assumption that it is in range.
		 * @param	vTiles
		 * @param	nX
		 * @param	nY
		 * @return
		 */
		private function checkTile(vTiles:Vector.<ChessTile>,nX:int,nY:int):Point
		{
			if (!getTile(vTiles, nX, nY))
			{
				return null;
			}
			if (getTile(vTiles, nX, nY).piece == null)
			{
				return new Point(nX, nY);
			}
			else
			{
				_bBreak = true;
			}
			if (getTile(vTiles, nX, nY).piece.color != color)
			{
				return new Point(nX, nY);
			}
			return null;
		}// END FUNCTION checkTile
		
		
		// **********************************************************************************/
		
		
		/**
		 * Move the piece.
		 * 
		 * @param	nX
		 * @param	nY
		 * @param	bNow
		 */
		public function moveTo(nX:int, nY:int,bNow:Boolean = false):void
		{
			if (bNow)
			{
				this.x = nX * _nWidth;
				this.y = nY * _nWidth;
			}
			else
			{
				var dist:Number = Math.sqrt(((boardX-nX)*(boardX-nX))+((boardY-nY)*(boardY-nY)))
				TweenMax.to(this, dist/4, { x: nX * _nWidth, y:nY * _nWidth } );
			}
			boardX = nX;
			boardY = nY;
		}// END FUNCTION moveTo
		
		
		// **********************************************************************************/
		
		
		/**
		 * Start cleaning up and play a destroy animation/sound.
		 */
		public function destory():void
		{
			_destroySound.play();
			
			while (this.numChildren)
				this.removeChildAt(0);
			
			_bmp = new Sprite();
			var tBmp:Sprite = LoaderMax.getContent("poof");
			_bmp.addChild(tBmp);
			tBmp.x = -tBmp.width / 2;
			tBmp.y = -tBmp.height / 2;
			_bmp.scaleX = 0;
			_bmp.scaleY = 0;
			_bmp.x = _nWidth / 2;
			_bmp.y = _nWidth / 2;
			this.addChild(_bmp);
			
			TweenMax.to(_bmp, .5, { rotation:720, scaleX:.5, scaleY:.5, onComplete:destroyFinish } );
			
		}// END FUNCTION destroy
			
		
		// **********************************************************************************/
		
		
		/**
		 * Finish cleaning up after destroy animation.
		 */
		private function destroyFinish():void
		{
			this.removeChild(_bmp);
			_bmp = null;
			if(this.parent)
				this.parent.removeChild(this);
		}// END FUNCTION destroyFinish
		
		
		// **********************************************************************************/
		
		
		/**
		 * Load the needed images.
		 */
		public static function loadImages():void
		{
			_queue = new LoaderMax({name:"LoginControl",onProgress:onQueueProgress, onComplete:onQueueComplete, onError:onQueueError});
			_queue.append(new ImageLoader("images/queen_black.png", { name:"queen_black" } ));
			_queue.append(new ImageLoader("images/knight_black.png", { name:"knight_black" } ));
			_queue.append(new ImageLoader("images/bishop_black.png", { name:"bishop_black" } ));
			_queue.append(new ImageLoader("images/queen_white.png", { name:"queen_white" } ));
			_queue.append(new ImageLoader("images/knight_white.png", { name:"knight_white" } ));
			_queue.append(new ImageLoader("images/bishop_white.png", { name:"bishop_white" } ));
			_queue.append(new ImageLoader("images/burst.png", { name:"burst" } ));
			_queue.append(new ImageLoader("images/poof.png", { name:"poof" } ));
			_queue.load();
		}// END FUNCTION loadImages
		
		
		// **********************************************************************************/
		
		
		/**
		 * Set the IMAGES_LOADED flag.
		 * 
		 * @param	event
		 */
		private static function onQueueComplete(event:LoaderEvent):void
		{
			IMAGES_LOADED = true;
		}// END FUNCTION onQueueComplete
		
		
		// **********************************************************************************/
		
		
		/**
		 * Nothing right now.
		 * 
		 * @param	event
		 */
		private static function onQueueProgress(event:LoaderEvent):void
		{
			
		}// END FUNCTION onQueueProgress
		
		
		// **********************************************************************************/
		
		
		/**
		 * Set the error flag if an image fails to load.
		 * 
		 * @param	event
		 */
		private static function onQueueError(event:LoaderEvent):void
		{
			_bImageError = true;
		}// END FUNCTION onQueueError
		
		
		// **********************************************************************************/
	}

}