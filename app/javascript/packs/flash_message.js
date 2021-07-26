let flashMessage = document.getElementById('flash-message');
let showFlag = document.getElementById('flash-check');

if(flashMessage) {
  show_message(flashMessage.textContent);
};

function show_message(message) {
  flashMessage.textContent = message;
  showFlag.checked = true;
  setTimeout( () => { showFlag.checked = false }, 5000 )
};