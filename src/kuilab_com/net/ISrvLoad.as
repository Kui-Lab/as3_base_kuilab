package kuilab_com.net
{
	public interface ISrvLoad
	{
		/**
		 * 
		 * @param request
		 * @param handler
		 * @param loaderClass
		 * @param arg @see kuilab_com.net.ISrvLoad_DEF[ISrvLoad_DEF] 以字典的形式输入参数，比如{ISrvLoad_DEF.ARG_wrapEvent:true}
		 * @return 
		 */
		function load( request:Object, handler:Function, loaderClass:Class=null, args:ISrvLoad_arg=null ):*
	}
}