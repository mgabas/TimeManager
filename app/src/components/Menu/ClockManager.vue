<template>
  <div class="dp-flex-vertical-center container">
    <div class="bg-color-2 bd-r-15 bd-shadow card">
      <div class="dp-flex-vertical-center" >
        <template v-if="currentTime()">
          <img id="moon" src="../../assets/img/moon.svg" alt="clock">
        </template>
        <template v-else>
          <img id="sun" src="../../assets/img/sun.svg" alt="clock">
        </template>
      </div>
    <div class="dp-flex " >
      <div class="dp-flex-vertical-center" >
        <img class="img-color img_scoped" src="../../assets/img/clock.svg" alt="clock">
      </div>
      <div class="dp-flex-vertical-center">
        <ul>
          <li class="element-list" >{{ user.username }}</li>
          <li class="element-list" :key="time" >{{ time.format('LLLL') }}</li>
          <li class="element-list" v-if="clock.status === true" >Is working...</li>
          <li class="element-list" v-else>Finished job</li>
        </ul>
      </div>
    </div>
      <div class="dp-flex-center w-100">
    <div class="dp-flex-space-between w-80">
      <button class="btn-submit btn" @click="stopJob()" v-if="clock.status === true" >Stop</button>
      <button class="btn-submit btn" @click="startJob()" v-else >Start</button>
    </div>
      </div>
      </div>
  </div>
</template>

<script>
import {mapState} from 'vuex';
import moment from 'moment';

export default {
  name: 'ClockManager',
  data () {
    return {
      time: null
    }
  },
  props: {
    data: null,
    userid: null
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
    async getClockStatus() {
      this.$store.commit('get_clock_with_userid', this.current_user);
      await new Promise(resolve => setTimeout(resolve, 500));
      
    },
    async startJob() {
      const payload = {"username": this.current_user, "status": true, "time": moment(new Date()).format('YYYY-MM-DD HH:mm:ss')};
      this.$store.commit('update_clock', payload); 

      await new Promise(resolve => setTimeout(resolve, 500));
      await this.getClockStatus();
    },
    async stopJob() {
      this.$store.commit('get_clock_with_userid', this.current_user);
      await new Promise(resolve => setTimeout(resolve, 500));

      let payload2 = {"start": this.clock.time, "end": moment(new Date()).format('YYYY-MM-DD HH:mm:ss'), "users": this.current_user};
      this.$store.commit('create_workingtimes', payload2);

      let payload = {"username": this.current_user, "status": false, "time": moment(new Date()).format('YYYY-MM-DD HH:mm:ss')};
      this.$store.commit('update_clock', payload);

      await new Promise(resolve => setTimeout(resolve, 500));
      await this.getClockStatus();
    },
    currentTime() {
      var now = new Date();
      if (now.getHours() > 19 && now.getHours() < 6){
        return true;
      }
      else{
        return false;
      }
    }
  },
  mounted() {
    this.$nextTick(function () {
      this.getClockStatus();


      setInterval((e) => {
          this.time  = moment(new Date());
      },1000);
    })

  },
  beforeDestroy () {
	  clearInterval()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

.container{
  height:600px;
}
.card{
  box-shadow: 0 3px 10px rgb(0 0 0 / 0.2);
  padding: 12px;
  position: relative;

}
.element-list{
  list-style: none;
}

.img_scoped{
  filter: invert(36%) sepia(51%) saturate(413%) hue-rotate(183deg) brightness(92%) contrast(86%);
}

.container #sun{
  filter: invert(0.79) saturate(0.9) sepia(1) drop-shadow( 3px 3px 2px rgba(0, 0, 0, .3));
  width: 98px;
  position: absolute;
  bottom: 60%;
  right: -16%;
}

.container #moon{
  filter: invert(0.79) saturate(0.9) sepia(1) drop-shadow( 3px 3px 2px rgba(0, 0, 0, .3));
  width: 200px;
  position: absolute;
  bottom: 54%;
  right: -34%;
}



.btn{
  margin:7px;
  transition: 0.2s;
  padding: 20px;
  border: none;
  border-radius:12px;
}
.btn:hover{
  transform: scale(0.9);
}


ul{
  margin:0px;
  padding: 0px;

}

</style>
