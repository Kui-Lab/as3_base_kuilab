package kuilab_com.avmBug
{
	import kuilab_com.nameSpaceKuilab;

	public class NameSpaceBugTest
	{
		public function NameSpaceBugTest()
		{
		}
		
		public static function runTest( ):Boolean
		{
			try{
				NameSpaceUser.nameSpaceKuilab::func() ;
				var instance:NameSpaceUser = new NameSpaceUser ;
				instance.nameSpaceKuilab::func() ;
				instance.nameSpaceKuilab::propA = 'new value' ;
			}catch( err:Error ){
				return false ;
			}
			return true ;
		}
	}
}
import kuilab_com.nameSpaceKuilab;

class NameSpaceUser{
	
	nameSpaceKuilab function func():*{
		return 'successfully invoke.' ;
	}
	
	nameSpaceKuilab static function func():*{
		return 'successfully invoke.(static)' ;
	}
	
	nameSpaceKuilab var propA:Object = true ;
	
}