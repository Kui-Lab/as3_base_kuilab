package kuilab_com.net.depend_util_etc
{

	/**<pre>业务逻辑直接操作，尤其是耦合资源地址是不干净的程序设计，
	 * 有时我们需要一个地址翻译者，kuilab_com.net.SrvGetAsset以及SrvLoad用到了它，
	 * 这个接口描述它。
	 * 也可以用在其它场合。
	 * </pre>
	 * @see kuilab_com.net.LocationReferer
	 * @see kuilab_com.net.SrvGetAsset
	 * @author kui.
	 */	
	public interface ILocationRefer
	{
		function refer( tar:Object, packagee:Object ):Object
	}
}