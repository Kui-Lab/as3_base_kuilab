package kuilab_com.config
{
	import flash.debugger.enterDebugger;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import kuilab_com.KuilabERROR;
	import kuilab_com.config.dep_etc.DepInjParser_DEF;
	import kuilab_com.event.EventBoost;
	import kuilab_com.util.Map_applicationDomain;
	import kuilab_com.util.Util_Vector;
	import kuilab_com.util.Util_Xml;
	///还未测试过。
	public class IncubatorByMark_Default implements IIncubator
	{
		public function IncubatorByMark_Default()
		{
		}
		
		protected var keyItems:* = 'impl-mapping-items' ;
		protected var keyInterface:* = 'interface' ;
		protected var keyClass:* = 'impl' ;
		protected var value_defaultImpl:* = '~' ;
		protected var keyPath:Object = 'path' ;
		/**
		 * <x interface >
		 * @param data
		 */		
		public function set dataConfig( data:Object):void
		{
		}
		
		public function buildUp( config:*, classMapOrAppDomain:*, onProg:Function, appendTo:*=null ):void
		{
			if( Util_Vector.isVectorOrArray( classMapOrAppDomain ) ){
				classMapOrAppDomain = new Map_applicationDomain( classMapOrAppDomain ) ;
			}else if( classMapOrAppDomain is ApplicationDomain ){
				classMapOrAppDomain = new Map_applicationDomain( [ classMapOrAppDomain ] ) ;
			}else if( classMapOrAppDomain == null ){
				classMapOrAppDomain = new Map_applicationDomain( [ ApplicationDomain.currentDomain ] ) ;
			}else
				throw new Error( KuilabERROR.argsIncorrect(  ) ) ;
			var theMap:* = new Dictionary ;
			if( appendTo == null )
				theMap = new Dictionary ;
			else
				theMap = appendTo ;
			
			
			if( config is XML )
			{}else{// if( config is String ){
				try{
					config = XML( String( config ) ) ;
				}catch( err:* ){
					throw new Error( KuilabERROR.argsIncorrect( 10 ) ) ;
				}
			}
			var domain:Map_applicationDomain 
			for each( var n:XML in Util_Xml.getChildren( config, keyItems ) )
			{
				/*var imp:* = keyClass == '~' ? 
					n.toString()
					: Util_Xml.getAttOrChild( n, keyClass ) ;*/
				//var pth:* = Util_Xml.getAttOrChild( n, keyPath ) ;
				
				parseItfNode( n ) ;
			}
			function parseItfNode( nodeItf:XML ):*{
				var interfac:* = Util_Xml.getChild( nodeItf, keyInterface ).toString() ;
				var itfName:String ;
				var itfMap:* ;
				if( appendTo.hasOwnProperty( interfac ) ){
					itfMap = theMap[ interfac ] ;
				}else{
					itfMap = new Dictionary() ;
					theMap[ interfac ] = itfMap ;
				}
				
				for each( var implNode:XML in nodeItf ){
					var itf:String = Util_Xml.getAttOrChild( nodeItf, keyInterface, true ) ;
					var impl:* = Util_Xml.getAttOrChild( nodeItf, keyClass, true ) ;
					var packag:String = Util_Xml.getAttOrChild( nodeItf, keyPath, true ) ;
					if( impl == '' )
					impl = classMapOrAppDomain[ impl ] ;
					if( impl ){
						try{
							impl = new( impl ) ;
						}catch( err:* ){
							onProg( new EventBoost( DepInjParser_DEF.EVNET_err, [ DepInjParser_DEF.ERR_instantiation( err ), implNode ] ) ) ;
							continue ;
						}
					}else{
						onProg( new EventBoost( DepInjParser_DEF.EVNET_err, [ DepInjParser_DEF.ERR_instantiation( 10 ), implNode ] ) ) ;
						continue ;
					}
					itfMap[ packag ] = impl ;
				}
			}
		}
		
	}
}