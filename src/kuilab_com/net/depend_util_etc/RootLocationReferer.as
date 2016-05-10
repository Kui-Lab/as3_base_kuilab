package kuilab_com.net.depend_util_etc
{
	
	public class RootLocationReferer implements ILocationRefer
	{
		public function RootLocationReferer()
		{
		}
		
		protected var subReferers:Array = [] ;
		
		public function refer(tar:Object, packagee:Object):Object
		{
			for each( var ev:ILocationRefer in subReferers ){
				if( true ){//ev是这个包
					
				}
			}
			return null;
			
			function reconsitution(tar:Object, packagee:Object):Object
			{
				var mapPackage:* ;
				var referer = mapPackage[ packagee ] ;
				return null ;
			}
		}
	}
}