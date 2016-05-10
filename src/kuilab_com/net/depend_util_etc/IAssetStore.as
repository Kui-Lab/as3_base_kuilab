package kuilab_com.net.depend_util_etc
{
	/**<pre>
	 * 一般在具体实现程序时直接使用，可投入ISrvGetAsset。
	 * 应改名为IAssetPackage。
	 * 
	 * 这个接口一般用于运行时加载进来的swf库，
	 * 因为是编译好的不会修改内容所以没有添加、删除、修改方法。
	 * 如果要实现添加、删除、修改，可以直接用哈希表（Dictionary投入ISrvGetAsset）或进行扩展。
	 * </pre>
	 * @author kui.
	 */
	public interface IAssetStore
	{
		function getCargo( name:Object ):Object
			
		function hasCargo( name:Object ):Boolean
	}
}