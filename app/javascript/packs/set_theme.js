import { color } from './theme_color.js' 

const theme = color[gon.theme]
const root = document.documentElement;
for(const property in theme) {
  root.style.setProperty(property, theme[property]);
}