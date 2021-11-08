<template>
  <div>
    <div class="dp-flex-column tests bd-r-30 bd-shadow bg-color-2 p-m" :class="{[`bg-color-3`] : user.job === 'Manager'}">
      <div class="h-40">
        <div class="dp-flex-vertical-center">
          <div class="fz-l fw-b">
            {{ user.username.toUpperCase() }}
          </div>
          <div>
            {{ user.job }}
          </div>
        </div>
      </div>
      <div class="h-60">
        <div v-for="(name, index) in component" :key="index" @click="handleFunctionName(name)">
          <UserBloc name="get" :component="name"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import UserBloc from "../User/UserBloc";

export default {
  name: 'TeamUserBloc',
  data() {
    return {
      component: ['chart', 'workingtime', 'clock']
    }
  },
  components: {
    UserBloc
  },
  methods: {
    handleFunctionName(functionName) {
      switch (functionName) {
        case "chart":
          this.getChart()
          break;
        case "workingtime":
          this.getWorkingtime()
          break;
        case "clock":
          this.getClock()
          break;
      }
    },
    getChart() {

    },
    getClock() {

    },
    getWorkingtime() {
      this.$router.push({
        name: 'Workingtime',
        params: {'userid': this.user.id}
      })
    }
  },
  props: {
    user: null
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.tests {
  width: 200px;
  height: 260px;
}

.h-40 {
  height: 40%;
}

.h-60 {
  height: 60%;
}
</style>
