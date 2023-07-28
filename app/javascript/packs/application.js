// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "../stylesheets/application";
import "jquery";
import $ from "jquery"
import "popper.js";
import "bootstrap";
import 'select2';


// フラッシュメッセージ設定
import toastr from "toastr";
window.toastr = toastr;
toastr.clear();
toastr.options.positionClass = 'toast-top-right';
toastr.options.newestOnTop = false;
toastr.options.timeOut = 3000;


document.addEventListener("turbolinks:load", function() {
  // フラッシュメッセージが表示されたら一定の遅延時間を経てクリアする
  if (toastr) {
    setTimeout(function() {
      toastr.clear();
    }, 4000);
  }
});

document.addEventListener("turbolinks:before-visit", function() {
  // 画面遷移前にフラッシュメッセージをクリアする
  if (toastr) {
    toastr.clear();
    var t = document.getElementById("toast-container");
    if (t != null) {
      t.remove();
    }
  }
});

// ブラウザバック時にtoastが存在する時発火
history.replaceState(null, null, null);
window.addEventListener('popstate', function(e) {
  var t = document.getElementById("toast-container");
      if (t != null) {
        t.remove();
      }
});

// 投稿ボタン設定
$(document).on('turbolinks:load', function() {
  var postButton = $('#post_button');
  postButton.hide();

  // スクロールイベントを定義
  $(window).scroll(function() {
    var scrollHeight = $(document).height(); // ページの全体の高さ
    var scrollPosition = $(window).height() + $(window).scrollTop(); // 現在のスクロール位置 + ウィンドウの高さ

    if (scrollHeight - scrollPosition <= 150) {
      // ページの最下部に近づいたら投稿ボタンを非表示
      postButton.fadeOut(200);
    } else {
      // ページの最下部でない場合は投稿ボタンを表示
      postButton.fadeIn(500);
    }
  });

  // 初回表示時にもスクロールイベントを発火させる
  $(window).trigger('scroll');
});

Rails.start()
Turbolinks.start()
ActiveStorage.start()

