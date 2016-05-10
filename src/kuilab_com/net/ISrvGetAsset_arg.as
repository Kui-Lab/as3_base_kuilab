package kuilab_com.net
{
	public dynamic class ISrvGetAsset_arg extends ISrvLoad_arg
	{
		//public static const V_storeType_noStore:Object = 0 ;
		public static const V_storeType_inProgram:Object = 1 ;
		public static const V_storeType_inSharedObj:Object = 2 ;
		public static const V_storeType_any:Object = 9 ;
		
		public static const NOT_EXIST:Object = {} ;
		
		//public static const REPLACE_STORE:Object = 'replace store';
		
		public static const ARG_NAME_disposeTime:String = 'dispose time.' ;
		
		/**
		 * 与ERR_LOADING相同。
		 */
		public static const TO_LOAD:Object = '正在加载所需数据或文件。' ;
		/**
		 * 请求资源时如果需要加载则返回type为这个值的事件。
		 */
		public static const ERR_LOADING:String = TO_LOAD+'这是一个表达逻辑的错误，而不是真的表示发生了错误。' ;	
		
		
		
		
		public var storeType:Object = V_storeType_inProgram ;
		public function setStoreType( value:Object ):ISrvGetAsset_arg
		{
			storeType = value;
			return this ;
		}
		
		public var updateStore:Boolean = false ;
		public function setUpdateStore( value:Boolean ):ISrvGetAsset_arg
		{
			updateStore = value ;
			return this ;
		}
		
		/*public var wrapEvent:Boolean = false ;
		public function setWrapEvent( value:Boolean ):ISrvGetAsset_arg
		{
			wrapEvent = value ;
			return this ;
		}*/

		/*public var resultBody:String = ARG_V_returnDataOrContent ;
		public function setResultBody( value:String ):ISrvGetAsset_arg
		{
			resultBody = value ;
			return this ;
		}*/
		
		public var beLoadThrowOrReturn:Boolean = true ;
		/**
		 * 注意：抛出的可能真的是错误而不是需要的对象。
		 */
		public function setBeLoadThrowOrReturn( value:Boolean ):ISrvGetAsset_arg
		{
			beLoadThrowOrReturn = value ;
			return this ;
		}
		
		public var returnByEvent:Boolean = true ;
		public function setReturnByEvent( value:Boolean ):ISrvGetAsset_arg
		{
			returnByEvent = value ;
			return this ;
		}
		
		public var overrideAtLoadNew:Boolean ;
		public function setOverride( v:Boolean ):void
		{
			overrideAtLoadNew = v ;
		}
		
		
		public var UDID:*
		public function setUDID( v:* ):void
		{
			UDID = v ;
		}
		/*public static function addARG_returnObj( arg:Object, addToArgObj:ISrvLoad_arg=null ):ISrvLoad_arg
		{
			if( addToArgObj == null )
				addToArgObj = new ISrvLoad_arg ;
			addToArgObj[ ARG_name_returnObj ] = arg ;
			return addToArgObj ;
		}*/
		
		/** 返回加载器本身或是数据、加载器数据、应用程序域。其实是指示存储哪个对象的。 **/
		public var returnObject:Object ;
				public static const ARG_name_returnObj:Object = 'kuilab_com.net.ISrvLoad::load() 返回加载器本身或是数据、加载器数据、应用程序域' ;
				
				public static const ARG_V_returnEventObject:Object = '返回、存储事件对象'
				
				public static const ARG_V_returnDataOrContent:Object = '返回、存储数据（URLLoader/data）或者内容（Loader/content）' ;
				
				public static const ARG_V_returnLoaer:Object = '返回、存储加载器本身对象' ;
				
				public static const ARG_V_returnLoaderInfo:Object = '返回、存储加载器信息（swfLoader.contentLoaderInfo）' ;
				
				public static const ARG_V_returnApplicationDomain:Object = '返回、存储应用程序域（swfLoader.contentLoaderInfo.applicationDomain）' ;
								
				public static const ARG_V_returnAssetInPackage:Object = '请求的资源在某个包中，加载整个包然后取出这个资源返回。' ;
				
				public function setReturnObj_eventObj():ISrvLoad_arg
				{
					returnObject = ARG_V_returnEventObject ;
					return this ;
				}
				
				public function setReturnObj_dataOrContent( ):ISrvLoad_arg
				{
					returnObject = ARG_V_returnDataOrContent ;
					return this ;
				}
				public function setReturnObj_loader():ISrvLoad_arg
				{
					returnObject = ARG_V_returnLoaer ;
					return this ;
				}
				public function setReturnObj_loaderInfo():ISrvLoad_arg
				{
					returnObject = ARG_V_returnLoaderInfo ;
					return this ;
				}
				public function setReturnObj_ApplicationDomain():ISrvLoad_arg
				{
					returnObject = ARG_V_returnApplicationDomain ;
					return this ;
				}
				
		public static function doNew():ISrvGetAsset_arg
		{
			return new ISrvGetAsset_arg ;
		}
		
		public function ISrvGetAsset_arg()
		{
		}
	}
}