<template>
  <div>
    <div class="dp-flex-vertical-center m-t-s">
      UPDATE USER
      <input class="m-h-s inpt" type="text" v-model="username" placeholder="entrez votre username">
      <input class="m-h-s inpt" type="text" v-model="email" placeholder="entrez votre email">
      <div class="dp-flex-center w-100">
        <div class="dp-flex-space-between w-80">
          <button class="btn-submit " @click="updateParent()">retour</button>
          <button class="btn-submit" @click="updateUser()">valider</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UserUpdate',
  data() {
    return {
      username: null,
      email: null,
    }
  },
  props: {},
  methods: {

    async updateUser() {
      let user = {};
      if (this.username !== null) {
        user['username'] = this.username;
      }
      if (this.email !== null) {
        user['email'] = this.email;
      }
      if (user.username === undefined) {
        return;
      }

      this.updateParent();
      this.$store.commit('update_user', user);
      await new Promise(resolve => setTimeout(resolve, 500));
      this.$store.commit('get_users_with_userid');
      this.$store.commit('get_users');
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
