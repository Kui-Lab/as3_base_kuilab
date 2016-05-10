package kuilab_com.dependInj
{
	/**<pre>
	 * 不同于Spring的有很多XxxAware接口来获取各种东西，我们的依赖注入规范实现一个可注册、检出的表。
	 * 要获取对象都从这个表上面来检出。模型类似于古老的单列管理器。
	 * 但机制进化了：一个接口（键）可以注册多个实例，根据包路径来区分，这个包路径就是path参数。
	 * 以"aa.bb.cc"这个path查询，依次检查"aa.bb.cc","aa.bb","aa",""有无注册，有则返回。
	 * 
	 * 而表的注册功能是用IDependInjectRegist接口来描述的。
	 * 自带默认的实现是ManagerApp(应该会改名字)。也可以自己实现。
	 * 
	 * <pre>
	 * 
	 * @see IDependInjectRegist IDependInjectRegist
	 */
	public interface IFactory4DepInj
	{
		/**
		 * 
		 * @param interfac
		 * @param path
		 * @param args 如果要创建实例，那么由这个参数传递构造函数参数。
		 * @return 
		 */
		function getInstanceAmply( interfacee:Object, path:Object=null, args:Object=null ):*
		
		function getClass( interfacee:Object, path:Object=null, args:Object=null ):Object
			
	}
}