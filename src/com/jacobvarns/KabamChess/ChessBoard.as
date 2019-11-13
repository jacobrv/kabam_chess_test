package com.jacobvarns.KabamChess 
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Jacob Varns
	 */
	public class ChessBoard extends Sprite 
	{
		public static const PLAYER_1:int = 0;
		public static const PLYAER_2:int = 0;
		
		private var _vPlayer1Pieces:Vector.<ChessPiece>;
		private var _vPlayer2Pieces:Vector.<ChessPiece>;
		
		
		private var _vTiles:Vector.<ChessTile>;
		private var _mcSelectedPiece:ChessPiece;
		
		private var _nBoardWidth:int = 0;
		private var _nTileWidth:int = 0;
		private var _nCurrentPlayer:int = 0;
		
		private var _tStatusText:TextField;
		
		// **********************************************************************************/
		
		
		/**
		 * Creates a ChessBoard
		 */
		public function ChessBoard() 
		{
			init();
		}// END FUNCTION ChessBoard
		
		
		// **********************************************************************************/
		
		
		/**
		 * Sets up the board.
		 * 
		 * @param	nBoardWidth		Number of tiles across or down.
		 * @param	nTileWidth		Width of tile in pixels.
		 */
		private function init(nBoardWidth:int = 8, nTileWidth:int = 50):void
		{
			_nBoardWidth = nBoardWidth;
			_nTileWidth = nTileWidth;
			_vTiles = new Vector.<ChessTile>(nBoardWidth*nBoardWidth,true);
			for (var i:int = 0; i < nBoardWidth; i++)
			{
				for (var j:int = 0; j < nBoardWidth; j++)
				{
					var nIndex:int = (i * nBoardWidth) + j;
					_vTiles[nIndex] = new ChessTile(((i % 2 + j % 2)%2)*0xFFFFFF,nTileWidth,i,j);
					_vTiles[nIndex].x = i * nTileWidth;
					_vTiles[nIndex].y = j * nTileWidth;
					this.addChild(_vTiles[nIndex]);
					
				}
			}
			enableTiles(false);
			
		}// END FUNCTION init
		
		
		// **********************************************************************************/
		
		
		/**
		 * Adds the pieces and enables player 1.
		 */
		public function start():void
		{
			addPieces();
			enablePlayer(1, false);
			enablePlayer(0, true);
		}// END FUNCTION start
		
		
		// **********************************************************************************/
		
		
		/**
		 * Create 3 pieces each for both players and adds them to the board.
		 */
		private function addPieces():void
		{
			var i:int;
		
			
			// Create a list of all possible slots (0 to length).
			// Shuffle the list.
			// Pop slots off the list to use as positions.
			// O(n) shuffle so with a fixed board size the shuffle time is fixed.
			var vSlots:Vector.<int> = new Vector.<int>();
			var nTiles:int = _nBoardWidth * _nBoardWidth;
			for (i = 0; i < nTiles; i++)
				vSlots[i] = i;
			
			var m:int = nTiles;
			var t:int = 0;
			i = 0;
			while (m > 0)
			{
				i = Math.floor(Math.random() * m--);
				t = vSlots[m];
				vSlots[m] = vSlots[i];
				vSlots[i] = t;
			}
			
			var nIndex:int;
			_vPlayer1Pieces = new Vector.<ChessPiece>();
			_vPlayer1Pieces.push(new ChessPiece(ChessPiece.KNIGHT,0,_nTileWidth));
			_vPlayer1Pieces.push(new ChessPiece(ChessPiece.BISHOP,0,_nTileWidth));
			_vPlayer1Pieces.push(new ChessPiece(ChessPiece.QUEEN,0,_nTileWidth));
			for (i = 0; i < _vPlayer1Pieces.length; i++)
			{
				this.addChild(_vPlayer1Pieces[i]);
				nIndex = vSlots.pop();
				_vPlayer1Pieces[i].moveTo(nIndex % _nBoardWidth, nIndex / _nBoardWidth,true);
				getTile(nIndex % _nBoardWidth, nIndex / _nBoardWidth).piece = _vPlayer1Pieces[i];
			}
			
			_vPlayer2Pieces = new Vector.<ChessPiece>();
			_vPlayer2Pieces.push(new ChessPiece(ChessPiece.KNIGHT,1,_nTileWidth));
			_vPlayer2Pieces.push(new ChessPiece(ChessPiece.BISHOP,1,_nTileWidth));
			_vPlayer2Pieces.push(new ChessPiece(ChessPiece.QUEEN,1,_nTileWidth));
			for (i = 0; i < _vPlayer2Pieces.length; i++)
			{
				this.addChild(_vPlayer2Pieces[i]);
				nIndex = vSlots.pop();
				_vPlayer2Pieces[i].moveTo(nIndex % _nBoardWidth, nIndex / _nBoardWidth,true);
				getTile(nIndex % _nBoardWidth, nIndex / _nBoardWidth).piece = _vPlayer2Pieces[i];
			}
		}// END FUNCTION addPieces
		
		
		// **********************************************************************************/
		
		
		/**
		 * Gets the tile at the given grid position.
		 * 
		 * @param	nX	The X position on the grid (not pixels).
		 * @param	nY	The Y position on the grid (not pixels).
		 * @return		A ChessTile
		 */
		private function getTile(nX:int, nY:int):ChessTile
		{
			if (nX >= _nBoardWidth || nX < 0 || nY >= _nBoardWidth || nY < 0)
				return null;
				
			return _vTiles[(nX * _nBoardWidth) + nY];
		}// END FUNCTION getTile
		
		
		// **********************************************************************************/
		
		
		/**
		 * Highlights the tile at the give grid position.
		 * 
		 * @param	nX				Tile X position on grid.
		 * @param	nY				Tile Y position on grid.
		 * @param	bHighlight		True to enable highlight, false to disable.
		 */
		private function highlightTile(nX:int, nY:int, bHighlight:Boolean = true):void
		{
			var tile:ChessTile = getTile(nX, nY);
			if (tile)
			{
				var bDoesTileHavePiece:Boolean = (tile.piece != null);
				var bIsPieceSameColor:Boolean;
				if (bDoesTileHavePiece)
					bIsPieceSameColor = tile.piece.color == _nCurrentPlayer;
				else
					bIsPieceSameColor = false;
				tile.highlight(bHighlight && (!bIsPieceSameColor || !bDoesTileHavePiece));
			}
		}// END FUNCTION highlightTile
		
		
		// **********************************************************************************/
		
		
		/**
		 * Gets the ChessPiece at the given grid position.
		 * 
		 * @param	nX  The X grid position.
		 * @param	nY	The Y grid position.
		 * @return		A ChessPiece or null if one doesn't exist.
		 */
		private function getPieceAtLocation(nX:int, nY:int):ChessPiece
		{
			return getTile(nX,nY).piece;
		}// END FUNCTION getPieceAtLocation
		
		
		// **********************************************************************************/
		
		
		/**
		 * Enables or disables mouse listeners on the tiles.
		 * 
		 * @param	bEnable
		 */
		private function enableTiles(bEnable:Boolean = true):void
		{
			var nTiles:int = _nBoardWidth * _nBoardWidth;
			var i:int = 0;
			if (bEnable)
			{
				for (i = 0; i < nTiles; i++)
					_vTiles[i].addEventListener(MouseEvent.CLICK, onTileClicked,false,0,true);
			}
			else
			{
				for (i = 0; i < nTiles; i++)
				{
					_vTiles[i].removeEventListener(MouseEvent.CLICK, onTileClicked);
					_vTiles[i].movable = false;
				}
			}
		}// END FUNCTION enableTiles
		
		
		// **********************************************************************************/
		
		
		/**
		 * Called when a tile is clicked.
		 * If a piece has been selected and the tile is marked as movable, move the piece.
		 * Otherwise, deselect the piece.
		 * 
		 * @param	event	The MouseEvent
		 */
		private function onTileClicked(event:MouseEvent):void
		{
			var tile:ChessTile = ChessTile(event.currentTarget);
			if (_mcSelectedPiece && tile.movable)
			{
				movePiece(_mcSelectedPiece, tile.boardX, tile.boardY);
			}
			else
			{
				deselectPiece();
			}
		}// END FUNCTION onTileClicked
		
		
		// **********************************************************************************/
		
		
		/**
		 * Clears the movable status on all tiles and sets the selected piece to null.
		 */
		private function deselectPiece():void
		{
			_mcSelectedPiece = null;
			enableTiles(false);
			enablePlayer((_nCurrentPlayer + 1) % 2, false);
			for (var i:int = 0; i < _vTiles.length; i++)
			{
				_vTiles[i].highlight(false);
			}
		}// END FUNCTION deselectPiece
		
		
		// **********************************************************************************/
		
		
		/**
		 * Move the piece if the move is valid, and destroy the target piece if there is one.
		 * 
		 * @param	mcPiece
		 * @param	nX
		 * @param	nY
		 */
		private function movePiece(mcPiece:ChessPiece, nX:int, nY:int):void
		{
			var targetPiece:ChessPiece = getTile(nX, nY).piece;
			if (targetPiece)
			{
				if (targetPiece.color == mcPiece.color)
				{
					deselectPiece();
					return;
				}
				else
				{
					if (_vPlayer1Pieces.indexOf(targetPiece) >= 0)
						_vPlayer1Pieces.splice(_vPlayer1Pieces.indexOf(targetPiece), 1);
					if (_vPlayer2Pieces.indexOf(targetPiece) >= 0)
						_vPlayer2Pieces.splice(_vPlayer2Pieces.indexOf(targetPiece), 1);
					targetPiece.destory();
				}
			}
				
			getTile(mcPiece.boardX, mcPiece.boardY).piece = null;
			getTile(nX, nY).piece = mcPiece;
			deselectPiece();
			mcPiece.moveTo(nX, nY);
			switchPlayer();
		}// END FUNCTION movePiece
		
		
		// **********************************************************************************/
		
		
		/**
		 * Changes to the other player.
		 */
		private function switchPlayer():void
		{
			if (_vPlayer1Pieces.length == 0)
			{
				gameOver(1);
				return;
			}
				
			if (_vPlayer2Pieces.length == 0)
			{
				gameOver(0);
				return;
			}
			
			if (_vPlayer1Pieces.length == 1 && _vPlayer2Pieces.length == 1)
			{
				if (_vPlayer1Pieces[0].type == ChessPiece.BISHOP && _vPlayer2Pieces[0].type == ChessPiece.BISHOP)
				{
					var x1:int = _vPlayer1Pieces[0].boardX;
					var x2:int = _vPlayer2Pieces[0].boardX;
					var y1:int = _vPlayer1Pieces[0].boardY;
					var y2:int = _vPlayer2Pieces[0].boardY;
					if (((x1 % 2 + y1 % 2) % 2) != ((x2 % 2 + y2 % 2) % 2))
					{
						gameOver(3);
						return;
					}
					
				}
			}
			
			enablePlayer(_nCurrentPlayer, false);
			_nCurrentPlayer = (_nCurrentPlayer + 1) % 2;
			enablePlayer(_nCurrentPlayer, true);
		}// END FUNCTION switchPlayer
		
		
		// **********************************************************************************/
		
		
		/**
		 * Adds or removes mouse listeners from the player's pieces.
		 * 
		 * @param	nPlayer		The player.
		 * @param	bEnable		True to enable.
		 */
		private function enablePlayer(nPlayer:int = 0, bEnable:Boolean = true, bOnlyClick:Boolean = false):void
		{
			var i:int = 0;
			if (bEnable)
			{
				if (nPlayer == PLAYER_1)
				{
					for (i = 0; i < _vPlayer1Pieces.length; i++)
					{
						_vPlayer1Pieces[i].addEventListener(MouseEvent.CLICK, onPieceClicked, false, 0, true);
						if (!bOnlyClick)
						{
							_vPlayer1Pieces[i].addEventListener(MouseEvent.ROLL_OVER, onPieceRollOver, false, 0, true);
							_vPlayer1Pieces[i].addEventListener(MouseEvent.ROLL_OUT, onPieceRollOut, false, 0, true);
						}
					}
				}
				else
				{
					for (i = 0; i < _vPlayer2Pieces.length; i++)
					{
						_vPlayer2Pieces[i].addEventListener(MouseEvent.CLICK, onPieceClicked, false, 0, true);
						if (!bOnlyClick)
						{
							_vPlayer2Pieces[i].addEventListener(MouseEvent.ROLL_OVER, onPieceRollOver, false, 0, true);
							_vPlayer2Pieces[i].addEventListener(MouseEvent.ROLL_OUT, onPieceRollOut, false, 0, true);
						}
					}
				}
			}
			else
			{
				if (nPlayer == PLAYER_1)
				{
					for (i = 0; i < _vPlayer1Pieces.length; i++)
					{
						_vPlayer1Pieces[i].removeEventListener(MouseEvent.CLICK, onPieceClicked);
						if (!bOnlyClick)
						{
							_vPlayer1Pieces[i].removeEventListener(MouseEvent.ROLL_OVER, onPieceRollOver);
							_vPlayer1Pieces[i].removeEventListener(MouseEvent.ROLL_OUT, onPieceRollOut);
						}
					}
				}
				else
				{
					for (i = 0; i < _vPlayer2Pieces.length; i++)
					{
						_vPlayer2Pieces[i].removeEventListener(MouseEvent.CLICK, onPieceClicked);
						if (!bOnlyClick)
						{
							_vPlayer2Pieces[i].removeEventListener(MouseEvent.ROLL_OVER, onPieceRollOver);
							_vPlayer2Pieces[i].removeEventListener(MouseEvent.ROLL_OUT, onPieceRollOut);
						}
					}
				}
			}
		}// END FUNCTION enablePlayer
		
		
		// **********************************************************************************/
		
		
		/**
		 * Sets the selected piece and enables the tiles.
		 * 
		 * @param	event	The MouseEvent
		 */
		private function onPieceClicked(event:MouseEvent):void
		{
			var mcPiece:ChessPiece = ChessPiece(event.currentTarget);
			
			var moves:Vector.<Point> = mcPiece.checkMoves(_vTiles);
			if (moves)
			{
				for (var i:int = 0; i <moves.length; i++)
				{
					getTile(moves[i].x, moves[i].y).movable = true;;
				}
			}
			
			if (_mcSelectedPiece)
			{
				if (mcPiece == _mcSelectedPiece)
				{
					deselectPiece();
					return;
				}
				if (ChessPiece(event.currentTarget).color != _mcSelectedPiece.color)
				{
					movePiece(_mcSelectedPiece, ChessPiece(event.currentTarget).boardX, ChessPiece(event.currentTarget).boardY);
					return;
				}
			}
			enablePlayer((_nCurrentPlayer + 1) % 2, true,true);
			_mcSelectedPiece = ChessPiece(event.currentTarget);
			clearHighlightPiece();
			highlightPiece(_mcSelectedPiece);
			enableTiles(true);
			
		}// END FUNCTION onPieceClicked
		
		
		// **********************************************************************************/
		
		
		/**
		 * Highlights all available moves for the rolled over piece.
		 * 
		 * @param	event	The MouseEvent
		 */
		private function onPieceRollOver(event:MouseEvent):void
		{
			if (_mcSelectedPiece)
				return;
			highlightPiece(ChessPiece(event.currentTarget));
		}// END FUNCTION onPieceRollOver
		
		
		// **********************************************************************************/
		
		
		/**
		 * Clears the highlights for the rolled over piece.
		 * 
		 * @param	event The MouseEvent
		 */
		private function onPieceRollOut(event:MouseEvent):void
		{
			if (_mcSelectedPiece)
				return;
			clearHighlightPiece();
			
		}// END FUNCTION onPieceRollOut
		
		
		// **********************************************************************************/
		
		
		/**
		 * Highlight all the valid moves for a piece.
		 * 
		 * @param	mcPiece
		 */
		private function highlightPiece(mcPiece:ChessPiece):void
		{
			var moves:Vector.<Point> = mcPiece.checkMoves(_vTiles);
			if (moves)
			{
				for (var i:int = 0; i <moves.length; i++)
				{
					highlightTile(moves[i].x,moves[i].y);
				}
			}
		}
		
		
		// **********************************************************************************/
		
		
		/**
		 * Clear all the highlights.
		 */
		private function clearHighlightPiece():void
		{
			for (var i:int = 0; i < _vTiles.length; i++)
			{
				_vTiles[i].highlight(false);
			}
		}
		
		
		// **********************************************************************************/
		
		
		/**
		 * Show the winner and clear the board.
		 * 
		 * @param	nPlayer
		 */
		private function gameOver(nPlayer:int):void
		{
			_tStatusText = new TextField();
			_tStatusText.selectable = false;
			this.addChild(_tStatusText);
			nPlayer++;
			if(nPlayer>2)
				_tStatusText.text = "DRAW!!!   CLICK HERE TO RESTART";
			else
				_tStatusText.text = "PLAYER " + nPlayer + " WINS!!!   CLICK HERE TO RESTART";
			_tStatusText.x = (_nBoardWidth + 1) * _nTileWidth;
			_tStatusText.width = _tStatusText.textWidth + 10;
			
			enablePlayer(0, false);
			enablePlayer(1, false);
			enableTiles(false);
			
			var i:int;
			for (i = 0; i < _vPlayer1Pieces.length; i++)
				this.removeChild(_vPlayer1Pieces[i]);
			for (i = 0; i < _vPlayer2Pieces.length; i++)
				this.removeChild(_vPlayer2Pieces[i]);
				
			_tStatusText.addEventListener(MouseEvent.CLICK, restart, false, 0, true);
		}
		
		
		// **********************************************************************************/
		
		
		/**
		 * Restart the game.
		 * 
		 * @param	event
		 */
		private function restart(event:MouseEvent):void
		{
			_tStatusText.text = "";
			_tStatusText.removeEventListener(MouseEvent.CLICK, restart);
			start();
		}
		
		// **********************************************************************************/
	}

}