package kuilab_com.net
{
	import flash.debugger.enterDebugger;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	
	import kuilab_com.KuilabERROR;
	import kuilab_com.ManagerApp;
	import kuilab_com.event.EventBoost;
	import kuilab_com.net.depend_util_etc.CombinedAssetPackage;
	import kuilab_com.net.depend_util_etc.IAssetPackage;
	import kuilab_com.net.depend_util_etc.IAssetStore;
	import kuilab_com.net.depend_util_etc.ILocationRefer;
	import kuilab_com.net.depend_util_etc.ISrvGetAssetManipulat;
	import kuilab_com.net.depend_util_etc.LocationData;
	import kuilab_com.util.Map_applicationDomain;
	import kuilab_com.util.Util_Vector;

	public class SrvGetAsset implements ISrvGetAsset,ISrvGetAssetManipulat
	{
		//public static const SEE_INTERFACE_DEF:String = 'see ISrvGetCargo_DEF' ;
		protected static const ERR_notSetSrvLoad:String = '这个类依赖'+String(ISrvLoad)+'请注入一个实例。' ;
		
		protected static const DEFAULT_args:ISrvGetAsset_arg = new ISrvGetAsset_arg() ;
		
		c::d0 private function testCase():void
		{
			var instance:SrvGetAsset ;
			//逻辑完善，但要求用一个常量表示启用加载(使用时需要耦合这个常量)。
			//且使用逻辑中变量声明不能使用类型限定（意味着需要多定义一次变量或使用类型转换）。
				var r:* = instance.getStoreOrLoad( 'name', onLoad ) ;
				if( r == 'loading' ){/**等待回调**/}
				else{//有值。
					//返回null就说明是null？
					onDone(  ) ;
						//存储Loader对象还是数据？
					//加载器复用？
				}
			//逻辑完善。返回表示正在加载的对象。
			//如果需要的数据本身是Object类型则必须用if判断。
				//所以不好。
				try{
					var r1:String = instance.getStoreOrLoad( 'name', onLoad ) ;
					//期待的对象类型如果是Object，那么需要判断一次返回值是否是表示正在加载的意思。
					var r2:Object = instance.getStoreOrLoad( 'name', onLoad ) ;
					if( r2 == 'loading' )//实际等于例一。
					{}else
						onDone( r2 ) ;
				}catch( err:* ){
					if( err == '转换类型错误' )
					{ /**意味着正在加载或类型真的错误，需要使用者推理。**/ }
					else{
						/**等待loader加载**/	
					} //真的出错。
				}
				
			//非主流用法。可以不要求编写独立的onDone函数。返回值？使用时需要直接返回数据而不是加载器。
				try{
					onLoad( instance.getStoreOrLoad( 'name', onLoad ) ) ;
				}catch( err:* ){//没有直接获取到值。
					if( err == 'loading' )
					{/**开始读取，等待回调。**/}
					else{/**处理真正的错误。**/}
				}
			//肯定有缓存直接取就用getByCache
			function onLoad( e:Event ):void{}
			function onDone( data:Object ):void{}
		}
		
		public function SrvGetAsset( srvLoad:ISrvLoad = null )
		{
			if( srvLoad == null ){
				srvLoad = ManagerApp.getInstance().getInstanceAmply( ISrvLoad ) ;
			}
			prgCache = new Dictionary() ;
		}
		
		protected var srvLoad:ISrvLoad ;
		/**以包名为键存储包。目前没有实现一个键对应多个swf，但不排除会这样做。**/
		protected var prgCache:Object ;
		protected var soCache:Object ;
		protected var locationTranslat:ILocationRefer ;
		
		protected static var mapLoaderHandler:Object = new Dictionary( false ) ;
		
		public function setSrvLoad( v:ISrvLoad ):void
		{
			srvLoad = v ;
		}
		
		public function getStoreOrLoad( path:*, handlerCallback:Function, packagee:Object=null, other:ISrvGetAsset_arg=null ):*{
			if( srvLoad == null )
				throw new Error( ERR_notSetSrvLoad ) ;
			//查找缓存。
				if( other == null )
					other = DEFAULT_args ;
				var re:* ;
				if( other.updateStore )//刷新，不使用缓存。
				{}else{
					path = getLocation( path, packagee ) ;
					
					/*怎样知道一个地址所在的物理包？必须输入（逻辑上相当于地址的一部分），或后台自动。
					
					如何实现传入的详细的资源路径转换成资源包路径？
					包对应物理地址，但是可以不对应吗？
					具体业务类需要的资源包名应当注入进去。要求包名要注入进业务类，如何设计？
					使用原则限定为必须用包，禁止使用无包资源？*/
					var asset:Object = getByStore( path, packagee, ISrvGetAsset_arg.NOT_EXIST ) ;
					if( asset != ISrvGetAsset_arg.NOT_EXIST ){
						if( other.returnByEvent ){
							re = new EventBoost( Event.COMPLETE, asset )
							re.target = asset ;
							if( handlerCallback != null )
								handlerCallback( re ) ;
							return re ;
						}
						if( handlerCallback != null )
							handlerCallback( asset ) ;
						return asset ;
					}
				}
			//执行加载。
				//var url:Object = getLocation( path, packagee ) ;//SrvLoad自己有路径转换功能，所以这里不用转换了。
				/*if( cacheType == ISrvGetCargo_arg.STORE_type_noStore )//不缓存则应使用SrvLoad。
					srvLoad.load( url, handlerCallback, null ) ;*/
				if( other.storeType == ISrvGetAsset_arg.V_storeType_any )
					throw new Error( KuilabERROR.argsIncorrect( '不能使用 "STORE_type_any"' ) ) ;
				//进行外部加载。
				if( path is LocationData )
					var realPath:* = LocationData( path ).url ;
				else 
					realPath = path ;
				var loader:Object = srvLoad.load( realPath, onLoader, null, other ) ;//
				var record:LoaderRecord = new LoaderRecord( path, packagee, other.storeType, loader, handlerCallback, other ) ;
					mapLoaderHandler[ loader ] = record ;
				//return loader ;
				if( other.returnByEvent ){
					re = new EventBoost( ISrvGetAsset_arg.ERR_LOADING, loader ) ;
					re.target = loader ;
					if( handlerCallback != null )
						handlerCallback( re ) ;
				}else
					re = ISrvGetAsset_arg.TO_LOAD ;
				if( other.beLoadThrowOrReturn == true )
					throw re ;//ISrvGetAsset_arg.TO_LOAD ;
				else
					return re ;//return ISrvGetAsset_arg.TO_LOAD ;
			//function needLoad( loc:* ):Boolean
		}
		
		/**目前设计为没有指定package就在所有package里面找，但是这样没有权限限制特性。**/
		public function getByStore( path:Object, packag:Object=null, defaultValue:Object=null ):Object
		{
			var cargo:Object = chkAppStore( path, packag ) ;
			if( cargo != ISrvGetAsset_arg.NOT_EXIST )
				return cargo ;
			cargo = chkSoStore( path ) ;
			
			if( cargo != ISrvGetAsset_arg.NOT_EXIST )
				return cargo ;
			return defaultValue ;
		}
		/**虽然可以将一个包体放进多个包，但显然是不良的用法，除非有必须的需求否则不应这样。**/
		public function storePackage( packageName:Object, assetPackageBody:Object, replace:*=true, storeType:Object=null ):*//ISrvGetAsset_arg.V_storeType_inProgram
		{
			if( storeType == null )
				storeType = ISrvGetAsset_arg.V_storeType_inProgram ;
			if( Util_Vector.isVectorOrArray( packageName ) )
			{}else
				packageName = [ packageName ] ;//
			for each( var ecp:* in packageName )
				store( ecp, assetPackageBody, replace, storeType ) ;
			function store( packageName:Object, assetPackageBody:Object, replace:*=true, storeType:Object=null ):*
			{
				if( storeType == ISrvGetAsset_arg.V_storeType_inProgram )
				{
					var cur:* = prgCache[ packageName ] ;
						if( cur == null ){
							prgCache[ packageName ] = assetPackageBody ;
						}if( cur is CombinedAssetPackage ){
							{	use namespace flash_proxy ;
								CombinedAssetPackage( cur ).addPackage( assetPackageBody, replace ) ;
								//if( assetPackage is IAssetPackage )
								//具体怎么存储，要考虑地址和uid参数。
							}
						}else{//第二个包体，进行合并。
							prgCache[ packageName ] = 
								new CombinedAssetPackage( [ prgCache[ packageName ], assetPackageBody ] ) ;
						}
					prgCache[ packageName ] = assetPackageBody ;
				}else{
					enterDebugger() ;
					throw new Error( KuilabERROR.methodDoesNotImplement() ) ;
				}
			}
		}
	
		/**一个“包”实际可能包含着多个包，如果要找其中具体的一个包，除packageName之外请输入至少一个参数。**/
		public function getPackgeBody( packageName:Object, udid:*=null, adress:*=null ):*
		{
			var pkg:* = prgCache[ packageName ] ;
			if( pkg is CombinedAssetPackage ){
				if( udid != null ){
					{ use namespace flash_proxy ;
						return CombinedAssetPackage( pkg ).seekByUDID( udid ) }
				}
				if( adress != null ){
					{ use namespace flash_proxy ;
						return CombinedAssetPackage( pkg ).seekByAdress( udid ) }
				}
			}
			return pkg ;
		}
		
		public function clearCache( name:Object ):void
		{
			enterDebugger() ;throw new Error( KuilabERROR.methodDoesNotImplement() ) ;
		}
		
		public function update( subPackage:*, onProgress:Function, packag:*=null ):*
		{
			throw new Error( KuilabERROR.methodDoesNotImplement( 2  ) ) ;
		}
		
		protected var locationRefererMap:* = new Dictionary ;
		
		public function setLocationReferer( referer:ILocationRefer ):*
		{
			locationTranslat = referer ;
		}
		//程序内部资源也要进行地址翻译
		protected function getLocation( name:Object, packagee:Object ):*
		{
			if( locationTranslat == null ){
				var pSpt:String = '/' ;
				if( Util_Vector.isVectorOrArray( name ) )
					return name.join( pSpt ) ;
				return name ;
			}
			var location:* = locationTranslat.refer( name, packagee ) ;
			if( location == null )
				return name ;
			return location ;
		}
		
		/**如果没有指定package就在所有package里面找这样可能引起混乱，而且效率低。**/
		protected function chkAppStore( path:Object, packageName:Object ):*
		{
			var ret:Object ;
				/*禁止了不知道包名的查询。if( packageName == null ){
					for each( var pkg:Object in prgCache ){
						ret = chkProc( pkg, path ) ;
						if( ret != ISrvGetAsset_arg.NOT_EXIST )
							return ret ;
					}
				}else{*/
				if( path is LocationData ){
					packageName = LocationData( path ).packag ;
					path = LocationData( path ).locP ;
					trace( 'packageName如果是类，在哪里进行转换？早转换没坏处，但是能不能取到类是问题。' ) ;
				}
				var pkg:* = prgCache[ packageName ] ;
				return chkProc( pkg, path ) ;
			return ISrvGetAsset_arg.NOT_EXIST ;
			
			function chkProc( pkgMap:Object, path:Object ):*//这里使用的是
			{
				if( pkgMap == null )
					return ISrvGetAsset_arg.NOT_EXIST ;
						if( pkgMap is IAssetStore ){
							if( IAssetStore( pkgMap ).hasCargo( path ) )
								return IAssetStore( pkgMap ).getCargo( path ) ;
						}
				if( pkgMap is Loader ){
					var domain:ApplicationDomain = Loader( pkgMap ).contentLoaderInfo.applicationDomain ;
					if( domain.hasDefinition( String( path ) ) )
						return domain.getDefinition( String( path ) ) ;
				}
				if( pkgMap.hasOwnProperty( path ) )
					return pkgMap[ path ] ;
				return ISrvGetAsset_arg.NOT_EXIST ;
			}
		}
		
		protected function chkSoStore( name:Object ):*
		{
			var localPath:String = null ;
			var so:SharedObject = SharedObject.getLocal( 'kuilab.util.store', localPath ) ;
			if( so.data.hasOwnProperty( name ) )
				return so.data[ name ] ;
			return ISrvGetAsset_arg.NOT_EXIST ;
		}
		
		protected function onLoader( e:Event ):void
		{
			var key:Object = e.target ;
			if( e.target is LoaderInfo )
				key = ( e.target as LoaderInfo ).loader ;
			var record:LoaderRecord = mapLoaderHandler[ key ] ;
			switch( e.type ){
				case Event.COMPLETE :
					//c::d0{ var chk:* = record.returnWhat }
					record.eventObj = e ;
					if( record.storeType == ISrvGetAsset_arg.V_storeType_inProgram ){
						//prgCache[ record.name ] = assetBody ;
						storePackage( record.packag, record.loader, true, record.storeType ) ;
					}else if( record.storeType == ISrvGetAsset_arg.V_storeType_inSharedObj )
						return enterDebugger() ;//soCache[ record.name ] = assetBody ;
					else{
						return enterDebugger() ;
					}
					//考虑直接用path表示真实路径的情况。
					/////////getByCacheOrLoad( 'asdf-swf', new Function(), 'class:Xxxx' ) ;
					/*先考虑怎样获取整个资源包，再设计获取包中资源。
					怎样判断资源是包还是包里面对象？
					
					真实路径/类名与使用名？*/
					if( record.otherArg.returnObject == ISrvGetAsset_arg.ARG_V_returnAssetInPackage ){//真实资源对象是包里面取出对象。
						e = EventBoost.cloneEvent( e, chkAppStore( record.name, record.packag ) ) ;//
					}//( 是要像正常加载一样,所以返回原来的事件。 
					else{//真实资源对象是一个包。
						var adrs:* = getLoaderUrl( record.loader ) ;//%%这两个函数考虑可以接受record做参数。
						var udid:* = getUDID( record.loader ) ;
						e = EventBoost.cloneEvent( e, getPackgeBody( record.name, udid, adrs  ) ) ;
						/*var assetBody:Object 
						if( ( record.otherArg is ISrvGetAsset_arg ) && 
						ISrvGetAsset_arg( record.otherArg ).returnObject == ISrvGetAsset_arg.ARG_V_returnEventObject )
						assetBody = e ;
						else
						assetBody = getLoaderObject( key ) ;这句好像没用了*/
					}
				break ;
				default:
					//enterDebugger() ;
			}			
			record.handler( e ) ;
			return ;
			/*function getLoaderData2( loader:Object ):Object
			{
				switch( record )
				{
					case null :
					case ISrvLoad_arg.ARG_V_returnLoaer :
						return record.handler( e.target ) ;
						break ;
					case ISrvLoad_arg.ARG_V_returnApplicationDomain :
						return record.handler( Loader( e.target ).contentLoaderInfo.applicationDomain ) ;
					case ISrvLoad_arg.ARG_V_returnLoaderInfo :
						return record.handler( Loader( e.target ).contentLoaderInfo ) ;
					case ISrvLoad_arg.ARG_V_returnDataOrContent :
						if( e.target is Loader )
							return record.handler( Loader( e.target ).content );
						else
							return record.handler( URLLoader( e.target ).data ) ;
					default :
				}
			}*/
			function getLoaderObject( loader:Object ):Object
			{
				switch( ISrvGetAsset_arg( record.otherArg ).returnObject )
				{ 
					case ISrvGetAsset_arg.ARG_V_returnEventObject :
						//if( record.otherArg.wrapEvent )
						return record.eventObj
					case ISrvGetAsset_arg.ARG_V_returnApplicationDomain :
						return ( LoaderInfo( e.target ).applicationDomain ) ;
					case ISrvGetAsset_arg.ARG_V_returnLoaderInfo :
						return ( LoaderInfo( e.target ) ) ;
					case ISrvGetAsset_arg.ARG_V_returnDataOrContent :
						if( e.target is LoaderInfo ){ //c::d0{ trace( 'get content on e.target.') }
							return ( LoaderInfo( e.target ).content );
						}else
							return ( URLLoader( e.target ).data ) ;
					case null :
					case ISrvGetAsset_arg.ARG_V_returnLoaer :
					default :
						if( e.target is LoaderInfo )
							return ( e.target ).loader ;
						return ( e.target ) ;
						break ;
				}
				throw new Error( '程序逻辑失误O4DZK4VG2N' ) ;
				return null ;
			}
			function getLoaderUrl( loader:* ):*{
				if( loader is Loader )
					return Loader( loader ).contentLoaderInfo.url ;
				return URLLoaderMapper.seek( loader ) ;
			}
			
			function getUDID( o:* ):*{
				if( o is Loader ){
					if( Loader( o ).content is IAssetPackage )
						return IAssetPackage( o.content ).getUDID() ;
					return null ;
				}
				if( o is IAssetPackage )
					return IAssetPackage( o ).getUDID() ;
				return null ;
			}
		}
	}
}
import flash.events.Event;

import kuilab_com.net.ISrvGetAsset_arg;

class LoaderRecord{
	public function LoaderRecord( name:String, packag:*, storeType:Object, loader:Object, handler:Function, otherArg:ISrvGetAsset_arg=null )
	{
		this.name = name ;
		this.storeType = storeType ;
		this.loader = loader ;
		this.handler = handler ;
		this.otherArg = otherArg ;
	}
	/**保存的是使用名**/
	public var name:Object
	public var packag:*
	public var otherArg:ISrvGetAsset_arg
	public var storeType:Object
	public var loader:Object
	public var handler:Function
	/**如果需要以事件对象存储**/
	public var eventObj:Event ;
	/*public function get returnWhat():Object
	{
		if( otherArg )
			otherArg.returnObject
		var r:* = otherArg. ;
		if( r == null )
			return ISrvLoad_arg.ARG_V_returnDataOrContent ;
		return r ;
	}*/
}