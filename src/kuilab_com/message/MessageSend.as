package kuilab_com.message
{
	import __AS3__.vec.Vector;
	
	import flash.utils.Dictionary;
	/**
	 * 废弃。
	 */	
	public class MessageSend implements IMessageSend
	{
		public function MessageSend(  )
		{
		}
		
		protected var mapFunc:Dictionary = new Dictionary( true ) ;
		protected var mapIndOnce:Dictionary = new Dictionary( true ) ;
		protected var enableOnce:Boolean ;
		//protected var vFunc:Vector.<Function> = new Vector.<Function> ;
		//protected var vIndOnce:Array = [] ;

		public function send( message:Message ):void
		{
			//var type:String = message.type ;
			var vFun:Vector.<Function> = mapFunc[ message.type] ;
				//for each( var f:Function in vFun )
				//var l:uint = vFun.length ;
				try{
					var i:uint = 0 ;
					vFun[i++]( message ) ;
				}catch( e:* ){}
				/*for( var i:uint=0; i< l; i++ )
				{
					vFun[i]( message ) ;
				}*/
			//var vIndOnce:Array = mapIndOnce[ type ] ;
			//while( vIndOnce.length )
			//	vFun.splice( vIndOnce.pop(), 1 ) ;
		}
		
		public function listenerAdd( type:String, listener:Function, priority:uint=0, once:Boolean=false ):void
		{
			var indOnce:uint;
			var vFunc:Vector.<Function> = mapFunc[ type ] ;
			if( vFunc != null )
				vFunc.fixed = false ;
			else{
				vFunc = new Vector.<Function>
				mapFunc[ type ] = vFunc ;
				mapIndOnce[ type ] = [] ;
			}
			var vIndOnce:Array = mapIndOnce[ type ] ;
			if( priority == 0 )
			{
				vFunc.push( listener ) ;
				if( once ) vIndOnce.push( vFunc.length-1 ) ;
			}
			else{	// 0, 2, 4
				if( priority >= vFunc.length )
				{
					vFunc.unshift( listener ) ;
					for( var i:uint=0; i<vIndOnce.length; i++ )
					{//让被向后挤的函数的索引都+1。
						vIndOnce[ i ] ++ ;
					}
					if( once )
						vIndOnce.unshift( 0 ) ;
				}else{
					vFunc.splice( vFunc.length - priority, 0, listener ) ;
					var i2:uint =0 ;//插入的函数索引在vIndOnce中的索引。
					if( once )
					{
						while( vIndOnce[ i2 ] < priority ) 
						{
							i2++ ;
						}
						vIndOnce.splice( i2, 0, priority ) ;
					}
					for( var ii:uint = i2+1; ii<vIndOnce.length; ii++ )
					{	//比插入的函数优先级更小的函数，在函数队列中的位置向后移动，所以在vIndOnce中表示它们的索引的也值要加大。
						vIndOnce[ ii ] ++ ;
					}
				}
			} 
			vFunc.fixed = true ;
		}
		
		public function listenerRem( type:String, listener:Function, once:Boolean=false ):void
		{
		}
		
		public function listenerCheck( listener:Function ):uint
		{
			return 0;
		}
		
	}
}