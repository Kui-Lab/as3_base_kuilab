package kuilab_com.net.depend_util_etc
{
	import flash.utils.Dictionary;

	public class LocationData
	{
		internal static const MAP_package:Object = new Dictionary( true ) ;
		
		public function LocationData()
		{
		}
		
		protected var name_:*
		protected var locP_:*
		protected var url_:*
		protected var packag_:*
		protected var udid_:*
		protected var loaded_:*

		public function get name():*
		{
			return name_;
		}

		public function set name(value:*):void
		{
			name_ = value;
		}

		public function get locP():*
		{
			return locP_;
		}

		public function set locP(value:*):void
		{
			locP_ = value;
		}

		public function get url():*
		{
			return url_;
		}

		public function set url(value:*):void
		{
			url_ = value;
		}

		public function get packag():*
		{
			return packag_;
		}

		public function set packag(value:*):void
		{
			packag_ = value;
		}


		public function get udid():*
		{
			return udid_;
		}

		public function set udid(value:*):void
		{
			udid_ = value;
		}

		public function get loaded():*
		{
			return loaded_;
		}

		public function set loaded(value:*):void
		{
			loaded_ = value;
		}


	}
}