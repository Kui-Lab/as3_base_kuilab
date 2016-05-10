package kuilab_com.message
{
	
	public class Message
	{
		public function Message( type:String, body:Object=null, sender:IMessageSend=null )
		{
			type_ = type ;
			body_ = body ;
			sender_ = sender ;
		}
		
		protected var type_:String ;
		protected var body_:Object ;
		protected var sender_:IMessageSend ;
		
		public function set type( v:String ):void
		{
			type_ = v ;
		}
		
		public function get type():String
		{
			return type_ ;
		}
		
		public function get body():Object
		{
			return body_ ;
		}
		
		public function set body( v:Object ):void
		{
			body_ = v ;
		}
		
		public function get sender():IMessageSend
		{
			return sender_ ;
		}
		
		public function clone():Message
		{
			return new Message( type_, body_, sender_ ) ;
		}

	}
}