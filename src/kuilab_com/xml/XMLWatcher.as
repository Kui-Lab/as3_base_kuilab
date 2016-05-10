package kuilab_com.xml
{
	
	import flash.events.EventDispatcher;

	[Event(name="xmlChange", type="kuilab_com.xml.XMLChangeEvent")]
	/**
	 * 用于侦听xml变化的类. 
	 * @author 汪汪
	 */        
	public class XMLWatcher extends EventDispatcher
	{
		/**
		 * 构造函数 
		 * @param xml 如果不为null会直接调用watchXML方法.
		 * 
		 */                
		public function XMLWatcher( xml:XML = null)
		{
			super();
			if( xml )watchXML( xml );
		}
		
		/**
		 * 设定侦听的xml. 
		 * @param xml
		 * 
		 */                
		public function watchXML( xml:XML ):void
		{
			var xitem:XML = XML( xml );
			if (!(xitem.notification() is Function))
			{
				xitem.setNotification(notificationFunction as Function);
			}
		}
		
		private function notificationFunction(currentTarget:Object,
											  type:String,
											  target:Object,
											  value:Object,
											  detail:Object):void
		{
			
			
			var prop:String;
			var oldValue:Object;
			var newValue:Object;
			
			switch(type)
			{
				case "attributeAdded":
				{
					prop = "@" + String(value);
					newValue = detail;
					break;
				}
					
				case "attributeChanged":
				{
					prop = "@" + String(value);
					oldValue = detail;
					newValue = target[prop];
					break;
				}
					
				case "attributeRemoved":
				{
					prop = "@" + String(value);
					oldValue = detail;
					break;
				}
					
				case "nodeAdded":
				{
					prop = value.localName();
					newValue = value;
					break;
				}
					
				case "nodeChanged":
				{
					prop = value.localName();
					oldValue = detail;
					newValue = value;
					break;
				}
					
				case "nodeRemoved":
				{
					prop = value.localName();
					oldValue = value;
					break;
				}
					
				case "textSet":
				{
					prop = String(value);
					newValue = String(target[prop]);
					oldValue = detail;
					break;
				}
				case "namespaceAdded":
				{
					newValue = value;
					break;
				}
				case "namespaceRemoved":
				{
					oldValue = value;
				}
				default:
				{
					break;
				}
			}
			
			
			var evt:XMLChangeEvent;
			evt = new XMLChangeEvent(XMLChangeEvent.XML_CHANGE);
			evt.kind = type;
			evt.oldValue = oldValue;
			evt.newValue = newValue;
			evt.property = prop;
			evt.currentXML = currentTarget;
			evt.xml = target;
			dispatchEvent(evt);
		}
		
		
	}

}