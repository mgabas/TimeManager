<template>
  <div>
    <div class="dp-flex-vertical-center m-t-s">
      CREATE USER
      <input class="m-h-s inpt" type="text" v-model="username" placeholder="entrez votre username">
      <input class="m-h-s inpt" type="text" v-model="email" placeholder="entrez votre email">
      <CustomSelect
        :options="payload"
        :default="'Please Select One'"
        class="select"
        @input="selectJob"
      />
      <div class="dp-flex-center w-100">
        <div class="dp-flex-space-between w-80">
          <button class="btn-submit " @click="updateParent()">retour</button>
          <button class="btn-submit" @click="createUser()">valider</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import CustomSelect from '../Workingtimes/CustomSelect';

export default {
  name: 'UserCreate',
  data() {
    return {
      username: null,
      email: null,
      job: null,
      payload: [{"id": "Employee"}, {"id": "Manager"}, {"id": "Administrator"}]
    }
  },
  components: {
    CustomSelect
  },
  props: {},
  methods: {
    selectJob(event) {
      if (event !== "Please Select One")
        this.job = event;
    },
    async createUser() {
      let user = {
        "username": this.username,
        "email": this.email,
        "job": this.job
      }
      if (user.username === null || user.email === null || user.job === null) {
        return;
      }
      this.updateParent();
      this.$store.commit('create_user', user);
      await new Promise(resolve => setTimeout(resolve, 500));
      this.$store.commit('get_users');
      this.$store.commit('get_users_with_username_email', user);
      await new Promise(resolve => setTimeout(resolve, 500));
      this.$store.commit('create_clock', this.$store.state.user[0].id);
    },
    updateParent() {
      this.$emit('updateCurrentComponent', '');
    }
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
