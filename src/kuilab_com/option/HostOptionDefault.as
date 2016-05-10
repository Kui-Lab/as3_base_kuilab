package kuilab_com.option
{
	import __AS3__.vec.Vector;
	
	import flash.utils.Dictionary;
	
	public class HostOptionDefault implements IHostOption
	{
		public function HostOptionDefault()
		{
			
			
		}
		
		public function init( data:Object ):void
		{
			
		}
		
		protected var mapCom_:Dictionary = new Dictionary( true ) ;
		protected var mapOption_:Dictionary = new Dictionary( true ) ;
		
		public function update( strItem:String, value:Object ):void
		{
			var vClient:Vector.<IClientOption> = mapCom_[ strItem ] ;
			var dOld:Object = mapOption_[ strItem ] ;
			if( vClient )
			{
				for each( var client:IClientOption in mapCom_ )
				{
					client.onOptionUpdate( strItem, value, mapOption_[ dOld ] ) ;
				}
			}
		}
		
		protected function handlDispose( ...arg ):void
		{
			var client:IClientOption = arg[0] as IClientOption ;
			clientRem( client ) ;
		}

		public function clientAdd( client:IClientOption ):void
		{
			for each( var name:String in client.vNameOption )
			{
				var v:Vector.<IClientOption> ; 
				if( mapCom_.hasOwnProperty( name ) )
				{
					v = mapCom_[ name ] ;
					v.push( client ) ;
				}
				if( v == null )
				{
					v = new Vector.<IClientOption> ;
					mapCom_[ name ] = v ;
					v.push( client ) ;
				}
			}
			client['ed'].addEventListener( EventOption.TYPE_dispose, onClient ) 
		}
		
		public function clientRem( client:IClientOption ):void
		{
			for each( var name:String in client.vNameOption )
			{
				var v:Vector.<IClientOption> ;
				if( mapCom_.hasOwnProperty( name ) )
				{
					var id:int = v.indexOf( client ) ;
					v.splice( id, 1 ) ;
					if( v.length == 0 )
						delete mapCom_[ name ] ;
				}
			}
		}
		
		protected function onClient( e:EventOption ):void
		{
			
		}
		
	}
}