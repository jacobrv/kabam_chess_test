package com.jacobvarns.KabamChess
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Jacob Varns
	 */
	public class Main extends Sprite 
	{
		
		private var _mcChessBoard:ChessBoard;
		private var _tTimer:Timer;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			ChessPiece.loadImages();
			
			_tTimer = new Timer(100);
			_tTimer.addEventListener(TimerEvent.TIMER, onTimer);
			_tTimer.start();
		}
		
		private function onTimer(event:TimerEvent):void
		{
			if (ChessPiece.IMAGES_LOADED)
			{
				_tTimer.stop();
				_mcChessBoard = new ChessBoard();
				this.addChild(_mcChessBoard);
				_mcChessBoard.start();
			}
		}
		
	}
	
}