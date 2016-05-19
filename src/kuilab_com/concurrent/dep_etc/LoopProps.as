package kuilab_com.concurrent.dep_etc
{
	import kuilab_com.KuilabERROR;
	import kuilab_com.concurrent.DaemonLoop;
	import kuilab_com.concurrent.LOOPER_def;
	import kuilab_com.nameSpaceKuilab;
	import kuilab_com.util.Util_object;

	/**
	 * 如果在创建进程任务时，loopArgType参数设置为LOOP_ARG__all，则循环体函数会收到这个类的实例作为参数。
	 * 另外，作为参数传给onProg函数（即完成或出错的响应函数）的参数，收到的参数也是这个类的子类(LoopExecuteMessage)实例。
	 * 使用时可以自己扩展，在嵌套循环中传递更多对象。
	 */	
	public class LoopProps
	{
		public static function doNew( loop:DaemonLoop ):LoopProps
		{
			return new( impl )( loop ) ;
		}
		/**自己兼做工厂类，可以拿自己扩展的子类替换。**/
		public static function setImpl( implSubClass:Class ):void
		{
			if( Util_object.isInherit( implSubClass, LoopProps ) )
				impl = implSubClass ;
			else
				throw new Error( KuilabERROR.argsIncorrect( 1 ) ) ;
		}
		
		protected static var impl:Class = LoopProps ;
		
		public function LoopProps( loop:DaemonLoop )
		{
			this.loop_ = loop ;
		}
		
		protected var loop_:DaemonLoop
		/**封装循环体的LoopProps，因为是给sub提供的，所以称parent。**/
		protected var parent_:LoopProps ;
		protected var lockWrite:Boolean = true ;//改到循环体上？
	
		/**应该改一下，不计数循环就返回-1。*/
		public function get index():*{
			{
				use namespace nameSpaceKuilab ;
				if( loop_.loopType == LOOPER_def.TYPE__tabl )
					return loop_.keys[ loop_.idx ] ;
				return loop_.idx ;
			}
		}
		
		public function get item():*{
			{
				use namespace nameSpaceKuilab ;
				try{
					return loop_.dataSet[ loop_.idx ];
				}catch( err:* ){
					return null ;
				}
			}
		}
		
		public function get length():uint
		{{
				use namespace nameSpaceKuilab ;
				return loop_.len ;
		}}
		
		public function get dataSet():*
		{{
				use namespace nameSpaceKuilab ;
				return loop_.dataSet ;
		}}
		/**下级取上级遗留的变量。对于每个循环自己要操作的变量，自己都访问得到，所以没必要再写保存变量的东西。<br/>
		 * 一般都是因为上下级之间要传数据，顺便保存数据，所以需要一个对象。那么通信也就顺便用它了。<br/>
		 * LoopProps本身只保存循环体固有的相关变量，没有任意添加成员的功能（但使用者可以自己扩展添加或扩展为dynamic），thisObj更不行。propToSub最可用。**/
		public function getUpperValue( name:* ):*
		{
			{//那么其实这个方法应该改名叫getUpperProp、再写一个subProp？
				use namespace nameSpaceKuilab ;
				if( loop_.parent ){//因为thisObj不一定是那个表。又没有其它地方可以存东西。
					if( loop_.parent.propToSub )
						return loop_.propToSub[ name ] ;
					else
						throw new Error( 'higher loop doesn\'t cereat the data object to share any thing to the sub.\n 上级循环体没有创建为下级循环体传递数据的对象。' ) ;
				}
				return null ;
			}
		}
		/*
		 *默认情况是禁止写入，因为嵌套子级修改上级的变量有可能引发错误。请确认你写的程序代码不会引发错误，然后执行unlockWrite()方法。 
		 *	
		public function setProp( name:*, value:* ):*
		{
			if( lockWrite )
				throw new Error( KuilabERROR.seeDocs() ) ;
			{
				use namespace nameSpaceKuilab ;
				loop_.propToSub[ name, value ] ; 
			}
		}
		
		public function unlockWrite():void
		{
			lockWrite = false ;
		}*/
		
		/**
		 * 上级的相关上下文，如果没有上级则返回null。</br>
		 * 或者通过其它方式通信。
		 */		
		public function get parent():LoopProps
		{
			if( parent_ )
				return parent_ ;
			{
				use namespace nameSpaceKuilab ;
				if( loop_.parent == null )
					return null ;
				parent_ = new impl( loop_.parent ) ;
				return parent_ ;
			}
		}
		
		public function get thisObj():*{{
			use namespace nameSpaceKuilab ;
			return loop_.thisObj ;
		}}
		
		/**如果执行的函数耗时较长，可以用这个方法检查AVM是否已经开始渲染下一帧，来决定是不是要终止过程。<br/>
		 * 这个方法主要是供开发中检测性能的，如果真的在因为进入下一帧而终止，通常会致使之前的逻辑作废，意味着性能的虚耗，是不良设计。<br/>
		 * 另外因为不同的设备性能不同，所以设计程序时应当尽量把循环体过程切细，让每次循环尽量简短，即将循环尽量拆分成较多的嵌套循环。<br/>
		 * **/
		public function checkBreak():Boolean
		{
			{
				use namespace nameSpaceKuilab ;
				return DaemonLoop.breakFr ;
			}
		}
		
		public function get loopBody():DaemonLoop
		{
			return loop_ ;
		}
	}
}