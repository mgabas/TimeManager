<template>
  <div>
    <div class="small">
      <p>Nombre d'heures par shift</p>
      <user-chart ref='chart' :chart-data="datacollection"></user-chart>
    </div>

  </div>
</template>

<script>
import { mapState } from 'vuex';
import {transformdate} from './ChartFunction.js';
import UserChart from './UserChart.js';
var randomColor = require('randomcolor');

export default {
  name: 'ChartUser',
  components:{
    UserChart
  },
  data () {
    return {
      datacollection: null
    }
  },
  mounted () {
    this.$nextTick(function () {
      this.$store.commit('get_workingtime_with_userid', this.current_user);   
    })
    this.fillData();

  },
  props: {
    userid: null
  },
  computed: {
    ...mapState([
      'workingtime',
      'users',
      'current_user',
      'all_workingtimes'
    ])
  },
  methods: {
    result(date) {
      return transformdate(date)
    },
    fillData() {
      var arrLabels = [];
      var arrData = [];
      this.workingtime.forEach((value) => {
        arrLabels.push([transformdate(value).date,transformdate(value).time.toString()+" Heures"]);
        arrData.push(transformdate(value).time);
      });
      this.datacollection = {
        labels: arrLabels,
        datasets: [
          {
            backgroundColor: randomColor(),
            data: arrData
          }
        ]
      };
    }
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  /* .small {
    max-width: 400px;
    margin:  auto auto;
  } */
</style>
