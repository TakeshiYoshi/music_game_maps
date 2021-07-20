let flashMessage = document.getElementById('map-flash-message');
let showFlag = document.getElementById('dialog-check');

window.onload = function() {
  if(flashMessage.textContent.length != 0) {
    show_message(flashMessage.textContent);
  };
};

function show_message(message) {
  flashMessage.textContent = message;
  showFlag.checked = true;
  setTimeout( () => { showFlag.checked = false }, 3000 )
};

export default {
  show_message
};