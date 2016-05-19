package kuilab_com.util
{
	import flash.debugger.enterDebugger;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import kuilab_com.util.depend.ArgHelp_Util_object_descibeType;

	public class Util_object
	{
		
		//public static const STR_constructor:String = 'constructor' ;
		public static const STR_prototype:String = 'prototype' ;
		
		public static function getArgSetter():void
		{
			
		}
		/**如果给出的祖先类参数，只是与某个祖先或所实现接口同名（包路径也相同）的类，这种情况下是无法区分到底是不是真的继承那个类。<br/>
		 * 就必须拿is语句来判断了。**/
		public static function isInherit( claOrStrName:Object, ancestor:Object ):Boolean
		{
			if( claOrStrName is String )
				claOrStrName = getDefinitionByName( String( claOrStrName ) ) ;
			var ancName:String = getQualifiedClassName( ancestor ) ;
			var desc:XML = describeType( claOrStrName ) ;
			var fact:XML = Util_Xml.getChild( desc, 'factory' ) ;
			var ancestors:Array = Util_Xml.getChildren( fact, 'extendsClass' ) ;
			var impls:Array = Util_Xml.getChildren( fact, 'implementsInterface' ) ;
			for each( var anc:XML in ancestors.concat( impls ) ){
				if( Util_Xml.attEqual( anc, 'type', ancName ) )
					return true ;
			}
			return false ;
		}
		/**本来可以不用与isInherit分离的，但是怕自己忘了或者后来用的人不知道还有能一次检查是否扩展自多个超类的其中一个的功能，所以专门写多一个函数。**/
		public static function isInheritThem( claOrStrName:*, ancestors:Array ):Boolean
		{
			if( claOrStrName is String )
				claOrStrName = getDefinitionByName( String( claOrStrName ) ) ;
			for each( var ancestor:Class in ancestors ){
				if( isInherit( claOrStrName, ancestor ) )
					return true ;
			}
			return false ;
		}
		
		public static function getCstct( obj:Object ):Class
		{
			return obj['constructor'] as Class ;
		}
		
		public static function get newingFuncVec():Object{
			return vFuncBuild.concat() ;
		}
		
		public static function getShortName( obj:Object ):String
		{
			try{ //getQualifiedClassName对于类或实例返回的是相同的结果。
				var str:String = getQualifiedClassName( obj ) ;//
				return str.split( /[.(::)]/ ).pop() ;
			}catch( e:* ){
			}
			return null ;
		}
		
		/**
		 * 由给定的参数数列创建对象。
		 * ADOBE为什么不能让构造函数有apply?操。
		 * @param cla 类对象。
		 * @param args 构造函数参数。
		 * @param nullOrErr 假如报错，返回null还是返回错误。
		 */
		public static function newObjByArg( cla:Class, args:Array, nullOrErr:Boolean=true ):Object
		{
			if( args == null )
				args = [] ;
			try{
				return vFuncBuild[ args.length ]( cla, args ) ;
			}catch( err:Object ){
				if( nullOrErr )
					return null ;
				return err ;
			}
			return null ;
		}
		
		/**有时要取一个对象的孙子甚至更远的成员引用次数获取对象，比如“a.b.c.d……”会很啰嗦，所以写了这个。<br/>
		 * 用法：“getPropByPath( a, 'b.c.d' )”**///需要优化，getObjArr为true时没必要制造数组。%%
		public static function getPropByPath( obj:Object, names:*, spliter:String='.', notFoundValue:*=null, getObjArr:Boolean=false ):*
		{
			var nameArr:Array ;
			if( names is Array ){
				nameArr = names ;
			}else{
				nameArr = String( names ).split( spliter ) ;
			}
			var item:* = obj ;
			var ret:Array = [ item ] ;
			for each( var name:String in nameArr ){
				try{
					item = item[ name ] ;
					ret.push( item ) ;
				}catch( err:* ){
					ret.push( notFoundValue ) ;
					break ;
				}
			}
			if( getObjArr )
				return ret ;
			return ret.pop() ;
		}
		
		/**这个是getPropByPath加强版，允许路径中带有函数。但最后一项如果是函数不会执行它而是返回这个函数体。**/
		public static function getPropByPathF( obj:Object, names:*, spliter:String='.', notFoundValue:*=null, getObjArr:Boolean=false ):*
		{
			var nameArr:Array ;
			if( names is Array ){
				nameArr = names ;
			}else{
				nameArr = String( names ).split( spliter ) ;
			}
			var last:String = nameArr.pop() ;
			var item:* = obj ;
			var ret:Array = [ item ] ;
			for each( var name:String in nameArr ){
				try{
					if( item is Function )
						item = item() ;
					ret.push( item ) ;
					var c:* = item[ name ] ;
					item = c ;
				}catch( err:* ){
					return notFoundValue  ;
				}
			}
			ret.push( item[ last ] ) ;
			if( getObjArr )//最后一次没取到的话不会返回null，算是bug。
				return ret ;
			return ret.pop() ;
		}
		
		/*public static function getProp( obj:Object, args:ArgHelp_Util_object_descibeType ):Array{
			var xml:XML = flash.utils.describeType( obj ) ;
			enterDebugger() ;
			return [] ;
		}*/
		
		/**类的构造函数不能apply,傻逼ADOBE。**/
		protected static const vFuncBuild:Array = [
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
			}
		]
	}
}