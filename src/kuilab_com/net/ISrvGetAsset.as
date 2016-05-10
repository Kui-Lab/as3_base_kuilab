package kuilab_com.net
{
	import kuilab_com.net.depend_util_etc.IAssetStore;

	/**
	 * @author kui夔。
	 */
	public interface ISrvGetAsset
	{
		function setSrvLoad( v:ISrvLoad ):void
		/**
		 *	path相当于key，package相当于不同的哈希表package之间互不相干。
		 */		
		function getStoreOrLoad( path:*, handlerCallback:Function, packagee:Object=null, other:ISrvGetAsset_arg=null ):*
			
			
		function getByStore( path:Object, packag:Object=null, nullValue:Object=null ):Object
		/**
		 * @param packageName
		 * @param packag 规范的使用是ICargoStore，也可使用普通哈希表(Dictionary)。
		 * @param replace 是否覆盖已有的资源包。
		 * @param type
		 * @return 
		 * @see ICargoStore 
		 */
		function storePackage( packageName:Object, assetPackageBody:Object, replace:*=true, storeType:Object=null ):*
			
		function getPackgeBody( packageName:Object, udid:*=null, adress:*=null ):*
			
		function clearCache( packag:Object ):void
		/**
		 * @param subPackage
		 * @param onProgress
		 * @param packag 如果无法识别包体属于的包，那么用这个参数传入。
		 */			
		function update( subPackage:*, onProgress:Function, packag:*=null ):*
	}
}