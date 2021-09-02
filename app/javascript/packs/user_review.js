window.setInformationToPreview = function(userReviewId, imageIndex) {
  // データ取得
  const nickname = document.getElementById('userReview-nickname-' + userReviewId).textContent;
  const iconUrl = document.getElementById('userReview-icon-' + userReviewId).dataset.url;
  const createdAt = document.getElementById('userReview-created-at-' + userReviewId).textContent;
  const body = document.getElementById('userReview-body-' + userReviewId).cloneNode(true);
  const images = document.getElementById('userReview-images-' + userReviewId);
  // データセット
  document.getElementById('userReviewNicknamePreview').textContent = nickname;
  document.getElementById('userReviewCreatedAtPreview').textContent = createdAt;
  document.getElementById('userReviewBodyPreview').innerHTML = '';
  document.getElementById('userReviewBodyPreview').appendChild(body);
  document.getElementById('userReviewIconPreview').setAttribute('src', iconUrl);

  const swiper = document.getElementById('previewImages');
  swiper.firstChild.innerHTML = '';

  for(const child of images.children) {
    // タグ作成
    let swiperSlide = document.createElement('div');
    let image = document.createElement('img');
    swiperSlide.setAttribute('class', 'glass-text userReview-image swiper-slide');
    image.setAttribute('src', child.dataset.url);
    swiperSlide.appendChild(image);
    // タグ追加
    swiper.firstChild.appendChild(swiperSlide);
  }
  // スワイパーの再設定
  swiper.swiper.update();
  swiper.swiper.slideTo(imageIndex);
}