<template>
  <div>
    <div class="dp-flex-vertical-center m-b-s m-t-l">
      <div>
        <span class="fz-l fw-b text-color-3">Workingtimes Table</span>
      </div>
    </div>
    <div class="m-t-m">
      <div class="dp-flex-center w-100">
        <div class="dp-flex-column w-90 bg-color-2 scrollable-y-l" style="border: 2px solid var(--color-3);">
          <div class="dp-flex-space-between" v-for="(tim, index) in data" :key="index">
            <div class="div_time_solo w-100 dp-flex-center" style="border: 2px solid var(--color-3);" v-for="(time, index) in tim" :key="index">
              <div class="w-100 dp-flex-vertical-center m-m">
                <div class="w-100 text-align-center text-color-1" style="border-bottom: 1px solid var(--color-3); font-size: 25px;">
                  {{ index }}
                </div>
                <div class="m-t-s w-100 dp-flex-space-between" v-for="(tmp, index) in time" :key="index">
                  <div class="w-30 h-100 m-v-xs bg-color-3 text-align-center text-color-1"> {{ tmp.start }}</div>
                  <label class="To">To</label>
                  <div class="w-30 h-100 m-v-xs bg-color-3 text-align-center text-color-1"> {{ tmp.end }}</div>
                </div>
              </div>
            </div>
            <div class="div_time_solo w-100 dp-flex-center" style="border: 2px solid var(--color-3);">
              <div class="w-100 dp-flex-vertical-center m-m">
                <div class="w-100 text-align-center text-color-1" style="border-bottom: 1px solid var(--color-3); font-size: 25px;">
                  Total
                </div>
                <div class="m-t-s w-100 dp-flex-center">
                  <div class="w-50 h-100 m-v-xs bg-color-3 text-color-1 text-align-center"> {{ totalHour(tim) }}</div>
                </div>
                <div class="m-t-s w-100 text-align-center text-color-1" style="height: 50%;">
                  <label>/35h</label>
                  <label>(temps minimum par semaine)</label>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {mapState} from 'vuex';
import moment from 'moment';

export default {
  name: 'Workingtime',
  data() {
    return {
      data: {}
    }
  },
  component: {
    moment
  },
  props: {
    userid: null
  },
  computed: {
    ...mapState([
      'workingtime'
    ])
  },
  methods: {
    totalHour(workingtimes) {
      let totalTimeHour = 0;
      let totalTimeMinute = 0;
      for (const [key, value] of Object.entries(workingtimes)) {
        value.forEach(function (workingtime) {
          let splitStart = workingtime.start.split(':');
          let startMinute = splitStart[1];
          let startHour = splitStart[0];

          let splitEnd = workingtime.end.split(':');
          let endMinute = splitEnd[1];
          let endHour = splitEnd[0];

          let diffMinute = endMinute - startMinute;
          let diffHour = endHour - startHour;

          if (diffMinute < 0) {
            let diffNegatif = diffHour * 60 + diffMinute;
              diffHour = parseInt(diffNegatif / 60)
              diffMinute = parseInt(((diffNegatif / 60) % 1)*60)
          }

          totalTimeHour += parseInt(diffHour);
          totalTimeMinute += parseInt(diffMinute);
        })
      }

      if ((totalTimeMinute / 60) >= 1) {
        totalTimeHour += parseInt(totalTimeMinute / 60)
        totalTimeMinute = Math.round(((totalTimeMinute / 60) % 1)*60)
      }
      if (totalTimeMinute < 10) {
        totalTimeMinute = '0' + totalTimeMinute;
      }
      return totalTimeHour + 'h' + totalTimeMinute;
    },
    getAllDate() {
      const prevMonthStart = moment().subtract(1, 'month').startOf('month');
      const nextMouthStart = moment().add(1, 'month').startOf('month');
      const prevMonthDays = prevMonthStart.daysInMonth() + nextMouthStart.daysInMonth() + moment().daysInMonth();
      let prevMonth = prevMonthStart;
      let prevMonthDates = [];
      let weekDays = [];
      let ismonday = false;
      let tmp = null;
      for (let i = 0; i <= prevMonthDays; i++) {
        tmp = prevMonth.clone().add(i, 'days').format("YYYY-MM-DD");
        if (moment(tmp).format('dddd') === "Saturday") {
          if (weekDays.length !== 0)
            prevMonthDates.push(weekDays);
          weekDays = [];
          ismonday = false;
        } else if (moment(tmp).format('dddd') === "Monday")
          ismonday = true;
        if (ismonday === true) {
          weekDays.push(moment(tmp).format("DD/MM/YYYY"));
        }
      }
      return prevMonthDates;
    },
    dateformating(tmp) {
      let start = tmp.split("T");
      start = start[1].slice(0, -1);
      start = start.split(":");
      start = start[0] + ':' + start[1];
      return start;
    },
    async getWorkingTimes() {
      this.$store.commit('get_workingtime_with_userid', this.userid);
      await new Promise(resolve => setTimeout(resolve, 500));
      let all_date = this.getAllDate();
      let data = {};
      for (let i = 0; i < all_date.length; i++) {
        data[i] = {};
        for (let k = 0; k < all_date[i].length; k++) {
          data[i][all_date[i][k]] = [];
        }
      }
      for (const tmp of this.$store.state.workingtime) {
        const start = this.dateformating(tmp.start);
        const end = this.dateformating(tmp.end);
        let json = {
          "start": start,
          "end": end,
          "date": moment(tmp.start).locale("fr").format("DD/MM/YYYY")
        };
        for (let i = 0; i < Object.keys(data).length; i++) {
          if (json.date in data[i]) {
            data[i][json.date].push(json);
          }
        }
      }
      this.data = data;
    }
  },
  mounted() {
    this.$nextTick(function () {
      this.getWorkingTimes();
    })
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
::-webkit-scrollbar {
  width: 6px;
}

::-webkit-scrollbar-track {
  -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
}

::-webkit-scrollbar-thumb {
  -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
}
</style>
