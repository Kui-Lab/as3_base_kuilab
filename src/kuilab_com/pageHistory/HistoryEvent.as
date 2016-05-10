package kuilab_com.pageHistory
{
	import flash.events.Event;
	
	import kuilab_com.event.EventBoost;
	
	
	public class HistoryEvent extends EventBoost
	{
		public static const TYPE:String = 'move' ;
		//public static const CHANGE:String = 'change' ;
		
		public function HistoryEvent( type:String, item:HistoryItem, index:uint, cancelable:Boolean=false )
		{
			super( TYPE, item, null, cancelable ) ;
			this.index_ = index ;
		}
		
		public function get historyItem():HistoryItem
		{
			return data_ as HistoryItem ;
		}
		
		protected var index_:uint

		public function get index():uint
		{
			return index_;
		}

		/*public function set index(value:uint):void
		{
			index_ = value;
		}*/

	}
}