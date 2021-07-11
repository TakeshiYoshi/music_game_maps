<template>
  <div id="form-vue">
    <div class="d-flex align-items-center">
      <div class="select-container">
        <select class="filter-select" name="prefecture" id="prefecture" v-model="selectedPref" @change="getCities(selectedPref)">
          <option v-for="prefecture in prefectures" :key="prefecture.name" :value="prefecture.id">{{prefecture.name}}</option>
        </select>
      </div>
      <div class="select-container">
        <select class="filter-select" name="city" id="city" v-model="selectedCity">
          <option v-for="city in cities" :key="city.name" :value="city.id">{{city.name}}</option>
        </select>
      </div>
    </div>
    <div class="geo-checkbox">
      <input type="checkbox" v-model="isGeoChecked" v-on:change="getGeolocation(isGeoChecked)">
      <p>{{latitude}}</p>
      <p>{{longitude}}</p>
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
      latitude: 0,
      longitude: 0
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
    getGeolocation: function (isGeoChecked) {
      if(isGeoChecked) {
        if (!navigator.geolocation) {
          alert('現在地情報を取得できませんでした')
          return
        }
        const options = {
          enableHighAccuracy: false,
          timeout: 5000,
          maximumAge: 0
        }
        navigator.geolocation.getCurrentPosition(this.success, this.error, options)
      }
    },
    success (position) {
      this.latitude = position.coords.latitude
      this.longitude = position.coords.longitude
    },
    error (error) {
      switch (error.code) {
        case 1: //PERMISSION_DENIED
          alert('位置情報の利用が許可されていません')
          break
        case 2: //POSITION_UNAVAILABLE
          alert('現在位置が取得できませんでした')
          break
        case 3: //TIMEOUT
          alert('タイムアウトになりました')
          break
        default:
          alert('現在位置が取得できませんでした')
          break
      }
    }
  }
}
</script>