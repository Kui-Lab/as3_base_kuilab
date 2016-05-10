package kuilab_com.ui.util
{
	public interface IProgressHandle
	{
		
		function outputProgress( info:Object, title:Object=null ):void
		
		function outputInfo( info:Object, title:Object=null ):void
			
		function dispose( remove:Boolean=true ):void
	}
}