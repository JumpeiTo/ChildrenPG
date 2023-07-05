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
import "popper.js";
import "bootstrap";

// フラッシュメッセージ設定
import toastr from "toastr";
window.toastr = toastr;
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
  }
});



Rails.start()
Turbolinks.start()
ActiveStorage.start()

