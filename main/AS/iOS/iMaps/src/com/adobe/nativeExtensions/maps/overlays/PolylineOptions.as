package com.adobe.nativeExtensions.maps.overlays
{

	public class PolylineOptions
	{
		private var _strokeColor:uint=0x000000; 
		public function PolylineOptions(strokecolor:uint)
		{
			_strokeColor=strokecolor;
		}
		
		public function get strokeColor():uint
		{
			return _strokeColor;
		}
	}
}