<template>
  <div>
    <div class="dp-flex-vertical-center m-t-s">
      DELETE USER
      <CustomSelect
        :key="users.id"
        :options="users"
        :default="'Select User'"
        class="select"
        @input="selectUserid"
      />
      <div class="dp-flex-center w-100">
        <div class="dp-flex-space-between w-80">
          <button class="btn-submit " @click="updateParent()">retour</button>
          <button class="btn-submit" @click="deleteUser()">delete</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {mapState} from "vuex";
import CustomSelect from "../Workingtimes/CustomSelect";

export default {
  name: 'UserDelete',
  data() {
    return {
      user_module: ''
    }
  },
  components: {
    CustomSelect
  },
  computed: {
    ...mapState([
      'users',
      'current_user'
    ])
  },
  methods: {

    async deleteUser() {

      this.updateParent();
      this.$store.commit('delete_user', this.user_module);
      await new Promise(resolve => setTimeout(resolve, 500));
      if (this.user_module === this.current_user) {
        this.$store.commit('get_users_with_userid', "undefined");
      }
      this.$store.commit('get_users');
    },
    selectUserid(event) {
      if (event !== "Select One")
        this.user_module = event;
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
