package kuilab_com.animation
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import kuilab_com.KuilabERROR;

	/**
	 * @author kui.
	 */	
	public class Circulator
	{
		public static const AUTO_LIMIT:Object ;
		public function Circulator( animationDspObj:Array, speed:int = 1, horiOrVerti:Boolean=true, paneLength:Object = 0 )
		{
			this.dspObj = animationDspObj ;
			this.speed = speed ;
			this.horiOrVerti = horiOrVerti ;
			if( paneLength is int )
				this.paneLength = paneLength as int ;
		}
		
		public		var speed:Number ;
		public	 	var horiOrVerti:Boolean ;
		public		var paneLength:int ;
		public		var pauseTime:uint = 1000 ;
		protected	var pauseCunt:uint ;
		protected	var dspObj:Array ;
		protected 	var gap:int = 0 ;
		protected 	var forceOffsetToGap:Boolean = false ;
		protected	var customFramProc:Function ;
		
		protected 	var tailIdx:uint
		protected	var headIdx:uint
		protected	var frameCnt:uint = 0 ;
		protected	var frameInterval:uint = 3 ;
		
		
		public function start( frameInterval:uint = 1, customFramProc:Function=null ):void
		{
			this.frameInterval = frameInterval ;
			var frameFunc:Function ;
			if( horiOrVerti ){
				resetHoriz() ;
				frameFunc = frameProcHorizontal ;
			}else{
				resetVerti() ;
				frameFunc = frameProcVertical ;
			}
			dspObj[0].addEventListener( Event.ENTER_FRAME, frameFunc ) ;
			/*if( customFramProc ){
				dspObj[0].addEventListener( Event.ENTER_FRAME, customFramProc ) ;
			}else
				dspObj[0].addEventListener( Event.ENTER_FRAME,  ) ;*/
			
		}
		
		public function stop( dispose:Boolean = false ):void
		{
			/*if( customFramProc )
				dspObj[0].removeEventListener( Event.ENTER_FRAME, customFramProc ) ;*/
			dspObj[0].removeEventListener( Event.ENTER_FRAME, frameProcHorizontal ) ;
			dspObj[0].removeEventListener( Event.ENTER_FRAME, frameProcVertical ) ; 
			
			if( dispose ){
				this.dispose() ;
			}
		}
		
		public function reset():void
		{
			if( horiOrVerti )
				resetHoriz() ;
			else
				resetVerti() ;
			pauseCunt = 0 ;
		}
		
		/**
		 * 
		 * @param gap
		 * @param forceOffsetToGap 为真则每个动画单位的x（或y）按gap的值递增。
		 */		
		public function setGap( gap:uint, forceOffsetToGap:Boolean= false ):void
		{
			this.gap = gap ;
			this.forceOffsetToGap = forceOffsetToGap ;
		}
		
		protected function resetHoriz( ):void
		{
			tailIdx = dspObj.length -1 ;
			//var speed:int = this.speed
			var i:uint ;
			var prev:DisplayObject = dspObj[ 0 ] ;
			//var lmtIdx:uint = 0 ;
			if( speed > 0 ){
				prev.x = paneLength - prev.width ;	trace( '[0]x', prev.x ) ;
				for( i = 1 ; i<dspObj.length; i++ ){
					var tx:int = forceOffsetToGap ? prev.x - gap : prev.x - dspObj[i].width - gap ;
					dspObj[i].x = tx ;
					//trace( 'x=', dspObj[i].x ) ;
					prev = dspObj[i] ;
					/*if( lmtIdx == 0 )
					if( dspObj[i].x < -paneLength ){
						lmtIdx = i ;
					}*/
				}
				if( paneLength == 0 ){
					if( forceOffsetToGap )
						paneLength = ( dspObj.length -1 ) *gap ;
					else{
						var totalAndMax:Array = getTotalAndMaxLen( true ) ;
						paneLength = totalAndMax.shift() - totalAndMax.shift() ;
					}
				}
				/*if( lmtIdx != 0 )
					for( i = 0; i<=lmtIdx; i++ ){
						dspObj[i].x -= containerSize ;
						trace( i,'invert to:',dspObj[i].x ) ;
					}
				else
					throw new Error( '逻辑错误2817vzeM' ) ;*/
			}else{
				prev.x = 0 ;
				for( i = 1 ; i<dspObj.length; i++ ){
					dspObj[i].x = forceOffsetToGap ? gap*i : prev.x + prev.width + gap ;
					prev = dspObj[i] ;
				}
			}
		}
		
		protected function resetVerti():void
		{
			tailIdx = dspObj.length -1 ;
			//var speed:int = this.speed
			var i:uint ;
			var prev:DisplayObject = dspObj[ 0 ] ;
			//var lmtIdx:uint = 0 ;
			if( speed > 0 ){
				prev.y = paneLength - prev.width ;
				for( i = 1 ; i<dspObj.length; i++ ){
					var ty:int = forceOffsetToGap ? prev.y - gap : prev.y - dspObj[i].height - gap ;
					dspObj[i].y = ty ;
					prev = dspObj[i] ;
					/*if( lmtIdx == 0 )
					if( dspObj[i].y < -paneLength ){
						lmtIdx = i ;
					}*/
				}
			}else{
				prev.y = 0 ;
				for( i = 1 ; i<dspObj.length; i++ ){
					dspObj[i].y = forceOffsetToGap ? gap*i : prev.y + prev.height + gap ;
					prev = dspObj[i] ;
				}
			}
		}
		
		protected function getTotalAndMaxLen( horiOrVerti:Boolean ):Array
		{
			var max:int = 0 ;
			var total:uint = 0 ;
			if( horiOrVerti ){
				for each( var oneH:DisplayObject in dspObj ){
					max = Math.max( oneH.width, max ) ;
					total += oneH.width ;
				}
			}else{
				for each( var oneV:DisplayObject in dspObj ){
					max = Math.max( oneV.height, max ) ;
					total += oneV.height ;
				}
			}
			return [ total, max ] ;
		}
		
		/*public function reset$( speed:int, horiOrVerti:Boolean ):void
		{
			var pName:String = horiOrVerti ? 'x', 'y' ;
			var prev:DisplayObject = dspObj[ 0 ] ;
			var pNameDm:String = horiOrVerti ? 'width', 'height' ;
			var lmtIdx:uint = 0 ;
			var totalInvert:uint ; 
			for ( var i:int = 1; i < dspObj.length; i++ ) 
			{
				if( forceOffsetToGap ){
					dspObj[ i ][ pName ] = i * gap ;
				}else{
					dspObj[ i ][ pName ] = prev[ pName ] + prev[ pNameDm ] ;
				}
				if( speed > 0 )//do nothing
				{
					if( lmtIdx == 0 ){//还未找到截尾处。
						if( dspObj[ i ][ pName ] > limit ){
							lmtIdx = i ;
						}else
							continue ;
					}else{ //if( lmtIdx != 0 ){
					}
					//if( dspObj[ i ][ pName ] < limit ){
				}else
					continue ;
				if( forceOffsetToGap )
					continue ;	
				else
					totalInvert + = ( dspObj[ i ][ pNameDm ] + gap ) ;
			}
			if( speed > 0 ){
				if( forceOffsetToGap )
					totalInvert = i * gap ;
				if( lmtIdx == 0 )
					trace( '显示尺寸过小' ) ;
				else{
					for( i=lmtIdx ; i<dspObj.length; i++ ){
						dspObj[i][pName] -= totalInvert ;
					}
				}
			}
		}*/
		
		public function procFrame$():void
		{
			if( pauseCunt != 0 ){
				pauseCunt -- ;
				return ;
			}else{
				//go on 
			}
			if( frameInterval > 1 ){
				if( frameCnt == 0 )
					frameCnt = frameInterval ;
				else{
					frameCnt -- ;
					return ;
				}
			}
			if( horiOrVerti )
				frameProcHorizontal( ) ;
			else
				frameProcVertical( )
		}
		
		protected function frameProcHorizontal( e:Event = null ):void
		{
			if( pauseCunt != 0 ){
				pauseCunt -- ;
				return ;
			}else{
				//go on 
			}
			for each( var dObj:DisplayObject in dspObj )
				dObj.x += speed ;
			//var headIdx:uint 
			var head:DisplayObject = dspObj[ headIdx ] ;
			var tail:DisplayObject = dspObj[ tailIdx ] ;
			if( speed > 0 )
			{
				if( head.x > paneLength ){
					head.x = tail.x - ( forceOffsetToGap ? gap : ( head.width + gap ) ) ;
					headToTail( ) ;
					doPause() ;
				}
				/*if( forceOffsetToGap ){
					if( head.x + gap == paneLength )
						doPause() ;
				}else{
					if( head.x + head.width + gap == paneLength )
					//if( head.x
						doPause() ;
				}*/
			}else{//speed < 0
				//var limit$:int = forceOffsetToGap ? gap : ( head.width + gap ) ;
				if( head.x < -head.width ){
					head.x = tail.x + ( forceOffsetToGap ? gap : ( tail.width + gap ) ) ;
					headToTail( ) ;
					doPause() ;
				}
			}
			/*function resetPos( ):void
			{
				var arr:Array = dspObj.concat() ;
				var prev:DisplayObject = dspObj.shift() ;
				var pName:String = horiOrVerti ? 'x', 'y' ;
				var pNameDm:String = horiOrVerti ? 'width', 'height' ;
					prev.x = 0 ;
				for each( var dObj:DisplayObject in dspObj )
				{
					if( forceOffsetToGap )
						dObj[pName] = prev[pName] + gap ;
					else
						dObj[pName] = prev[pName] + prev[pNameDm] + gap ;
					//prev
				}
			}*/
		}
		
		protected function frameProcVertical( e:Event = null ):void
		{
			if( pauseCunt != 0 ){
				pauseCunt -- ;
				return ;
			}else{
				//go on 
			}
			for each( var dObj:DisplayObject in dspObj )
				dObj.y += speed ;
			//var headIdx:uint 
			var head:DisplayObject = dspObj[ headIdx ] ;
			var tail:DisplayObject = dspObj[ tailIdx ] ;
			if( speed > 0 )
			{
				if( head.y > paneLength ){
					head.y = tail.y - ( forceOffsetToGap ? gap : ( head.height + gap ) ) ;
					headToTail( ) ;
					doPause() ;
				}
			}else{//speed < 0
				//var limit$:int = forceOffsetToGap ? gap : ( head.width + gap ) ;
				if( head.y < -head.height ){
					head.y = tail.y + ( forceOffsetToGap ? gap : ( tail.height + gap ) ) ;
					headToTail( ) ;
					doPause() ;
				}
			}
		}
		
		protected function headToTail( h:Vector.<uint>=null ):void
		{	//c::d0{ var dbg:Array = [ 'head:', headIdx, ',tail:', tailIdx ] } ;
			//tail = head ;//( headIdx == 0 ) ? dspObj : headIdx ;
			tailIdx = headIdx ;
			if( speed > 0 ){
				headIdx = ( headIdx == dspObj.length-1 ) ? 0 : headIdx +1 ;
			}else{ //speed < 0
				headIdx = ( headIdx == dspObj.length-1 ) ? 0 : headIdx +1 ;
				//headIdx = ( headIdx == 0 ) ? dspObj.length -1 : headIdx -1 ;
			}
			//c::d0{ trace.apply( null, dbg.concat( ' head->', headIdx ) ) } ;
		}
		
		protected function doPause( ):void
		{
			if( pauseTime <= 0 )
				return ;
			var frameRate:uint = DisplayObject( dspObj[0] ).stage.frameRate ;
			pauseCunt = pauseTime / frameRate * frameInterval ;
			//trace( 'doPause,cnt=', pauseCunt );
		}
		
		public function dispose():void
		{
			dspObj[0].removeEventListener( Event.ENTER_FRAME, frameProcHorizontal ) ;
			dspObj[0].removeEventListener( Event.ENTER_FRAME, frameProcVertical ) ;
			dspObj = null ;
		}
	}
}