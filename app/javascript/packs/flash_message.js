let flashMessage = document.getElementById('flash-message');
const dialog = document.getElementById('mainFlashMessageDialog');

if (flashMessage) {
  show_message(flashMessage.textContent);
};

function show_message(message) {
  flashMessage.textContent = message;
  dialog.classList.add('display');
  setTimeout(() => { dialog.classList.remove('display') }, 5000)
};