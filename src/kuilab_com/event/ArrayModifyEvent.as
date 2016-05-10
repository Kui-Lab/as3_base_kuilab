package kuilab_com.event
{
	import flash.events.Event;
	
	public class ArrayModifyEvent extends Event
	{
		public static const TYPE:String = 'modify' ;
		/*public static const ADD:String = 'added' ;
		public static const REMOVE:String = 'remove' ;*/
		
		public function ArrayModifyEvent( index:uint, removed:Array, inserted:Array, cancelable:Boolean=false )
		{
			super( TYPE, false, cancelable );
			
			this.index_ = index ;
			this.removed_ = removed ;
			this.inserted_ = inserted ;
		}
		
		private var removed_:Array ;
		
		private var inserted_:Array ;
		
		private var index_:uint ;

		public function get removed():Array
		{
			return removed_ ;
		}

		/*public function set removed(value):void
		{
			removed_ = value;
		}*/

		public function get inserted():Array
		{
			return inserted_;
		}

		/*public function set inserted(value:Array):void
		{
			inserted_ = value;
		}*/

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