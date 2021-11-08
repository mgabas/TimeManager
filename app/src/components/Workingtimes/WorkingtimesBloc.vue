<template>
  <div>
    <div class="w-100">
      <div class="text-align-left text-color-3 fz-l fw-b m-t-xs">
        <label>Start: </label>
      </div>
      <!--<Datepicker :key="customDate" inputClass="button-datePicker" v-model="customDate" format="dd-MM-yyyy" placeholder="Select Date"></Datepicker>-->
      <Datetime type="datetime"
                v-model="customDate"
                :key="customDate"
                input-class="button-datePicker"
                placeholder="Select Date"
                :auto="true">
      </Datetime>
    </div>
    <div class="w-100 m-t-xs">
      <div class="text-align-left text-color-3 fz-l fw-b">
        <label>End: </label>
      </div>
      <!--<Datepicker :key="customDate2" inputClass="button-datePicker" v-model="customDate2" format="dd-MM-yyyy" placeholder="Select Date"></Datepicker>-->
      <Datetime type="datetime"
                v-model="customDate2"
                :key="customDate2"
                input-class="button-datePicker"
                placeholder="Select Date"
                :auto="true">
      </Datetime>
    </div>
    <div v-if="name === 'update'" class="w-100 m-t-s">
      <div class="text-align-left text-color-3 fz-l fw-b">
        <label>Select Workingtimes Id: </label>
      </div>
      <CustomSelect
        :key="refresh"
        :options="workingtime"
        :default="'Please Select One'"
        class="select"
        @input="selectId"
      />
    </div>
    <div class="dp-flex-center w-100 m-t-s click" @click="handlerFunctionName()">
      <UserBloc class="w-70" :name="name"/>
    </div>
  </div>
</template>

<script>
import Datepicker from 'vuejs-datepicker';
import moment from 'moment';
import {mapState} from 'vuex';
import UserBloc from '../User/UserBloc';
import CustomSelect from '../Workingtimes/CustomSelect';
import { Datetime } from 'vue-datetime';
import { Settings } from 'luxon';
import 'vue-datetime/dist/vue-datetime.css';

export default {
  name: 'WorkingtimesBloc',
  data() {
    return {
      customDate: null,
      customDate2: null,
      id:"",
      refresh: false
    }
  },
  props: {
    name: ''
  },
  computed: {
    ...mapState([
      'workingtime',
      'workingtimes'
    ])
  },
  components: {
    Datepicker,
    UserBloc,
    CustomSelect,
    Datetime,
    Settings
  },
  methods: {
    async selectId(event) {
      if (event === "Please Select One") {
        return;
      }
      if (this.name !== "update") {
        return;
      }
      this.$store.commit('get_workingtimes_with_id', event);
      await new Promise(resolve => setTimeout(resolve, 300));
      this.customDate2 = this.$store.state.workingtimes.end;
      this.customDate = this.$store.state.workingtimes.start;
      let tmp = this.customDate2.split("T");
      this.customDate2 = tmp[0] + ' ' +  tmp[1].slice(0, -1);
      tmp = this.customDate.split("T");
      this.customDate = tmp[0] + ' ' + tmp[1].slice(0, -1);
      this.id = event;
    },
    handlerFunctionName() {
      switch (this.name) {
        case "create":
          this.createWorkingTime();
          break;
        case "update":
          this.updateWorkingTime();
          break;
      }
    },
    async createWorkingTime() {
      if (this.customDate === '' || this.customDate2 === '' || this.id === '') {
        return;
      }
      let working = {
        "start": moment(this.customDate).locale("fr").format('YYYY-MM-DD HH:mm:ss'),
        "end": moment(this.customDate2).format('YYYY-MM-DD HH:mm:ss')
      }
      this.$store.commit('create_workingtimes', working);
      await new Promise(resolve => setTimeout(resolve, 500));
      this.getWorkingTimes();
    },
    async updateWorkingTime() {
      if (this.customDate === '' || this.customDate2 === '' || this.id === '') {
        return;
      }
      let working = {
        "start": moment(this.customDate).locale("fr").format('YYYY-MM-DD HH:mm:ss'),
        "end": moment(this.customDate2).format('YYYY-MM-DD HH:mm:ss'),
        "id": this.id
      }
      this.$store.commit('update_workingtimes', working);
      await new Promise(resolve => setTimeout(resolve, 500));
      this.getWorkingTimes()
      this.refresh = !this.refresh
    },
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
::-webkit-scrollbar {
  width: 6px;
}
::-webkit-scrollbar-track {
  -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
}
::-webkit-scrollbar-thumb {
  -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
}
</style>
