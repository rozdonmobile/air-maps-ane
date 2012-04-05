package com.adobe.nativeExtensions.maps
{
	import com.adobe.nativeExtensions.maps.overlays.Marker;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	[Event(name="mapevent_detailbuttonpressed", type="com.adobe.nativeExtensions.maps.MapEvent")]
	[Event(name="mapevent_pinselect",           type="com.adobe.nativeExtensions.maps.MapEvent")]
	[Event(name="mapevent_pindeselect",         type="com.adobe.nativeExtensions.maps.MapEvent")]
	[Event(name="mapevent_maploaderror",        type="com.adobe.nativeExtensions.maps.MapEvent")]
	[Event(name="mapevent_tilesloadedpending",  type="com.adobe.nativeExtensions.maps.MapEvent")]
	[Event(name="mapevent_tilesloaded",         type="com.adobe.nativeExtensions.maps.MapEvent")]
	[Event(name="mapevent_userlocationclick",   type="com.adobe.nativeExtensions.maps.MapEvent")]
	[Event(name="mapevent_userlocationupdate",  type="com.adobe.nativeExtensions.maps.MapEvent")]
	
	[Event(name="mapevent_userlocationerror",   type="com.adobe.nativeExtensions.maps.MapEvent")]
	[Event(name="mapevent_userlocationfail",    type="com.adobe.nativeExtensions.maps.MapEvent")]
	[Event(name="mapevent_userlocationstart",   type="com.adobe.nativeExtensions.maps.MapEvent")]
	[Event(name="mapevent_userlocationstop",    type="com.adobe.nativeExtensions.maps.MapEvent")]

	public class Map extends EventDispatcher
	{
		private var _visible:Boolean;
		private var _viewPort:Rectangle;
		private var _userLocation:Boolean;
		
		private var _overlayVector:Vector.<Marker>;
		private var _userMarker:Marker;
		
		private var	extContext:ExtensionContext=null;
		
		public function Map()
		{
			super();
			trace("asdasa");
			extContext=ExtensionContext.createExtensionContext("com.sampleNativeExtensions.Maps","iMaps");
			extContext.addEventListener(StatusEvent.STATUS,tilesLoadingHandler);
			extContext.call("createMapView");
			
			//Setting the default properties
			_viewPort=extContext.call("getViewPort") as Rectangle;
			_visible=false;
			_userLocation=false;
			_overlayVector = new Vector.<Marker>();
			_userMarker = new Marker(new LatLng(0,0));
		}
		
		private function tilesLoadingHandler(se:StatusEvent):void
		{
			var _marker:Marker;
			
			trace("\tCode:",se.code,"\n\tLevel:",se.level);
			if(se.code=="PIN_SELECTED")
			{
				_marker = getMarkerFromId( int(se.level) );
				this.dispatchEvent(new MapEvent(MapEvent.PIN_SELECTED,_marker));
			}
			else if(se.code=="PIN_DESELECTED")
			{
				_marker = getMarkerFromId( int(se.level) );
				this.dispatchEvent(new MapEvent(MapEvent.PIN_DESELECTED,_marker));
			}
			else if(se.code=="DETAIL_BUTTON_PRESSED")
			{
				_marker = getMarkerFromId( int(se.level) );
				this.dispatchEvent(new MapEvent(MapEvent.DETAIL_BUTTON_PRESSED,_marker));
			}
			else if(se.code=="USER_LOCATION_CLICKED")
			{
				this.dispatchEvent(new MapEvent(MapEvent.USER_LOCATION_CLICKED));
			}
			else if(se.code=="USER_LOCATION_UPDATE")
			{
				var _arr:Array = se.level.split("|");
				trace("Array after split", _arr);
				_userMarker.latLng = new LatLng( Number(_arr[0]),Number(_arr[1]));
				//_userMarker.latLng._latitude  = Number(_arr[0]);
				//_userMarker.latLng._longitude = Number(_arr[1]);
				trace("\t_lat", _userMarker.latLng._latitude);
				trace("\t_lng", _userMarker.latLng._longitude);
				trace("_userMarker", _userMarker);
				this.dispatchEvent(new MapEvent(MapEvent.USER_LOCATION_UPDATE,_userMarker));
			}
			else if(se.code=="USER_LOCATION_FAIL_TO_LOCATE_USER_WITH_ERROR")
			{
				this.dispatchEvent(new MapEvent(MapEvent.USER_LOCATION_FAIL_TO_LOCATE_USER_WITH_ERROR));
			}
			else if(se.code=="USER_LOCATION_FAIL_TO_LOCATE_USER")
			{
				this.dispatchEvent(new MapEvent(MapEvent.USER_LOCATION_FAIL_TO_LOCATE_USER));
			}
			else if(se.code=="USER_LOCATION_UPDATE_STARTED")
			{
				this.dispatchEvent(new MapEvent(MapEvent.USER_LOCATION_UPDATE_STARTED));
			}
			else if(se.code=="USER_LOCATION_UPDATE_STOPPED")
			{
				this.dispatchEvent(new MapEvent(MapEvent.USER_LOCATION_UPDATE_STOPPED));
			}
			else if(se.code=="WillStartLoadingMap")
			{
				this.dispatchEvent(new MapEvent(MapEvent.TILES_LOADED_PENDING));
				trace("Loading Tiles");
			}
			else if(se.code=="DidFinishLoadingMap")
			{
				this.dispatchEvent(new MapEvent(MapEvent.TILES_LOADED));
				trace("Tiles Loaded");
			}
			else if(se.code=="DidFailLoadingMap")
			{
				this.dispatchEvent(new MapEvent(MapEvent.MAP_LOAD_ERROR));
				trace("Map Loading Error");
			}
			else
			{
				this.dispatchEvent(se);
				trace("Unrecognized Error got dispatched from Native Extnesion");
			}
		}
		
		private function getMarkerFromId(markerId:int):Marker
		{
			for each(var _marker:Marker in _overlayVector) {
				if (_marker.myId == markerId) {
					return _marker;
				}
			}
			return null;
		}
		
		/********** New Action Script APIs that doesnt exist in Google Maps, but required for adding/removing/modification on stage**************/
		
		public function get visible():Boolean
		{
			return _visible;
		}
		public function set visible(newValue:Boolean):void
		{
			if(newValue==true)
				extContext.call("showMapView");
			else
				extContext.call("hideMapView");
			_visible=newValue;
		}
		public function get viewPort():Rectangle
		{
			_viewPort=extContext.call("getViewPort") as Rectangle;
			return _viewPort;
		}
		public function set viewPort(newRect:Rectangle):void
		{
			_viewPort=newRect;
			extContext.call("setViewPort",_viewPort);
		}
		//Disposes of the Map object
		public function dispose():void
		{
			extContext.dispose();
		}
		
		/************ Writing Action Script APIs similar in signature to what Google Maps for Flash offers so that minimal change in code is required for reuse ***********/
		public function getSize():Point
		{
			return new Point(_viewPort.width,_viewPort.height);	
		}
		public function setSize(newSize:Point):void
		{
			_viewPort.width=newSize.x;
			_viewPort.height=newSize.y;
			extContext.call("setViewPort",_viewPort);
		}
		
		public function getCenter():LatLng
		{
			var mapCenter:LatLng=extContext.call("getCenter") as LatLng;
			return mapCenter;
		}
		public function setCenter(newCenter:LatLng):void
		{
			if(newCenter.lat()<89.9999 && newCenter.lat()>-89.99 && newCenter.lng()<180.0 && newCenter.lng()>-180.0)
				extContext.call("setCenter",newCenter);
			else
				throw new Error("Latitude and Longitude should be between (-90,90) and [-180,180]",1508);
			
			//Latitude can have a value of -90 and 90 but iOS crashes application on setting the map latitude to -90 or 90 
			//Please contact me [meetshah at adobe.com] if you find a solution to this
		}
		
		public function getZoom():Number
		{
			return extContext.call("getZoom") as Number;
		}
		public function setZoom(newZoomLevel:Number):void
		{
			extContext.call("setZoom",newZoomLevel);
		}
		
		public function panTo(newCenter:LatLng):void
		{
			if(newCenter.lat()<89.9999 && newCenter.lat()>-89.99 && newCenter.lng()<180.0 && newCenter.lng()>-180.0)
				extContext.call("setCenter",newCenter);
			else
				throw new Error("Latitude and Longitude should be between (-90,90) and [-180,180]",1508);
			
			//Latitude can have a value of -90 and 90 but iOS crashes application on setting the map latitude to -90 or 90 
			//Please contact me [meetshah at adobe.com] if you find a solution to this
		}
		
		public function addOverlay(overlay:Marker):void
		{
			_overlayVector.push(overlay);
			extContext.call("addOverlay",overlay);
		}
		public function removeOverlay(overlay:Marker):void
		{
			var overlayIndex:int = _overlayVector.indexOf(overlay);
			if(overlayIndex > -1) {
				_overlayVector.slice(overlayIndex,1);
				extContext.call("removeOverlay",overlay);
			}
		}
		
		public function setMapType(mapType:int):void
		{
			if(mapType<0 || mapType>2)
				throw new Error("Unsupported Map Type By Native Extension",8001);
			else
				extContext.call("setMapType",mapType);
		}
		
		public function set userLocation(showusr:Boolean):void
		{
			_userLocation = showusr;
			var _opt:int = showusr?1:0;
			extContext.call("setUserLocation",_opt);
		}
		public function get userLocation():Boolean
		{
			return _userLocation;
		}
		
		public function zoomToRect(param1:LatLng, param2:LatLng):void
		{
			var _rect:Rectangle = new Rectangle(param1.lat(),param1.lng(),param2.lat(),param2.lng());
			extContext.call("zoomToRect",_rect);
		}
		
		/**
		 * Replaces the default "Current Location" with our custom text.
		 * 
		 * Alpha Version - 
		 * 
		 * @param:String - New title for current location (blue dot).
		 * 
		 */
		public function userLocationText(param:String):void
		{
			var _obj:Object = {userTitle:param};
			extContext.call("setUserLocationText", _obj);
		}
		
		/**
		 * Opens the callout for the marker with coresponding markerId.
		 * Only one callout is possible at a time.
		 * 
		 * @param
		 *     markerId:int - The id of the marker you want to open.
		 * 
		 */
		public function openMarker(markerId:int):void
		{
			extContext.call("openMarker", markerId);
		}
		
		/**
		 * Closes callout for the opened marker.
		 */
		public function closeMarker():void
		{
			extContext.call("closeMarker");
		}
		
		public function drawViewPortToBitmapData(bitmapData:BitmapData):void
		{
			var validCall:Boolean=true;
			if(!bitmapData)
			{
				throw new Error("Null object reference : BitmapData is null",1009);
				validCall=false;
			}
			if(!visible)
			{
				throw new Error("Mapview must be on stage before call to drawViewPortToBitmapData",8002);
				validCall=false;
			}
			
			if(validCall)
				extContext.call("drawViewPortToBitmapData",bitmapData);
			else
				return;
			
		}
		
	}
}