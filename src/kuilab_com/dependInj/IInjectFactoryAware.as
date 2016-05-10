package kuilab_com.dependInj
{
	/**<pre>
	 * 抄袭Spring里面的XxxxAware。
	 * AnyBuilder引擎也并没有实现给这个接口自动注入实现者的逻辑。
	 * 编写程序时根据需要进行实现，并注入。
	 * </pre>
	 * 
	 * @see kuilab_com.dependInj.IFactory4DepInj IFactory4DepInj
	 * @see kuilab_com.dependInj.IDependInjectRegist IDependInjectRegist
	 */	
	public interface IInjectFactoryAware extends IAbstInjectFactoryAware
	{
		function setFactory( factory:IFactory4DepInj ):void
	}
}