<template>
  <div id="geolocationButton">
    <button class="update-geo-button" id="update-geo-button" @click="getGeolocation()">
      <div class="icon-container" :class="{ 'icon-blue': isGeoChecked }">
        <i class="fas fa-crosshairs"></i>
      </div>
    </button>
  </div>
</template>

<script>
import Export from "./packs/map_flash_message"
import axios from 'axios'

// CSRFトークン作成
axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default {
  data: function () {
    return {
      isGeoChecked: gon.location,
      isDialogChecked: false,
      geoMessage: ''
    }
  },
  methods: {
    getGeolocation: function() {
      if (!navigator.geolocation) {
        Export.show_message('現在位置が取得できませんでした')
        return
      }
      const options = {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0
      }
      Export.show_message('現在位置情報を取得しています...');
      navigator.geolocation.getCurrentPosition(this.success, this.error, options)
    },
    success: function(position) {
      this.latitude = position.coords.latitude
      this.longitude = position.coords.longitude
      this.isGeoChecked = true;
      // Rails側にセッションとして記録
      axios
        .post('/set_location', {
        lat: this.latitude,
        lng: this.longitude
        })
        .then((response) => {
          this.cities = response.data
          window.globalFunction.addGeoLocationMarker([this.latitude, this.longitude]);
          Export.show_message('現在位置を取得しました');
        })
    },
    error: function(error) {
      switch (error.code) {
        case 1: // PERMISSION_DENIED
          Export.show_message('位置情報の利用が許可されていません')
          break
        case 2: // POSITION_UNAVAILABLE
          Export.show_message('現在位置が取得できませんでした')
          break
        case 3: // TIMEOUT
          Export.show_message('タイムアウトになりました')
          break
        default:
          Export.show_message('現在位置が取得できませんでした')
          break
      }
    }
  }
}
</script>

<style lang="scss" scoped>
</style>