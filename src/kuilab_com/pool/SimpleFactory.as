package kuilab_com.pool
{
	import kuilab_com.IFactory;
	import kuilab_com.KuilabERROR;
	import kuilab_com.util.Util_object;
	
	public class SimpleFactory implements IFactory
	{
		protected var cla_:Class ;
		protected var constArg_:Array ;
		protected static var newingFuncVec:* ; 
		
		public function SimpleFactory()
		{
		}
		
		public function set classs( v:* ):void
		{
			cla_ = v ;
		}
		
		public function setDefaultConstructArg( v:Array, check:Boolean=false ):void
		{
			if( constArg_ == null )
			if( newingFuncVec == null )
				newingFuncVec = Util_object.newingFuncVec ; 
			constArg_ = v ;
		}
		
		public function getInstance():Object
		{
			if( constArg_ )
				return newingFuncVec[ constArg_.length ]( cla_, constArg_ ) ;
			return new( cla_ ) ;
		}
		
		public function getClass( interfacee:Object, path:Object, args:Object ):Object
		{
			throw new Error( KuilabERROR.methodDoesNotImplement() ) ;
			return null;
		}
	}
}