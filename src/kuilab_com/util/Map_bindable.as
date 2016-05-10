package kuilab_com.util
{
	import kuilab_com.KuilabERROR;
	import kuilab_com.event.EventBoost;
	import kuilab_com.event.EventUpdate;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace flash_proxy ;
	
	public dynamic class Map_bindable extends Proxy
	{
		/**
		 * @param weakKey 与Dictionary的weakKey意义相同。
		 * @param autoSetBindable
		 * @param allowEnumeration
		 */
		public function Map_bindable( weakKey:Boolean=false, autoSetBindable:Boolean=false, allowEnumeration:Boolean=false )
		{
			super();
			mapProp = new Dictionary( weakKey ) ;
			this.autoSetPropBindable = autoSetBindable ;
			//this.allowEnumeration
		}
		
		protected var mapProp:Dictionary ;
		protected var mapNameBind:Dictionary = new Dictionary( true ) ;
		protected var updateHandler_:Function
		protected var ed:EventDispatcher = new EventDispatcher ;
		protected var keyChanged:Object ;
		protected var autoSetPropBindable:Boolean = false ;
		protected var allowEnumeration:Boolean = false ;
		protected var sendUpdate1_:Boolean = false ;
		protected var sendUpdate2_:Boolean = true ;
		
		/**
		 * 覆盖通过成员访问运算符对某个成员赋值，也就是“Map_bindable(obj)[成员名称]=键值”。
		 * override the property access operator.("[]").
		 * Any Sting will be translated to a QName by AVM .
		 */
		flash_proxy override function setProperty( name:*, value:* ):void
		{ 
			/**类型的键会在运行时强制转换成QName之后再传入。*/
			
			var vOld:Object 
			if( mapProp[ name ] !== undefined )
				vOld = mapProp[ name ] ;
			else{
				if( autoSetPropBindable )
					mapNameBind[ name ] = true ;
			}
			mapProp[ name ] = value ;
			keyChanged = name ;
			if( mapNameBind[ name ] )
			{
				var e:EventUpdate 
				if( updateHandler_ is Function )
				{
					e = new EventUpdate( EventUpdate.TYPE, name ) ;
					e.target = this ;
					ed.dispatchEvent( e ) ;
					//updateHandler_( e ) ;
				}
				if( sendUpdate2_ )
				{
					e = new EventUpdate( String( name ), value, vOld ) ;
					e.target = this ;
					ed.dispatchEvent( e ) ;
					/*for each( var f:Function in mapNameBind[ name ] )
						f( e ) ;*/
				}
			}
		}
		
		flash_proxy override function getProperty( name:* ):*
		{
			var bIsString:Boolean = true ;
			if( name is String ){}
			else if( name is QName )
				name = QName( name ).localName ;
			else bIsString = false ;
			
			return mapProp[ name ] ;
		}
		
		flash_proxy function setPropertyBindable( name:Object, bindable:Boolean =true ):void
		{
			if( ! ( name is String ) )
			{
				throw new Error( KuilabERROR.mapBindStringOnly() ) ;
				return ;
			}
			if( bindable )
			{
				if( ! mapNameBind[ name ] )
				{
					var value:Object = mapProp[ name ] ;
					mapNameBind[ name ] = true ;
					var e:EventUpdate = new EventUpdate( Event.CHANGE, name ) ;
					e.target = this ;
					ed.dispatchEvent( e ) ;
					e = new EventUpdate( String( name ), value ) ;
					e.target = this ;
					e.oldValue = value ;
					ed.dispatchEvent( e ) ;
				}
			}else{
				if( mapNameBind[ name ] )
					delete mapNameBind[ name ] ;
			}
		}
		
		flash_proxy function bindProperty( name:Object, listener:Function, autoSetBindable:Boolean=false, priority:int=0 ):void
		{
			if( name is String )
			{
				if( mapNameBind[ name ] )
				{}else{
					if( autoSetBindable )
						mapNameBind[ name ] = true ;
					else return ;//不要自动设置可绑定且成员是不可绑定绑定的情况下就无效。
				}
				//( mapNameBind[ name ] as Array ).push( listener ) ;
				ed.addEventListener( String( name ), listener, false, priority, true ) ;
			}else
				throw new Error( KuilabERROR.mapBindStringOnly() ) ;
		}
		
		flash_proxy function removeBind( propertyName:String, listener:Function ):void
		{
			ed.removeEventListener( propertyName, listener ) ;
		}
		
		flash_proxy function get map():Object
		{
			return mapProp ;
		}

	}
}