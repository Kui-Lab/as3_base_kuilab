package kuilab_com.util
{
	import flash.debugger.enterDebugger;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import kuilab_com.event.EventBoost;
	
	//swf本身出错可能依旧会发事件。
	/**
	 * 没用的，因为LoaderInfo类禁止调用dispatchEvent方法。
	 * 用法：[Frame(factoryClass="kuilab_com.util.PreloaderFixAvmBug")]
	 * @author kui.
	 */
	public class PreloaderFixAvmBug extends MovieClip
	{
		protected static const TIMEOUT:uint = 1000 ;
		public function PreloaderFixAvmBug()
		{
			super();
			li = this.loaderInfo ;
			li.addEventListener( Event.COMPLETE, onComplete ) ;
			addEventListener( Event.ENTER_FRAME, enterFrame ) ;
		}
		
		protected var li:LoaderInfo ;
		protected var evtDispatched:Boolean = false ;
		
		protected function onComplete( e:Event ):void
		{
			c::d0{ trace( 'preloader feel complete:', li.loaderURL ) }
			evtDispatched = true ;
		}
		
		protected function enterFrame( e:Event ):void
		{
			if( li.bytesLoaded == li.bytesTotal )
			{
				removeEventListener( e.type, enterFrame ) ;
				
				if( evtDispatched )
					return ;
				var timeout:uint = TIMEOUT ;
				c::d0{ timeout = 2222 }
				var id:int = setTimeout( function( ):void
				{
					if( !evtDispatched ){ trace( 'bug occur. preloader dispatched event.' ) ; enterDebugger() ;
						li.removeEventListener( Event.COMPLETE, onComplete ) ;
						c::d0{ li.dispatchEvent( new EventBoost( '!!!' ) ) }
						li.dispatchEvent( new Event( Event.COMPLETE ) ) ;
						clearTimeout( id ) ;
					}
				}, timeout ) ;
				
			}
		}
	}
}