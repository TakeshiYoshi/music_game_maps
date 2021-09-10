<template>
  <div id="tutorial">
    <input type="checkbox" id="tutorial-animation-start" class="d-none">
    <input type="checkbox" id="tutorial-animation-select" class="d-none">
    <input type="checkbox" id="tutorial-animation-about-map" class="d-none">
    <input type="checkbox" id="tutorial-animation-about-geolocation" class="d-none">
    <input type="checkbox" id="tutorial-animation-about-search-by-map" class="d-none">
    <input type="checkbox" id="tutorial-animation-about-search-by-free-word-middle" class="d-none">
    <input type="checkbox" id="tutorial-animation-about-search-by-free-word" class="d-none">
    <input type="checkbox" id="tutorial-animation-about-filter-button" class="d-none">
    <input type="checkbox" id="tutorial-animation-about-filter-modal-start" class="d-none">
    <input type="checkbox" id="tutorial-animation-about-filter-modal" class="d-none">
    <input type="checkbox" id="tutorial-animation-end" class="d-none">
    <div class="tutorial-container d-flex align-items-center justify-content-center">
      <div class="container-xl px-0">
        <div class="focus-container">
          <div class="tutorial-focus"></div>
        </div>
      </div>
      <div class="tutorial-character">
        <img src="./images/tutorial_otomaru.png">
      </div>
      <div class="tutorial-message-box glass blur">
        <vue-typer class="glass-text tutorial-message" :text="message" :repeat="0" :pre-type-delay="1000" @typed="messageEvents"></vue-typer>
      </div>
      <div class="tutorial-select d-flex align-items-center justify-content-center">
        <div class="tutorial-select-button d-flex align-items-center justify-content-center glass blur glass-text" @click="selectedButton(true)">聞きたい！</div>
        <div class="tutorial-select-button d-flex align-items-center justify-content-center glass blur glass-text" @click="selectedButton(false)">大丈夫です</div>
      </div>
    </div>
  </div>
</template>

<script>
import { VueTyper } from 'vue-typer'

export default {
  data: function () {
    return {
      template: { enter: ['OTOMAPへようこそ！ぼくの名前はおとまる！OTOMAPの案内犬だよ！', 'これからOTOMAPの使い方について話そうと思うんだけど...', '聞きたいかい？'], no: ['OTOMAPを気に入ってくれるとうれしいな！またね！'], yes: ['わかった！それじゃあ早速説明していくね！'], map: ['このマップには検索結果の場所がピンで表示されてるよ！'], geolocation: ['このボタンを押すと現在位置がマップ上に表示されるようになるよ！'], search_by_map: ['このボタンを押すと今マップで表示している場所の周辺を検索できるよ！'], search_by_free_word: ['ここからフリーワード検索ができるよ！'], filter_button: ['このボタンを押すとフィルター設定画面が開くよ！'], filter_modal: ['これがフィルター設定画面だよ！', 'ゲーム機種や都道府県、市区町村でフィルターを設定できるよ！'], end: ['ひと通りの機能を紹介したよ！', 'それじゃあぼくはこのへんで。またね！']},
      message: ' ',
      selectFlag: false,
    }
  },
  components: {
    'vue-typer': VueTyper
  },
  mounted: function() {
    if (gon.attend_tutorial) {
      document.getElementById('tutorial').style.display = 'none';
    } else if (gon.isTest) {
      // テスト用
      document.getElementById('tutorial').style.display = 'none';
    } else {
      // スクロール禁止
      document.getElementsByTagName('body')[0].style.overflow = 'hidden';
      window.onload = function () {
        // ページ読み込み後アニメーション開始
        document.getElementById('tutorial-animation-start').checked = true;
      }
      // メッセージ表示
      this.message = this.template.enter;
    }
  },
  methods: {
    messageEvents: function (typedString) {
      switch(typedString) {
        case this.template.enter[2]:
          // 選択肢表示
          document.getElementById('tutorial-animation-select').checked = true;
          break;
        case this.template.no[0]:
          this.closeTutorial();
          break;
        case this.template.yes[0]:
          // ページトップへスクロール
          window.scrollTo({
            top: 0,
            behavior: 'smooth'
          });
          document.getElementById('tutorial-animation-about-map').checked = true;
          // マップ説明テキスト追加
          setTimeout(() => {
            this.message = this.template.map
          }, 1000)
          break;
        case this.template.map[0]:
          setTimeout(() => {
            document.getElementById('tutorial-animation-about-geolocation').checked = true;
          }, 2000)
          setTimeout(() => {
            this.message = this.template.geolocation
          }, 2500)
          break;
        case this.template.geolocation[0]:
          setTimeout(() => {
            document.getElementById('tutorial-animation-about-search-by-map').checked = true;
          }, 2000)
          setTimeout(() => {
            this.message = this.template.search_by_map
          }, 2500)
          break;
        case this.template.search_by_map[0]:
          setTimeout(() => {
            document.getElementById('tutorial-animation-about-search-by-free-word-middle').checked = true;
          }, 2000)
          setTimeout(() => {
            document.getElementById('tutorial-animation-about-search-by-free-word').checked = true;
          }, 2500)
          setTimeout(() => {
            this.message = this.template.search_by_free_word
          }, 3000)
          break;
        case this.template.search_by_free_word[0]:
          setTimeout(() => {
            document.getElementById('tutorial-animation-about-filter-button').checked = true;
          }, 2000)
          setTimeout(() => {
            this.message = this.template.filter_button
          }, 2500)
          break;
        case this.template.filter_button[0]:
          setTimeout(() => {
            document.getElementById('filter-button').click();
            document.getElementById('tutorial-animation-about-filter-modal-start').checked = true;
          }, 2000)
          setTimeout(() => {
            // 一度すべてのアニメーション用チェックボックスをリセット
            document.getElementById('tutorial-animation-about-geolocation').checked = false;
            document.getElementById('tutorial-animation-about-search-by-map').checked = false;
            document.getElementById('tutorial-animation-about-search-by-free-word-middle').checked = false;
            document.getElementById('tutorial-animation-about-search-by-free-word').checked = false;
            document.getElementById('tutorial-animation-about-filter-button').checked = false;
            // 新しいアニメーション開始
            document.getElementById('tutorial-animation-about-filter-modal').checked = true;
          }, 2500)
          setTimeout(() => {
            this.message = this.template.filter_modal
          }, 3000)
          break;
        case this.template.filter_modal[1]:
          setTimeout(() => {
            document.getElementById('filter-close').click();
            document.getElementById('tutorial-animation-about-map').checked = false;
            document.getElementById('tutorial-animation-end').checked = true;
          }, 2000)
          setTimeout(() => {
            this.message = this.template.end
          }, 3000)
          break;
        case this.template.end[1]:
          this.closeTutorial();
          break;
      }
    },
    selectedButton: function (selected) {
      // 選択肢非表示
      document.getElementById('tutorial-animation-select').checked = false;
      this.message = selected ? this.template.yes : this.template.no;
    },
    closeTutorial: function() {
      // スクロール禁止解除
      document.getElementsByTagName('body')[0].style.overflow = 'visible';
      // チュートリアル終了
      setTimeout(() => {
        document.getElementById('tutorial-animation-start').checked = false;
      }, 1000)
      // 現在位置情報から周辺店舗を検索するためリロード
      location.reload();
    }
  }
}
</script>

<style lang="scss" scoped>
</style>