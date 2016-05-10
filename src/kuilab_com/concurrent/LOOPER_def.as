package kuilab_com.concurrent
{
	import kuilab_com.lang.Pair;

	public class LOOPER_def
	{
		public function LOOPER_def()
		{
		}
		
		/*当执行函数时发生错误，会将错误交给错误响应函数处理，（如果设置了的话）如果返回这个值，就终止。**/
		public static const ABORT:* = 'VALUE_ABORT' ;
		//public static const PAUSE:* = 'pause 停止，但可再继续' ;
		public static const FINISH:* = 'complete 完了' ;
		
		
		
		public static const ISTT___finish:* = new Pair( 'complete 完了。' ) ;;
		public static const ISTT____pause:* = new Pair( '暂停直到空闲。Pause until idle.' ) ;
		public static const ISTT_____stop:* = new Pair( '停止。Stop' ) ;
		public static const ISTT_continue:* = new Pair( '终止当前循环并执行下一次。break current loop and start next loop' ) ;
		public static const ISTT____error:* = new Pair( '发生了错误' ) ;
		public static const ISTT____break:* = new Pair( 'break loop 终止循环' ) ;
		
		/**执行完毕自然成为此状态。**/
		public static const STAT_OVER:* = '完了。Complete。' ;
		/**刚创建时的值，一旦被执行过就不是它了，除非reset()。**/
		public static const STAT_WAIT:* = '未开始执行' ;
		public static const STAT_PAUS:* = '暂停。Pause until idle.' ;
		/**未完毕而被执行了无限期暂停，即使其它任务完成也不会开始执行。只能人为操作继续。**/
		public static const STAT_STOP:* = '停止。Stop' ;
		//public static const STAT_EXEC:* = '正在执行' ;
		public static const STAT_EXE_SELF:* = '正在执行自己' ;
		public static const STAT_EXE__SUB:* = '正在执行下级' ;
		
		
		public static const LOOP_ARG_index:* = '序号或者键' ;//key也用这个表示。
		public static const LOOP_ARG_item:* = '每一项的值' ;//key也用这个表示。
		public static const LOOP_ARG_count:* = '计数' ;//数据集合并不是可数或可遍历的(比如为空)，则专门进行计数并在每次循环时传给循环函数。
		public static const LOOP_ARG_none:* = '不传任何参数' ;
		public static const LOOP_ARG_data:* = '整个数据集' ;
		/**要改个名字。**/
		public static const LOOP_ARG__all:* = '所有相关对象()' ;
		
		public static const LOOP_ARGpItem:* = '使用上级的当前迭代项' ;//下级循环都要拿上级的数据来操作的。
		public static const LOOP_ARGpProp:* = '使用上下级之间的数据传输对象' ;
		public static function get LOOP_ARG_TYPES():Array
		{
			return [ LOOP_ARG__all, LOOP_ARG_data, LOOP_ARG_index, LOOP_ARG_none, LOOP_ARG_item, LOOP_ARG_count ] ;
		}
		
		//public static const parentKeyAsSubData:* = new Pair( '下级将上级的当前索引对象作为自己的迭代主体对象。'  ) ;
		
		
		/**作为数据对象参数，也就是第二个参数使用的。使用上级的数据集合对象，必须是有上级，也就是被嵌套的循环体可以使用此选项。**/
		//public static const PARENT_item:* = '使用上级的当前迭代项' ;
		/**作为数据对象参数，也就是第二个参数使用的。使用上下级之间的数据传输对象作为this，必须是有上级，也就是被嵌套的循环体可以使用此选项。**/
		//public static const PARENT_prop:* = '使用上下级之间的数据传输对象' ;
		
		//四种循环类型，只有noLmt是被动结束（无限循环）的。
			public static const TYPE__list:* = new Pair( 'Vector or Array 线性数据结构', null ) ;
			public static const TYPE__tabl:* = new Pair( 'Table(Enumerable) 表（可枚举）', null );
			public static const TYPE_count:* = new Pair( 'loop several times 运行一定的次数', null );
			/**会检查循环体函数的返回值，如果是ISTT_BREAK就停止执行。目前只有它可以作为添加任务的第二个参数来启动无限循环。**/
			public static const TYPE_noLmt:* = new Pair( 'until artificial stop 无限循环直到人为停止', null );
		
		//静态变量直接创建并赋值私有类会导致1007类无法创建的bug。
		//protected static var NEWING_KAY_ARG:DenyNewing = function():DenyNewing{ return new DenyNewing }() ;
		
		/**因为上下级被循环函数之间通信要依赖一个数据对象，给数据这个对象写入数据是通常情况下用到的功能。如果只写不读，可以选用这个参数。</br>写入方法：“this( 变量名, 值对象 )”。**/
		public static const THIS_setFunc:* = '使用函数作为this' ;
		/**这种是默认，因为上下级循环体之间通信要依赖一个数据对象。如果THIS_setFunc那样“this( 变量名, 值对象 )”你无法理解或不喜欢，就使用这种。写入形式是“this[ 变量名 ] = 值对象 。”**/
		public static const THIS_propObj:* = '使用专用对象作为this' ;
		/**一般人用不到这种。用了这种，嵌套的循环体函数this就是循环体实例本身，像普通类成员方法一样。**/
		public static const THIS_loopObj:* = '使用循环体（DaemonLoop的实例）本身做this' ;
		/**一般数据对象就是被迭代的对象集合，以实参传入迭代函数（或用LoopProps携带），这种也是特殊情况才会用到。**/
		public static const THIS_dataSet:* = '使用数据对象做this' ;
		/**继承上级的this对象。作为下级的循环体使用此选项，this就是上级的this对象。当然没有上级的循环体是不能用此选项的。**/
		public static const THIS__parent:* = '继承上级的this对象' ;
		/**包括我在内的很多程序员认为编程语言不应当提供全局对象，也就是global。而Adboe将嵌套和匿名函数运行时的this默认设置为global。**/
		public static const THIS__global:* = '不替代this，avm默认会在循环体函数执行时使用global对象。' ;
	}
}