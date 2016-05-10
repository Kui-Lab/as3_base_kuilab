package kuilab_com.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import kuilab_com.ui.NoScaleSprite;

	public class Util_dspObj
	{
		public function Util_dspObj()
		{
		}
		
		public static function scaleWithW( obj:DisplayObject, width:uint ):Number
		{
			var ratio:Number = width / obj.width ;
				obj.width = width ;
				obj.height = Math.round( ratio * obj.height ) ;
			return ratio ;
		}
		/**一般直接设置scale就行了，这个是给
		 */		
		public static function scaleWithH( obj:DisplayObject, height:uint ):Number
		{
			var ratio:Number = height / obj.height ;
				obj.height = height ;
				obj.width = Math.round( ratio * obj.width ) ;
			return ratio ;
		}
		/**以长或宽之中最大的一个来进行等比缩放，以使长或宽达到这个参数值。**/
		public static function scaleWithTheDims( obj:DisplayObject, value:uint ):Number
		{
			var ratio:Number ;
			if( obj.width >= obj.height )
			{
				ratio = value / obj.width ; ;
				obj.height = Math.round( obj.height * ratio ) ;
			}else{
				ratio = value / obj.height;
				obj.width = Math.round( obj.width * ratio ) ;
			}
			return ratio ;
		}
		
		public static function getPathStr( obj:DisplayObject ):String 
		{
			var path:String = obj.name
			while( obj.parent ) 
			{
				obj = obj.parent
				path = ( obj.name ? obj.name+'/' : '' ).concat( path )
			}
			if( obj is Stage ) path = 'stage/' + path
			return path
		}
		
		public static function getPath( obj:DisplayObject ):Array 
		{
			var path:Array = [ ] ;
			while( obj != null ) 
			{
				path.push( obj ) ;
				obj = obj.parent ;
				//path = ( obj.name ? obj.name+'/' : '' ).concat( path )
			}
			//if( obj is Stage ) path = '[STAGE]/' + path
			return path
		}
		
		public static function getChildren( container:DisplayObjectContainer ):Array
		{
			var ret:Array = [] ;
			while( ret.length < container.numChildren )
				ret.push( container.getChildAt( ret.length ) )
			return ret ;
		}
		
		public static function copyLocation( src:DisplayObject, tar:DisplayObject ):void
		{
			tar.x = src.x ;
			tar.y = src.y ;
		}
		
		public static function clearAndAdd( contaienr:DisplayObjectContainer, child:DisplayObject ):*
		{
			var ret:Array = [] ;
			var n:uint = contaienr.numChildren -1 ;
			while( n-- != 0 ){
				contaienr.removeChildAt( n ) ;
			}
			contaienr.addChild( child ) ;
		}
		/**可以自己扩展NoScaleSprite的子类。*/		
		public static function newNoScaleSprite( color:uint, alpha:Number, width:uint=100, height:uint=100, cla:Class = null ):Sprite
		{
			if( cla == null )
				cla = NoScaleSprite ;
			width = Math.max( 1, width ) ;
			height = Math.max( 1, height ) ;
			var ret:NoScaleSprite = new cla( ) ;
				ret.width = width ;
				ret.height = height ;
				ret.fillColor = color ;
				ret.fillAlpha = alpha ;
			return ret ;
		}
	}
}