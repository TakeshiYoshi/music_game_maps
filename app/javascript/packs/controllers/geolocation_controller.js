import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="geolocation"
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

  initialize() {
    this.isGeoChecked = gon.location;
    this.latitude = gon.location ? gon.location[0] : "";
    this.longitude = gon.location ? gon.location[1] : "";

    // 初回処理
    this.getMode = 'first';
    this.getGeolocation();
    if (this.isGeoChecked) {
      // 現在位置の取得がオンになっていたら５秒に1度現在地の更新を行う。
      // 頻繁に更新をするためRails側でセッションは作成せず地図のマーカーの位置のみを変更する。
      this.intervalFunction = setInterval(function () {
        this.updateGeolocation;
      }, 5000);
    }
  }

  get() {
    this.getMode = "button";
    this.getGeolocation();
    if (this.isGeoChecked) {
      // 2回目以降に現在地取得をする場合は現在地のズームを行う
      this.focusCurrentPosition();
    }
  }

  updateGeolocation() {
    if (this.isGeoChecked) {
      this.getMode = 'auto';
      this.getGeolocation();
    }
  }

  getGeolocation() {
    // getMode: button=>現在位置取得ボタンを押した時の挙動, atLoad=>画面ロード時の挙動
    const options = {
      enableHighAccuracy: true,
      timeout: 5000,
      maximumAge: 0,
    };

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          // 成功時の処理
          this.latitude = position.coords.latitude;
          this.longitude = position.coords.longitude;

          // 通信処理
          if (
            this.getMode == "button" ||
            this.getMode == "first" ||
            !this.isGeoChecked
          ) {
            // Rails側にセッションとして記録
            fetch('/set_location', {
              method: 'POST',
              credentials: 'same-origin',
              headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': this.getCsrfToken()
              },
              body: JSON.stringify({
                lat: this.latitude,
                lng: this.longitude
              })
            }).then(() => {
              if (
                this.getMode == "first" &&
                !gon.isSearchByMapMode &&
                this.isCloserThanBefore
              ) {
                // 現在位置の取得がオンかつマップ検索されていないかつ以前取得した位置情報と比べ1km以上離れている場合
                // ページリロードを実行
                //location.reload();
                document.getElementsByClassName('map-loading')[0].classList.add('visible');
                document.getElementById('mapMenuSubmitButton').click();
              }
              if (this.getMode == "button") {
                this.flashMessage("現在位置を取得しました");
              }
            });
          }

          // 現在地マーカーを更新
          window.globalFunction.addGeoLocationMarker([
            this.latitude,
            this.longitude,
          ]);

          // 初回の現在位置取得の場合は地図のズームを変更し全マーカーを表示する
          if (!this.isGeoChecked) {
            window.globalFunction.focusAllMarker([this.latitude, this.longitude]);
            this.isGeoChecked = true;
          }
        },
        (error) => {
          // 失敗時の処理
          if (this.getMode == "button") {
            switch (error.code) {
              case 1: // PERMISSION_DENIED
                this.flashMessage("位置情報の利用が許可されていません");
                break;
              case 2: // POSITION_UNAVAILABLE
                this.flashMessage("現在位置が取得できませんでした");
                break;
              case 3: // TIMEOUT
                this.flashMessage("タイムアウトになりました");
                break;
              default:
                this.flashMessage("現在位置が取得できませんでした");
                break;
            }
          }
        },
        options
      );
    } else {
      this.flashMessage('現在位置が取得できませんでした');
    }
  }

  focusCurrentPosition() {
    window.globalFunction.focusCurrentPosition([
      this.latitude,
      this.longitude,
    ]);
  }

  isCloserThanBefore() {
    // 日本の場合経度は1度=約80kmであるがここでは1度約100kmとして計算
    return (
      Math.abs(gon.location[0] - this.latitude) >= 0.01 ||
      Math.abs(gon.location[1] - this.longitude) >= 0.01
    );
  }

  flashMessage(message) {
    const flashMessageElement = document.getElementsByClassName('map-message-dialog')[0];
    flashMessageElement.textContent = message
    // フェードインアニメーション
    flashMessageElement.classList.add('display');
    // 5秒でフェードアウトアニメーション
    setTimeout(() => {
      flashMessageElement.classList.remove('display');
    }, 5000);
  }
}
