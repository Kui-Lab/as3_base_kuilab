package kuilab_com 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import kuilab_com.config.IIncubator;
	import kuilab_com.config.IncubatorDefault;
	import kuilab_com.dependInj.IDependInjectRegist;
	import kuilab_com.net.SrvLoad;
	import kuilab_com.util.Map_applicationDomain;
	import kuilab_com.util.Util_Vector;
	import kuilab_com.util.Util_object;
	import kuilab_com.dependInj.IFactory4DepInj;
	/**
	 * 这个类应该要做修改。
	 */	
	public class ManagerApp extends EventDispatcher implements IFactory4DepInj,IDependInjectRegist
	{
		//public static const POLICY_configGet_param:uint = 0 ;
		public static const EVENT_configOk:String = '配置项完成' ;
		
		protected static const STR_ERROR_loadConfigFail:String = '抱歉，程序获取配置失败(0)。' ;
		protected static const STR_ERROR_loadConfigTimeout:String = '抱歉，程序获取配置超时(1)。' ;
		protected static const STR_ERROR_stageNotSet:String = '请传入Stage实例引用，不然ManagerApp无法正常工作。'
		protected static const STR_ERROR_urlFileCfg:String = '使用方法不当，没有传入url地址时请勿调用此方法。'
			//'The path url of config file is invalidate!\n' + 
			//'please make sure ManagerApp is use correctly.' ) ;
		public function ManagerApp()
		{
			SrvLoad ;
		}
		
		protected static var instance_:ManagerApp ;
		
		/**
		 * @param nameParamUrlConfig {配置信息的URL}在当前swf的URL参数中的参数名称。
		 * 比如当前swf文件的URL是“http://xxx.com/a.swf?urlConfig=config/cfgA.xml”
		 * 那么它的值就应该是“urlConfig”，如此程序将去“config/cfgA.xml”这个URL获取配置文件。
		 */
		public static function getInstance( nameParamUrlConfig:String = 'urlConfig', stage:Stage=null ):ManagerApp
		{
			if( stage )
				ManagerApp.stage = stage ;
			if( instance_ )
				return instance_ ;
			instance_ = new ManagerApp ;
			instance_.addApplicationDomain( ApplicationDomain.currentDomain ) ;
			instance_.nameParamUrlConfig_ = nameParamUrlConfig ;
			if( stage )
			{
				var p:Object = stage_.loaderInfo.parameters ;
				instance_.strUrlConfig_ = p[ nameParamUrlConfig ] ;
			}
			//instance_.strUrlConfig_ = p[ instance_.nameParamUrlConfig_ ] ;
				return instance_ ;	
		}
		
		//数据。
			protected var nameParamUrlConfig_:String ;
			protected var strUrlConfig_:String ;
		//设置。
			protected var pathSpliter_:String = '.' ;
			protected var policyConfigGet_:uint ;
			protected var debug_:Object ;
		//业务逻辑成员。
			protected static var stage_:Stage ;
			protected var parserConfig_:IIncubator ;
			protected var mapInterface:Object = new Dictionary ;
			//protected var toolUrl:Object ;
		
		public function set parserConfig( parser:IIncubator ):void
		{
			parserConfig_ = parser ;
		}
		
		public function get parserConfig():IIncubator
		{
			return parserConfig_ ;
		}
		
		public function set strUrlConfig( v:String ):void
		{
			strUrlConfig_ = v ;
		}
		
		public function get strUrlConfig():String
		{
			return strUrlConfig_ ;
		}
		
		public function set pathSpliter( v:String ):void
		{
			pathSpliter_ = v ;
		}
				
		public static function set stage( v:Stage ):void
		{
			//var p:Object = v.loaderInfo.parameters ;
			//strUrlConfig_ = p[ nameParamUrlConfig_ ] ;
			stage_ = v ;
		}
		
		public static function get stage():Stage
		{
			return stage_ ;
		}
		
		public function configLoad( filePath:URLRequest=null ):void
		{
			if( filePath == null )
			if( strUrlConfig_ )
				filePath = new URLRequest( strUrlConfig_ ) ;
			else throw new Error( STR_ERROR_urlFileCfg ) ;	
			var loader:URLLoader = new URLLoader ;
				loader.addEventListener( Event.COMPLETE, handlLoader ) ;
				loader.addEventListener( IOErrorEvent.IO_ERROR, handlLoader ) ;
				loader.load( filePath ) ;
			var idTimeout:int = setTimeout( handlTimeOut, 10*1000 ) ;
			var refThis:ManagerApp = this ;
			function handlLoader( e:Event ):void
			{
				if( e.type == Event.COMPLETE )
				{
					if( parserConfig_ == null )
						parserConfig_ = new IncubatorDefault ;
					try{
						parserConfig_.dataConfig = loader.data ;
					}catch( e:* ){ throw e }
					refThis.dispatchEvent( new Event( EVENT_configOk ) ) ;
				}
				else if( e.type == IOErrorEvent.IO_ERROR )
					throw new Error( STR_ERROR_loadConfigFail ) ;
				loader.removeEventListener( Event.COMPLETE, handlLoader ) ;
				loader.removeEventListener( IOErrorEvent.IO_ERROR, handlLoader ) ;
			}
			function handlTimeOut():void
			{
				clearInterval( idTimeout ) ;				
				if( loader.bytesTotal ==0 || loader.bytesLoaded < loader.bytesTotal )
					throw new Error( STR_ERROR_loadConfigTimeout ) ;
				loader.removeEventListener( Event.COMPLETE, handlLoader ) ;
				loader.removeEventListener( IOErrorEvent.IO_ERROR, handlLoader ) ;
			}
		}
		
		public function getFactory( interfac:Object, path:String ):IFactory
		{
			return null ;
		}
		
		public function registInterface( interfac:Object, instance:Object, path:*='*' ):*
		{
			var key:String 
			if( interfac is String )
				key = interfac as String ;
			else if( interfac is Class )//接口对象is Class。
			{
				key = getQualifiedClassName( interfac ) ;
				key = key.replace( '::', '.' ) ;
			}else return ;
			
			if( mapInterface[ key ] )
			{}else
				mapInterface[ key ] = new Dictionary ;
			mapInterface[ key ][ path ] = instance ;
		}
		
		public function getInstanceAmply( interfac:Object, path:Object=null, args:Object=null ):*
		{
		
			var nameInterface:String ;
			if( interfac is String )
				nameInterface = String( interfac );
			else if( interfac is Class )
				nameInterface = getQualifiedClassName( interfac ) ;
			else
				return null ;
			nameInterface = nameInterface.replace( '::', '.' ) ;
			
			var map:Object = mapInterface[ nameInterface ] ;
			var obj:Object ;
			if( map )
				obj = getByPath( path, map ) ;
			// if( obj is IFactory ) return IFactory( obj ).getInstance( interfac, path, args ) ;
			if( obj != null )
			{
				return obj ;
			}
			/////////////尝试根据接口名称获取未注册的实现类(同时注册)。%%TODO 这个应该加参数控制。
			var nameShort:String = nameInterface.split( '.' ).pop() ;
			if( nameShort.charAt( 0 ) == 'I' )	//Iaaa
			{
				//nameShort = nameShort.substr( 1 ) ;
				//str = str.charAt( 0 ).toUpperCase() + str.substr( 1 ) //首字母改大写。
				nameInterface = nameInterface.replace( nameShort, nameShort.substr(1) ) ;
					//nameInterface.substr( 0, ind ) +'.'+ str ;
			}else{
				return null ;
			}
			
			try{
				var cla:Class = mapAppDomain[ nameInterface ] ;
				if( cla == null ){
					if( interfac == IFactory4DepInj )
						return this ;
					return null ;
				}
				var ins:Object = Util_object.newObjByArg( cla, args as Array ) ;
				registInterface( interfac, ins ) ;
				return ins ;
			}catch( e:Error ){
			}
			return null ;
		}
		
		public function getClass( interfacee:Object, path:Object=null, args:Object=null ):Object
		{
			throw new Error( KuilabERROR.methodDoesNotImplement() ) ;
		}
		
		/**以"aa.bb.cc"查询，依次检查"aa.bb.cc","aa.bb","aa",""，有则返回。 */		
		protected function getByPath( path:*, map:Object ):*
		{
			var vPath:Array ;
			if( path == null )
				return map[ '*' ] ;
			else if( path is String )
				vPath = path.split( pathSpliter_ ) ;
			else if( Util_Vector.isVectorOrArray( path ) )
				vPath = path ;
			else
				throw new Error( KuilabERROR.argsIncorrect( 1 ) ) ;
			var pathCur:String ;
			while( true )
			{
				if( vPath.length == 0 ){
					//if( map.hasOwnProperty( '*' ) )
					return map[ '*' ] ;
				}
				pathCur = vPath.join( pathSpliter_ ) ;
				if( map[ pathCur ] )
					return map[ pathCur ] ;
				vPath.pop() ;
			}
			return null ;
		}
		
		protected var mapAppDomain:Map_applicationDomain = new Map_applicationDomain ;
		
		public function addApplicationDomain( domain:ApplicationDomain ):void
		{
			use namespace flash_proxy ;
			mapAppDomain.addDomain( domain ) ;
		}
		
		public function removeDomain( domain:ApplicationDomain ):void
		{
			use namespace flash_proxy ;
			mapAppDomain.remDomain( domain ) ;
		}
		
		public function setToWeak():void
		{}
		
		/*public function get applicationDomain():ApplicationDomain
		{
			if( stage_ )
				return stage_.loaderInfo.applicationDomain ;
			else
				throw new Error( STR_ERROR_stageNotSet ) ; 
		}*/
		
	}
}