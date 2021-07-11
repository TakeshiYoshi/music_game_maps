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
      cities: cityHash
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
    }
  }
}
</script>

<style lang="scss" scoped>
</style>