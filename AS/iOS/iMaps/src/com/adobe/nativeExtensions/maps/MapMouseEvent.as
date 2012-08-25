package com.adobe.nativeExtensions.maps
{
	import flash.events.Event;
	
	public class MapMouseEvent extends Event
	{
		public static var MARKER_SELECT:String="mapevent_select";
		public static var MARKER_DESELECT:String="mapevent_deselect";
		public var data:Object=null;
		public function MapMouseEvent(type:String,feature:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data=feature;
			super(type, bubbles, cancelable);
		}
	}
}