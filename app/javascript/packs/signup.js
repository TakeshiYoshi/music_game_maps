import Vue from 'vue/dist/vue.esm';

new Vue({
  el: '#signup_form',
  data: {
    emailError: '',
    passwordError: '',
    passwordConfirmationError: '',
    nicknameError: '',
    emailField: '',
    passwordField: '',
    passwordConfirmationField: '',
    nicknameField: ''
  },
  methods: {
    emailValid: function() {
      this.emailNullCheck
      this.emailError ? false : this.emailValidCheck
    },
    passwordValid: function() {
      this.passwordNullCheck
      this.passwordError ? false : this.passwordValidCheck
    },
    passwordConfirmationValid: function() {
      this.passwordConfirmationNullCheck
      this.passwordConfirmationError ? false : this.passwordConfirmationValidCheck
    },
    nicknameValid: function() {
      this.nicknameNullCheck
      this.nicknameError ? false : this.nicknameValidCheck
    }
  },
  computed: {
    emailValidCheck: function() {
      const emailReg = /^[a-zA-Z0-9_.+-]+@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}$/;
      this.emailError = emailReg.test(this.emailField) ? '' : 'メールアドレスを正しく入力してください。'
    },
    passwordValidCheck: function() {
      const passwordReg = /^(?=.*?[a-z])(?=.*?[A-Z])[a-zA-Z\d!?_\.$&%\-]{8,30}$/;
      this.passwordError = passwordReg.test(this.passwordField) ? '' : 'パスワードを正しく入力してください。'
    },
    passwordConfirmationValidCheck: function() {
      this.passwordConfirmationError = this.passwordField == this.passwordConfirmationField ? '' : '同じパスワードを入力してください。'
    },
    nicknameValidCheck: function() {
      const nicknameReg = /^.{1,30}$/;
      this.nicknameError = nicknameReg.test(this.nicknameField) ? '' : 'ニックネームは1~30文字で入力してください。'
    },
    emailNullCheck: function() {
      this.emailError = this.emailField ? '' : 'メールアドレスを入力してください。'
    },
    passwordNullCheck: function() {
      this.passwordError = this.passwordField ? '' : 'パスワードを入力してください。'
    },
    passwordConfirmationNullCheck: function() {
      this.passwordConfirmationError = this.passwordConfirmationField ? '' : 'パスワード再入力を入力してください。'
    },
    nicknameNullCheck: function() {
      this.nicknameError = this.nicknameField ? '' : 'ニックネームを入力してください。'
    },
  }
});