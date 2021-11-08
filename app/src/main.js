// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
import { Datetime } from 'vue-datetime'
import 'vue-datetime/dist/vue-datetime.css'
import Vuelidate from 'vuelidate'
import VueCryptojs from 'vue-cryptojs'

Vue.use(VueCryptojs)
Vue.config.productionTip = false
Vue.use(Datetime);
Vue.use(Vuelidate);
/* eslint-disable no-new */

new Vue({
  el: '#app',
  router,
  components: { App },
  store,
  validations: {},
  template: '<App/>'
})
