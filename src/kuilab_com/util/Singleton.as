package kuilab_com.util
{
	import flash.utils.Dictionary;
	

	public class Singleton
	{
		//public static const NO_ARG:Object = new Object ;
		//public static const NULL_ARG:Object = new Object ;
		public function Singleton()
		{
		}
		
		protected static const mapInstance:Object = new Dictionary ;
		/**
		 * 目前实现这个类的理由就是：
		 * 需要单例的类可以不去写getInstance函数。
		 * @param cla
		 * @param constructArg 当构造函数参数需要
		 * @return 
		 */		
		public static function getInstance( cla:Class, constructArg:Array=null ):*
		{
			if( mapInstance[ cla ] )
				return mapInstance[ cla ] ;
			var it:Object ;
			switch( constructArg )
			{
				//case NO_ARG :
				case null :
					it = new( cla ) ;
					//if( ! mapInstance[ cla ] )
						//mapInstance[ cla ] = new( cla ) ;
					break ;
				default :
					it = Util_object.newObjByArg( cla, constructArg ) ;
					break ;
			}
			mapInstance[ cla ] = it ;
			return it ;//mapInstance[ cla ] ;
		}
		
		public static function setInstance( instance:Object, cla:Class=null ):Boolean
		{
			if( cla == null )
				cla = instance.constructor ;
			mapInstance[ cla ] = instance ;
			return true ;
		}
		
		public static function setToWeak():void
		{}
	}
}