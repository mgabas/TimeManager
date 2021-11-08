<template>
  <div>
    <div class="btn dp-flex-center w-100 p-b-s">
      <div class="w-80 bg-color-1 bd-r-15 bd-shadow p-s dp-flex">
        <div class="dp-flex-vertical-center">
          <img :src="getImgUrl()" class="img-color" height="25" width="25"/>
        </div>
        <div class="w-100 dp-flex-vertical-center text-color-3 fz-s">
          {{name[0].toUpperCase() + name.slice(1)}} {{component}}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UserBloc',
  data () {
    return {
    }
  },
  methods: {
    getImgUrl() {
      let images = require.context('../../assets/icons', false, /\.svg$/)
      return images('./' + this.name + ".svg")
    }
  },
  props: {
    name: '',
    component: ''
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
