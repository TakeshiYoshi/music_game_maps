<template>
  <div id="editTheme">
    <div class="theme-container">
      <div class="d-flex" style="margin-bottom: 5px;">
        <div class="theme-button normal" @click="updateTheme('normal')"></div>
        <div class="theme-button dark" @click="updateTheme('dark')"></div>
        <div class="theme-button dark-blue" @click="updateTheme('darkBlue')"></div>
      </div>
      <div class="d-flex">
        <div class="theme-button shinkai" @click="updateTheme('shinkai')"></div>
        <div class="theme-button yumekawa" @click="updateTheme('yumekawa')"></div>
        <div class="theme-button mono" @click="updateTheme('mono')"></div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { color } from './packs/theme_color.js' 

// CSRFトークン作成
axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default {
  data: function() {
    return {
    }
  },
  methods: {
    updateTheme: function(themeName) {
      this.changeTheme(themeName)
      this.setTheme(themeName)
    },
    changeTheme: function(themeName) {
      const theme = color[themeName]
      const root = document.documentElement;
      const check = document.getElementById('bg-color-check');
      for(const property in theme) {
        if(property == '--bg-end') {
          continue;
        }
        if(property == '--bg-start') {
          // 以下背景色のアニメーション処理
          // アニメーション用グラデーションの設定
          root.style.setProperty('--bg-start-changing', theme['--bg-start']);
          root.style.setProperty('--bg-end-changing', theme['--bg-end']);
          // アニメーション開始
          check.checked = true;
          // 1秒後にアニメーション終了処理
          setTimeout( () => {
            root.style.setProperty('--bg-start', theme['--bg-start']);
            root.style.setProperty('--bg-end', theme['--bg-end']);
            check.checked = false;
          }, 301 )
        }else{
          root.style.setProperty(property, theme[property]);
        }
      }
    },
    setTheme: function(themeName) {
      // Rails側にセッションとして記録
      axios
        .post('/theme', {
          user: {
            theme: themeName
          }
        })
    }
  }
}
</script>

<style lang="scss" scoped>
.theme-container {
  margin: 10px 10px 0 10px;
  border-top: 1px solid rgb(199, 199, 199);
  padding: 10px 10px 0 10px;
}

.theme-button {
  width: 30px;
  height: 30px;
  border: 1px solid rgba(white, 0.8);
  border-radius: 15px;
}

.theme-button:not(:last-child) {
  margin-right: 5px;
}

.normal {
  background-color: #6ABBC4;
}

.dark {
  background-color: #1B474D;
}

.dark-blue {
  background-color: #BBBBFF;
}

.shinkai {
  background-color: #BFC56E;
}

.yumekawa {
  background-color: #BC6E9B;
}

.mono {
  background-color: #000000;
}
</style>