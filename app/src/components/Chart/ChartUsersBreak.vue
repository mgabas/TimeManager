<template>
  <div>
    <div class="small">
      <p>Nombre de pauses par jour</p>
      <user-chart-break :chart-data="datacollection" :options="{scales:{yAxes:[{ticks:{beginAtZero:true}}]}}"></user-chart-break> 
    </div>


  </div>
</template>

<script>
import { mapState } from 'vuex';
import {findBreak, findListDay, transformdate} from './ChartFunction.js';
import UserChartBreak from './UserChartBreak.js';
var randomColor = require('randomcolor');

export default {
  name: 'ChartUsersMonth',
  components:{
    UserChartBreak
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
      'current_user'
    ])
  },
  methods:{
    result(date){
      return transformdate(date)
    },
    fillData () {
      var arrDayTemp =[]
      this.workingtime.forEach((value) => {
        
        arrDayTemp.push(findListDay(value));
      });

      var arrLabels = findBreak(arrDayTemp).day;
      var arrData = findBreak(arrDayTemp).break;

      this.datacollection = {
        labels: arrLabels,
        datasets: [
          {
            label: "pauses",
            backgroundColor: randomColor(),
            data: arrData
          }
        ]
      }
    },
    
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
