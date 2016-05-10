package kuilab_com.dependInj
{
	/**
	 * 对于bean模式的编程，可以实现这个接口，列出自己需要的依赖对象和资源。
	 * 然后接受注入。
	 */
	public interface IDependListing
	{
		function getDependings():*
	}
}