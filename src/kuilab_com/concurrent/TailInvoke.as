package kuilab_com.concurrent
{
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	//%%搬到utils里面。应该重写用帧驱动而不是用时钟驱动。
	public class TailInvoke
	{
		public function TailInvoke()
		{
		}
		/** 如果要获取调用堆栈  **/
		public static function invoke( func:Function, args:Array, callBack:Function = null, catchErr:Function=null, getStackTrace:Boolean=false ):*{
			if( getStackTrace ){
				try{
					throw new Error( 'Trigger error for get stack.' ) ;
				}catch( e:Error ){
					var stackTrace:* = e.getStackTrace() ;
				}
			}
			
			var itvId:int ; 
			itvId = setTimeout( function():void{
				clearInterval( itvId ) ;
					try{
						var ret:Object = func.apply( null, args ) ;
						if( callBack is Function ){
							callBack( ret ) ;
						}else{
							//func.apply( null, args ) ;
						}
					}catch( err:Error ){
						if( catchErr is Function )//可以返回错误则返回。
							catchErr( err ) ;
					}
				if( getStackTrace ){//此处未做try。
					catchErr( stackTrace ) ;
				}
			}, 888 ) ;
		}
		
		protected var que:* = [] ;
		protected var itvId:int = -1 ;
		/****/
		public function invoke( func:Function, args:Array ):*{
			que.push( new InvokeNote( func, args ) ) ;
			if( itvId == -1 )
				itvId = setInterval( proc, 8 ) ;//也可以改成proc自己设置setTimeout，但是效率低点。
			function proc():void{
				var it:InvokeNote = que.shift() ;
				it.func.apply( null, it.args ) ;
				if( que.length == 0 ){
					clearInterval( itvId ) ;
					itvId = -1 ;
				}
			}
		}
		
	}
}
class InvokeNote{
	public var func:Function ;
	public var args:Array ;
	public function InvokeNote( func:Function, args:Array ){
		this.func = func ;
		this.args = args ;
	}
}