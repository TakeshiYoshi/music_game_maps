import Vue from 'vue/dist/vue.esm';

new Vue({
  el: '#edit_profile_form',
  data: {
    nicknameError: '',
    descriptionError: '',
    nicknameField: document.getElementById('userNickname').value,
    descriptionField: document.getElementById('userDescription').value
  },
  methods: {
    nicknameValid: function() {
      this.nicknameNullCheck
      this.nicknameError ? false : this.nicknameValidCheck
    },
    descriptionValid: function() {
      this.descriptionError ? false : this.descriptionValidCheck
    }
  },
  computed: {
    nicknameValidCheck: function() {
      const nicknameReg = /^.{1,30}$/;
      this.nicknameError = nicknameReg.test(this.nicknameField) ? '' : 'ニックネームは1~30文字で入力してください。'
    },
    descriptionValidCheck: function() {
      this.descriptionError = this.descriptionField.length <= 300 ? '' : '自己紹介は300文字以内で入力してください。'
    },
    nicknameNullCheck: function() {
      this.nicknameError = this.nicknameField ? '' : 'ニックネームを入力してください。'
    }
  }
});