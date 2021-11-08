<template>
  <div id="app">
    <div v-if="current_user === undefined">
      <Menu/>
<!--      <Login/>-->
    </div>
    <div v-else>
      <div>
        <Menu/>
      </div>
      <div>
        <router-view/>
      </div>
    </div>
  </div>
</template>

<script>
import {mapState} from 'vuex';
import Menu from "./components/Menu";
import Login from "./components/Login";

export default {
  name: 'App',
  data() {
    return {}
  },
  components: {
    Menu,
    Login
  },
  computed: {
    ...mapState([
      'current_user',
      'user',
      'team'
    ])
  },

  methods: {
    log(log) {
      console.log(log)
    }
  },

  mounted() {
    this.$nextTick(function () {
      this.$store.commit('get_users');
    })
  },
}

</script>

<style>
@import "assets/styles/general.css";
</style>
