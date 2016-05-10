package kuilab_com.dependInj
{
	/**<pre>将这个查询与注册功能分离为两个接口是因为使用者（业务逻辑单元）一般不会实施注册行为而只是查询。
	 * 模块管理器向依赖注入框架演化的中间产物。
	 * 可以认为是注入式模块管理器。
	 * 这个接口只描述它的注册功能，使用功能在IFactory4DegInj描述。		
	 * 
	 * 使用path可以在有限范围内解决权限问题。
	 * 比如写一个口令，在构建需要用到某些对象的bean时分发给它们。
	 * 或者通过抛错的hack方法检查调用者是不是被允许的。
	 * 
	 * 
	 * 
	 * @param path 比如以“*”，“packageA”各注册了一个实例，再以“packageA.packageB”查询
	 * 就返回packageA的那个而不是“*”的。
	 * 注意：path的分隔符是“.”
	 * </pre>
	 * 
	 * @author kui夔。
	 */	
	public interface IDependInjectRegist
	{
		/**
		 * @param interfac	不一定要用接口做键，可以用别的，当高级的字典用。
		 * @param instance
		 * @param path
		 * @return 
		 */
		function registInterface( interfac:Object, instance:Object, path:*='*' ):*
	}
}