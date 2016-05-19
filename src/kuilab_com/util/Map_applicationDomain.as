package kuilab_com.util
{
	import flash.system.ApplicationDomain;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import kuilab_com.KuilabERROR;

	use namespace flash_proxy ;

	public dynamic class Map_applicationDomain extends Proxy
	{
		/**可以使用Array或Vector.<ApplicationDomain>**/
		public function Map_applicationDomain( vApplicationDomain:*=null )
		{
			if( vApplicationDomain == null ){
				vAppDomain_ = [] ;
				return ;
			}
			if( Util_Vector.isVectorOrArray( vApplicationDomain ) )
				vAppDomain_ = vApplicationDomain || [] ;
			else
				throw new Error( KuilabERROR.argsIncorrect( 1 ) ) ;
		}
		
		protected var vAppDomain_:*
		
		flash_proxy function addDomain( domain:ApplicationDomain ):void
		{
			if( vAppDomain_.indexOf( domain ) == -1 )
				vAppDomain_.push( domain ) ;
		}
		
		flash_proxy function remDomain( domain:ApplicationDomain ):void
		{
			var idx:int = vAppDomain_.indexOf( domain ) ;
			if( idx > 0 )
				vAppDomain_.splice( idx, 1 ) ;
		}
		
		flash_proxy function getDomains( ):*
		{
			return vAppDomain_.concat() ;
		}
		
		flash_proxy function dispose( ):void
		{
			vAppDomain_.length = 0 ;
		}
		
		flash_proxy override function hasProperty( name:* ):Boolean
		{
			for each( var domain:ApplicationDomain in vAppDomain_ )
			{
				if( domain.hasDefinition( name ) )
					return true ;
			}
			return false ;
		}
		
		flash_proxy override function getProperty( name:* ):*
		{
			for each( var domain:ApplicationDomain in vAppDomain_ )
			{
				if( domain.hasDefinition( name ) )
					return domain.getDefinition( name ) ;
			}
			return undefined ;
		}
		
		flash_proxy override function callProperty( name:*, ...parameters ):*
		{
		}
		
	}
}