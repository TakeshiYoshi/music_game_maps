import { color } from './theme_color.js' 

let themeName = gon.theme == '' ? 'normal' : gon.theme;
const theme = color[themeName]
const root = document.documentElement;
for(const property in theme) {
  root.style.setProperty(property, theme[property]);
}