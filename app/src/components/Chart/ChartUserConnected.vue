<template>
  <div>
    <div class="small">
      <p>Nombre d'heures des employés</p>
    <user-chart-connected ref="need_help" :data="difineData()"></user-chart-connected>
    </div>

  </div>
</template>

<script>
import { mapState } from 'vuex';
import {findHours} from './ChartFunction.js';
import UserChartConnected from './UserChartConnected.js';
var randomColor = require('randomcolor');

export default {
  name: 'ChartUsersMonth',
  components:{
    UserChartConnected
  },
  data () {
    return {
    };
  },
  props: {
    userid: null
  },
  computed: {
    ...mapState([
      'workingtime',
      'users',
      'all_workingtimes',
      'current_user'
    ])
  },
  methods:{
    updateChart () {
      this.$refs.need_help.update();
    },
    getAssociatedWorkingTime() {
      let associatedArray = []
    
      for (let i = 0; i < this.users.length; i++) {
        let id = this.users[i].id
        let works = []
        for (let j = 0; j < this.all_workingtimes.length; j++) {
          if (id === this.all_workingtimes[j].users)
            works.push(this.all_workingtimes[j])
        }
        associatedArray.push([this.users[i].username, works])
      }
      return associatedArray
    },
    findData(){
      var data = new Object;
      var username = [];
      var hours = [];
      var color = [];
      var dataTemp=this.getAssociatedWorkingTime();
      for (var i = 0; i < dataTemp.length; i++){
        username.push(dataTemp[i][0]);
        hours.push(parseFloat(findHours(dataTemp[i][1])));
        color.push(randomColor());
      }
      data.users=username;
      data.hours=hours;
      data.color=color;

      return data
    },
    difineData(){
      return {
        labels: this.findData().users,
        datasets: [
          {
            label: "Data One",
            backgroundColor: this.findData().color,
            data: this.findData().hours
          }
        ]
      };
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  /* .small {
    max-width: 400px;
    margin:  auto auto;
  } */
</style>
