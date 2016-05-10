package kuilab_com.util
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;

	public class Util_func
	{
		public function Util_func()
		{
		}
		
		/**由给定的参数和类（类实例与类名称） 
		 * 高可用性，效率低，如需高效请使用#vConstruction自己实现。  **/	
		public static function newObjByArg( cla:*, args:Array, applictionDomain:Object=null ):Object{
			var classObj:Class ;
			if( cla is Class ){
				classObj = cla as Class ;
			}else{
				if( applictionDomain == null ){
					classObj = ApplicationDomain.currentDomain.getDefinition( cla ) as Class ;
				}else{
					if( applictionDomain is ApplicationDomain ){
						classObj = applictionDomain.getDefinition( cla ) ;
					}else{
						classObj = applictionDomain[ cla ] ;
					}
				}
			}
			return vConstruction[ args.length ]( cla, args ) ;
		}
		
		public static function get NEW_objByArgs_arr():Array{
			return vConstruction.concat() ;
		}
		
		protected static const vConstruction:Array = [
			function( cla:Class, vArg:Array ):*
			{
				return new( cla ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0],vArg[1] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0],vArg[1],vArg[2] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{//5
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3],vArg[4] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3],vArg[4],vArg[5] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3],vArg[4],vArg[5],vArg[6] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3],vArg[4],vArg[5],vArg[6],vArg[7] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3],vArg[4],vArg[5],vArg[6],vArg[7],vArg[8] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{//10
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3],vArg[4],vArg[5],vArg[6],vArg[7],vArg[8],vArg[9],vArg[10] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3],vArg[4],vArg[5],vArg[6],vArg[7],vArg[8],vArg[9],vArg[10],vArg[11] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3],vArg[4],vArg[5],vArg[6],vArg[7],vArg[8],vArg[9],vArg[10],vArg[11],vArg[12] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3],vArg[4],vArg[5],vArg[6],vArg[7],vArg[8],vArg[9],vArg[10],vArg[11],vArg[12],vArg[13] ) ;
			},
			function( cla:Class, vArg:Array ):*
			{//15个参数最多了，再多我不管了。
				return new( cla )( vArg[0],vArg[1],vArg[2],vArg[3],vArg[4],vArg[5],vArg[6],vArg[7],vArg[8],vArg[9],vArg[10],vArg[11],vArg[12],vArg[13],vArg[14] ) ;
			} ] ;
		
	}
}