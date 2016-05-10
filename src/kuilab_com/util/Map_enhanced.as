package kuilab_com.util
{
	import kuilab_com.event.EventBoost;
	import kuilab_com.event.EventUpdate;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	use namespace flash_proxy ;

	/**
	 * 任何对象都可以做键来存储对象，但是只有String做键的成员赋值时会发送事件。
	 * @author kui.
	 */
	 /*%%	changedKey*/
	public dynamic class Map_enhanced extends Proxy implements IEventDispatcher,IBindable
	{
		public function Map_enhanced( weakKey:Boolean = false, autoSetPropBindable:Boolean=false, separator:String='.' )
		{
			super();
			this.weakKey = weakKey ;
			this.autoSetPropBindable = autoSetPropBindable ;
			this.separator = separator ;
			mapProp = new Dictionary( weakKey ) ;
		}
		
		protected var weakKey:Boolean = true ;
		protected var mapProp:Dictionary ;
		protected var mapNameBind:Dictionary = new Dictionary( ) ;
		protected var ed:EventDispatcher = new EventDispatcher ;
		protected var separator:String = '.' ;
		protected var keyChanged:Object ;
		protected var autoSetPropBindable:Boolean = false ;
		
		protected function dispatchUpdate():void
		{
			
		}
		
		/**
		 * 覆盖成员访问运算符，也就是“[]”。
		 * override the property access operator.("[]").
		 * @param name String类型的键会在运行时强制转换成QName之后再传入。
		 * Any Sting will be translated to a QName by AVM .
		 */
		flash_proxy override function setProperty( name:*, value:* ):void
		{
			var bIsString:Boolean = true ;
			if( name is String )
			{}else if( name is QName )
				name = QName( name ).localName ;
			else bIsString = false ;
			if( bIsString 	&&		String(name).indexOf(separator) != -1 )
			{	//带有路径的赋值。
				var vPath:Array = String(name).split( separator ) ;
				var nameProp:String = vPath.pop() ;
				var host:Object = this ;
				for each( var path:String in vPath )
				{
						if( host[ path ] is Object ) {}	//获取成员可能抛错。
						else if( host is IBindable )	
							host[ path ] = new Map_enhanced ;//没有成员则自动创建。
						host = host[ path ] ;
				}
				host[ nameProp ] = value ;
				return ;
			}
			//if( mapProp[ name ] === undefined && ( name is String ) && autoSetPropBindable )
			//	mapNameBind[ name ] = [] ;
			var vOld:Object = mapProp[ name ] ;
			mapProp[ name ] = value ;
			keyChanged = name ;
			if( mapNameBind[ name ] != null && ( mapNameBind[ name ] as Array ).length > 0 )
			{
				var e:EventUpdate = new EventUpdate( Event.CHANGE, name ) ;
					e.target = this ;
				ed.dispatchEvent( e ) ;
					e = new EventUpdate( String( name ), value ) ;
					e.target = this ;
					e.oldValue = vOld ;
				ed.dispatchEvent( e ) ;
			}
		}
		
		protected function getByPath( path:Array ):*
		{
			var host:Object = this ;
			//var last:Object = path.pop() ;
			while( path.length )
			{
				host = host[ path.shift() ] ;
				if( host == null )
					return undefined ; 
			}
			return host ;
		}
		
		flash_proxy override function getProperty(name:*):*
		{
			var bIsString:Boolean = true ;
			if( name is String ){}
			else if( name is QName )
				name = QName( name ).localName ;
			else bIsString = false ;
			if( bIsString 	&&		String(name).indexOf(separator) != -1 )
			{	//带有路径的赋值。
				var vPath:Array = String(name).split( separator ) ;
				var nameProp:String = vPath.pop() ;
				var host:Object = this ;
				for each( var path:String in vPath )
				{
					host = host[ path ] ;//会抛错。
				}
				return host[ nameProp ] ;
			}
			return mapProp[ name ] ;
		}
		
		flash_proxy override function hasProperty( name:* ):Boolean
		{
			var bIsString:Boolean = true ;
			if( name is String ){}
			else if( name is QName )
				name = QName( name ).localName ;
			else 
				return false ;
			if( bIsString &&		String(name).indexOf(separator) != -1 )
			{	//带有路径的赋值。
				var vPath:Array = String(name).split( separator ) ;
				var nameProp:String = vPath.pop() ;
				var host:Object = this ;
				for each( var path:String in vPath )
				{
					host = host[ path ] ;//会抛错。
					if( host == null )
						return false ;
				}
				return host.hasOwnProperty( nameProp ) ; 
			}
			return mapProp.hasOwnProperty( name ) ;
		}
		/*flash_proxy override function callProperty( name:*, ... rest ):*
		{
			return mapProp[ name ] ;
		}*/
		
		flash_proxy override function deleteProperty( name:* ):Boolean
		{
			var bIsString:Boolean = true ;
			if( name is String ){}
			else if( name is QName )
				name = QName( name ).localName ;
			else bIsString = false ;
			if( bIsString 	&&		String(name).indexOf(separator) != -1 )
			{	//带有路径的赋值。
				var vPath:Array = String(name).split( separator ) ;
				var nameProp:String = vPath.pop() ;
				var host:Object = this ;
				for each( var path:String in vPath )
				{
					host = host[ path ] ;//会抛错。
					if( host == null )
						return false ;
				}
				return delete host[ nameProp ] ; 
			}
			delete mapProp[ name ] ;
			delete mapNameBind[ name ] ;
			if( keyChanged === name )
				keyChanged = null ;
			return true ;
		}
		
		flash_proxy override function getDescendants( name:* ):*
		{
			var v:Array = [] ;
			if( mapProp[ name ] !== undefined )
				v.push( mapProp[ name ] ) ;
			for each( var inferior:Object in mapProp )
			{
				if( inferior is Map_enhanced )
				{
					var r:Array = inferior.getDescendants( name ) as Array ;
					v.concat( r ) ;
				}else if( inferior is Dictionary ){
					if( inferior[ name ] !== undefined )
						v.push( inferior[ name ] ) ;
				}
			}
			return v ;
		}
		
		public function setPropertyBindable( name:Object, bindable:Boolean =true ):void
		{
			if( bindable )
			{
				if( mapNameBind[ name ] == null )
				{
					mapNameBind[ name ] = [] ;
					ed.dispatchEvent( new EventBoost( Event.CHANGE, name ) ) ;
					ed.dispatchEvent( new EventBoost( String( name ), mapProp[ name ] ) ) ;
				}
			}else{
				if( mapNameBind[ name ] != null )
					delete mapNameBind[ name ]  ;
					//'移除侦听'
			}
		}
		
		public function isPropertyBindable( name:Object ):Boolean
		{
			var bIsString:Boolean = true ;
			if( name is String ){}
			else if( name is QName )
				name = QName( name ).localName ;
			else 
				return false ;
			if( bIsString &&		String(name).indexOf(separator) != -1 )
			{	//带有路径的赋值。
				var vPath:Array = String(name).split( separator ) ;
				var nameProp:String = vPath.pop() ;
				var host:Object = this ;
				for each( var path:String in vPath )
				{
					host = host[ path ] ;//会抛错。
					if( host == null )
						return false ;
				}
				if( host is IBindable )
					return IBindable( host ).isPropertyBindable( nameProp ) ;
				return false ;
			}
			if( mapProp[ name ] === undefined )
				return false ;
			return mapNameBind[ name ] != null ; 
		}
		
		public function bindProperty( name:Object, listener:Function, autoSetBindable:Boolean=false, priority:int=0 ):void
		{
			if( name is String )
			{
				if( mapNameBind[ name ] != null )
				{}else{
					if( autoSetBindable ){
						mapNameBind[ name ] = [] ;
					}else return ;//不要自动设置可绑定且成员是不可绑定绑定的情况下就无效。
				}
				( mapNameBind[ name ] as Array ).push( listener ) ;
				ed.addEventListener( String( name ), listener, false, priority ) ;
			}
		}
		
		/**
		 * 将会移除所有的这个函数的绑定。 
		 * @param listener
		 * @return 
		 */
		public function removeBindBySeek( listener:Function ):Boolean
		{
			return false ;
		}
		
		public function removeBind( propertyName:String, listener:Function ):void
		{
			if( mapNameBind.hasOwnProperty( propertyName ) )
			{
				var arr:Array = mapNameBind[ propertyName ] as Array ;
				var i:int = arr.indexOf( listener ) ;
				arr.splice( i, 1 ) ;
			}
			ed.removeEventListener( propertyName, listener ) ;
			//mapNameBind[ propertyName ]
		}
		
		public function getChangedKey():*
		{
			return keyChanged ;
		}
		
		//IEventDispatcher implements.
			public function addEventListener( type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false ):void
			{
				ed.addEventListener( type, listener, useCapture, priority, useWeakReference ) ;
			}
			
			public function removeEventListener( type:String, listener:Function, useCapture:Boolean=false ):void
			{
				ed.removeEventListener( type, listener, useCapture ) ;
			}
			
			public function dispatchEvent( event:Event ):Boolean
			{
				return ed.dispatchEvent( event );
			}
			
			public function hasEventListener( type:String ):Boolean
			{
				return ed.hasEventListener( type );
			}
			
			public function willTrigger( type:String ):Boolean
			{
				return ed.willTrigger( type ) ;
			}
		
	}
}