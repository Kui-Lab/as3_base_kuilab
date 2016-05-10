package kuilab_com.util
{
	import flash.debugger.enterDebugger;
	import flash.utils.Dictionary;
	
	public class Util_String
	{
		public function Util_String()
		{
		}
		
		public static const CODE_aLow:uint = 'a'.charCodeAt( 0 ) ;
		public static const CODE_zLow:uint = 'z'.charCodeAt( 0 ) ;
		public static const CODE_Aupp:uint = 'A'.charCodeAt( 0 ) ;
		public static const CODE_Zupp:uint = 'Z'.charCodeAt( 0 ) ;
		
		public static function isEmptyStrOrNull( str:String ):Boolean{
			return str == null || str == '' ;
		}
		
		public static function isNotEmptyOrNull( str:String ):Boolean{
			if( str == null )	return false ;
			if( str == '' )		return false ;
			return true ;
		}
		
		public static function parseBoolean( str:String ):Boolean
		{
			switch( str )
			{
				case 'undefined' :
				case 'null' :
				case '0' :
				case '' :
				case 'false' :
					return false ;
				//case 'true' :
				//case '1' :
				default :
					//return true ;
			}
			return true ;
		}
		
		public static function substrByLimint( str:String, maxLength:uint, apostrophe:String = '...' ):String{
			if( str.length > maxLength ){
				str = str.substr( 0, maxLength ) ;
				if( apostrophe is String )
					str = str.concat( apostrophe ) ;
			}
			return str ;
		}
		
		public static function replaceAll( str:String, pattern:Object, replace:Object ):String
		{
			str.split( pattern ).join( replace ) ;
			return str ;
		}
		
		public static function isUpperCase( str:String ):Boolean
		{
			if( str.length < 1000 )
				return( str.toUpperCase() == str ) ;
			var i:uint = 0 ;
			while( i < str.length ){
				var c:uint = str.charCodeAt( i ) ;
				if( CODE_Aupp <= c )
				if( CODE_Zupp >= c )
				{
					i++ ;
					continue ;
				}
				return false ;
			}
			return true ;
		}
		
		/** 用/[a-z]/匹配也许更快。 **/
		public static function isLowerCase( str:String ):Boolean
		{	
			if( str.length < 1000 )
				return( str.toLowerCase() == str ) ;
			var i:uint = 0 ;
			while( i < str.length ){
				var c:uint = str.charCodeAt( i ) ;
				if( CODE_aLow <= c )
				if( CODE_zLow >= c ){
					i++ ;
					continue ;
				}
				return false ;
			}
			return true ;
		}

		/**
		 * 字符转换为数字。
		 * @param str 
		 * @param radix
		 * @param array 以字母为单位分解为数组，false则返回一个字符串。
		 * @return 
		 */
		public static function toNumStr( str:String, radix:Object=16, array:Boolean=false ):*
		{
			if( ! array ){
				var retStr:String = '' ;
				for ( var i:int = 0; i < str.length; i++ ) 
				{
					retStr += str.charCodeAt( i ).toString( radix ) ;
				}
				return retStr
			} 
			var retArr:Array = [] ;
			for ( i = 0; i < str.length; i++ ) 
			{
				retArr.push( str.charCodeAt( i ).toString( radix ) ) ;
			}
			return retArr ;
		}
		
		public static function equalIgnoreCase( a:String, b:String ):Boolean
		{
			return a.toUpperCase() == b.toUpperCase() ;
		}
		
		public static function getAllMatch( str:String, reg:RegExp, nullIfNone:Boolean=false ):Array
		{
			var ret:Array = [] ;
			if( reg.global ){}
			else{ 
				var opt:String = 'g' ;
				if( reg.ignoreCase ) opt += 'i' ;
				if( reg.dotall ) opt += 's' ;
				if( reg.multiline ) opt += 'm' ;
				if( reg.extended ) opt += 'x' ;
				reg = new RegExp( reg.source, 'g' ) ;
			}
			while( true ){
				var every:* = reg.exec( str ) ;
				if( every == null )
					break ;
				delete every['input'] ;
				ret.push( every );
			}
			if( ret.length == 0 )
			if( nullIfNone )
				return null ;
			return ret ;
		}
		
		public static function parseArr( str:String, parseBaseType:Boolean= false, spliter:String=',' ):Array
		{
			const regDec:RegExp =  /([+-]?^\d+(\.\d+)?$)|([+-]?\.\d+)/ ;
			const regDee:RegExp = /^[+-]?\d+(e\d+)?$/ ;
			const regHex:RegExp = /^0x([A-F]|[a-f]|\d)+$/i ;
			const regStr:RegExp = /[A-z]+/ ;
			const regQtt:RegExp = /[^\\]['"]/ ;
			var ret:Array = [] ;
			var procA:Array = str.split( spliter ) ;
			var joinQ$:Array = [] ; //将被引号包含的分隔符两边项目合并，还原真实。
			var cntCharI:uint = 0 ;
			
			if( parseBaseType )
			{
				ret = procA.map( function( estr:String, idx:uint, arr:Array ):*{
				if( estr == 'true' )
					return true ;
				if( estr == 'false' )
					return false ;
				if( regDec.test( estr ) )//
				{
					if( '.'.indexOf( estr ) == -1 )
						return parseInt( estr ) 
					else
						return parseFloat( estr )
				}
				if( regHex.test( estr ) )//HEX。
					return parseInt( estr.substr( 2 ), 16 ) ;
				if( regDee.test( estr ) )//指数形式。
					return parseFloat( estr ) ;
				return estr ;
				} ) ;
			}
			
			/*switch( "mths.length" )
			{
				case 0 :
					break ;
				case 1 :
					ret[ 'soloQuot' ] = mths[0].index ;
					break ;
				case 2 :
					break ;
			}*/
			
			/*procA = procA.map( function( estr:String, idx:uint, arr:Array ):*{
				if( estr == 'true' )
					return true ;
				if( estr == 'false' )
					return false ;
				if( regDec.test( estr ) )
				{
					if( '.'.indexOf( estr ) == -1 )
						return parseInt( estr ) 
					else
						return parseFloat( estr )
				}
				if( regHex.test( estr ) )
					return parseInt( estr.substr( 2 ) ) ;
				if( regDee.test( estr ) )
					return parseInt( estr ) ;
				return estr ;
			} ) ;*/
			
			return ret ; 
				
			function rejoinQt( arr:Array ):Array
			{
				const regQtt:RegExp = /[^\\]['"]/ ;
				var mthQt:Array = getAllMatch( str, regQtt ) ;
				var	curq:String ;
					curq = mthQt[0][0] ;
				var	qStart:uint = uint.MAX_VALUE ;
					qStart = mthQt[0].index ;
				var joinTmp:String = null ;
				var ret:Array = [] ;
				for each( var estr:String in procA )
				{
					/*if( mths.length > 0 ){
					var tr:Array = [] ;
					for each( var qe:* in t ){
					curq = qe[0] ;
					qe.index = 
					}
					}*/
					var curStrE:uint = cntCharI + estr.length;
					//if( joinTmp )//引号未闭合。
					if( qStart <= curStrE )//当前串有引号。
					{
						if( curStrE )
						{//分隔符没有被引号包含
							ret.push( estr ) ;
						}else{//分隔符被引号包含。
							joinTmp = joinTmp.concat( estr ) ;//增加当前项到引号字符串。
							joinTmp = null ;
							ret.push( joinTmp ) ;
						}
					}/*else if( qStart == curStrE ){//最后一个字符是引号。
					}*/else{//当前串无引号。
						if( joinTmp )//引号未闭合。
						{
							joinTmp = joinTmp.concat( estr ) ;
						}
					}
					
					var qs:String  
					var qp1:int = estr.indexOf( qs )  ;
					if( qp1 != -1 ){
						
						var qp2:int = estr.indexOf( qs, qp1+1 ) ;
						if( qp2 != -1 ){
							
						}
					}
					if( '' ){}
					
					cntCharI += estr.length ;
				}
				return null ;
			}
			
			/*function nexQt():*{
				curq = mths[0][0] ;
				qStart = mths[0].index ;
				mths.shift()
			}*/
		}
		
		/**
		 * 以引号对拆分字符串。前面有“\”的不算引号。
		 * @param str
		 * @return 
		 */		
		public static function parseQuot( str:String ):Array
		{	//"\"
			const MISS:uint = uint.MAX_VALUE ;
			const REGQA:RegExp = /[^\\]['"]/g ;//匹配两种引号。
			const REGQS:RegExp = /[^\\]'/g ;//匹配单引号。
			const REGQD:RegExp = /[^\\]"/g ;//匹配双引号。
			const SQS:String = "'" ;
			const DQS:String = '"' ;
			const mapReg:Object = function():*{	var d:* = new Dictionary ;
 											d[ '"' ] = REGQD ;
											d[ "'" ] = REGQS ;
											return d } () ;
				
			var regCur:RegExp 
			var iqp:uint
			var qCur:String ; //单引号或者双引号。
			var curPair:Array = [] ;
			var ret:Array ;
			/*toNext() ;
			if( iqp = uint.MAX_VALUE )
			{
				return null ;
			}*/
			while( true ){
				//var pEnd:int
				
				toNext( regCur, iqp+1 ) ;
				//寻找下一个开始。
				if( iqp==MISS )//找不到开始
					return ret ;
				curPair = [ iqp ] ;
				//寻找完结。
				regCur = mapReg[ qCur ] ;
				toNext( regCur, iqp+1 ) ;
				if( iqp==MISS )
					return ret ;
				curPair.push( iqp ) ;
				regCur = REGQA ;
			}
			return ret ;
			
			function toNext( p:RegExp, start:uint ):*
			{
				//iqp = str.indexOf( regQtt, iqp ) ;
				p.lastIndex = start ;
				var exOne:Array = p.exec( str ) ;
				if( exOne == null ){
					iqp = uint( -1 ) ;
					return
				}
				qCur = exOne[0] ;
				iqp = uint( exOne.index );
				return exOne ;
			}
		}
	}
}