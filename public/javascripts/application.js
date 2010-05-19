// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Main position is Plaza do Obradoiro (Santiago de Compostela)
MAIN_LAT = 42.880481
MAIN_LNG = -8.545722

var map = null;
var userCoords = new Object();

function initMap() {
    map = new GMap2(document.getElementById('map'));
	map.enableScrollWheelZoom();
	map.addControl(new GLargeMapControl());
	map.addControl(new GMapTypeControl());
}

function createNodeMarkers(nodes) {
    // Add the nodes markers and center the map to show all markers
    var bounds = null;
    var zoom_level = 13;

    for (i = 0; i < nodes.length; i++) {
        nodePoint = createNodeMarker(nodes[i].node);

        if (!bounds) {
            // First time: we set the center and get the bounds
            map.setCenter(nodePoint, zoom_level);
            bounds = map.getBounds();
        }
        else {
            // Bounds already set: extend
            bounds.extend(nodePoint);
        }
    }

    if (bounds) {
        var zoom = map.getBoundsZoomLevel(bounds);
        var center = bounds.getCenter();
        map.setZoom(zoom);
        map.setCenter(center);
    }

    map.savePosition();
}

function getNodeIcon(node) {
	return new GIcon(G_DEFAULT_ICON, '/images/marker_node_type_' + node.node_type + '.png');
}

function createNodeMarker(node) {
  	nodePoint = new GLatLng(node.lat, node.lng);
	nodeIcon = getNodeIcon(node);
	if(nodeIcon){
		marker = new GMarker(nodePoint, {
	  		title: node.title,
	  		icon: nodeIcon
	  	});
	} else {
  		marker = new GMarker(nodePoint, {
  			title: node.title
  		});
  	}
  	marker.node = node;
  	map.addOverlay(marker);
	return nodePoint;
}

function supportNavigatorGeolocation() {
	return navigator.geolocation;
}

function processUserLocation(nodes) {
	navigator.geolocation.getCurrentPosition(function (position) {
		userCoords.lat = position.coords.latitude;
		userCoords.lng = position.coords.longitude;

		userPoint = new GLatLng(userCoords.lat, userCoords.lng);
	    userIcon = new GIcon(G_DEFAULT_ICON, '/images/user_small.png');
	    marker = new GMarker(userPoint, {
	        icon: userIcon
	    });
		marker.isUserPoint=true;
	    map.addOverlay(marker);

		bounds = map.getBounds();
		bounds.extend(userPoint);
		var zoom = map.getBoundsZoomLevel(bounds);
		var center = bounds.getCenter();
		map.setZoom(zoom);
		map.setCenter(center);
		map.savePosition();

	    var nearestNode = null;
	    var nearestDistance = null;

		for (i = 0; i < nodes.length; i++) {
	        nodeDistance = distance(userCoords.lat, userCoords.lng, nodes[i].node.lat, nodes[i].node.lng, "K");

	        if (nodeDistance && (!nearestDistance || nodeDistance < nearestDistance)) {
	            nearestDistance = nodeDistance;
	            nearestNode = nodes[i].node;
	        }
		}
		$('#nearestDistanceSpan').html(nearestDistance + " km.");
		$('#nearestNodeAnchor').attr('href', "javascript:centerMap(" + nearestNode.lat +"," + nearestNode.lng + ")");
		$('#nearestNodeSpan').html(nearestNode.title);
	});
}

function centerMap(lat, lng) {
	map.setCenter(new GLatLng(lat, lng), 15);
}

function defaultInUser() {
	map.setCenter(new GLatLng(MAIN_LAT, MAIN_LNG), 7);
	if(supportNavigatorGeolocation()){
		navigator.geolocation.getCurrentPosition(function (position) {
			userCoords.lat = position.coords.latitude;
			userCoords.lng = position.coords.longitude;

			map.setCenter(new GLatLng(userCoords.lat, userCoords.lng), 15);
			userPoint = new GLatLng(userCoords.lat, userCoords.lng);
		    userIcon = new GIcon(G_DEFAULT_ICON, '/images/user_small.png');
		    marker = new GMarker(userPoint, {
		        icon: userIcon
		    });
			marker.isUserPoint=true;
		    map.addOverlay(marker);
		});
	}
}

function setUserPositionFormFields(form_field_id_lat, form_field_id_lng){
	navigator.geolocation.getCurrentPosition(function (position) {
		userCoords.lat = position.coords.latitude;
		userCoords.lng = position.coords.longitude;

		$(form_field_id_lat).val(userCoords.lat);
		$(form_field_id_lng).val(userCoords.lng);
	});
}

function globalMapClick(overlay, point) {
    if (overlay.isUserPoint || overlay.node) {
        overlay.openInfoWindowHtml(getHtmlInfo(overlay));
    }
}

function showCoordsMapClick(overlay, point) {
    if (overlay.node) {
        overlay.openInfoWindowHtml("<div><strong>GPS:</strong><br/>[" + overlay.node.lat + "," + overlay.node.lng + "]</div>");
    }
}

function getHtmlInfo(overlay) {
    html = "<div class=\"mapInfoWindow\">";
	if(overlay.isUserPoint){
		html += "<div id=\"userLocationInfo\">" + $('#popupUser').html() + "</div>";
	}else{
		node = overlay.node;
	    html += "<b>" + node.title + "</b><br/>";
		if(userCoords.lat){
	    	html += $('#popupPre').html() + distance(userCoords.lat, userCoords.lng, node.lat, node.lng, "K") + " km. " + $('#popupPost').html();
		}
	    html += "<br/><a href=\"/" + LOCALE + "/nodes/" + node.id + "\">"+$('#popupDetails').html()+"</a>";
	}
    html += "</div>";
    return html;
}

function editNodeMapClick(overlay, point) {
    if (overlay) {
        map.removeOverlay(overlay);
        $('#node_lat').val(null);
        $('#node_lng').val(null);
    }
    else {
        map.clearOverlays();
        var marker = new GMarker(point, {
            draggable: true
        });
        GEvent.addListener(marker, "dragend", function(point){
            if (point) {
                setFormGeoInfo(point);
            }
        });
        map.addOverlay(marker);
        setFormGeoInfo(point);
    }
}

function setFormGeoInfo(point) {
    $('#node_lat').val(point.lat());
    $('#node_lng').val(point.lng());

    new GClientGeocoder().getLocations(point, function(response){
        place = response.Placemark[0];
        if (place) {
            $('#address_input').val(place.address);
        }
    });
}

function centerMapInAddress(address) {
    new GClientGeocoder().getLatLng(address, function(point){
        if (!point) {
            alert($('#alertAddressPre').html() + " '" + address + "' " + $('#alertAddressPost').html());
        }
        else {
            map.setCenter(point, 16);
        }
    });
}

function distance(lat1, lon1, lat2, lon2, unit) {
    var radlat1 = Math.PI * lat1 / 180
    var radlat2 = Math.PI * lat2 / 180
    var radlon1 = Math.PI * lon1 / 180
    var radlon2 = Math.PI * lon2 / 180
    var theta = lon1 - lon2
    var radtheta = Math.PI * theta / 180
    var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
    dist = Math.acos(dist)
    dist = dist * 180 / Math.PI
    dist = dist * 60 * 1.1515
    if (unit == "K") {
        dist = dist * 1.609344
    }
    if (unit == "N") {
        dist = dist * 0.8684
    }
    return Math.round(dist * 100) / 100;
}