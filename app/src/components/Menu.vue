<template>
  <div>
    <div class="bg-color-3 dp-flex-space-between text-color-1 h-50p">
      <div class="w-100 dp-flex">
        <img src="../assets/img/logo.svg" width="50" height="50">
        <div class="dp-flex-vertical-center p-l-s fz-l">Time Manager</div>
      </div>
      <div class="dp-flex-right w-100 fz-l">
        <div class="dp-flex-vertical-center menu-btn-menu zi-1" @click="toggleUser()">
          <div class="click dp-flex-vertical-center">
            menu
          </div>
        </div>
      </div>
    </div>
    <div class="dp-flex fz-s w-100">
      <div class="dp-flex-vertical-center" v-for="(component, index) in getComponents()" :key="index">
        <div class="menu-btn click dp-flex-vertical-center p-s" v-if="component !== 'Home'">
          <div @click="pageRedirect(component)">
            {{ component }}
          </div>
        </div>
      </div>
    </div>
    <div v-if="is_user_toggle">
      <User/>
    </div>
  </div>
</template>

<script>
import User from "./User";
import {mapState} from 'vuex';

export default {
  name: 'Menu',
  data() {
    return {
      is_user_toggle: false
    }
  },
  components: {
    User
  },
  computed: {
    ...mapState([
      'current_user',
      'users',
      'user',
      'team'
    ])
  },
  methods: {
    toggleUser() {
      this.is_user_toggle = !this.is_user_toggle;
    },
    getComponents() {
      const files = require.context('@/components/Menu', true, /^.*\.vue$/);
      let names = files.keys();
      let vue = [];
      for (let i = 0; i < names.length; i++) {
        if (this.current_user === undefined) {
          break
        }
        if (this.team.id === undefined && (names[i].split('.')[1]).split('/')[1] === "Team") {
          continue
        }
        if (this.user.job === "Employee" && (names[i].split('.')[1]).split('/')[1] !== "Workingtimes") {
          vue.push((names[i].split('.')[1]).split('/')[1]);
        } else if (this.user.job === "Manager")
          vue.push((names[i].split('.')[1]).split('/')[1]);
        else if (this.user.job === "Administrator")
          vue.push((names[i].split('.')[1]).split('/')[1]);
      }
      return vue;
    },
    pageRedirect(pageName) {
      if (this.$route.path === '/' + pageName) {
        return;
      }
      this.$router.push({
        name: pageName,
        params: {'userid': this.current_user}

      })
    },
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.menu-btn {
  color: var(--color-3);
  border-right: 2px solid var(--color-3);
  padding-left: 10px;
  padding-right: 10px;
  height: 70%;
}

.menu-btn:hover, .menu-btn-menu:hover {
  color: var(--color-1);
  background-color: var(--color-3);
}

.menu-btn-menu {
  width: 178px;
  color: var(--color-1);
  border-left: 2px solid var(--color-3);
  padding-left: 30px;
  padding-right: 30px;
}

.menu-btn-menu:hover {
  color: var(--color-3);
  background-color: var(--color-1);
}
</style>
