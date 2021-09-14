require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap"
import "../stylesheets/application";
import '@fortawesome/fontawesome-free/js/all';

const images = require.context('../images', true)
const imagePath = (name) => images(name, true)