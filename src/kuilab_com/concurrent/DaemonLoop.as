package kuilab_com.concurrent
{
	import flash.debugger.enterDebugger;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import kuilab_com.KuilabERROR;
	import kuilab_com.concurrent.dep_etc.LoopDataSet;
	import kuilab_com.concurrent.dep_etc.LoopExeuteMessage;
	import kuilab_com.concurrent.dep_etc.LoopProps;
	import kuilab_com.lang.Pair;
	import kuilab_com.nameSpaceKuilab;
	import kuilab_com.util.Util_Vector;
	import kuilab_com.util.Util_object;

	/**
	 * <pre>在帧渲染的间隙进行计算。实现后台并行的进程。
	 * 执行的形式是循环执行给出的函数体，并且可以给出数据、索引进行操作，
	 * 基础for循环、for each遍历（枚举，包括对键或值的）、无限循环都可以。
	 * Adobe官方的线程就是在一个虚拟机里面同时跑两个swf，要通信还要setAlias(),
	 * 而且线程代码要多编译一次，太烂了(或者自己加载自己，太stupid、freak)。
	 * 
	 * 额外的特性：
	 * 可添加下级循环体以模拟嵌套循环。
	 * 
	 * 上下级循环之间的通信方式：
	 * 1.使用专用的propToSub对象，方法是loogArgType参数设置为LOOP_ARG__all（在常量定义类）。
	 * 2.使用“this”对象继承，如果不喜欢或不能使用第一种方式那么使用这种。要求的条件是下级被循环函数是嵌套或匿名函数，它创建时的thisObj参数设置为THIS_parent。
	 * 3.在可能的任意作用域内共享，比如上下级循环函数体所在的同一个函数、某静态类上的变量等等。
	 * 
	 * 还未实现：暂停的任务重新启动。
	 * 
	 * 写成两个类比较容易弄懂，但是觉得没有必要再花时间拆了，反正api（public方法）也没超过十个。
	 * </pre>
	 */
	use namespace nameSpaceKuilab ;
	public class DaemonLoop 
	{
		//public static const DEFS_:Looper 
			
		/**查询所有的实例，一般用不到。**/
		public static function getInstances():Array
		{
			var ret:Array = [] ;
			/*for each( var a:DaemonLoop in instanceMap )
				ret.push( a ) ;*/
			return instanceQue.concat() ;
		}
		
		/**
		 * 不想使用公用的可以自己扩展。但是理论上还是要与实际的进-出帧时间相符合。**/
		public static function set frameDispatcher( v:IEventDispatcher ):void
		{
			if( listening )
				pause() ;
			frameDispatcher_ = v ;
			if( listening )
				start() ;
		}
		
		protected static var frameDispatcher_:IEventDispatcher = new Sprite ;
		
		//protected static const instanceMap:* = new Dictionary( true ) ;
		protected static const instanceQue:Array = [] ;
		
		kuilab::dbg private var dbgNxtFr:Boolean = false ;
		
		
		public function DaemonLoop( denyNewing:DenyNewing )
		{
			super() ;
			if( denyNewing == null )
				throw new Error( 'can not cerate instance by contructor, use static method. 禁止直接创建实例，请使用静态方法。' ) ;
			init() ;
		}
		
		protected function init():void
		{
			//instanceMap[this] = this ;
		}
		/**start(),stop()使用这个变量**/
		protected static var listening:Boolean = false ;
		protected static var curExing:DaemonLoop ;
		
		kuilab::dbg public var name:* ;
		
		nameSpaceKuilab var dataSet:* ;//
		protected var func:Function ;
		//protected var countToStop:*
		nameSpaceKuilab var parent:DaemonLoop ;
		protected var subLoop:DaemonLoop ;
		//protected var subs:Array = [] ;
		/**因为替换了sub的onProg_，所以要保存起来。但有必要？**/
		protected var subProg:Function ;
		
		protected var onProg_:Function ;
		
		protected var stat:* = LOOPER_def.STAT_WAIT ;
		/**当前由哪个函数来具体执行。触发的时机：1.startStack 2.onSubProg(下级执行完，自己执行一次)**/
		protected var exe:Function ;
		protected var resetF:Function
		//protected var loopArg:* ;
		nameSpaceKuilab var loopType:* ;
		protected var loopArgType:* ;
		nameSpaceKuilab var idx:uint = 0 ;//
		nameSpaceKuilab var len:uint = 0 ;//其实也可以不用len，需要的时候拿lastIdx+1就是了.
		/**经常写len-1既令人烦，又有效率损耗，所以保存下来。**/
		protected var lastI:uint
		nameSpaceKuilab var thisObj:* = null ;
		nameSpaceKuilab var keys:Array ;
		protected var loopProps:LoopProps ;
		/**上下级之间传递数据用。目前实际给当前循环函数做this。**/
		nameSpaceKuilab var propToSub:* //= new Dictionary() ;
		/**作为子级的循环，自己的数据集，或者如何创建自己数据集对象的方式。**/
		protected var dataOrInheritWhat:* ;
		
		nameSpaceKuilab static var breakFr:Boolean = false ;
		
		static protected var clkId:int = -1 ;
		
		/**设置一个循环体。
		 * @param func 用来做循环体的函数，即每次循环执行它。
		 * @param dataSet 要处理的数据集合，可遍历。如果输入的是一个正整数，则把它作为循环的次数。
		 * @param onProg 发生错误、暂停（暂停再继续）、结束时由这个函数接收通知。
		 * @param loopArgType 定义常量的类目前叫做LOOPER_def。他们各自的的值就是说明。<br/>
		 * LOOP_ARG_index：序号（uint）或者键<br/>
		 * LOOP_ARG_item：每一项的值<br/>
		 * LOOP_ARG_count：序号（uint）<br/>
		 * LOOP_ARG_none：空无，循环体函数被执行时不会有任何参数。<br/>
		 * LOOP_ARG_data：数据集，即添加任务时的第二个参数。<br/>
		 * LOOP_ARG__all：所有相关的量，用LoopProps封装在一起。<br/>
		 * @param thisObj 方便嵌套的上下级循环之间传递数据，所以循环体函数执行时用传递数据的对象来替换它的“this”。<br/>
		 * 使用这个要求执行循环的函数必须是匿名或嵌套函数，因为类成员函数是无法改变它的this对象的。<br/>
		 * 除了可以使用任意对象作this，还可以使用几个特殊的参数值。<br/>
		 * 他们作为常量定义定义在另个类上了，目前叫做LOOPER_def。如果被循环函数参数不设置为LOOP_ARG__all，那么这就是其次的嵌套循环上下级间通信方式。<br/>
		 * THIS_setFunc：使用DaemonLoop/setProp，如果要保存数据给下级循环使用，那么就“this( 变量名, 变量值对象 )”<br/>
		 * THIS_propObj：使用传递数据的对象本身，现在叫做propToSub，用法如普通的dynamic Object或者Dictionary。<br/>
		 * THIS_loopObj: 使用循环体（DaemonLoop的实例）本身做this。<br/>
		 * THIS__global：嵌套、匿名函数默认的this是avm的global对象。<br/>
		 * @param priority 插队用，还未实现
		 * @return 
		 * @see kuilab_com.concurrent.LOOPER_def
		 */
		public static function addTask( func:Function, dataSet:*, onProg:Function, 
									loopArgType:* = null, thisObj:*=null, priority:uint=0 ):DaemonLoop{
			var ins:DaemonLoop = new DaemonLoop( DenyNewing.INSTANCE ) ;
			ins.func = func ;
			{ use namespace nameSpaceKuilab ;
			ins.dataSet = dataSet };
			ins.onProg_ = onProg ;
			ins.setThisToFunc( thisObj ) ;
			/*if( parent )//这里没有做检查是否已经有sub。
				parent.setSub( ins ) ;*/
			ins.setLoopArgType( loopArgType ) ;
			ins.chkLoopType() ;
			instanceQue.push( ins ) ;
			if( isRunning() ){//这个似乎是多余的。静态帧函数会每帧自动开始。
				if( curExing == null )
					curExing = ins ;
			}else{}
				//DaemonLoop.start() ;
			return ins ;
		}
		
		/*public function reset__uu():void
		{
			stat = Looper.STAT_WAIT ;
			chkLoopType() ;
			idx = 0 ;
		}*/
		/**如果start不能满足，再来写这个方法。每一帧只会调用一个实例的此方法。**/
		protected static function resumeFromFrame():void{
		}
		
		public static function start():void
		{
			if( isRunning() )
				return ;
			if( ! listening ){//未侦听//与上面isRunning重复的判断，可以去掉的。
				frameDispatcher_.addEventListener( Event.ENTER_FRAME, ENTER_FR_func ) ;//移到start（）里面
				frameDispatcher_.addEventListener( Event.EXIT_FRAME, EXITT_FR_func ) ;
				listening = true ;
			}
			{ use namespace nameSpaceKuilab ;
				breakFr = false } ;
			if( instanceQue.length > 0  ){
				if( curExing == null ){//怎样会出现这种情况？
					curExing = instanceQue[0] ;
				}
				curExing.startStack() ;
			}else{
				//stop() ;//不要执行停止因为可能有一个在执行。
			}
		}
		/**startStack()**/
		protected function start():void
		{
			startStack() ;
		}
		
		protected function startStack():void//不应叫做startStack，而是startCur。
		{
			if( getRoot( this ) == this )
			{}
			kuilab::dbg{ 
				/*{ use namespace nameSpaceKuilab ;
					if( breakFr )
						trace( '渲染超时；cpu超负荷1' ) ;
				}*/
				if( dbgNxtFr ){
				trace( 'start():dbgNxtFr!' ) ;//enterDebugger() ;
				dbgNxtFr = false ;
			} } ;
			
			/*var isResume:Boolean
			if( isResume ){//自己不执行，直接从子级中断的地方执行。
				'每帧的中断与手动的暂停有何区别？'
			}*/
			if( curExing == this ){	;//curExing平时应该是sub，只有当sub完成时，才是子级
				stat = LOOPER_def.STAT_EXE_SELF ;//这里总是这个状态，是不会在需要的时候重置的。
				exe( ) ;
			}
			
			//if( subLoop ){
				/**要不要自己先执行，实质问题是下级循环在上级循环代码相对顺序位置问题。
				不实现afterSub特性，就只能在之前和之后选择。即使上级先运行一次，也难以解决当前索引与项目问题。
				 要么在开始前手动处理（执行上级的部分内容），这样满足下级执行所需的条件。
				 *执行一次上级，然后reset、执行下级：怪异
				 *克隆副本？每次循环都要克隆。效率太低。
				 *索引初始置-1？执行的次数会多1次，且要求idx++在开头
				 *加参数控制索引步进的时机。
				 *把索引步进放在onSubProg里面执行？
				 *子级循环完成时（onSubProg）执行索引步进，一般编程语言本身也是在循环完成后步进索引的，即使for()里面把i++写成++i
				 * **/
				
				/*if( altSq$ ){//默认是不执行自己直接执行下级的，这样是先执行自己。
					stat = LOOPER_def.STAT_EXE_SELF ;/**但是注意这样在子级循环时，上级索引已经到了第二个了，所以不是完备的设计。
					exe() ;// clearInterval( clkId )//立即清除定时，这样阻止连续运行。
				}*/
				
				/*if( stat == LOOPER_def.STAT_WAIT ){
					stat = LOOPER_def.STAT_EXE_SELF ;
					runOnceLoop() ;//这样没有停顿的连续运行上下级各一次会导致画面卡。
					//idx -- ;
					下级如果插入上级执行，那么会导致时空分支。
				}*/
				///stat = LOOPER_def.STAT_EXE__SUB ;
				//if( Util_Vector.contains( [ LOOPER_def.STAT_WAIT,LOOPER_def.STAT_OVER ], subLoop.stat ) ) //'下级需要重置' )//onSubProg中执行的话，第一次就执行不到。
					//subLoop.reset( true ) ;//改用惰性实现？
				///subLoop.startStack() ;//要不要改为断尾调用？
			//}else{
				/**重置一个sub应该在何时进行？在onSubProg或finish或者使用标记->下一帧重置。
				也许是否需要重置不应与stat共用同个变量？	
				super-oneLoop-resetSub
				下级重置一般是上级一次循环中调用。所以上级每次执行都是只执行一次然后交给下级等待反馈。
				目前的实现是下级完成时在onSubProg立即重置，**/
							/*if( parent ){////这里还未改变stat，所以会进入，导致每帧都执行（重置等……）
								if( [ LOOPER_def.STAT_WAIT,LOOPER_def.STAT_OVER ].indexOf( stat ) != -1 ){
									reset( true ) ;
								}//考虑把这整段移进reset()里面。
							}*/
		}
		//public var altSq$:Boolean = false ;
		
			protected static const VALUE_notFound:* = new Pair( 'value not found. 未找到值。' ) ;
		
		public static function pause():void//不写stop，停止和暂停都用同个。
		{	//没有修改stat状态。
			if( ! isRunning() )
				return ;
			frameDispatcher_.removeEventListener( Event.ENTER_FRAME, ENTER_FR_func ) ;//移到start（）里面
			frameDispatcher_.removeEventListener( Event.EXIT_FRAME, EXITT_FR_func ) ;
			listening = false ;{ use namespace nameSpaceKuilab ;
			breakFr = true ;}//?
			/*if( curExing )
				curExing.pause( false ) ;*/
		}
		/**没有想到有停止当前一个且执行之后的需求，所以不实现这个方法。**/
		protected function pauseCurAndNext__dp():void{}
		//从区分全部停止和单个停止来入手。
		/**只停止它自己（包括所有子级与上级），之后的一个顶级会执行。</br>如果要全部停止，请使用静态的pause()方法。**/
		public function pauseStack( startAtIdle:Boolean=false ):Boolean
		{
			if( getRoot( curExing ) != getRoot() )
				{ return false ;}//自己所在链/栈并不是在执行的。
			if( parent == null ){
				cancelAndClearTimeout() ;//可以不执行？ 
				pauseStackProc( !startAtIdle ) ;
				startNext( this, false ) ;//一个栈只执行一次
				return true ;
			}else{
				return getRoot(this).pauseStack() ;
			}
		}
			protected function pauseStackProc( stop:Boolean=false ):*{
				try{
					onProg_( new LoopExeuteMessage( this, stop ? LOOPER_def.STAT_STOP : LOOPER_def.STAT_PAUS  ) ) ;
				}catch( err:* ){}
				if( stop )
					stat = LOOPER_def.STAT_STOP ;
				else
					stat = LOOPER_def.STAT_PAUS ;
				if( subLoop )
					subLoop.pauseStackProc() ;
			}
		
		/**现在还未实现插队立即执行。另写一个方法还是加个参数实现？？？？？？？？？？？？？？？？？？？？？？**/
		protected function resumeStack( ):*
		{
			resumeProc( getRoot( this ) ) ;
			
			function resumeProc( loop:DaemonLoop ):*{
				loop.stat = LOOPER_def.STAT_PAUS ;
				if( loop.subLoop )
					resumeProc( loop.subLoop ) ;
			}
			
		}
		
		/*执行这个方法并不会立即开始，而是要排队到之前的任务执行完再继续。**/
		/*protected static function resume( loop:DaemonLoop, jumpPrior:* ):void
		{
			var idx:int = instanceQue.indexOf( loop ) ;
			if( idx == -1 )
				throw new Error( '逻辑未实现' ) ;
		}*/
		/*如果start不能满足，再来写这个方法。
		public function resume( ):void
		{
			if( getRoot( this ) == this ){
			}else{
			}
		}*/
		
		/**实例执行完毕时调用。abort并不会使整个线程停下，之后的任务会开始执行。**/
		protected function finish( abort:Boolean=false ):void//可以再加一个参数，以实现return
		{
			stat = LOOPER_def.STAT_OVER ;
			var msg:LoopExeuteMessage =  new LoopExeuteMessage( this, abort? LOOPER_def.ABORT : LOOPER_def.FINISH ) ;
			try{
				onProg_( msg ) ;
			}catch( err1:* ){}
			if( parent == null )
			{	//instanceQue.splice( instanceQue.indexOf( this ), 1 ) ;
				startNext( this, true ) ;//如果不是顶级，就没有把curExing置空或修改。
			}else{
				parent.onSubProg( msg ) ;
			}
		}
		
		protected static function startNext( overd:DaemonLoop, remove:Boolean ):void
		{//隐式条件是当前正在执行。
			//var last:DaemonLoop = instanceQue.shift() ;
			/*if( instanceQue[0] == overd ) 
				instanceQue.shift() ;
			else{//结束的不是第一个。
				if( overd != null )//因为允许暂停一个执行下一个，所以不报错了。
					throw new Error( 'n4VNsyoz' ) ;
			}*/
			var idxOver:int =  instanceQue.indexOf( overd ) ;
			if( idxOver < 0 ){//也可能是一个非顶级的实例调用导致的。
				/*if( instanceQue.length == 0 )
					throw new Error( '' ) ;*/
				throw new Error( '只能对顶级的循环体使用这个方法。' ) ;
			}else if( idxOver==0 ){
				
			}else{ //>0
				
//如果有之前停下的或者加队的：
			}
			
			if( remove )
				Util_Vector.remove( instanceQue, overd ) -1 ;//移除了，之后的所有id向前移1。
			curExing = null ;
			
			for (var i:int = 0; i < instanceQue.length; i++ ) 
			{
				var ec:DaemonLoop = instanceQue[i] ;
				if( Util_Vector.contains( [ LOOPER_def.STAT_WAIT, LOOPER_def.STAT_PAUS ], ec.stat ) ){
					curExing = ec ;
					break ;
				}
			}
			/*else
				p = instanceQue.indexOf( overd ) ;*/
			/*if( instanceQue.length > 0 ){
				curExing = ( instanceQue[0] as DaemonLoop ) ;
				//curExing.startStack() ;下一帧即会执行这句。
			}else
				curExing = null ;*/
							
		}//end of startNext()
		
		
		/**无限循环，只能由外部操作停止。当返回参数类型设置为与数据索引无关的计数（器）。**/
		private function runCeaseless():void
		{
			clearTimeout( clkId ) ; clkId = -1 ;
			try{
				if( func.apply( thisObj, getLoopArg() ) == LOOPER_def.ISTT____break ){
					return void finish( false ) ;
				}//else //idx ++ ;
			}catch( err:* ){
				switch( err ){
					case LOOPER_def.ISTT_continue :
						breakFr = true ;//为了阻止下级执行。但是也阻止了自己在当前帧的继续执行。
						break ;
					case LOOPER_def.ISTT____break :
						return void finish( true ) ;
					default :
						if( onProg_( new LoopExeuteMessage( this, LOOPER_def.ISTT____error, err ) ) == LOOPER_def.ABORT )
							return void finish( true ) ;
				}
			}
			if( subLoop ){
				curExing = subLoop ;
				return ;
			}
			if( breakFr || subLoop )
			{}else
				clkId = setTimeout( runCeaseless, 1 ) ;
		}
		/**这个目前还没有使用。次数超过uint.MAX_VALUE时，会从0重新数起。！！！结束逻辑没有写。**/
		private function runCeaselessWithCount():void
		{
			clearTimeout( clkId ) ; clkId = -1 ;
			try{
				if( func.apply( thisObj, getLoopArg() ) == LOOPER_def.ISTT____break )
					return void finish( false ) ;
			}catch( err:* ){
				switch( err ){
					case LOOPER_def.ISTT_continue :
						breakFr = true ;//为了阻止下级的执行。
						break ;
					case LOOPER_def.ISTT____break :
						return void finish( true ) ;
					default :
						if( onProg_( new LoopExeuteMessage( this, LOOPER_def.ISTT____error, err ) ) == LOOPER_def.ABORT )
							return void finish( true ) ;
				}
			}
			if( subLoop ){//如有下级循环，需待下级循环执行才在onSubProg完成才步进。
				curExing = subLoop ;
				return ;
			}else
				idx ++ ;//如果移到函数开头，则从0开始执行的开始前要把序号设置为-1。
			if( breakFr || subLoop )
			{}else
				clkId = setTimeout( runCeaseless, 1 ) ;
		}
		
		private function runWithCountAmount():void
		{
			clearTimeout( clkId ) ; clkId = -1 ;
			var runSub:Boolean = Boolean( subLoop )
			if( idx < lastI ){
				try{
					func.apply( thisObj, getLoopArg() ) ;
				}catch( err:* ){
					switch( err ){
						case LOOPER_def.ISTT_continue ://还是return？
							runSub = false ;
							break ;
						case LOOPER_def.ISTT____break :
							return void finish( true ) ;
						default :
							var istt:* = onProg_( new LoopExeuteMessage( this, LOOPER_def.ISTT____error, err ) ) ;
							if( istt == LOOPER_def.ABORT ){
								//这里对curExing可能应该改变。
								return void finish( true ) ;
							}else///阻止下级的执行。
								runSub = false ;
							kuilab::dbg{
							if( istt == LOOPER_def.ISTT___repeat ){
								runSub = false ;
								idx -- ;//下面的idx++还会执行，和为0所以下一循环的idx不变.
							}
						}
							
					}
				}
				if( ! runSub )
					idx ++ ;
			}else{
				var last:Boolean = true ;
				runSub = false ;
			}
			if( ! breakFr ){
				if( runSub ){
					curExing = subLoop ;
					stat = LOOPER_def.STAT_EXE__SUB ;
					setTimeout( subLoop.exe , 1 )
				}else
					clkId = setTimeout( last ? runWithCountAmountLast : runWithCountAmount , 1 ) ;
			}else{
				kuilab::dbg{ dbgNxtFr = true ; }
			}
		}
			private function runWithCountAmountLast():void
			{
				clearTimeout( clkId ) ; clkId = -1 ;
				try{
					func.apply( thisObj, getLoopArg() ) ;
				}catch( err:* ){
					switch( err ){
						case LOOPER_def.ISTT_continue :
							finish( true ) ;
							break ;
						case LOOPER_def.ISTT____break :
							return void finish( true ) ;
						default :
							if( onProg_( new LoopExeuteMessage( this, LOOPER_def.ISTT____error, err ) ) == LOOPER_def.ABORT )
								return void finish( true ) ;
					}
				}
				if( subLoop != null ){//没有下级就执行完毕，有下级就开始下级的最后一组迭代。
					curExing = subLoop ;
					stat = LOOPER_def.STAT_EXE__SUB ;
				}else
					finish( false ) ;
			}
		
		private function runWithCountArray(  ):void
		{	//子级循环完结时，curExing没有清理，（但且它被重置了）所以下一帧又会开始执行。
			clearTimeout( clkId ) ; clkId = -1 ;//也可以和setTimeout写在一起，继续执行情况下还能省去clkId重置的语句。或者把=-1移动到setTimeout之前。
			var runSub:Boolean = Boolean( subLoop )
				
			if( idx < lastI ){
				try{
					func.apply( thisObj, getLoopArg() ) ;
					//如果要利用this传递数据，则要求func必须是嵌套，不论匿名或命名。
					//不用白不用，如果不指定this,那么函数中的this将会是global。
				}catch( err:* ){
					switch( err ){
						case LOOPER_def.ISTT_continue ://还是return？
							runSub = false ;
							break ;
						case LOOPER_def.ISTT____break :
							return void finish( true ) ;
						default :
							var istt:* = onProg_( new LoopExeuteMessage( this, LOOPER_def.ISTT____error, err ) ) ;
							if( istt == LOOPER_def.ABORT ){
							//这里对curExing可能应该改变。
								return void finish( true ) ;
							}else///阻止下级的执行。
								runSub = false ;
						kuilab::dbg{
							if( istt == LOOPER_def.ISTT___repeat ){
								runSub = false ;
								idx -- ;//下面的idx++还会执行，和为0所以下一循环的idx不变.
							}
						}
							
				}
			}
				/*if( breakFr || runSub  )//这里breakFr好像多余了!!!!!!!!!!//这个放在try里面也可以？因为func抛错的话
				{	return }else{//if( idx == length-1 ){}
				}//改成出帧时取消？--------------*/
				if( ! runSub )
					idx ++ ;
			}else{
				var last:Boolean = true ;
				runSub = false ;////目前的错误是上级循环的最后一次循环没执行(但下级执行了)，这时为了将逻辑导向执行xxxLast()
			}
				/*if( runSub ){ //&& subLoop //如有下级循环，需待下级循环执行才在onSubProg完成才步进。
					//return ;
				}else{
					if( !last )
						idx ++ ;//本来这句在大if里面的，现在拿出来，last真时就不执行了。
				}这段优化后就是if里面最后那句if( ! runSub ) */
				if( ! breakFr ){//要调试一下，确认下一帧执行的是不是到这个函数。
					if( runSub ){
						curExing = subLoop ;
						stat = LOOPER_def.STAT_EXE__SUB ;
						setTimeout( subLoop.exe , 1 )//本来是在startStack中的执行下级的，为了不浪费当前帧剩下的时间改在这里。
					}else
						clkId = setTimeout( last ? runWithCountArrayLast : runWithCountArray , 1 ) ;//如果这时已进入下一帧则可能造成逻辑错误等，目前在进出帧时做了调试检查。
				}else{
					kuilab::dbg{ dbgNxtFr = true ; }
				}
					//clkId = setTimeout( runWithCountArray, 1 ) ;//最后一项时，这次timeout是多余的，虽然执行时会finish()//试试0？	
		}//可以为Vector再写个效率更高的。
			/**为了在循环体函数里少一个判断，把最后一次循环另外写了一个函数。**/
			private function runWithCountArrayLast( ):void
			{	
				clearTimeout( clkId ) ; clkId = -1 ;
				try{
					func.apply( thisObj, getLoopArg() ) ;
				}catch( err:* ){
					switch( err ){
						case LOOPER_def.ISTT_continue ://最后一次迭代，给出continue也是要finish。
							finish( true ) ;//breakFr = true ;//////为了阻止下级的执行。
							return ;
						case LOOPER_def.ISTT____break :
							return void finish( true ) ;
						default :
							if( onProg_( new LoopExeuteMessage( this, LOOPER_def.ISTT____error, err ) ) == LOOPER_def.ABORT )
								return void finish( true ) ;
					}
				}
				if( subLoop != null ){
					curExing = subLoop ;
					stat = LOOPER_def.STAT_EXE__SUB ;
				}else
					finish( false ) ;
			}
		
		private function runWithCountTable():void
		{
			clearTimeout( clkId ) ; clkId = -1 ;
			var runSub:Boolean = Boolean( subLoop )
			if( idx < len ) {
				var k:* = keys[ idx ] ;//keys.shift() ;
				try{
					func.apply( thisObj, getLoopArg() ) ;
				}catch( err:* ){
					switch( err ){
						case LOOPER_def.ISTT_continue ://还是return？
							runSub = false ;
							break ;
						case LOOPER_def.ISTT____break :
							return void finish( true ) ;
						default :
							var istt:* = onProg_( new LoopExeuteMessage( this, LOOPER_def.ISTT____error, err ) ) ;
							if( istt == LOOPER_def.ABORT ){
								//这里对curExing可能应该改变。
								return void finish( true ) ;
							}else///阻止下级的执行。
								runSub = false ;
					}
				}
				if( ! runSub )
					idx ++ ;
			}else{//while( k == null && keys.length == 0 )
				var last:Boolean = true ;
				runSub = false ;////目前的错误是上级循环的最后一次循环没执行(但下级执行了)，这时为了将逻辑导向执行xxxLast()
			}
			if( ! breakFr ){//要调试一下，确认下一帧执行的是不是到这个函数。
				if( runSub ){
					curExing = subLoop ;
					stat = LOOPER_def.STAT_EXE__SUB ;
					setTimeout( subLoop.exe , 1 )//本来是在startStack中的执行下级的，为了不浪费当前帧剩下的时间改在这里。
				}else
					clkId = setTimeout( last ? runWithCountTableLast : runWithCountTable , 1 ) ;//如果这时已进入下一帧则可能造成逻辑错误等，目前在进出帧时做了调试检查。
			}else{
				//kuilab::dbg{ dbgNxtFr = true ; }
			}
		}
				private function runWithCountTableLast():void
				{
					clearTimeout( clkId ) ; clkId = -1 ;
					var k:* = keys[ idx ] ;//keys.shift() ;
					try{
						func.apply( thisObj, getLoopArg() ) ;
					}catch( err:* ){
						switch( err ){
							case LOOPER_def.ISTT_continue :
								return void finish( true ) ;
							case LOOPER_def.ISTT____break :
								return void finish( true ) ;
							default :
								if( onProg_( new LoopExeuteMessage( this, LOOPER_def.ISTT____error, err ) ) == LOOPER_def.ABORT )
									return void finish( true ) ;
						}
					}
					if( subLoop != null ){
						curExing = subLoop ;
						stat = LOOPER_def.STAT_EXE__SUB ;
					}else
						finish( false ) ;
				}
		
		private function runWithoutCount$():void//这种什么情况下会用？？？？
		{
			clearTimeout( clkId ) ; clkId = -1 ;
			try{ 
				/*if( breakFr )
					return ;*/
				if( func.apply( thisObj, getLoopArg() ) == LOOPER_def.ABORT )
					finish( true ) ;
			}catch( err:* ){
				if( onProg_( err ) == LOOPER_def.ABORT )
					finish( true ) ;
			}
			if( breakFr )
			{}else
				clkId = setTimeout( runWithoutCount$, 1 ) ;
		}
		
		protected function chkLoopType(  ):void//要改名。
		{
			//var TYPES:Array = [ LOOPER_def.TYPE__list, LOOPER_def.TYPE_count, LOOPER_def.TYPE__tabl, LOOPER_def.TYPE_noLmt ] ;
			//if( TYPES.indexOf( dataSet ) != -1 ){
			//无限循环可以数也可以不数。
			if( Util_Vector.isVectorOrArray( dataSet ) ){
				len = dataSet.length ;
				lastI = len -1 ;
				loopType = LOOPER_def.TYPE__list ;
				exe = runWithCountArray ;
			}
			else if( dataSet == LOOPER_def.TYPE_noLmt ){
				loopType =  LOOPER_def.TYPE_noLmt ;
				len = uint.MAX_VALUE ;//只有Number类型可以使用NaN常量。
				lastI = len ;
				exe = runCeaseless ;
			}else if( dataSet == null ){//这两种一样，数据给null就表示无限循环。。
				loopType = LOOPER_def.TYPE_noLmt ;
				len = uint.MAX_VALUE ;
				lastI = len ;
				exe = runCeaseless ;
			}
			else if( dataSet is int ){
				loopType = LOOPER_def.TYPE_count ;
				if( dataSet > 0 ){
					len = dataSet ;
					lastI = dataSet -1 ;
				}else//应该抛错，拿个负数做数据也挺二的。
					len = uint.MAX_VALUE ;
				exe = runWithCountAmount ;
			/*}else if( dataSet == LOOPER_def.LOOP_ARGpItem ){
				//可以实现成主动从parent获取，赋值到dataSet？从上级获取就要每次更新，所以应在startStack()里面执行。
				throw new Error( KuilabERROR.methodDoesNotImplement( 2 ) ) ;
			}else if( dataSet == LOOPER_def.LOOP_ARGpProp ){
				throw new Error( KuilabERROR.methodDoesNotImplement( 2 ) ) ;*/
			}else{//哈希表或“动态对象”。
				loopType = LOOPER_def.TYPE__tabl ;
				makeKeys() ;
				exe = runWithCountTable ;
			}
			idx = 0 ;
			//exe = runWithCountAmount ;
		}
		
		/**
		 * 对于嵌套的下级循环体，上级是先执行自己的循环体再执行下级的。如果一份代码原本的逻辑是下级循环前后都有代码，
		 * 后面的代码可以通过给子级再添加一个只执行一次的下级（顶级的孙子级）循环体来实现。
		 * @param loopFunc
		 * @param onProg
		 * @param loopType 对于嵌套的下级循环，因为循环的数据主体难以确定，循环类型也就难以判断，所以要使用者通过参数指明。定义常量的类目前叫做LOOPER_def，可选的值是名字以“TYPE_”起头的四个。
		 * @param loopArg
		 * @param dataNameOrGetFun 从上级循环获取对象来使用时，默认的dataSet是上级循环的当前项目（item）,</br>
		 * 如果要取的不是每一项本身，是每一项上的所属成员，那么用这个参数，支持“item.b.c.d”这样以“.”作为分隔符的路径写法。</br>
		 * 如果输入"index"，那么当前循环体的循环对象将是上级循环的当前索引对象。
		 * 也可以输入一个函数，程序将会把上级循环体和当前循环体的LoopProps实例两个参数分别传给它，让他自己取到当前遍历对象。
		 * @return 
		 */		
		public function setSubLoop( loopFunc:Function, onProg:Function, loopArg:*, dataNameOrGetFun:*='item', thisObj:*=null ):DaemonLoop
		{
			if( subLoop )
				throw new Error( KuilabERROR.programingLogicMistak( 'K0ksSn53' ) ) ;
			if( getRoot().isRunningThis() )
			if( stat != LOOPER_def.STAT_WAIT )
				throw new Error( 'RkOSo04v' ) ;
			var a:DaemonLoop = new DaemonLoop( DenyNewing.INSTANCE ) ;
				a.func = loopFunc ;
				a.onProg_ = onProg ;
				{ use namespace nameSpaceKuilab
				a.parent = this ; }  
				a.dataOrInheritWhat = dataNameOrGetFun ;
				a.setLoopArgType( loopArg ) ;
				a.setThisToFunc( thisObj ) ;
				if( loopProps == null )
					loopProps = LoopProps.doNew( this ) ;
			setSub( a ) ;
			//a.reset( true ) ;//下级在第一次开始之前要chkLoopType，但如果数据是由上级而来，就不能在执行前初始化。
			subLoop.exe = function():*{
			//if( Util_Vector.contins( [ LOOPER_def.STAT_WAIT,LOOPER_def.STAT_OVER ], subLoop.stat ) ) //'下级需要重置' )//onSubProg中执行的话，第一次就执行不到。
				subLoop.reset( true ) ;//惰性技巧，难得一用。exe会在reset中被赋值。
				subLoop.exe( ) ;
			}
			return a ;
		}
		
			protected function setSub( sub:DaemonLoop ):void
			{
				if( subLoop ){
					throw new Error( 'LUldEAmu' ) ;
				}
				{ use namespace nameSpaceKuilab ;
					if( propToSub == null )
						propToSub = new Dictionary() ;
					subLoop = sub ;
					sub.parent = this ; }
			}
		
		protected function setLoopArgType( type:* ):void
		{
			if( type == null )
				type = LOOPER_def.LOOP_ARG_item ;
			/*if( parent ){
				if( [ LOOPER_def.LOOP_ARGpItem, LOOPER_def.LOOP_ARGpProp ].indexOf( type ) != -1 ){
					loopArgType = type ;
					return ;
				}else throw new Error( 'HS1Q9Q7P' ) ;
			}*/
			if( LOOPER_def.LOOP_ARG_TYPES.indexOf( type ) == -1 )
				throw new Error( KuilabERROR.argsIncorrect( 1 )+'bRiW1XHft' ) ;
			loopArgType = type ;
			if( LOOPER_def.LOOP_ARG__all == type )
				loopProps = LoopProps.doNew( this as DaemonLoop ) ;
		}
		/**每次迭代时会调用**/
		protected function getLoopArg():Array{
			/*if( parent != null ){
				if( loopArgType == LOOPER_def.PARENT_item )//这是之前没有设计好时写的，应当废除。
					return [ loopProps.parent.item ] ;
				if( loopArgType == LOOPER_def.PARENT_prop )
					return [ loopProps.parent ] ;
			}*/
			switch( loopArgType ){
				case LOOPER_def.LOOP_ARG_index :
					return [ idx ] ;
				case LOOPER_def.LOOP_ARG_item :
					return [ dataSet[ idx ] ] ;
				case LOOPER_def.LOOP_ARG_data :
					return [ dataSet ] ;
				case LOOPER_def.LOOP_ARG_none :
					return null ;
				case LOOPER_def.LOOP_ARG__all :
					return [ loopProps ] ;
				default :
			}
			return [ loopProps ] ;
		}
		
		protected function makeKeys():void
		{
			idx = 0 ;
			var ret:Array = [] ;
			for( var k:* in dataSet )
				ret.push( k ) ;
			keys = ret ;
			len = keys.length ;
			lastI = len -1 ;
		}
		
		protected function setThisToFunc( typeOrObj:* ):void
		{
			switch( typeOrObj ){
				case LOOPER_def.THIS_setFunc :
					if( propToSub == null )
						propToSub = new Dictionary ;
					thisObj = setProp ;
					break ;
				case LOOPER_def.THIS_loopObj :
					thisObj = this ;
					break ;
				case LOOPER_def.THIS_dataSet :
					thisObj = dataSet ;
					break ;
				case LOOPER_def.THIS__parent :
					if( parent == null )//只有属于某上级循环体的下级才能使用此选项值。
						throw new Error( KuilabERROR.argsIncorrect( 15 )+'WbhlMZuN' ) ;
					{	use namespace nameSpaceKuilab ;
						thisObj = parent.thisObj ;
					}
					break ;
				case LOOPER_def.THIS__global :
					thisObj = null ;
					break ;
				case LOOPER_def.THIS_propObj :
				case null :
					if( propToSub == null )
						propToSub = new Dictionary ;
					thisObj = propToSub ;
					break ;
				default :
					thisObj = typeOrObj ;
			}
			
			function setProp( name:*, value:* ):void
			{
				/*if( name == LOOPER_def.ISTT_BREAK )多个判断效率低，所以先不加了。
				curExing.finish( true ) ;*/
				propToSub[ name ] = value ;
			}
		}
		
		/**要感知sub的完结或错误。由sub调用，原本是替代了sub的onProg。**/
		protected function onSubProg( r:LoopExeuteMessage ):void
		{
			switch( r.title ){
				case LOOPER_def.FINISH://sub执行完结。
					c::d0{ trace( 'sub done@', idx ) ;
					  }
					if( isLastLoop() )//因为有下级时runXxx函数是难以自己直接执行finish()的，那么只能在此时判断。
					{			//这里哪些能移到startStack()里面？
						stat = LOOPER_def.STAT_OVER ;
						if( parent ){//移到finish????
							parent.onSubProg( r )
						}else{ //一个任务以及它的所有子级任务执行完毕。
							onProg_( r ) ;
							startNext( this, true ) ;
							//进入下一帧。
						}
					}else{///!isLastLoop
/*
有下级：下级循环结束引发索引步进
无下级：自己步进（在run？中执行）
可在startStack中执行reset，
 * **/
						idx ++ ;
						subLoop.reset( true ) ;//
						curExing = this ;//exe() ;//自己没有判断结束。自己是最后一循环时再执行这个就是逻辑错误。
					}
					break ;
				case LOOPER_def.ABORT ://如果要终止上级循环，应专门设计一个指令。但目前未实现下级终止上级，这也不是必需的，且可手动终止上级。
				case LOOPER_def.ISTT____break ://根ABORT同义。下级的break应该传递给上级FINISH。
					enterDebugger() ;
					throw new Error( 'jtWErXhTPe' ) ;
					idx ++ ;
					//但是下级break上级应当步进。
					subLoop == null ;//要不要写个移除函数？
					//这里应该执行清理
					break ;
				case LOOPER_def.ISTT_continue ://只是下级continue，不是自己。
					//上级需要感知下级的continue吗？
					break ;
				default ://出错了
					enterDebugger() ; 
					if( parent ){
						
					}
			}
			/*function nextSub():*{
				subs.shift() ;
				if( subs.length > 0 )
					runSub( subs[0], true ) ;
				else{
					stat = STAT_EXE_SELF ;
					this.start() ;
				}
			}*/
		}//end of onSubProg()
		
		public function set onProg( f:Function ):void
		{
			this.onProg_ = f ;
		}
		/*判断是否在运行能用：1.timeout凭据,这个不够，因为开始执行到第一次setTimeout之间会判断失误
		 * 而且要求执行停止时立即clearTimeout。
		 * 2.exe函数本身开关标志，这样效率有损失。
		 * 3.state变量**/
		/**需要给实例写公开的isRunning/isPausing方法。
		 */
		public static function isRunning():Boolean
		{
			/*if( clkId != -1 )
				return false ;*/
			if( ! listening )
				return false ;
			/*if( instanceQue.length > 0 )//空转也判断为转，所以不用这个
				return false ;//而且这个还是绝对严谨，最后一个执行完调用stop……*/
			return true ;
		}
		
		protected function isRunningThis():Boolean
		{
			if( curExing != this )
				return false ;
			return true ; 
		}
		/**如果一个任务正在执行，与当前此函数可能形成并发冲突。**/
		protected function cancelAndClearTimeout():void
		{
			clearTimeout( clkId ) ; clkId = -1 ;
		}
		
		protected function runOnceLoop():void
		{
			exe() ;
			cancelAndClearTimeout() ;//改动了逻辑，这里要核算。
		}
		/**应该再加上循环类型等其它判断。因为对于无限循环，当索引到达uint.MAX_VALUE时会返回true，产生逻辑错误。**/
		protected function isLastLoop():Boolean
		{
			if( loopType == LOOPER_def.TYPE_noLmt )
				return false ;
			if( len > 0 )
				return idx == lastI ;
			return false ;
		}
		/*不应当支持变化，要变化应该创建新的循环体。
		 * 执行的时机？有下级，每次迭代时执行！下级每次结束时执行行不行？
		 * @return 告知上级自己*
		protected function chkReset( parentReset:Boolean ):Boolean
		{
			1.未执行过
			2.下级循环完毕
			*要不要在开始前执行reset？
			if( stat = LOOPER_def.STAT_OVER )//stat == LOOPER_def.STAT_WAIT ||
			{
				reset() ;
			}
			
		}*/
		
		/**上级循环体每执行一次迭代，都会将下级循环体重置，也就是执行这个方法。但是也可以人为调用。</br> **/
		public function reset( dataSetModifed:Boolean=false ):*
		{
			/*if( keys )
				makeKeys() ;//去掉了，每次重置都makeKeys()开销大。*/
			//if( LOOPER_def.TYPE_noLmt == loopType )
			stat = LOOPER_def.STAT_WAIT ;
			if( resetF is Function ){
				if( resetF( new LoopProps( this ), dataSetModifed ) )
					return ;
			}
			idx = 0 ;
			if( dataSetModifed ){
				if( dataOrInheritWhat is Function ){
					dataSet = dataOrInheritWhat( parent.getLoopProps(), loopProps ) ;//参数有待商榷。。。。
					if( dataSet == VALUE_notFound )
					{}
				}else if( dataOrInheritWhat is LoopDataSet ){
					var h:* = LoopDataSet(dataOrInheritWhat).propPathOrGainFunc ;
					dataSet = getPropByPathF( parent.getLoopProps(), h, '.' ) ;
				}else{
					dataSet = dataOrInheritWhat ;
					//throw new Error( KuilabERROR.methodDoesNotImplement(2) ) ;
				}
				chkLoopType() ;
			}
		}
		
		
		/**因为官方SDK不能inline，而由外部调用又因为只能读public的成员，所以我很傻的从Utils复制了这个函数导致增加了三十多行代码。**/
		protected function getPropByPathF( obj:Object, names:*, spliter:String='.', getObjArr:Boolean=false ):*
		{
			var nameArr:Array ;
			if( names is Array ){
				nameArr = names ;
			}else{
				nameArr = String( names ).split( spliter ) ;
			}
			//var last:String = nameArr.pop() ;
			var item:* = obj ;
			//var ret:Array = [ item ] ;
			for each( var name:String in nameArr ){
				try{
					var p:* = item[ name ] ;
					if( p is Function )
						item = item() ;
					//ret.push( item ) ;
					item = p ;
				}catch( err:* ){
					return null  ;
				}
			}
			//ret.push( item[ last ] ) ;
			return item ;//ret.pop() ;
		}
		/**对一个循环体进行重置的方法。如果默认的reset()方法不能达到目的，那么使用自己编写的重置方法就可以直接替换而不用扩展子类。<br/>
		 * 访问相关成员时如果需要请使用命名空间。reset方法执行时如果dataSetUpdated参数为true默认会执行chkLoopType()这个方法，
		 * 传入的这个客制化函数如果返回非假的值，那么将不执行默认的重置逻辑。**/
		public function set resetFunction( f:Function ):void
		{
			resetF = f ;
		}
		/**即使循环体是未创建loopProps的，获取时也会自动创建一个。**/
		public function getLoopProps():LoopProps
		{
			if( loopProps )
				return loopProps ;
			loopProps = LoopProps.doNew( this ) ;
			return loopProps ;
		}
		/**设计未最终决定。**/
		public function getProp( name:* ):*
		{
			if( loopProps )
				return loopProps.getUpperValue( name ) ;
			return null ;
		}
		/**未实现**/
		public function setOpts( resetFunc:Function, backupDataForReset:Boolean ):void
		{
			
			function backupData():void
			{
				
			}
		}
		
		protected function getRoot( instance:DaemonLoop=null ):DaemonLoop
		{
			if( instance == null )
				instance = this ;
			while( instance.parent )
				instance = instance.parent ;
			return instance ;
		}
		
		protected function onFrameEnter( e:Event ):void
		{
			breakFr = true ;/**可能需要取消interval**/
		}
		//被静态的帧侦听函数调用的实例方法。
		protected function onFrameExit( e:Event ):void
		{
			breakFr = false ;
			this.startStack() ;//startStack的逻辑不是每帧启动所适合的?
			if( isRunning() )//正在运行
			{
				/*if( subLoop )
					return void subLoop.exe() ;//sub没有获得上级的作用域环境。*/
			}else{
				//需要则运行()
				
			}

		}
		/*protected const ON_FRAME_ENTER:Function = onFrameEnter ;
		protected const ON_FRAME_EXIT:Function = onFrameExit ;*/
		
		protected static function onEnterFrame_S( e:Event ):void
		{
			kuilab::dbg{ if( clkId != -1 )
				trace( '----------------------------------发现了跨帧定时(进帧)=', clkId ) ;//应该会引起逻辑错误的并发执行。
			}
			if( curExing )
				curExing.onFrameEnter( e ) ;
		}
		
		protected static function onExittFrame_S( e:Event ):void
		{	//没有判断pause。
			kuilab::dbg{ if( clkId != -1 )
				trace( '----------------------------------发现了跨帧定时(出帧)。' ) ;//应该会引起逻辑错误的并发执行。
			}
			if( curExing )
				curExing.onFrameExit( e ) ;
		}
		protected static const ENTER_FR_func:Function = onEnterFrame_S ;
		protected static const EXITT_FR_func:Function = onExittFrame_S ;
		
		/*
		 * @param onProg 循环时发生错误也会传给这个函数。如果函数返回了ABORT常量,则循环停止。
		 *	
		public function setTask$( func:Function, dataSet:*, onProg:Function, loopTypeArg:* = LOOP_ARG_index ):void
		{
			this.dataSet = dataSet ;
			this.func = func ;
			this.onProg_ = onProg ;
			chkLoopType() ;
			setLoopArgType( loopTypeArg ) ;
		}*/
	}
}
//class VALUE_ABORT{}
class DenyNewing{
	public static const INSTANCE:DenyNewing = new DenyNewing ;
	//public function DenyNewing(){}
}