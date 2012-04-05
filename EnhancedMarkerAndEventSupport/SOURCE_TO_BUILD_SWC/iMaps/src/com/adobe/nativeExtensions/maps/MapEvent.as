package com.adobe.nativeExtensions.maps
{
	import com.adobe.nativeExtensions.maps.overlays.Marker;
	
	import flash.events.Event;
	
	public class MapEvent extends Event
	{
		// Original Events
		public static var MAP_LOAD_ERROR:String        = "mapevent_maploaderror";
		public static var TILES_LOADED_PENDING:String  = "mapevent_tilesloadedpending";
		public static var TILES_LOADED:String          = "mapevent_tilesloaded";
		
		// Added Events
		public static var DETAIL_BUTTON_PRESSED:String = "mapevent_detailbuttonpressed";
		public static var PIN_SELECTED:String          = "mapevent_pinselect";
		public static var PIN_DESELECTED:String        = "mapevent_pindeselect";
		public static var USER_LOCATION_CLICKED:String = "mapevent_userlocationclick";
		public static var USER_LOCATION_UPDATE:String  = "mapevent_userlocationupdate";
		
		public static var USER_LOCATION_FAIL_TO_LOCATE_USER_WITH_ERROR:String = "mapevent_userlocationerror";
		public static var USER_LOCATION_FAIL_TO_LOCATE_USER:String            = "mapevent_userlocationfail";
		public static var USER_LOCATION_UPDATE_STARTED:String                 = "mapevent_userlocationstart";
		public static var USER_LOCATION_UPDATE_STOPPED:String                 = "mapevent_userlocationstop";
		
		private var _data:Object;
		
		public function MapEvent(type:String, feature:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = feature;
			trace("_data",_data);
		}

		/*/ 
		override public function get target():Object
		{
			return _data;
		}
		//*/
		
		public function get marker():Marker
		{
			return _data as Marker;
		}
		
		public function get markerId():int
		{
			var mark:Marker = _data as Marker;
			return mark.myId;
			// Function not working
			// return _data.myId;
		}
	}
}