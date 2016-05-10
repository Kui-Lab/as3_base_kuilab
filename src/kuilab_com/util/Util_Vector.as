package kuilab_com.util
{
	import kuilab_com.KuilabERROR;
	

	/**
	 * 给Vector和Array擦屁股。
	 * @author kui夔.
	 */
	public class Util_Vector
	{
		public static const AUTO_SET_FIX_alaway:uint = 0;
		public static const AUTO_SET_FIX_if
		
		public static function isVectorOrArray( obj:Object, isXMLList:Boolean=false ):Boolean
		{
			if( obj is Array )
				return true ;
			if( obj is Vector.<*> )
				return true ;
			if( isXMLList )
			if( obj is XMLList )
				return true ;
			return false ;
		}
		
		public static function isVector( obj:Object ):Boolean
		{
			return obj is Vector.<*> ;
		}
		
		public static function isEmpty( obj:* ):Boolean
		{
			if( obj == null )
				return true ;
			if( obj is Array )
				return ( obj as Array ).length == 0 ;
			if( obj is Vector.<*> )
				return obj.length == 0 ;
			throw new Error( KuilabERROR.argsIncorrect( 1 ) ) ;
		}
		
		public static function isNotEmpty( obj:* ):Boolean
		{
			if( obj is Array )
				return obj.length > 0 ;
			if( obj is Vector.<*> )
				return obj.length > 0 ;
			if( obj == null )
				return false ;
			throw new Error( KuilabERROR.argsIncorrect( 1 ) ) ;
		}
		
		public static function set autoSetFix( v:uint ):void{
			
		}
		protected static var autoSetFix_:uint
		
		public function Util_Vector( v:*=null )
		{
			this.v = v ;
		}
		
		public function set vct( v:* ):void
		{
			this.v = v ;
		}
		
		protected static var v:Vector.<Object> ;
		protected var v:Vector.<Object> ;
		
		public static function pop():*
		{
			return v.pop() ;
		}
		public function pop():*
		{
			return v.pop() ;
		}
		
		public static function push( v:*, some:* ):uint{
			return v.push( some ) ;
		}
		public function push( some:* ):uint{
			return v.push( some ) ;
		}
		
		
		public static function shift( v:* ):*
		{
			return v.shift() ;
		}
		public function shift():*
		{
			return v.shift() ;
		}
		
		public static function unshift( one:* ):uint{
			return v.unshift( one ) ;
		}
		public function unshift( v:*, one:* ):uint{
			return v.unshift( one ) ;
		}
		
		public static function last( v:* ):*
		{
			return v[ v.length-1 ] ;
		}
		public function last():*
		{
			return v[ v.length-1 ] ;
		}
		
		public static function splice( v:*, startIdx:int, deleteCount:uint, ...items ):*
		{
			return v.splice.apply( v, [ startIdx, deleteCount].concat( items ) ) 
		}
		public function splice( startIdx:int, deleteCount:uint, ...items ):*
		{
			return v.splice.apply( v, [startIdx, deleteCount].concat( items ) ) ;
		}
		
		public static function spliceArr( vct:*, startIdx:int, deleteCount:uint, arr:* ):*
		{
			return v.splice.call( v, startIdx, deleteCount, arr ) ;
		}
		public function spliceArr( startIdx:int, deleteCount:uint, arr:* ):*
		{
			return v.splice.call( v, startIdx, deleteCount, arr ) ;
		}
		
		public static function insert( v:*, pos:uint, ...items ):uint{
			v.splice.apply( v, [ pos, 0 ].concat( items ) ) ; 
			return v.length ;
		}
		public function insert( pos:uint, ...items ):uint{
			v.splice.apply( v, [ pos, 0 ].concat( items ) ) ; 
			return v.length ;
		}
		
		public static function compare( a:Array, b:Array ):Boolean
		{
			var l:uint = a.length ;
			if( l != b.length )
				return false ;
			for( var i:uint = l; i>=0; i-- ){
				if( a[i] == b[i] )
					continue ;
				return false ;
			}
			return true ;
		}
		
		public static function swapAt( array:*, idx1:int, idx2:int ):void
		{
			if( !isVectorOrArray( array ) )
				throw new Error( KuilabERROR.argsIncorrect(1) ) ;
			if( ! validateIndex( idx1, array.length ) )
				throw new Error( KuilabERROR.argsIncorrect(5) ) ;
			if( ! validateIndex( idx2, array.length ) )
				throw new Error( KuilabERROR.argsIncorrect(5) ) ;
			var t:* = array[ idx1 ] ;
			array[ idx1 ] = array[ idx2 ] ;
			array[ idx2 ] = array[ idx1 ] ;
			function validateIndex( idx:int, length:uint ):Boolean
			{
				if( idx<0 ){
					idx = length - idx ;
					if( idx < 0 )
						return false ;
					return true ;
				}else
					return idx < length ;
			}
		}
		
		public static function swap( array:*, item1:*, item2:* ):void
		{
			if( !isVectorOrArray( array ) )
				throw new Error( KuilabERROR.argsIncorrect(1) ) ;
			var idx1:int = array.indexOf( item1 ) ;
			var idx2:int = array.indexOf( item2 ) ;
			swapAt( array, idx1, idx2 ) ;
		}
		
		public static function remove( array:*, item:* ):int
		{
			var p:int = array.indexOf( item ) ;
			array.splice( p , 1 ) ;
			return p ;
		}
		/**
		 * @param index 负数从尾部开始数。
		 * @return 
		 */		
		public static function removeAt( list:*, index:int ):*
		{
			if( index > 0 ){
				//if( index > list.length ) //这种错他自己会抛
			}else{
				index = list.length -index ;
				if( index < 0 )
					throw new Error( KuilabERROR.argsIncorrect( 5 ) ) ;
			}
			return list.splice( index, 1 ) ;
		}
		
		public static function contains( list:*, item:* ):Boolean
		{
			return list.indexOf( item ) != -1 ;
		}
	}
}