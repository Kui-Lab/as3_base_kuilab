package kuilab_com.net
{
	import flash.debugger.enterDebugger;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	
	import kuilab_com.KuilabERROR;
	import kuilab_com.event.EventBoost;
	import kuilab_com.net.depend_util_etc.ILocationRefer;
	import kuilab_com.net.depend_util_etc.ISrvLoadManipulat;
	import kuilab_com.util.Util_Vector;
	import kuilab_com.util.Util_loader;
	
	/**
	 * %%自动卸载侦听函数。
	 * 
	 * 使用了闭包，开销可能稍微有点大。
	 * @author kui.
	 */
	public class SrvLoad implements ISrvLoad,ISrvLoadManipulat
	{
		
		public static const ARG_null:ISrvLoad_arg = ISrvLoad_arg.ARG_null ;
		
		public static function setQueLen( v:uint ):void
		{
			throw new Error( KuilabERROR.methodDoesNotImplement( ) ) ;
		}
		
		public function SrvLoad()
		{
		}
		
		protected var locationTranslat:ILocationRefer ;
		
		public function setLocationReferer( referer:ILocationRefer ):*
		{
			locationTranslat = referer ;
		}
		
		/*protected function getLocation( name:Object, packagee:Object ):*
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
		}*/
		
		public function load( request:Object, handler:Function, loaderClass:Class=null, args:ISrvLoad_arg=null ):*
		{
			/*if( request is URLRequest ){
			}else{
				request = getLocation( request, null ) ;
			}*/
			if( ! ( request is URLRequest ) )
			{
				request = new URLRequest( request.toString() ) ;
			}
			//自动判断使用哪种加载器。
			if( loaderClass == null )
			{
				if( String(request.url).match( /(\.(swf|jpg|png|gif)(\?|\W))|(\.(swf|jpg|png|gif)$)/i ) )
					loaderClass = Loader ;
				else
					loaderClass = URLLoader ;
			}
			
			if( args == null )
				args = ISrvLoad_arg.ARG_null ;
				//throw new Error( KuilabERROR.argsIncorrect( '请使用kuilab_com.net.ISrvLoad_DEF生成参数。' ) );
			//查找LoaderContext参数。
				//for( var key:Object in args )
				if( args.context is LoaderContext )
					var loaderContext:LoaderContext = args.context ;
			
			//加载器执行工作。
				var loader:* = new( loaderClass ) ;
				switch( loaderClass )
				{
					case Loader :
						Util_loader.configLoader( loader, handlLoader, false ) ;
						Loader( loader ).load( URLRequest( request ), loaderContext ) ;
						break ;
					case URLLoader :
						Util_loader.configLoader( loader, handlLoader, false ) ;
						URLLoader( loader ).load( URLRequest( request ) ) ;
						URLLoaderMapper.note( loader, URLRequest( request ).url ) ;
						break ;
					default :
						enterDebugger() ;
				}
			//var wrapEvent:Boolean = args.wrapEvent ? true : false ;
			
			//为移除侦听而进行变量赋值。
				if( loader is Loader )
				{
					loader = Loader( loader ).contentLoaderInfo ;
					return LoaderInfo( loader ).loader ;
				}else
					return loader ;
			/*function loaderConfig( loader:IEventDispatcher ):void
			{
				loader.addEventListener( Event.COMPLETE, handlLoader ) ;
				loader.addEventListener( Event.INIT, handlLoader ) ;
				loader.addEventListener( Event.OPEN, handlLoader ) ;
				loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, handlLoader ) ;
				loader.addEventListener( IOErrorEvent.IO_ERROR, handlLoader ) ;
				loader.addEventListener( ProgressEvent.PROGRESS, handlLoader ) ;
				//loader.addEventListener( EVENT_requestEnd, handlEnd ) ;
			}*/
			function handlLoader( e:Event ):void
			{
				if( e.type == Event.COMPLETE )
					Util_loader.dischargeLoader( e.target, arguments.callee ) ;
				else if( e.type == IOErrorEvent.IO_ERROR )
					Util_loader.dischargeLoader( e.target, arguments.callee ) ;
				if( args.wrapEvent ){//%%不包装事件可以直接用原来的侦听函数。
					e = new EventBoost( e.type, e ) ;
					//eNew.target = e.target ;//其实EventBoost取target会自动返回e.target。 
					
				}
				handler( e ) ;
				/*var strInfo:String = '' ;
				switch( e.type )
				{
					case Event.COMPLETE :
						strInfo = '载入完成。' ;
						handlEnd( e ) ;
						break ;
					case Event.INIT :
						strInfo = '资源类初始化完成。' ;
						break ;
					case Event.OPEN :
						strInfo = '开始连接……' ;
						break ;
					case HTTPStatusEvent.HTTP_STATUS :
						strInfo = '服务器状态：'+HTTPStatusEvent( e ).status ;
						break ;
					case IOErrorEvent.IO_ERROR :
						strInfo = '抱歉，读写错误导致了载入失败。' ;
						handlEnd( e ) ;
						break ;
					case ProgressEvent.PROGRESS :
						var e1:ProgressEvent = ProgressEvent( e ) ;
						var percent:Number = Math.round( e1.bytesLoaded / e1.bytesTotal *100 );
						strInfo = '载入进度：'+ percent+ '%'
						break ;
					case HTTPStatusEvent.HTTP_RESPONSE_STATUS: //only in
						break ;
					default :
						if( Capabilities.playerType == 'Desktop' )
						if( HTTPStatusEvent.HTTP_RESPONSE_STATUS == e.type ){
							
						}
				}*/
			}
		}
		
		protected function handlEnd( e:Event, listener:Function ):void
		{
			var tar:IEventDispatcher = e.target as IEventDispatcher ;
			Util_loader.dischargeLoader( tar, listener ) ;
			/*tar.removeEventListener( Event.COMPLETE, listener ) ;
			tar.removeEventListener( Event.INIT, listener ) ;
			tar.removeEventListener( Event.OPEN, listener ) ;
			tar.removeEventListener( HTTPStatusEvent.HTTP_STATUS, listener ) ;
			tar.removeEventListener( IOErrorEvent.IO_ERROR, listener ) ;
			tar.removeEventListener( ProgressEvent.PROGRESS, listener ) ;*/
			//loader.removeEventListener( EVENT_requestEnd, handlEnd ) ;
			//handler = null ;
		}

	}
}