<template>
  <div>
    <div class="w-100 dp-flex-center">
      <div class="w-90 dp-flex-wrap-space-between">
        <ChartUser/>
        <ChartUsersBreak/>
        <ChartUserConnected/>
      </div>
    </div>
  </div>
</template>

<script>
import ChartUser from "../Chart/ChartUser.vue";
import ChartUsersBreak from "../Chart/ChartUsersBreak.vue";
import ChartUserConnected from "../Chart/ChartUserConnected.vue";
import {mapState} from "vuex";

export default {
  name: 'ChartManager',
  data() {
    this.$store.commit('get_workingtime_with_userid', this.current_user)
    return {}
  },
  props: {
    data: null,
    userid: null
  },
  computed: {
    ...mapState([
      'current_user'
    ])
  },
  components: {
    ChartUser,
    ChartUsersBreak,
    ChartUserConnected
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
