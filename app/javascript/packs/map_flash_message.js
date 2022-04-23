const flashMessage = document.getElementsByClassName('map-message-dialog')[0]

function show_message(message) {
  flashMessage.textContent = message;
  // フェードインアニメーション
  flashMessage.classList.add('display');
  // 5秒でフェードアウトアニメーション
  setTimeout(() => {
    flashMessage.classList.remove('display');
  }, 5000);
};

export default {
  show_message
};