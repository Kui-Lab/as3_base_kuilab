package kuilab_com.pool
{
	public interface IRecyclePool
	{
		
		function set factory( factoryOrClass:* ):void
		
		function create( num:uint, setBusy:Boolean, arg:* ):*
			
		function obtain( setBusy:Boolean = true ):IObjInRecPool
			
		function recycle( numOrMemSize:uint ):*
			
		function setBusy( obj:IObjInRecPool ):*
			
		function setIdle( obj:IObjInRecPool ):*
			
	}
}