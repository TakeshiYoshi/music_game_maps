import MapIconImage from '../images/map_icon.png'

let shopsLatAndLng = JSON.parse(gon.shops_lat_and_lng);

// オブジェクトから緯度経度の配列を作成
let latAry = [];
let lngAry = [];
Object.keys(shopsLatAndLng).forEach(function (key) {
  latAry.push(parseFloat(shopsLatAndLng[key].lat));
  lngAry.push(parseFloat(shopsLatAndLng[key].lng));
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
Object.keys(shopsLatAndLng).forEach(function (key) {
  let mapIcon = L.divIcon({
    className: 'map-icon-container',
    html: '<a href="#shop-' + shopsLatAndLng[key].id + '">' +
          '<img src="' + MapIconImage + '" style="width:50px; height:52.5px;">' +
          '<span class="map-icon-text">' + (Number(key) + 1) + '</span>' +
          '</a>',
    iconSize: [50, 52.5],
    iconAnchor: [25, 52.5],
    popupAnchor: [0, -52.5],
  });
  L.marker([parseFloat(shopsLatAndLng[key].lat), parseFloat(shopsLatAndLng[key].lng)],{ icon: mapIcon }).addTo(map);
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

// 以下初期処理
// window.onloadが何故か動かないため直書きしてます
// 現在位置が取得されていたら現在地マーカーを表示する
if(gon.location != null) {
  own = L.marker(gon.location).addTo(map);
}
// 中心位置初期設定
inputCenterPos();