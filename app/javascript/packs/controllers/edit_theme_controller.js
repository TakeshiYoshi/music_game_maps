import { Controller } from "@hotwired/stimulus"
import { color } from '../theme_color'

// Connects to data-controller="edit-theme"
export default class extends Controller {
  connect() {
    this.getCsrfToken = () => {
      const metas = document.getElementsByTagName('meta');
      for (let meta of metas) {
        if (meta.getAttribute('name') === 'csrf-token') {
          return meta.getAttribute('content');
        }
      }
      return '';
    }
  }

  updateTheme(e) {
    const themeName = e.target.classList[1];

    this.changeTheme(themeName);
    this.setTheme(themeName);
  }

  changeTheme(themeName) {
    const theme = color[themeName]
    const root = document.documentElement;
    const check = document.getElementById('bg-color-check');
    for (const property in theme) {
      if (property == '--bg-end') {
        continue;
      }
      if (property == '--bg-start') {
        // 以下背景色のアニメーション処理
        // アニメーション用グラデーションの設定
        root.style.setProperty('--bg-start-changing', theme['--bg-start']);
        root.style.setProperty('--bg-end-changing', theme['--bg-end']);
        // アニメーション開始
        check.checked = true;
        // 1秒後にアニメーション終了処理
        setTimeout(() => {
          root.style.setProperty('--bg-start', theme['--bg-start']);
          root.style.setProperty('--bg-end', theme['--bg-end']);
          check.checked = false;
        }, 301)
      } else {
        root.style.setProperty(property, theme[property]);
      }
    }
  }

  setTheme(themeName) {
    // Rails側にセッションとして記録
    fetch('/theme', {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': this.getCsrfToken()
      },
      body: JSON.stringify({
        user: {
          theme: themeName
        }
      })
    })
  }
}
