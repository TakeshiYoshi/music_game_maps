<template>
  <div id="form-vue">
    <div class="d-flex align-items-center">
      <div class="select-container" :class="{ disabled: isGeoChecked }">
        <select class="filter-select" name="prefecture" id="prefecture" v-model="selectedPref" @change="getCities(selectedPref)" :disabled="isGeoChecked">
          <option v-for="prefecture in prefectures" :key="prefecture.name" :value="prefecture.id">{{prefecture.name}}</option>
        </select>
      </div>
      <div class="select-container" :class="{ disabled: isGeoChecked }">
        <select class="filter-select" name="city" id="city" v-model="selectedCity" :disabled="isGeoChecked">
          <option v-for="city in cities" :key="city.name" :value="city.id">{{city.name}}</option>
        </select>
      </div>
    </div>
    <div class="geo-checkbox">
      <input type="checkbox" id="geo-check" v-model="isGeoChecked" v-on:change="getGeolocation(isGeoChecked)">
      <label for="geo-check">現在位置周辺を検索する</label>
      <span class="geo-message" :hidden="!isGeoChecked">{{geoMessage}}</span>
      <input type="hidden" name="latitude" :value="latitude">
      <input type="hidden" name="longitude" :value="longitude">
    </div>
  </div>
</template>

<script>
import axios from 'axios'

// CSRFトークン作成
axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default {
  data: function () {
    return {
      selectedPref: filterHash.prefecture_id,
      selectedCity: filterHash.city_id,
      prefectures: prefHash,
      cities: cityHash,
      isGeoChecked: false,
      latitude: null,
      longitude: null,
      geoMessage: ''
    }
  },
  methods: {
    getCities: function(selectedPref) {
      axios
        .post('/cities', {
        id: selectedPref
        })
        .then((response) => {
          this.cities = response.data
        })
    },
    getGeolocation: function(isGeoChecked) {
      if(isGeoChecked) {
        if (!navigator.geolocation) {
          this.setMessage('現在位置が取得できませんでした')
          return
        }
        const options = {
          enableHighAccuracy: false,
          timeout: 5000,
          maximumAge: 0
        }
        navigator.geolocation.getCurrentPosition(this.success, this.error, options)
        this.geoMessage = '現在位置を取得中です...'
      }
    },
    success: function(position) {
      this.latitude = position.coords.latitude
      this.longitude = position.coords.longitude
      this.setMessage('現在位置を取得中しました')
    },
    error: function(error) {
      switch (error.code) {
        case 1: // PERMISSION_DENIED
          this.setMessage('位置情報の利用が許可されていません')
          break
        case 2: // POSITION_UNAVAILABLE
          this.setMessage('現在位置が取得できませんでした')
          break
        case 3: // TIMEOUT
          this.setMessage('タイムアウトになりました')
          break
        default:
          this.setMessage('現在位置が取得できませんでした')
          break
      }
    },
    setMessage: function(message) {
      this.geoMessage = message
      setTimeout( () => { this.geoMessage = '' }, 3000 )
    }
  }
}
</script>

<style lang="scss" scoped>
</style>