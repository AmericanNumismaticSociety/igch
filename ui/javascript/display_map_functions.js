$(document).ready(function () {
	$('a.thumbImage').fancybox({
		beforeShow: function () {
			this.title = '<a href="' + this.element.attr('id') + '">' + this.element.attr('title') + '</a>'
		},
		helpers: {
			title: {
				type: 'inside'
			}
		}
	});
	
	var id = $('title').attr('id');
	initialize_map(id);
});

function initialize_map(id) {
	var mapboxKey = $('#mapboxKey').text();
	
	var mb_physical = L.tileLayer(
	'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=' + mapboxKey, {
		attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
		'<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
		'Imagery © <a href="http://mapbox.com">Mapbox</a>', id: 'mapbox.streets', maxZoom: 10
	});
	
	var imperium = L.tileLayer(
	'http://dare.ht.lu.se/tiles/imperium/{z}/{x}/{y}.png', {
		maxZoom: 12,
		attribution: 'Powered by <a href="http://leafletjs.com/">Leaflet</a>. Map base: <a href="http://dare.ht.lu.se/" title="Digital Atlas of the Roman Empire, Department of Archaeology and Ancient History, Lund University, Sweden">DARE</a>, 2015 (cc-by-sa).'
	});
	
	var map = new L.Map('mapcontainer', {
		center: new L.LatLng(0, 0),
		zoom: 4,
		layers:[mb_physical]
	});
	
	//add mintLayer from AJAX
	var overlay = L.geoJson.ajax(id + '.geojson', {
		onEachFeature: onEachFeature,
		pointToLayer: renderPoints
	}).addTo(map);
	
	//add controls
	var baseMaps = {
		"Streets": mb_physical,
		"Imperium": imperium
	};
	
	var overlayMaps = {
		"Distribution": overlay
	};
	
	L.control.layers(baseMaps, overlayMaps).addTo(map);
	
	//zoom to extend on Ajax loaded
	overlay.on('data:loaded', function () {
		map.fitBounds(overlay.getBounds());
	}.bind(this));
	
	/*****
	 * Features for manipulating layers
	 *****/
	function renderPoints(feature, latlng) {
		var fillColor;
		switch (feature.properties.type) {
			case 'mint':
			fillColor = '#6992fd';
			break;
			case 'findspot':
			fillColor = '#d86458';
		}
		
		return new L.CircleMarker(latlng, {
			radius: 5,
			fillColor: fillColor,
			color: "#000",
			weight: 1,
			opacity: 1,
			fillOpacity: 0.6
		});
	}
	
	function onEachFeature (feature, layer) {
		var str;
		if (feature.properties.hasOwnProperty('uri') == false) {
			str = feature.properties.name;
		} else {
			str = feature.properties.name + ' <a href="' + feature.properties.uri + '" target="_blank"><span class="glyphicon glyphicon-new-window"/></a>';
		}
		layer.bindPopup(str);
	}
}