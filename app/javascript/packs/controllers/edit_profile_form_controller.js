import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-profile-form"
export default class extends Controller {
  connect() {
    this.validations = {
      'userNickname': [
        {
          'reg': /^[\s\S]{1,30}$/,
          'errorMessage': 'ニックネームは1~30文字で入力してください。'
        }
      ],
      'userDescription': [
        {
          'reg': /^[\s\S]{0,300}$/,
          'errorMessage': '自己紹介は300文字以内で入力してください。'
        }
      ]
    }
    this.nullChecks = {
      'userNickname': 'ニックネームを入力してください。'
    }
  }

  validation(e) {
    let value = e.target.value;
    const id = e.target.id;
    const errorNode = document.getElementById(`${id}Error`);

    // バリデーションエラー
    this.validations[id].map((valid) => {
      if (valid['reg'].test(value)) {
        errorNode.textContent = '';
        e.target.classList.remove('basic-error-field');
      } else {
        errorNode.textContent = valid['errorMessage'];
        e.target.classList.add('basic-error-field');
      }
    })

    // NullCheck
    if (this.nullChecks[id]) {
      if (value.length === 0) {
        errorNode.textContent = this.nullChecks[id];
        e.target.classList.add('basic-error-field');
      }
    }
  }

  imagePreview(e) {
    const id = e.target.dataset.previewId;
    const file = e.target.files[0];
    const url = window.URL.createObjectURL(file);
    document.getElementById(id).src = url;
  }
}
