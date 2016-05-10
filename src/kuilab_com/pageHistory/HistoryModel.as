package kuilab_com.pageHistory
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import kuilab_com.KuilabERROR;
	import kuilab_com.event.ArrayModifyEvent;
	
	[Event(name="move", type="kuilab_com.pageHistory.HistoryEvent")]
	
	public class HistoryModel implements IEventDispatcher
	{
		public function HistoryModel()
		{
		}
		
		protected var book_:Array = [] ;
		protected var maximal_:uint = 20 ;
		protected var curIdx_:uint = 0 ;
		protected var evtDpt:IEventDispatcher = new EventDispatcher ;
		
		public function goto( page:*, throwIfIllegal:Boolean=false ):*
		{
			if( page is uint )
				return gotoPos( page as uint, throwIfIllegal ) ;
			if( page is HistoryItem ){
				var si:int = book_.indexOf( page ) ;
				if( si == -1 )
					throw new Error( KuilabERROR.argsIncorrect( HistoryModel+'48F646B5' ) ) ;
				return gotoPos( si, throwIfIllegal ) ;
			}
		}
		
		public function gotoPos( pos:uint, throwOutRangeErr:Boolean=false ):void
		{
			if( book_.length == 0 ){
				return ;
			}
			if( pos >= book_.length ){
				if( throwOutRangeErr )
					throw new Error( KuilabERROR.argsIncorrect( 5 ) ) ;
				pos = book_.length -1 ;
			}
			/*if( pos == curIdx_ )
				return ;
			这里不能直接return?xx时侯要确保前面的都删除，最后一个是加上的。
			满了顶掉最旧一个时，索引位置没有变?*/
			curIdx_ = pos ;
			//var item:HistoryItem = book_[ curIdx_ ] ;
			fireWalkEvent( curIdx_ ) ;
		}
		
		public function goBack( throwIfAtFirst:Boolean = false ):*{
			if( curIdx_ == 0 ){
				if( throwIfAtFirst )
					throw new Error( KuilabERROR.argsIncorrect( 5 ) );
				return ;
			}
			curIdx_ -- ;
			gotoPos( curIdx_ ) ;
		}
		
		public function goForw( throwIfAtLast:Boolean = false ):*{
			if( curIdx_ == book_.length -1 ){
				if( throwIfAtLast )
					throw new Error( KuilabERROR.argsIncorrect( 5 ) ) ;
				else{}//继续执行。
			}
			curIdx_ ++ ;
			curIdx_ = Math.min( curIdx_, book_.length-1 ) ;//忽略了长度为0的异常情况。
			gotoPos( curIdx_ ) ;
		}
		
		/**可以优化，相等的项重复使用。**/
		public function append( appendItem:HistoryItem, gotoIt:Boolean= true ):*{
			return reconsitution() ;
			if( curIdx_ == book_.length-1 ){
				if( book_.length >= maximal_ )//已经满了则删除最早一个。
					remove( 1, true ) ;
				else{//未满
				}
				//book_.push( appendItem ) ;
			}else{//当前没有在最后一项，那么移除当前项之后的项再加。
				if( curIdx_ >= book_.length )
					curIdx_ = book_.length -1 ;
				var rm:Array = removeP( book_.length-curIdx_-1, false, true ) ;
			}
			book_.push( appendItem ) ;
			evtDpt.dispatchEvent( new ArrayModifyEvent( curIdx_, rm, [appendItem] ) ) ;
			if( gotoIt ){
				goto( book_.length -1 ) ;
			}
			function reconsitution(){//无内容时id置为0.
				trace( '未实现逻辑：忽略新页面是当前页面' ) ;
				if( curIdx_ < book_.length ){//正常情况
					if( curIdx_ == book_.length-1 ){//指针在最后。
						if( book_.length >= maximal_ )//满了，删除最早一个。
							rm = removeP( 1, true ) ;
						//book_.push( appendItem ) ;
					}else{//删除当前位置之后所有（然后再添加）。
						var rm:Array = removeP( book_.length-curIdx_-1, false, true ) ;
						//book_.push( appendItem ) ;
					}
				}else{//长度为0或超出范围。
					if( book_.length == 0 ){//长度为0.
					}else{//指针超出最大值。
						curIdx_ == book.length -1 ;
					}
					//book_.push( appendItem ) ;
				}
				book_.push( appendItem ) ;
				evtDpt.dispatchEvent( new ArrayModifyEvent( curIdx_, rm, [appendItem] ) ) ;
				if( gotoIt )
					gotoPos( book_.length-1 ) ;
			}
		}
		
		public function appendAndGoto( historyItem:HistoryItem ):*{
			append( historyItem, true ) ;
		}
		
		public function clear():Array
		{
			evtDpt.dispatchEvent( new ArrayModifyEvent( 0, book_, null ) ) ;
			gotoPos( uint.MAX_VALUE ) ;
			var ret:Array = book_.concat() ;
			book_.length = 0 ;
			return ret ;
		}
		
		public function get book():Array
		{
			return book_.concat() ;
		}
		
		public function get num():uint
		{
			return book_.length ;
		}
		
		public function get curIdx():uint
		{
			return curIdx_ ;
		}
		
		public function set curIdx( v:uint ):void
		{
			v = Math.min( book_.length -1, v ) ;
			if( v == curIdx_ )
				return ;
			curIdx_ = v ;
			fireWalkEvent( curIdx_ ) ;
		}
		
		public function get maximal():uint
		{
			return maximal_ ;
		}
		
		public function set maximal( v:uint ):void
		{
			if( v > maximal_ ){
				remove( v-maximal_, true ) ;
			}
			maximal_ = v ;
		}
		
		public function remove( num:uint, headOrLast:Boolean ):Array
		{
			return removeP( num, headOrLast ) ;
		}
		
		protected function removeP( num:uint, headOrLast:Boolean, dontSendEvent:Boolean=false ):Array
		{
			if( book_.length < num )
				return clear() ;
			if( num == 0 )
				return null;
			var removed:Array ;
			if( headOrLast ){//在开头移除旧的。
				removed = book_.slice( 0, num-1 ) ;
				book_.length = book_.length - num ;
				curIdx_ -= removed.length ;
			}else{//在末尾移除新的。
				removed = book_.slice( -num ) ;
				book_ = book_.slice( 0, -num ) ;//这里要测试
				curIdx_ = Math.min( curIdx_, book_.length-1 ) ;
			}
			if( ! dontSendEvent )
				evtDpt.dispatchEvent( new ArrayModifyEvent( headOrLast ? 0 : book_.length, removed, null ) ) ;
			return removed ;
		}
		
		protected function fireWalkEvent( idx:uint ):void
		{
			var item:HistoryItem = book_[ idx ] ;
			var evt:HistoryEvent = new HistoryEvent( HistoryEvent.TYPE, item, curIdx_ ) ;
			//evt.target = this ;
			evtDpt.dispatchEvent( evt );
		}
		
		///////////////////////////IEventDispatcher/////////////////////////////////////////////////
		public function addEventListener( type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false ):void
		{
			evtDpt.addEventListener( type, listener, useCapture, priority, useWeakReference ) ;
		}
		
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean=false ):void
		{
			evtDpt.removeEventListener( type, listener, useCapture ) ;
		}
		
		public function dispatchEvent( event:Event ):Boolean
		{
			throw new Error( KuilabERROR.methodDoesNotImplement( 4 ) ) ;
			//return evtDpt.dispatchEvent( event ) ;
		}
		
		public function hasEventListener( type:String ):Boolean
		{
			return evtDpt.hasEventListener( type ) ;
		}
		
		public function willTrigger( type:String ):Boolean
		{
			return evtDpt.willTrigger( type ) ;
		}
		//////////////////////////////////////////////////////////////////////////////////
	}
}