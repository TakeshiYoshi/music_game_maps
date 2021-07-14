import MapIconImage from '../images/map_icon.png'

let map;
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
const aryMax = function (a, b) { return Math.max(a, b); }
const aryMin = function (a, b) { return Math.min(a, b); }
let latDelta = latAry.reduce(aryMax) - latAry.reduce(aryMin);
let lngDelta = lngAry.reduce(aryMax) - lngAry.reduce(aryMin);
let latCenter = latDelta/2 + latAry.reduce(aryMin);
let lngCenter = lngDelta/2 + lngAry.reduce(aryMin);

// Zoomレベルを算出
// 算出式 (EarthDiameter/2^zoomLevel) = 表示されるサイズ[km]
// よって zoomLevel = log2(EarthDiameter/表示されるサイズ)
// 緯度1度 = 111.11km
let latDeltaKm = latDelta * 111.11;
let zoomLevel_lat = Math.floor(Math.log(40075/latDeltaKm) / Math.log(2));
// 経度1度 = 111.11km × cos(35°) = 約 91km
let lngDeltaKm = lngDelta * 91;
let zoomLevel_lng = Math.floor(Math.log(40075/lngDeltaKm) / Math.log(2));
// 緯度と経度のzoomLevelを比較し値が小さい方を採用する
let zoomLevel = zoomLevel_lat > zoomLevel_lng ? zoomLevel_lng : zoomLevel_lat;

// Map作成
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