package com.adobe.nativeExtensions.maps.overlays
{
	import com.adobe.nativeExtensions.maps.LatLng;

	public class Marker
	{
		private var _myId:int;
		public var latLng:LatLng;
		public var title:String="";
		public var subtitle:String="";
		public var fillColor:uint=MarkerStyles.MARKER_COLOR_RED;
		private static var nextId:int=0;
		public function Marker(latLng:LatLng)
		{
			this.latLng=latLng;
			this._myId=getNextMarkerId();
		}
		private static function getNextMarkerId():int
		{
			return nextId++;	
		}
		public function get myId():int
		{
			return _myId;
		}
	}
}