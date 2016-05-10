package kuilab_com.util
{
	public interface IBindable
	{
		function setPropertyBindable( name:Object, bindable:Boolean=true ):void
		function isPropertyBindable( name:Object ):Boolean
		function bindProperty( name:Object, listener:Function, autoSetBindable:Boolean=false, priority:int=0 ):void
		function removeBind( propertyName:String, listener:Function ):void
		function removeBindBySeek( listener:Function ):Boolean
	}
}