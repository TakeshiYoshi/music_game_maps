import Vue from 'vue/dist/vue.esm';

new Vue({
  el: '#password_reset_form',
  data: {
    passwordError: '',
    passwordConfirmationError: '',
    passwordField: document.getElementById('userPassword').value,
    passwordConfirmationField: document.getElementById('userPasswordConfirmation').value
  },
  methods: {
    passwordValid: function() {
      this.passwordNullCheck
      this.passwordError ? false : this.passwordValidCheck
    },
    passwordConfirmationValid: function() {
      this.passwordConfirmationNullCheck
      this.passwordConfirmationError ? false : this.passwordConfirmationValidCheck
    }
  },
  computed: {
    passwordValidCheck: function() {
      const passwordReg = /^(?=.*?[a-z])(?=.*?[A-Z])[a-zA-Z\d!?_\.$&%\-]{8,30}$/;
      this.passwordError = passwordReg.test(this.passwordField) ? '' : '大文字, 小文字英数を含む8~30文字で入力してください。'
    },
    passwordConfirmationValidCheck: function() {
      this.passwordConfirmationError = this.passwordField == this.passwordConfirmationField ? '' : '同じパスワードを入力してください。'
    },
    passwordNullCheck: function() {
      this.passwordError = this.passwordField ? '' : 'パスワードを入力してください。'
    },
    passwordConfirmationNullCheck: function() {
      this.passwordConfirmationError = this.passwordConfirmationField ? '' : 'パスワード再入力を入力してください。'
    },
  }
});