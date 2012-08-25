package com.adobe.nativeExtensions.maps.overlays
{
	import com.adobe.nativeExtensions.maps.LatLng;

	public class Polyline
	{
		private var _myId:int;
		private var _pts:Vector.<LatLng>;
		private static var nextId:int=0;
		public function Polyline(points:Vector.<LatLng>)
		{
			_pts=points;
			this._myId=getNextPolylineId();
		}
		private static function getNextPolylineId():int
		{
			return nextId++;	
		}
		public function get myId():int
		{
			return _myId;
		}
		public function get points():Vector.<LatLng>
		{
			return _pts;
		}
	}
}