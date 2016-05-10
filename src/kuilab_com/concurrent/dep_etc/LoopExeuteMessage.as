package kuilab_com.concurrent.dep_etc
{
	import kuilab_com.concurrent.DaemonLoop;
	import kuilab_com.normalize.ICommonData;
	
	public class LoopExeuteMessage extends LoopProps implements ICommonData
	{
		public function LoopExeuteMessage( loop:DaemonLoop, title:*, detail:*=null )
		{
			super( loop );
			this.detail_ = detail ;
			this.title_ = title ;
		}
		
		protected var title_:*
		protected var detail_:*
		public var error:* ;
		
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
	}
}