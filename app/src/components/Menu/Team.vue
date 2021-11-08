<template>
  <div>
    <div class="w-100 m-t-m">
      <div id="title" class="dp-flex-vertical-center">
        <div class="fz-l fw-b text-color-3">
          MY TEAM
        </div>
      </div>
      <div id="team-part" class="w-100 dp-flex-center">
        <div class="dp-flex-vertical-center bd-color-3 bd-r-15 test">
          <div class="team-grid-container m-m">
            <div v-for="(user, index) in team_members" :key="index" class="grid-item"
                 :class="{[`grid-item-1`] : team_members.length % 3 === 1 && index === team_members.length - 1,
                          [`grid-item-2`] : team_members.length % 3 === 2 && index === team_members.length - 2
                                         || team_members.length % 3 === 2 && index === team_members.length - 1}">
              <div>
                <TeamUserBloc :user="user"/>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import TeamUserBloc from "../Teams/TeamUserBloc";
import {mapState} from "vuex";

export default {
  name: 'Teams',
  data() {
    return {
    }
  },
  computed: {
    ...mapState([
      'team',
      'team_members',
      'current_user'
    ])
  },
  components: {
    TeamUserBloc
  },
  props: {
    userid: null
  },
  methods: {

  },
  mounted() {
    this.$nextTick(async function () {
      this.$store.commit('get_team_by_userid', this.current_user);
      await new Promise(resolve => setTimeout(resolve, 500));
      this.$store.commit('get_team_members_by_id_team');

    })
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.test {
  min-height: 400px;
  min-width: 600px;
}

.team-grid-container {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  grid-gap: 1rem;
  justify-items: center;
}

.grid-item {
  grid-column: span 2;
}

.grid-item-1 {
  grid-column: span 6;
}

.grid-item-2 {
  grid-column: span 3;
}

</style>
