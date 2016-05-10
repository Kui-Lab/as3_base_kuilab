package kuilab_com.ui.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Util_UI
	{
		public function Util_UI()
		{
		}
		
		public static function getChildren( container:DisplayObjectContainer, objOrname:Boolean=false ):Array
		{
			var arr:Array =[] ;
			var n:uint = container.numChildren ;
			if( objOrname )
			{
				for( var i:uint=0; i<n; i++ )
					arr.push( container.getChildAt( i ) );
			}else{
				for( var i2:uint=0; i2<n; i2++ )
					arr.push( container.getChildAt( i2 ).name );
			}
			return arr ;
		}
		
		public static function getTree( container:DisplayObjectContainer ):Array
		{
			var arr:Array = proc( container ) ;
			function proc( c:DisplayObjectContainer ):Array
			{
				var vc:* = [] ;
				var n:uint = c.numChildren ;
				if( n == 0 )
					return vc ;
				for( var i:uint=0; i<n; i++ )
				{
					var d:DisplayObject = c.getChildAt( i ) ;
					var row:* = {'_name:':d.name, '_obj:':d } ;
					vc.push( row ) ;
					if( d is DisplayObjectContainer )
					{
						var vj:Array = proc( d as DisplayObjectContainer ) ;
						if( vj.length )
							row['junior'] = vj ;
					}
				}
				return vc ;
			}
			return arr ;
		}
		
		public static function getDisplayObjectPath( obj:DisplayObject, root:DisplayObjectContainer=null, seperator:String='/' ):String
		{
			return '' ;
		}
	}
}