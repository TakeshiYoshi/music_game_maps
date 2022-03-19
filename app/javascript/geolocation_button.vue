<template>
  <div id="geolocationButton">
    <button
      class="update-geo-button"
      id="update-geo-button"
      @click="onGeoButton()"
    >
      <div class="icon-container" :class="{ 'icon-blue': isGeoChecked }">
        <i class="fas fa-crosshairs"></i>
      </div>
    </button>
  </div>
</template>

<script>
import Export from "./packs/map_flash_message";
import axios from "axios";

// CSRFトークン作成
axios.defaults.headers.common = {
  "X-Requested-With": "XMLHttpRequest",
  "X-CSRF-TOKEN": document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content"),
};

export default {
  data: function () {
    return {
      isGeoChecked: gon.location,
      isDialogChecked: false,
      geoMessage: "",
      latitude: gon.location ? gon.location[0] : "",
      longitude: gon.location ? gon.location[1] : "",
      intervalFunction: null,
      getMode: true,
    };
  },
  mounted: function () {
    this.getMode = "first";
    this.getGeolocation();
    if (this.isGeoChecked) {
      // 現在位置の取得がオンになっていたら５秒に1度現在地の更新を行う。
      // 頻繁に更新をするためRails側でセッションは作成せず地図のマーカーの位置のみを変更する。
      this.intervalFunction = setInterval(this.updateLocation, 5000);
    }
  },
  methods: {
    updateLocation: function () {
      if (this.isGeoChecked) {
        this.getMode = "auto";
        this.getGeolocation();
      }
    },
    onGeoButton: function () {
      this.getMode = "button";
      this.getGeolocation();
      if (this.isGeoChecked) {
        // 2回目以降に現在地取得をする場合は現在地のズームを行う
        this.focusCurrentPosition();
      }
    },
    getGeolocation: function () {
      // getMode: button=>現在位置取得ボタンを押した時の挙動, atLoad=>画面ロード時の挙動
      if (!navigator.geolocation) {
        Export.show_message("現在位置が取得できませんでした");
        return;
      }
      const options = {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0,
      };
      if (this.getMode == "button") {
        Export.show_message("現在位置情報を取得しています...");
      }
      navigator.geolocation.getCurrentPosition(
        this.success,
        this.error,
        options
      );
    },
    success: function (position) {
      this.latitude = position.coords.latitude;
      this.longitude = position.coords.longitude;
      if (
        this.getMode == "button" ||
        this.getMode == "first" ||
        !this.isGeoChecked
      ) {
        // Rails側にセッションとして記録
        axios
          .post("/set_location", {
            lat: this.latitude,
            lng: this.longitude,
          })
          .then(() => {
            if (
              this.getMode == "first" &&
              !gon.isSearchByMapMode &&
              this.isCloserThanBefore
            ) {
              // 現在位置の取得がオンかつマップ検索されていないかつ以前取得した位置情報と比べ1km以上離れている場合
              // ページリロードを実行
              location.reload();
            }
            if (this.getMode == "button") {
              Export.show_message("現在位置を取得しました");
            }
          });
      }
      window.globalFunction.addGeoLocationMarker([
        this.latitude,
        this.longitude,
      ]);
      if (!this.isGeoChecked) {
        // 初回の現在位置取得の場合は地図のズームを変更し全マーカーを表示する
        window.globalFunction.focusAllMarker([this.latitude, this.longitude]);
        this.isGeoChecked = true;
      }
    },
    error: function (error) {
      if (this.getMode == "button") {
        switch (error.code) {
          case 1: // PERMISSION_DENIED
            Export.show_message("位置情報の利用が許可されていません");
            break;
          case 2: // POSITION_UNAVAILABLE
            Export.show_message("現在位置が取得できませんでした");
            break;
          case 3: // TIMEOUT
            Export.show_message("タイムアウトになりました");
            break;
          default:
            Export.show_message("現在位置が取得できませんでした");
            break;
        }
      }
    },
    focusCurrentPosition: function () {
      window.globalFunction.focusCurrentPosition([
        this.latitude,
        this.longitude,
      ]);
    },
  },
  computed: {
    isCloserThanBefore: function () {
      // 日本の場合経度は1度=約80kmであるがここでは1度約100kmとして計算
      return (
        Math.abs(gon.location[0] - this.latitude) >= 0.01 ||
        Math.abs(gon.location[1] - this.longitude) >= 0.01
      );
    },
  },
};
</script>

<style lang="scss" scoped>
</style>