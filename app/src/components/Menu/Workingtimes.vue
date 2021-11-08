<template>
  <div class="dp-flex" v-if="this.user.job !== 'Employee'">
    <div v-for="(met, index) in names" :key="index" class="p-m m-m dp-flex-column">
      <div class="dp-flex-vertical-center m-b-s">
        <span class="fz-l fw-b text-color-3">{{ met[0].toUpperCase() + met.slice(1) }} WorkingTimes</span>
      </div>
      <WorkingtimesBloc class="dp-flex-vertical-center bg-color-2 bd-r-15 bd-shadow p-m h-100" style="min-width: 285px;" :name="met"/>
    </div>
    <div class="p-m m-m dp-flex-column">
      <div class="dp-flex-vertical-center m-b-s">
        <span class="fz-l fw-b text-color-3">Delete Workingtimes</span>
      </div>
      <div class="dp-flex-vertical-center bg-color-2 bd-r-15 bd-shadow p-m m-m h-100" style="min-width: 285px;">
        <div class="text-align-left text-color-3 fz-l fw-b">
          <label>Select Workingtimes Id: </label>
        </div>
        <CustomSelect
          :options="workingtime"
          :key="refresh"
          :default="'Please Select One'"
          class="select"
          @input="selectId"
        />
        <div class="dp-flex-center w-100 m-t-s click" @click="deleteWorkingTime">
          <UserBloc class="w-70" name="delete"/>
        </div>
      </div>
    </div>
    <br>
  </div>
</template>

<script>
import Datepicker from 'vuejs-datepicker';
import {mapState} from 'vuex';
import moment from 'moment';
import WorkingtimesBloc from "../Workingtimes/WorkingtimesBloc";
import UserBloc from "../User/UserBloc";
import CustomSelect from '../Workingtimes/CustomSelect';

export default {
  name: 'Workingtimes',
  components: {
    Datepicker,
    WorkingtimesBloc,
    UserBloc,
    CustomSelect
  },
  data () {
    return {
      names: ["create", "update"],
      id: "",
      refresh: false
    }
  },
  props: {
    data: null,
    userid: null
  },
  computed: {
    ...mapState([
      'current_user',
      'workingtimes',
      'workingtime',
      'user'
    ])
  },
  methods: {
    selectId(event) {
      if (event !== "Please Select One")
        this.id = event;
    },
    getWorkingTimes() {
      this.$store.commit('get_workingtime_with_userid', this.current_user);
    },
    async deleteWorkingTime() {
      if (this.id === '') {
        return;
      }
      this.$store.commit('delete_workingtimes', this.id);
      await new Promise(resolve => setTimeout(resolve, 500));
      this.id = '';
      this.getWorkingTimes();
      this.refresh = !this.refresh;
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
</style>
