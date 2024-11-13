import "@hotwired/turbo-rails"
import "./controllers"
import './spotify_search'
import jquery from "jquery"
window.$ = jquery
window.jQuery = jquery

$(document).ready(function(){
  alert('ok');
});
