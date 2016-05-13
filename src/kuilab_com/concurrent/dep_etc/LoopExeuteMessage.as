package kuilab_com.concurrent.dep_etc
{
	import kuilab_com.concurrent.DaemonLoop;
	import kuilab_com.lang.Pair;
	import kuilab_com.normalize.ICommonData;
	
	public class LoopExeuteMessage extends LoopProps implements ICommonData
	{
		public function LoopExeuteMessage( loop:DaemonLoop, title:*, detail:*=null )
		{
			super( loop );
			this.detail_ = detail ;
			this.title_ = title ;
		}
		
		protected var title_:* ;
		protected var detail_:* ;
		protected var error_:* ;
		
		public function set error( v:* ):void
		{
			error_ = v ;
		}
		
		public function get error():*
		{
			if( error_ == null )
				return detail_ ;
			return error_ ;
		}
		
		public function get title():*
		{
			return title_ ;
		}
			
		public function get body():*
		{
			return detail_ ;
		}
		
		public function get detail():*
		{
			return detail_ ;
		}
		
		public function toString():String
		{
			var ret:String = '[LoopExeuteMessage] title:$title#, detail:$detail# '.
					replace( '$title#', ( title_ is Pair ? ( title_.prop1 + ( title_.prop2 || '' )  ) : title_ ) ).
					replace( '$detail#', detail_ )  ;
			if( error_ )
				ret += ', error:'+error_ ;
			ret += '.' ;
			return ret ;
		}
	}
}