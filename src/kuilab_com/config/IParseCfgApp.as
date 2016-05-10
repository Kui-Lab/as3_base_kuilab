package kuilab_com.config
{
	public interface IParseCfgApp
	{
		function set dataConfig( data:Object ):void
		function getValue( key:Object, type:uint =uint.MAX_VALUE ):Object 
	}
}