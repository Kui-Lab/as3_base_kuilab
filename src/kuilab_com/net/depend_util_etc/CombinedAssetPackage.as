package kuilab_com.net.depend_util_etc
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import kuilab_com.KuilabERROR;
	import kuilab_com.net.URLLoaderMapper;
	import kuilab_com.util.Util_Vector;
	import kuilab_com.util.Util_loader;
	
	use namespace flash_proxy ;
	public dynamic class CombinedAssetPackage extends Proxy
	{
		public function CombinedAssetPackage( packages:* )
		{
			super();
			if( Util_Vector.isVectorOrArray( packages ) )
			{}else
				packages = [ packages ] ;
			for each( var ecp:* in packages ){
				use namespace flash_proxy ;
				addPackage( ecp, false ) ;
			}
		}
		
		protected var packages:* = new Dictionary() ;
		
		flash_proxy function addPackage( packag:*, replace:Boolean=false ):void
		{
			/*if( isLoader( packag ) ){
			}
			if( packag is IAssetPackage ){
				if( IAssetPackage( packag ).getAddress() == null )
				if( IAssetPackage( packag ).getUDID() == null )
					throw new Error( KuilabERROR.argsIncorrect( 10 ) ) ;
			}*/
			{ use namespace flash_proxy ;
				var old:* = flash_proxy::seek( packag ) ; }
			if( old ){
				if( replace )
					delete packages[ old ] ;
			}
			packages[ packag ] = packag ;
		}
		
		flash_proxy function remPackage( packag:* ):void
		{
			/*var i:int = packages.indexOf( packag ) ;
			if( i >= 0 )
				packages.splice( i, 1 ) ;*/
			delete packages[ packag ] ;
		}
		
		flash_proxy function remPackageByID( udid:* ):*{
			for each( var pkg:* in packages )
			{
				if( pkg is IAssetPackage ){
					var a:IAssetPackage = pkg as IAssetPackage ;
					if( a.getUDID() == udid ){
						remPackage( a ) ;
						return true ;
					}
				}
			}
			return false ;
		}
		
		flash_proxy function remPackageByAdr( adress:* ):*{
			for each( var pkg:* in packages )
			{
				if( pkg is IAssetPackage ){
					var a:IAssetPackage = pkg as IAssetPackage ;
					if( a.getAddress() == adress ){
						remPackage( a ) ;
						return true ;
					}
				}else{
					if( pkg is Loader ){
						if( pkg.contentLoaderInfo.url == adress ){
							remPackage( a ) ;
							return true ;
						}
					}else if( pkg is URLLoader ){
						if( getLoaderUrl( pkg ) == adress ){
							remPackage( a ) ;
							return true ;
						}
					}
				}
			}
			return false ;
		}
		/**是IAssetPackage就不需要后两个参数了**/
		flash_proxy function replacePkg( pkg:*, adress:String=null, udid:*=null ):*
		{
			for ( var cur:* in packages ){
				var adr:String ;
				var udid:* ;
				if( pkg is IAssetPackage ){
					adr = IAssetPackage( pkg ).getAddress() ;
					udid = IAssetPackage( udid ).getUDID() ;
				}else if( isLoader( cur ) ){
					adr = getLoaderUrl( pkg ) ;
				}else
					throw new Error( KuilabERROR.programingLogicMistak( '' ) ) ;
				var old:* = seek( pkg ) ;
				if( old ){
					remPackage( old ) ;
					break ;
				}
			}

			addPackage( pkg ) ;
		}
		
		flash_proxy function seek( packag:* ):*{
			/*var matchAdr:Array = [] ;
			for ( var ech:* in packages ){
				var udid:* = getUDID( ech ) ;
				var adrs:* = getLoaderUrl( ech ) ;
					if( udid != null ){
						if( udid == udid ){
							return ech ;
						}
					}else{
						if( adrs != null ){
							if( adrs == udid ){
								return ech ;
							}
						}
					}
				}else if( isLoader( ech ) ){// not IAssetPackage
					if( getLoaderUrl( ech ) == adress )
						return ech ;
				}
			}*/
			return null ;
		}
		flash_proxy function seekByUDID( udid:* ):*{
			for ( var ech:* in packages ){
				if( getUDID( ech ) == udid ){
					return ech ;
				}
			}
			return null ;
		}
		flash_proxy function seekByAdress( adress:* ):*{
		for ( var ech:* in packages ){
			if( getLoaderUrl( ech ) == adress )
				return ech ;
		}
		return null ;
		}
		
		protected function isLoader( o:* ):Boolean
		{
			if( o is Loader )
				return true ;
			if( o is URLLoader )
				return true ;
			return false ;
		}
		
		protected function getLoaderUrl( loader:* ):*{
			if( loader is Loader )
				return Loader( loader ).contentLoaderInfo.url ;
			return URLLoaderMapper.seek( loader ) ;
		}
		
		protected function getUDID( o:* ):*{
			if( o is Loader ){
				if( Loader( o ).content is IAssetPackage )
					return IAssetPackage( o.content ).getUDID() ;
				return null ;
			}
			if( o is IAssetPackage )
				return IAssetPackage( o ).getUDID() ;
			return null ;
		}
		
		flash_proxy override function getProperty( name:* ):*
		{
			for each( var pkg:Object in packages ){
				if( pkg.hasOwnProperty( name ) ){
					return pkg[ name ] ;
				}
			}
			return null ;
		}
		
		flash_proxy override function hasProperty(name:*):Boolean
		{
			for each( var pkg:Object in packages ){
				if( pkg.hasOwnProperty( name ) ){
					return true ;
				}
			}
			return false ;
		}
	}
}
