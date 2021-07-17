<template>
  <div id="geolocationButton">
    <input class="d-none" type="checkbox" id="dialog-check" v-model="isDialogChecked">
    <div class="map-message-dialog blur">
      <p>{{geoMessage}}</p>
    </div>
    <button class="update-geo-button" @click="getGeolocation()">
      <div class="icon-container" :class="{ 'icon-blue': isGeoChecked }">
        <i class="fas fa-crosshairs"></i>
      </div>
    </button>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      isGeoChecked: false,
      isDialogChecked: false,
      geoMessage: ''
    }
  },
  methods: {
    getGeolocation: function() {
      if (!navigator.geolocation) {
        this.setGeoMessage('現在位置が取得できませんでした')
        return
      }
      const options = {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0
      }
      this.setGeoMessage('現在位置情報を取得しています...')
      navigator.geolocation.getCurrentPosition(this.success, this.error, options)
    },
    success: function(position) {
      this.latitude = position.coords.latitude
      this.longitude = position.coords.longitude
      this.isGeoChecked = true;
      window.globalFunction.addGeoLocationMarker([this.latitude, this.longitude]);
      this.setGeoMessage('現在位置を取得しました')
    },
    error: function(error) {
      switch (error.code) {
        case 1: // PERMISSION_DENIED
          this.setGeoMessage('位置情報の利用が許可されていません')
          break
        case 2: // POSITION_UNAVAILABLE
          this.setGeoMessage('現在位置が取得できませんでした')
          break
        case 3: // TIMEOUT
          this.setGeoMessage('タイムアウトになりました')
          break
        default:
          this.setGeoMessage('現在位置が取得できませんでした')
          break
      }
    },
    setGeoMessage: function(message) {
      this.geoMessage = message;
      this.isDialogChecked = true;
      setTimeout( () => { this.isDialogChecked = false }, 3000 )
    }
  }
}
</script>

<style lang="scss" scoped>
</style>