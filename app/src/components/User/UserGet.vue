<template>
  <div>
    <div class="dp-flex-vertical-center m-t-s">
      GET USER
      <div v-for="user in users" :key="user.id">
        <div class="text-color-3" v-for="(value, key) in user" :key="key"><span class="fw-b"> {{ key }} </span>: {{ value }}</div><br>
      </div>
      <button class="btn-submit " @click="updateParent()">retour</button>
    </div>
  </div>
</template>

<script>
import {mapState} from "vuex";
import CustomSelect from "../Workingtimes/CustomSelect";

export default {
  name: 'UserGet',
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
      'users'
    ])
  },
  methods: {
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
