<template>
    <div>
        <div v-if="clock.status === true">
            <div v-if="diffTime.day > 0">
                <span class="dp-flex-vertical-center text-color-3 fz-small fw-b p-b-m">You work since</span>
                <span class="dp-flex-vertical-center text-color-3 fz-small fw-b p-b-m">{{diffTime.day}} day(s) {{diffTime.hour}} : {{diffTime.min}} : {{diffTime.sec}}</span>
                <span>{{new Date()}}</span>
                <span></span>
            </div>
            <div v-else>
                <span class="dp-flex-vertical-center text-color-3 fz-small fw-b p-b-m">You work since</span>
                <span class="dp-flex-vertical-center text-color-3 fz-small fw-b p-b-m">{{diffTime.hour}} : {{diffTime.min}} : {{diffTime.sec}}</span>
            </div>
        </div>
        <div v-else class="dp-flex-vertical-center text-color-3 fz-small fw-b p-b-m">You don't work.</div>
    </div>
</template>
<script>
import { dateDiff } from "./HorlogeFunction.js";
import { mapState } from 'vuex';
import moment from 'moment';

export default {
  name: 'TimeWork',
  data() {
    return {
        diffTime: null
    }
  },
  computed: {
      ...mapState([
        'clock',
        'user',
        'current_user'
      ])
  },
  component: {
    moment
  },
  methods: {
    getClock() {
        this.$store.commit('get_clock_with_userid', this.current_user);
    },
    workDuring(){
        var actualDate = moment(new Date()).utc().add(1, 'hours');
        var workclock = moment(this.clock.time).utc();

        this.diffTime = dateDiff(actualDate,workclock);
    }

  },
  mounted() {
    this.$nextTick(function () {
      this.getClock();
      setInterval(()=>{
        this.workDuring();
      },1000);
    })
  },
  beforeDestroy () {
	  clearInterval()
  }
}
</script>
<style scoped>
</style>
