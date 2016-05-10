package kuilab_com.event
{
	import flash.events.Event;

	/**
	 * 事件上带数据方便，不解释。
	 * 原生的flash.events.Event的target是不能改写的，这里采用了另一个变量替代的做法。
	 * @author kui.
	 */
	public class EventBoost extends flash.events.Event
	{
		public function EventBoost( type:String, data:Object=null, target:*=null, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super( type, bubbles, cancelable );
			data_ = data ;
			target_ = target ;
		}
		
		protected var data_:Object ;
		protected var target_:Object ;
		
		public function get data():Object
		{
			return data_ ;
		}
		
		public function set data( v:Object ):void
		{
			data_ = v ;
		}
		
		public override function clone():Event
		{
			return new EventBoost( type, data_, bubbles, cancelable ) ;
		}
		
		public function set target( v:Object ):void
		{
			target_ = v ;
		}
		
		/**
		 * 没有赋值target则返回原本的target。
		 * 原本的target也没有（这事件对象没有被dispatch）则尝试返回data的target。
		 * @return 
		 */
		public override function get target():Object
		{
			if( target_ != null )
				return target_ ;
			if( super.target != null )
				return super.target ;
			if( data_ is Event )
				return ( data_ as Event ).target ;
			return null ;
		}
		
		public function get primitiveTarget():Object
		{
			return super.target ;
		}
		
		public static function cloneEvent( e:Event, data:Object = null ):EventBoost
		{
			var eClone:EventBoost = new EventBoost( e.type, data, e.bubbles, e.cancelable ) ;
			eClone.target_ = e.target ;
			return eClone  ;
		}
		
		public override function toString():String
		{
			return super.toString() + ' data='+String(data_)+'' ;
		}
		
		kuilab::dbg public function appendDbgInfo( info:Object ):void
		{
			dbgInfo.push( info ) ;
		}
		
		kuilab::dbg public var dbgInfo:Array =[] ;
	}
}