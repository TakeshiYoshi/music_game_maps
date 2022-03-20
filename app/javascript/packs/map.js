import MapIconImage from '../images/map_icon.png'

let latAry = [];
let lngAry = [];
let mapIcons = [];
let shopsLatAndLng = JSON.parse(gon.shops_lat_and_lng);

// 店舗の緯度経度情報取得
setShopsData(shopsLatAndLng);

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

putMapIcons(shopsLatAndLng);

// マップが動いたら中心座標を出力
map.on('move', function (e) {
  inputCenterPos();
});

// マップピンの再生成
const rePutMapIcons = (shopsJson) => {
  setShopsData(shopsJson);
  removeMarkers(mapIcons);
  putMapIcons(shopsJson);
}

// マップピンを生成
function putMapIcons(shopsJson) {
  shopsJson.map((shopJson, index) => {
    let mapIcon = L.divIcon({
      className: 'map-icon-container',
      html: '<a href="#shop-' + shopJson.id + '">' +
        '<img src="' + MapIconImage + '" style="width:50px; height:52.5px;">' +
        '<span class="map-icon-text">' + (Number(index) + 1) + '</span>' +
        '</a>',
      iconSize: [50, 52.5],
      iconAnchor: [25, 52.5],
      popupAnchor: [0, -52.5],
    });
    const marker = L.marker([parseFloat(shopJson.lat), parseFloat(shopJson.lng)], { icon: mapIcon }).addTo(map);
    mapIcons.push(marker);
  })
}

// 指定したピンを削除
function removeMarkers(markers) {
  markers.map((marker) => {
    map.removeLayer(marker)
  })
}

// 緯度経度の配列を作成
function setShopsData(shopsJson) {
  shopsJson.map((shop) => {
    latAry.push(parseFloat(shop.lat));
    lngAry.push(parseFloat(shop.lng));
  })
};

function inputCenterPos() {
  let centerPos = map.getCenter();
  document.getElementById('map-lat').value = centerPos.lat;
  document.getElementById('map-lng').value = centerPos.lng;
};

let addGeoLocationMarker = (location) => {
  // 古いマーカーを削除
  if (own != null) {
    map.removeLayer(own);
  };
  // マーカーを生成
  createOwnMaker(location);
};

let focusAllMarker = (location) => {
  // ビューを変更する
  let latAryLocal = latAry;
  let lngAryLocal = lngAry;
  latAryLocal.push(location[0]);
  lngAryLocal.push(location[1]);
  let latCenter = calculateCenter(latAryLocal);
  let lngCenter = calculateCenter(lngAryLocal);
  let zoomLevel = calculateZoomLevel(latAryLocal, lngAryLocal);
  map.setView([latCenter, lngCenter], zoomLevel);
}


let focusCurrentPosition = (location) => {
  map.setView(location, 16);
};

function createOwnMaker(location) {
  // マーカーを生成
  let mapIcon = L.divIcon({
    className: 'own-icon',
    iconSize: [30, 30],
    iconAnchor: [15, 15],
    popupAnchor: [0, -15],
  });
  own = L.marker(location, { icon: mapIcon }).addTo(map);
};


let getMapCenter = () => {
  let centerPosition = map.getCenter();
  return centerPosition;
}

window.globalFunction = {};
window.getMapCenter = {};
window.globalFunction.addGeoLocationMarker = addGeoLocationMarker;
window.globalFunction.focusAllMarker = focusAllMarker;
window.globalFunction.getMapCenter = getMapCenter;
window.globalFunction.focusCurrentPosition = focusCurrentPosition;
window.globalFunction.rePutMapIcons = rePutMapIcons;

function calculateDelta(ary) {
  const aryMax = function (a, b) { return Math.max(a, b); }
  const aryMin = function (a, b) { return Math.min(a, b); }
  let delta = ary.reduce(aryMax) - ary.reduce(aryMin);
  return delta;
}

function calculateCenter(ary) {
  const aryMin = function (a, b) { return Math.min(a, b); }
  let delta = calculateDelta(ary);
  let center = delta / 2 + ary.reduce(aryMin);
  return center;
};

function calculateZoomLevel(latAry, lngAry) {
  // Zoomレベルを算出
  // 算出式 (EarthDiameter/2^zoomLevel) = 表示されるサイズ[km]
  // よって zoomLevel = log2(EarthDiameter/表示されるサイズ)
  // 緯度1度 = 111.11km
  let latDelta = calculateDelta(latAry);
  let latDeltaKm = latDelta * 111.11;
  let zoomLevel_lat = Math.round(Math.log(40075 / latDeltaKm) / Math.log(2));
  // 経度1度 = 111.11km × cos(35°) = 約 91km
  let lngDelta = calculateDelta(lngAry);
  let lngDeltaKm = lngDelta * 91;
  let zoomLevel_lng = Math.round(Math.log(40075 / lngDeltaKm) / Math.log(2));
  // 緯度と経度のzoomLevelを比較し値が小さい方を採用する
  let zoomLevel = zoomLevel_lat > zoomLevel_lng ? zoomLevel_lng : zoomLevel_lat;
  zoomLevel = zoomLevel > 15 ? 15 : zoomLevel;
  return zoomLevel;
};

// 以下初期処理
// window.onloadが何故か動かないため直書きしてます
// 現在位置が取得されていたら現在地マーカーを表示する
if (gon.location != null) {
  createOwnMaker(gon.location)
}
// 中心位置初期設定
inputCenterPos();