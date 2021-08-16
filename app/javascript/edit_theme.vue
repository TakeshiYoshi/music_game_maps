<template>
  <div id="editTheme">
    <div class="theme-container">
      <div class="d-flex" style="margin-bottom: 5px;">
        <div class="theme-button normal" @click="changeTheme(normal)"></div>
        <div class="theme-button dark" @click="changeTheme(dark)"></div>
        <div class="theme-button dark-blue" @click="changeTheme(darkBlue)"></div>
      </div>
      <div class="d-flex">
        <div class="theme-button shinkai" @click="changeTheme(shinkai)"></div>
        <div class="theme-button yumekawa" @click="changeTheme(yumekawa)"></div>
        <div class="theme-button mono" @click="changeTheme(mono)"></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: 'Hello world',
      normal:   { '--bg-start': '#6ABBC4', '--bg-end': '#6E74BC', '--site-title': '#378892', '--field-color': '#326FFA', '--field-color-light': '#467DFA', '--label-open': '226, 106, 157', '--label-close': '64, 107, 143' },
      dark:     { '--bg-start': '#1B474D', '--bg-end': '#370D62', '--site-title': '#78BCC4', '--field-color': '#326FFA', '--field-color-light': '#467DFA', '--label-open': '226, 106, 157', '--label-close': '64, 107, 143' },
      darkBlue: { '--bg-start': '#000011', '--bg-end': '#101030', '--site-title': '#BBBBFF', '--field-color': '#3d5796', '--field-color-light': '#485e92', '--label-open': '145, 63, 97', '--label-close': '55, 89, 117' },
      shinkai:  { '--bg-start': '#0D355A', '--bg-end': '#07202B', '--site-title': '#BFC56E', '--field-color': '#326FFA', '--field-color-light': '#467DFA', '--label-open': '226, 106, 157', '--label-close': '64, 107, 143' },
      yumekawa: { '--bg-start': '#C2AFE6', '--bg-end': '#BC6E9B', '--site-title': '#6FB8D4', '--field-color': '#30A2B6', '--field-color-light': '#4AADBE', '--label-open': '238, 131, 175', '--label-close': '66, 114, 153' },
      mono:     { '--bg-start': '#000000', '--bg-end': '#000000', '--site-title': '#FFFFFF', '--field-color': '#292929', '--field-color-light': '#363636', '--label-open': '59, 11, 20', '--label-close': '11, 37, 59' }
    }
  },
  methods: {
    changeTheme: function(theme) {
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