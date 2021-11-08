<template>
  <div>
    <div class="user-div-general bd-r-30 bd-shadow bg-color-2 p-m">
      <div v-if="current_user === undefined">
        <div class="dp-flex-vertical-center">
          <CustomSelect
            :key="users.id"
            :options="users"
            :default="'Select User'"
            class="select"
            @input="selectUserid"
          />
          <button class="btn-submit" @click="selectUser()">select user</button>
        </div>
        <div v-if="current_component === ''" class="click" @click="handleFunctionName('create')">
          <UserBloc name="create"/>
        </div>
      </div>
      <div v-if="user.username !== undefined">
        <div class="dp-flex-vertical-center p-b-m">
          <span class="text-color-3 fz-l fw-b text-align-center" style="word-break: break-all">{{ user.username.toUpperCase() }}</span>
          <span class="text-color-3">{{ user.job }}</span>
        </div>
        <TimeWork/>
        <div class="dp-flex-column">
          <div v-if="current_component === ''">
            <div class="dp-flex-vertical-center">
              User Management
            </div>
            <div v-for="(icon, index) in getIcons()" :key="index">
              <div v-if="current_component === '' && icon !== 'get'" class="click" @click="handleFunctionName(icon)">
                <UserBloc :name="icon" component="user"/>
              </div>
            </div>
            <div>
              <div class="dp-flex-vertical-center">
                Team Management
              </div>
            <div v-if="current_component === '' && user.job === 'Manager'" class="click" @click="getTeam">
              <UserBloc name="get" component="team"/>
            </div>
            <div v-if="current_component === '' && user.job === 'Manager'" class="click" @click="getTeam">
              <UserBloc name="create" component="team"/>
            </div>
            </div>
          </div>
        </div>
      </div>
      <div v-if="current_component !== ''">
        <component @updateCurrentComponent="updateParent()" v-bind:is="current_component"/>
      </div>
      <div class="dp-flex-vertical-center">
        <button class="btn-submit m-t-m" v-if="user.username !== undefined" @click="deconnexion()">deconnexion</button>
      </div>
    </div>
  </div>
</template>

<script>
import {mapState} from "vuex";
import UserBloc from "./User/UserBloc";
import UserCreate from "./User/UserCreate";
import UserUpdate from "./User/UserUpdate";
import UserDelete from "./User/UserDelete";
import UserGet from "./User/UserGet";
import TeamGet from "./Teams/TeamGet";
import CustomSelect from "./Workingtimes/CustomSelect";
import TimeWork from "./Horloge/TimeWork.vue";

export default {
  name: 'User',
  data() {
    return {
      current_component: '',
      user_module: ''
    }
  },
  components: {
    UserBloc,
    UserCreate,
    UserUpdate,
    UserDelete,
    UserGet,
    TeamGet,
    CustomSelect,
    TimeWork
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
    selectUserid(event) {
      if (event !== "Select One")
        this.user_module = event;
    },
    log(log) {
      console.log(log)
    },
    updateParent() {
      this.current_component = '';
    },
    getIcons() {
      const files = require.context('@/assets/icons', true, /^.*\.png$/);
      let names = files.keys();
      let icons = [];
      for (let i = 0; i < names.length; i++) {
        icons.push((names[i].split('.')[1]).split('/')[1]);
      }
      return icons;
    },
    handleFunctionName(functionName) {
      switch (functionName) {
        case "create":
          this.createUser()
          break;
        case "update":
          this.updateUser()
          break;
        case "get":
          this.getUser()
          break;
        case "delete":
          this.deleteUser()
          break;
      }
    },
    async selectUser() {
      if (this.$route.path !== '/Home') {
        this.$router.push({
          name: 'Home'
        })
      }
      this.$store.state.current_user = this.user_module;
      this.$store.commit('get_users_with_userid');
      await new Promise(resolve => setTimeout(resolve, 500));
      this.$store.commit('get_team_by_userid', this.current_user);
    },
    deconnexion() {
      this.$store.state.current_user = undefined;
      this.$store.state.user = [];
      this.$store.state.workingtime = [];
      this.current_component = '';
    },
    createUser() {
      this.current_component = "UserCreate";
    },
    updateUser() {
      this.current_component = "UserUpdate";
    },
    getUser() {
      this.$store.commit('get_users');
      this.current_component = "UserGet";
    },
    getTeam() {
      this.$store.commit('get_team_members_by_id_team');
      this.current_component = "TeamGet";
    },
    deleteUser() {
      this.current_component = "UserDelete";
    }
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.user-div-general {
  position: absolute;
  width: 200px;
  right: 0;
  border-radius: 0 0 30px 30px;
  box-shadow: 0 3px 10px rgb(0 0 0 / 0.2);
  top: 50px;
  animation: slidein 0.3s;
}

@keyframes slidein {
  from {
    margin-top: -180px
  }

  to {
    margin-top: 0;
  }
}
</style>
