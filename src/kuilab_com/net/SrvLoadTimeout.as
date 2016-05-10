package kuilab_com.net
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	
	import kuilab_com.KuilabERROR;
	import kuilab_com.event.EventBoost;
	import kuilab_com.util.Util_loader;
	
	
	/**未写完。
	 * %%自动卸载侦听函数
	 * 
	 * 使用了闭包，开销可能稍微有点大。
	 * @author kui.
	 */
	public class SrvLoadTimeout implements ISrvLoad
	{
		
		public function SrvLoadTimeout()
		{
		}
		
		protected static var mapLoader:Object = new Dictionary( true ) ;
		protected static var lTimeOut:Array = [] ;
		
		protected static var itvIdTick:uint = uint.MAX_VALUE ;
		
		protected static function onTimerTick( e:TimerEvent ):void
		{
			for( var loader:Object in mapLoader ) 
			{
				var holder:LoadHolder = mapLoader[ loader ] ;
				var timeSec:int = mapLoader[ holder ] ;
				if( timeSec <= 0 ){
					if( holder.loader is Loader )
						Loader( holder.loader ).unload() ;
					else{}
					stopTimerCnt( loader ) ;
					//IEventDispatcher( holder.loader ).removeEventListener( 
				}else
					holder.timeLife -- ;
			}
			if( loader == null )
				chkStopTimer( true ) ;
		}
		
		/** 超时或加载完成。 **///必须是全局函数。
		public static function stopTimerCnt( loader:Object, dispatchTimerComplete:Boolean=false ):void
		{
			var holder:LoadHolder = mapLoader[ loader ] ;
			if( dispatchTimerComplete ){
				if( holder.loader is URLLoader )
					IEventDispatcher( holder.loader ).dispatchEvent( new TimerEvent( TimerEvent.TIMER_COMPLETE ) ) ;
				else
					IEventDispatcher( Loader( holder.loader ).contentLoaderInfo ).dispatchEvent( new TimerEvent( TimerEvent.TIMER_COMPLETE ) ) ;
			}
			delete mapLoader[ holder ] ;
			Util_loader.dischargeLoader( loader, holder.handler ) ;
		}
		
		public function stopTimerCnt$( loader:Object ):void
		{
			
		}
		
		protected function chkStartTimer():void
		{
			if( itvIdTick ){}
		}
		
		/** 所有加载器超时测量结束则停止周期全局检查。 **/
		protected static function chkStopTimer( ignoreChk:Boolean=false ):void
		{
			if( ignoreChk )
			{}else{
				for each( var holder:LoadHolder in mapLoader ){
					if( holder.timeLife == 0 )
						stopTimerCnt( holder.loader ) ;
					else
						holder.timeLife -- ;
				}
			}
			clearInterval( itvIdTick ) ;
			itvIdTick = uint.MAX_VALUE ;
		}
		
		protected function resetTime( loader:Object ):void
		{
			var holder:LoadHolder = mapLoader[ loader ] ;
			if( holder ){
				holder.timeLife = holder.timeout ;
			}
		}

		public function load( request:Object, handler:Function, loaderClass:Class=null, args:ISrvLoad_arg=null ):*
		{
			if( ! ( request is URLRequest ) )
			{
				request = new URLRequest( request.toString() ) ;
			}
			if( loaderClass == null )
			{
				if( String(request.url).match( / \Wswf(\??\W) /i ) )
					loaderClass = Loader ;
				else
					loaderClass = URLLoader ;
			}
			if( args is String )
				throw new Error( KuilabERROR.argsIncorrect( 'see kuilab_com.net.ISrvLoad_DEF' ) );
			var loader:* = new( loaderClass ) ;
			var handlLoader:Function //= args. ? handlLoaderWrap : handlLoaderOrig ;
			
			switch( loaderClass )
			{
				case Loader :
					Util_loader.configLoader( loader, handlLoader ) ;
					Loader( loader ).load( URLRequest( request ), args.context ) ;
					break ;
				case URLLoader :
					Util_loader.configLoader( loader, handlLoader ) ;
					URLLoader( loader ).load( URLRequest( request ) ) ;
					break ;
			}
			if( args.timeoutSecd )
			{
				var timeout:uint = args.timeoutSecd ;
				var holder:* = new LoadHolder( loader, handler, timeout ) ;
				mapLoader[ loader ] = holder ;
			}
			
			if( loader is Loader )//为移除侦听而赋值loader。
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
			function handlLoaderWrap( e:Event ):void
			{
					var eNew:Event ; 
					eNew = new EventBoost( e.type, e.target ) ;
					var strInfo:String = '' ;
					switch( e.type )
					{
						case Event.COMPLETE :
							strInfo = '载入完成。' ;
							handlEnd( null ) ;
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
							handlEnd( null ) ;
							break ;
						case ProgressEvent.PROGRESS :
							var e1:ProgressEvent = ProgressEvent( e ) ;
							var percent:Number = Math.round( e1.bytesLoaded / e1.bytesTotal *100 );
							strInfo = '载入进度：'+ percent+ '%'
							resetTime( e.target ) ;
							break ;
						case HTTPStatusEvent.HTTP_RESPONSE_STATUS: //only in
							break ;
						default :
							if( Capabilities.playerType == 'Desktop' )
							if( HTTPStatusEvent.HTTP_RESPONSE_STATUS == e.type ){
								
							}
							
					}
					EventBoost( eNew ).data = strInfo ; 
					handler( eNew ) ;
			}
			function handlLoaderOrig( e:Event ):void
			{
				handler( e ) ;
				if( e.type == ProgressEvent.PROGRESS ){
					resetTime( e.target ) ;
					return ;
				}
				if( e.type == Event.COMPLETE )
					return void handlEnd( e ) ;
				if( e.type == IOErrorEvent.IO_ERROR )
					return void handlEnd( e ) ;
			}
			function handlEnd( e:Event ):void
			{
				if( mapLoader[ e.target ] )
					stopTimerCnt( e.target ) ;
				var tar:IEventDispatcher = e.target as IEventDispatcher ;
				/*tar.removeEventListener( Event.COMPLETE, handlLoader ) ;
				tar.removeEventListener( Event.INIT, handlLoader ) ;
				tar.removeEventListener( Event.OPEN, handlLoader ) ;
				tar.removeEventListener( HTTPStatusEvent.HTTP_STATUS, handlLoader ) ;
				tar.removeEventListener( IOErrorEvent.IO_ERROR, handlLoader ) ;
				tar.removeEventListener( ProgressEvent.PROGRESS, handlLoader ) ;*/
				//loader.removeEventListener( EVENT_requestEnd, handlEnd ) ;
				handler = null ;
			}
		}

	}
}
class LoadHolder{
	function LoadHolder( loader:Object, handler:Function, timeout:uint )
	{
		this.loader = loader ;
		this.handler = handler ;
		this.timeout = timeout ;
		this.timeLife = timeout ;
	}
	
	public var loader:Object ;
	public var handler:Function ;
	public var timeLife:int ;
	public var timeout:uint ;
}