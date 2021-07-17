import MapIconImage from '../images/map_icon.png'

let shopsLatAndLon = document.getElementById('shops-lat-and-lng');
let shopsLatAndLonObject = JSON.parse(shopsLatAndLon.getAttribute('data-shops-lat-and-lng'));

// オブジェクトから緯度経度の配列を作成
let latAry = [];
let lngAry = [];
Object.keys(shopsLatAndLonObject).forEach(function (key) {
  latAry.push(parseFloat(shopsLatAndLonObject[key].lat));
  lngAry.push(parseFloat(shopsLatAndLonObject[key].lng));
});

// Mapの中央座標を算出
let latCenter = calculateCenter(latAry);
let lngCenter = calculateCenter(lngAry);

// ZoomLevelを算出
let zoomLevel = calculateZoomLevel(latAry, lngAry);

// OpenStreetMap生成
let own = null; // 現在地のピン
let map = L.map('map', {
  center: [latCenter, lngCenter],
  zoom: zoomLevel,
});
let tileLayer = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
  attribution: '© <a href="http://osm.org/copyright">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
});
tileLayer.addTo(map);
Object.keys(shopsLatAndLonObject).forEach(function (key) {
  let mapIcon = L.divIcon({
    className: 'map-icon-container',
    html: '<a href="#shop-' + shopsLatAndLonObject[key].id + '">' +
          '<img src="' + MapIconImage + '" style="width:50px; height:52.5px;">' +
          '<span class="map-icon-text">' + (Number(key) + 1) + '</span>' +
          '</a>',
    iconSize: [50, 52.5],
    iconAnchor: [25, 52.5],
    popupAnchor: [0, -52.5],
  });
  L.marker([parseFloat(shopsLatAndLonObject[key].lat), parseFloat(shopsLatAndLonObject[key].lng)],{ icon: mapIcon }).addTo(map);
});

// マップが動いたら中心座標を出力
map.on('move', function(e) {
  inputCenterPos();
});

function inputCenterPos() {
  let centerPos = map.getCenter();
  document.getElementById('map-lat').value = centerPos.lat;
  document.getElementById('map-lng').value = centerPos.lng;
};

let addGeoLocationMarker = (location) => {
  // 古いマーカーを削除
  if(own != null) {
    map.removeLayer(own);
  };
  // マーカーを生成
  own = L.marker(location).addTo(map);
  // ビューを変更する
  let latAryLocal = latAry;
  let lngAryLocal = lngAry;
  latAryLocal.push(location[0]);
  lngAryLocal.push(location[1]);
  let latCenter = calculateCenter(latAryLocal);
  let lngCenter = calculateCenter(lngAryLocal);
  let zoomLevel = calculateZoomLevel(latAryLocal, lngAryLocal);
  map.setView([latCenter, lngCenter], zoomLevel);
};
let getMapCenter = () => {
  let centerPosition = map.getCenter();
  return centerPosition;
}
window.globalFunction = {};
window.getMapCenter = {};
window.globalFunction.addGeoLocationMarker = addGeoLocationMarker;
window.globalFunction.getMapCenter = getMapCenter;

function calculateDelta(ary) {
  const aryMax = function (a, b) { return Math.max(a, b); }
  const aryMin = function (a, b) { return Math.min(a, b); }
  let delta = ary.reduce(aryMax) - ary.reduce(aryMin);
  return delta;
}

function calculateCenter(ary) {
  const aryMin = function (a, b) { return Math.min(a, b); }
  let delta = calculateDelta(ary);
  let center = delta/2 + ary.reduce(aryMin);
  return center;
};

function calculateZoomLevel(latAry, lngAry) {
  // Zoomレベルを算出
  // 算出式 (EarthDiameter/2^zoomLevel) = 表示されるサイズ[km]
  // よって zoomLevel = log2(EarthDiameter/表示されるサイズ)
  // 緯度1度 = 111.11km
  let latDelta = calculateDelta(latAry);
  let latDeltaKm = latDelta * 111.11;
  let zoomLevel_lat = Math.round(Math.log(40075/latDeltaKm) / Math.log(2));
  // 経度1度 = 111.11km × cos(35°) = 約 91km
  let lngDelta = calculateDelta(lngAry);
  let lngDeltaKm = lngDelta * 91;
  let zoomLevel_lng = Math.round(Math.log(40075/lngDeltaKm) / Math.log(2));
  // 緯度と経度のzoomLevelを比較し値が小さい方を採用する
  let zoomLevel = zoomLevel_lat > zoomLevel_lng ? zoomLevel_lng : zoomLevel_lat;
  zoomLevel = zoomLevel > 15 ? 15 : zoomLevel;
  return zoomLevel;
};

// 以下GoogleMaps
/*
// Map作成
let map;
let marker = [];
function initMap() {
  map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: latCenter, lng: lngCenter },
    zoom: zoomLevel,
  });
  Object.keys(shopsLatAndLonObject).forEach(function (key) {
    marker[key] = new google.maps.Marker({
      position: {
        lat: parseFloat(shopsLatAndLonObject[key].lat),
        lng: parseFloat(shopsLatAndLonObject[key].lng)
      },
      icon: {
        url: MapIconImage,
        scaledSize: new google.maps.Size(50, 52.5)
      },
      label: {
        text: String(Number(key) + 1),
        fontSize: '20px',
        fontWeight: '900',
        fontFamily: "LEMONMILK-BOLD",
        color: '#666666'
      },
      map: map
    });
    let url = '#shop-' + shopsLatAndLonObject[key].id;
    google.maps.event.addListener(marker[key], 'click', (function(url){
      return function(){ location.href = url; };
    })(url));
  });
}
window.onload = function () {
  initMap();
}
*/