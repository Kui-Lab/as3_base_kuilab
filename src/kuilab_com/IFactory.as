package kuilab_com
{
	/**
	 * **/
	public interface IFactory
	{
		/**创建单个类（或若干种子类）的工厂， 实现时可以通过改变类来改变创造的实例。 **/
		function set classs( v:* ):void
			
		function setDefaultConstructArg( v:Array, check:Boolean=false ):void
			
		function getInstance( ):Object
	}
}