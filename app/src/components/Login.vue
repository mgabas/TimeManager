<template>
  <div>
    <div class="blur"></div>
    <div class="form">
      <span style="font-size: 50px">Login</span>
      <br/>
      <span style="opacity: 0; color: red;" ref="error"></span>
      <br/>
      <div class="error" v-if="!$v.email.required">Email is required</div>
      <div class="error" v-if="!$v.email.minLength">Email must have at least {{ $v.email.$params.minLength.min }}
        characters.
      </div>
      <div class="error" v-if="!$v.email.maxLength">Email must have a maximum of {{ $v.email.$params.maxLength.max }}
        characters.
      </div>
      <div class="error" v-if="!$v.email.email">Email require at least a @ and a valid extension.</div>
      <input placeholder="Enter your email" class="form__input" v-model.trim="$v.email.$model"
             @input="setEmail($event.target.value)"/>
      <div class="error" v-if="!$v.password.required">Password is required</div>
      <div class="error" v-if="!$v.password.minLength">Password must have at least
        {{ $v.password.$params.minLength.min }} characters.
      </div>
      <div class="error" v-if="!$v.password.maxLength">Pseudo must have a maximum of
        {{ $v.password.$params.maxLength.max }} characters.
      </div>
      <input placeholder="Enter your password" type="password" class="m-h-s inpt" v-model.trim="$v.password.$model"
             @input="setPasswords($event.target.value)"/>
      <button type="submit" class="btn-submit" @click="login">Connect</button>
    </div>
  </div>
</template>

<script>
import {mapState} from "vuex";
import UserBloc from "./User/UserBloc";
import {required, minLength, maxLength, email} from 'vuelidate/lib/validators'

export default {
  name: 'User',
  data() {
    return {
      password: "",
      email: ""
    }
  },
  components: {
    UserBloc
  },
  computed: {
    ...mapState([
      'current_user',
      'users',
      'user',
      'error'
    ])
  },
  validations: {
    email: {
      required,
      email,
      minLength: minLength(5),
      maxLength: maxLength(50)
    },
    password: {
      required,
      minLength: minLength(3),
      maxLength: maxLength(50)
    }
  },
  methods: {
    setEmail(value) {
      this.email = value;
      this.$v.email.$touch();
    },
    setPasswords(value) {
      this.password = value;
      this.$v.password.$touch();
    },
    utf8_to_b64(str) {
      return window.btoa(unescape(encodeURIComponent(str)));
    },
    b64_to_sha256(str) {
      return this.CryptoJS.SHA256(str).toString();
    },
    async login() {
      if (this.$v.$invalid)
        return;
      let pass_tmp = this.utf8_to_b64(this.password);
      pass_tmp = this.b64_to_sha256(pass_tmp.toString());
      const json = JSON.stringify({"users": {"email": this.email, "password": pass_tmp}});
      this.$store.commit('login_user', json);
      await new Promise(resolve => setTimeout(resolve, 500));
      if (this.$store.state.error !== undefined) {
        this.$refs.error.value = this.$store.state.error;
        this.$refs.error.style.opacity = "1";
      }
    }
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.user-div-general {
  position: absolute;
  width: 200px;
  right: 0;
  border-radius: 0 0 30px 30px;
  box-shadow: 0 3px 10px rgb(0 0 0 / 0.2);
  top: 50px;
  animation: slidein 0.3s;
}

@keyframes slidein {
  from {
    margin-top: -180px
  }

  to {
    margin-top: 0;
  }
}

.blur {
  background-image: url("../assets/img/Capture.png");
  filter: blur(8px);
  -webkit-filter: blur(8px);
  height: 900px;
  width: 100%;
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
}

.form {
  display: flex;
  flex-direction: column;
  justify-content: center;
  z-index: 1;
  background-color: #F5F8FF;
  max-width: 360px;
  margin: 0 auto 100px;
  padding: 45px;
  text-align: center;
  box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  height: 400px;
  width: 300px;
  border-radius: 30px;
  color: #51648F;
}

.form input {
  font-family: "Roboto", sans-serif;
  outline: 0;
  background: #FFFFFF;
  width: 100%;
  border: 0;
  margin: 0 0 15px;
  padding: 15px;
  box-sizing: border-box;
  font-size: 14px;
}

.error {
  color: red;
}
</style>
