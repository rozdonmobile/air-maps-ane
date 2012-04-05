package com.adobe.nativeExtensions.maps
{
	public class LatLng
	{
		internal var _latitude:Number=0.0;
		internal var _longitude:Number=0.0;
		public function LatLng(lat:Number,lng:Number)
		{
			_latitude=lat;
			_longitude=lng;
		}
		
		public function lat():Number
		{
			return _latitude;
		}
		public function lng():Number
		{
			return _longitude;
		}
	}
}