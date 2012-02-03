package com.adobe.nativeExtensions.maps
{
	import flash.events.Event;
	
	public class MapEvent extends Event
	{
		public static var TILES_LOADED_PENDING:String="mapevent_tilesloadedpending";
		public static var TILES_LOADED:String="mapevent_tilesloaded";
		public static var MAP_LOAD_ERROR:String="mapevent_maploaderror";
		public function MapEvent(type:String,feature:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}