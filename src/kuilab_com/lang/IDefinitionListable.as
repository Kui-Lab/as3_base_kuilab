package kuilab_com.lang
{
	import flash.system.ApplicationDomain;

	/**
	 * <pre>ApplicationDomain后来提供了getQualifiedDefinitionNames()，
	 * 但是如果不是融合在当前域的加载方式，外部执行它是无法获取的。
	 * 所以写这个接口，让获取定义列表方便点。一般是让运行加载库的主类实现它。</pre>
	 * 
	 * @author kui夔.
	 */	
	public interface IDefinitionListable
	{
		function getDefinitionNames():Vector.<String> ;
	}
}