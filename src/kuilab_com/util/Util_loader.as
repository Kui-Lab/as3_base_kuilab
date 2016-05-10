package kuilab_com.util
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLStream;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	
	import kuilab_com.KuilabERROR;
	
	/**
	 * @see kuilab_com.net.SrvLoad.
	 * @author kui.
	 * 
	 */
	public class Util_loader
	{
		public function Util_loader()
		{
		}
		
		public static function get EVENT_urlLoader():Array{
			//var vect:Vector.<String> = new Vector.<String>( ) ;
			return common_loader_EVENTS.concat() ;
		}
		public static function get EVENT_urlLoaderAir():Array{
			//var vect:Vector.<String> = new Vector.<String>( ) ;
			return common_loader_EVENTS.concat( HTTPStatusEvent.HTTP_RESPONSE_STATUS ) ;
		}
		public static function get EVENT_swfLoader():Array{
			//var vect:Vector.<String> = new Vector.<String>( ) ;
			return common_loader_EVENTS.concat( Event.INIT ) ;
		}
		
		public static function get EVENT_all():Array{
			return common_loader_EVENTS.concat( HTTPStatusEvent.HTTP_RESPONSE_STATUS, Event.INIT ) ;
		}
		
		protected static const common_loader_EVENTS:Array = [	Event.COMPLETE, Event.OPEN,
															ProgressEvent.PROGRESS,
															HTTPStatusEvent.HTTP_STATUS, 
															IOErrorEvent.IO_ERROR, 
															SecurityErrorEvent.SECURITY_ERROR ] ;
		/*protected static const URL_LOADER_EVENTS:Array = [	Event.COMPLETE, Event.OPEN,
															ProgressEvent.PROGRESS,
															HTTPStatusEvent.HTTP_STATUS, 
															IOErrorEvent.IO_ERROR, 
															SecurityErrorEvent.SECURITY_ERROR ]*/
		
		public static function configLoader( loader:*, listener:Function, weak:Boolean=false ):*
		{
			if( loader is Class )
				loader = new( loader ) ;
			if( loader is Loader )
			{
				for each( var type:String in EVENT_swfLoader )
					Loader( loader ).contentLoaderInfo.addEventListener( type, listener, false, 0, weak ) ;
				return loader ;
			}
			//URLLoader().addEventListener(
			if( loader is URLLoader )
			{
				for each( var type2:String in common_loader_EVENTS ){
					URLLoader( loader ).addEventListener( type2, listener, false, 0, weak ) ;
				}
				if( Capabilities.playerType == 'Desktop' )//air 有
					URLLoader( loader ).addEventListener( HTTPStatusEvent.HTTP_RESPONSE_STATUS, listener, false, 0, weak ) ;	
			}else
				throw new Error( KuilabERROR.argsIncorrect( '目前只接受Loader或URLLoader' ) ) ;
			return loader ;
		}
		
		public static function dischargeLoader( loader:*, listener:Function, useCapture:Boolean= false ):void
		{
			if( loader is Loader )
				loader = Loader( loader ).contentLoaderInfo ;
			for each( var type:String in EVENT_all ){
				if( type )
					loader.removeEventListener( type, listener, useCapture ) ;
			}
		}
		/**
		 * @param loaderOrDomain 传LoaderInfo也可以。
		 */		
		public static function getDefinition( loaderOrDomain:*, name:String ):*{
			var domain:ApplicationDomain ; 
			if( loaderOrDomain is Loader ){
				domain = loaderOrDomain.contentLoaderInfo.applicationDomain ;
			}else if( loaderOrDomain is LoaderInfo ){
				domain = loaderOrDomain.applicationDomain ;
			}else if( loaderOrDomain is ApplicationDomain ){
				domain = loaderOrDomain ;
			}else
				throw new Error( KuilabERROR.argsIncorrect( 1 ) ) ;
			if( domain.hasDefinition( name ) )
				return domain.getDefinition( name ) ;
			return null ;
		}
	}
}