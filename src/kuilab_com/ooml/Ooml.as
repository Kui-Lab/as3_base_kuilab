package kuilab_com.ooml
{
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	
	import kuilab_com.ManagerApp;
	import kuilab_com.net.ISrvLoad;

	public class Ooml
	{
		
		public function build( xml:XML, handler:IOomlBuildHandle ):void
		{
			var allowOoInQuote:Boolean
			
			proc( xml ) ;
			
			function proc( node:XML ):*
			{
				var vInst:XMLList = node.processingInstructions() ;
				for each( var ni:XML in vInst )
				{
					enterDebugger() ;
				}
				for each( var ch:XML in node.children() )
				{
					proc( ch ) ;
				}
			}
		}
		
		public function buildUrl( url:Object, handler:IOomlBuildHandle ):void
		{
			/*var srvLoad:ISrvLoad = ManagerApp.getInstance().getObj( ISrvLoad ) as ISrvLoad ;
			var loader:URLLoader = srvLoad.load( url, onLoad, LoaderEx ) ;*/
			
			var loader:LoaderEx = new LoaderEx ;
				//loader.load( 
				
			var xml:XML ;
			function onLoad( e:Event ):void
			{
				if( e.type == Event.COMPLETE )
				{
					var s:Object = XML.settings()
					xml = XML( URLLoader( e.target ).data ) ;
					XML.setSettings( s ) ;
					build( xml, handler ) ;
				}
			}
			function config( loader:URLLoader ):void
			{
				/*loader.addEventListener(
				for each( var type:String in [Event.COMPLETE,IOErrorEvent.IO_ERROR,sec]*/
			}
		}
		
		public function Ooml()
		{
		}
		
		protected var tag:OomlTag ;
		
		protected function parseNode( node:XML ):*
		{
			
		}
	}
}
import flash.net.URLLoader;

class LoaderEx extends URLLoader
{
	public var dataHold:* ;
}