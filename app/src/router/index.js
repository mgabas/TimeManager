import Vue from 'vue'
import Router from 'vue-router'
import User from "../components/User";
import Home from "../components/Menu/Home";
import Team from "../components/Menu/Team";
import Login from "../components/Login";
import Workingtime from "../components/Menu/Workingtime";
import Workingtimes from "../components/Menu/Workingtimes";
import ChartManager from "../components/Menu/ChartManager";
import ClockManager from "../components/Menu/ClockManager";

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/User',
      name: 'User',
      component: User,
      props: true
    },
    {
      path: '/Home',
      name: 'Home',
      component: Home,
      props: true
    },
    {
      path: '/ClockManager',
      name: 'ClockManager',
      component: ClockManager,
      props: true
    },
    {
      path: '/Workingtimes',
      name: 'Workingtimes',
      component: Workingtimes,
      props: true
    },
    {
      path: '/Workingtime',
      name: 'Workingtime',
      component: Workingtime,
      props: true
    },
    {
      path: '/ChartManager',
      name: 'ChartManager',
      component: ChartManager,
      props: true
    },
    {
      path: '/Team',
      name: 'Team',
      component: Team,
      props: true
    },
    {
      path: '/Login',
      name: 'Login',
      component: Login,
      props: true
    }
  ]
})
