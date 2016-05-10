package kuilab_com.xml
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.Direction;

	/**
	 * 原包名 com.aaaqe.common.utils.xml</br>
	 * ---------------------------
	 * xml变化的事件. 
	 * @author 汪汪
	 */        
	public class XMLChangeEvent extends Event
	{
		/**
		 * 事件名称统一为 XML_CHANGE.
		 */                
		public static const XML_CHANGE:String = "xmlChange";
		/**
		 * 事件对象的kind,添加一个属性. 
		 */                
		public static const ATTRIBUTE_ADDED:String = "attributeAdded";
		/**
		 * 事件对象的kind,修改一个属性. 
		 */                
		public static const ATTRIBUTE_CHANGED:String = "attributeChanged";
		
		/**
		 * 事件对象的kind,删除一个属性. 
		 */                
		public static const ATTRIBUTE_REMOVED:String = "attributeRemoved";
		/**
		 *  事件对象的kind,添加一个节点. 
		 */                
		public static const NODE_ADDED:String = "nodeAdded";
		/**
		 * 事件对象的kind,修改一个节点. 
		 */                
		public static const NODE_CHANGED:String = "nodeChanged";
		/**
		 * 事件对象的kind,删除一个节点. 
		 */                
		public static const NODE_REMOVED:String = "nodeRemoved";
		/**
		 * 事件对象的kind,添加一个节点,此方法后会再次派发 NODE_ADDED,当然是否有其它情况可能发生还不清楚.
		 * 测试中xml.appendChild("text");,将会使用最后的节点名来创建一个新的节点.以后还需留意观察其它现象.
		 */                
		public static const TEXT_SET:String = "textSet";
		/**
		 * 事件对象的kind,添加一个命名空间 
		 */                
		public static const NAMESPACE_ADDED:String = "namespaceAdded";
		/**
		 * 事件对象的kind,删除一个命名空间. 
		 */                
		public static const NAMESPACE_REMOVED:String = "namespaceRemoved";
		/**
		 * 如果是修改的话,这是修改前的值. 
		 */                
		public var oldValue:Object;
		/**
		 * 修改后的值或添加后的值. 
		 */                
		public var newValue:Object;
		/**
		 * 主xml. 
		 */                
		public var currentXML:Object;
		/**
		 * 当事者的xml. 
		 */                
		public var xml:Object;
		/**
		 * 属性名. 
		 */                
		public var property:Object;
		/**
		 * 事件类型. 
		 */                
		public var kind:String;
		public function XMLChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		/**
		 * @private 
		 * @return 
		 * 
		 */                
		override public function toString() : String
		{
			return ("XMLChangeEvent\n"+getString("oldValue",oldValue)+getString("newValue",newValue)+getString("source",currentXML)
				+getString("property",property)+"kind = " + kind);
		}
		
		private static function getString(name:String,obj:Object):String
		{
			var str:String;
			str = name +" = \n\t" + (obj is XML? XML(obj).toXMLString():(obj ? obj.toString() :"null")) ;
			return str += "\n";
		}
		/**
		 * @private 
		 * @return 
		 * 
		 */                
		override public function clone() : Event
		{
			var evt:XMLChangeEvent;
			evt = new XMLChangeEvent(type,bubbles,cancelable);
			evt.oldValue = oldValue;
			evt.newValue = newValue;
			evt.currentXML = currentXML;
			evt.property = property;
			evt.kind = kind;
			return evt;
		}
		
		/*public static function watch( xml:XML, listener:Function )
		{
			//xml.setNotification(
			( new XMLWatcher ).watchXML( xml ) ;
			mapXml[ xml ] = listener ;
		}
		
		public static function unwatch( xml:XML, listener:Function ):void
		{
			delete mapXml[ xml ] ;
		}
		
		protected static var mapXml:Object = new Dictionary( true ) ;*/
	}
}