<template>
  <div>
    <div class="dp-flex-vertical-center m-t-s">
      GET TEAM
      <div v-for="members in team_members" :key="member.id">
        <div class="text-color-3" v-for="(value, key) in member" :key="key"><span class="fw-b"> {{ key }} </span>: {{ value }}</div><br>
      </div>
      <button class="btn-submit " @click="updateParent()">retour</button>
    </div>
  </div>
</template>

<script>
import {mapState} from "vuex";
import CustomSelect from "../Workingtimes/CustomSelect";

export default {
  name: 'TeamGet',
  data() {
    return {
      member_module: ''
    }
  },
  components: {
    CustomSelect
  },
  computed: {
    ...mapState([
      'team_members'
    ])
  },
  methods: {
    selectUserid(event) {
      if (event !== "Select One")
        this.member_module = event;
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
