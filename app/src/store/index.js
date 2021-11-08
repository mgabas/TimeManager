import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    urlBase: 'http://134.209.31.125:4000/api',
    current_user: undefined,
    users: [],
    user: [],
    team: [],
    team_members: [],
    workingtime: [],
    workingtimes: [],
    all_workingtimes: [],
    clock: [],
    error: undefined
  },
  mutations: {
    //User route
    get_users(state, payload) {
      state.users = [];

      fetch(state.urlBase + '/users')
        .then(response => response.json())
        .then(data => {
          data = data['data'];
          for (let i = 0; i < data.length; i++) {
            if (data[i].id === data[i].username) {
              continue
            }
            state.users.push(data[i]);
          }
        });
    },
    login_user(state, payload) {
      state.current_user = "";
      fetch(state.urlBase + '/users/sign-in', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: payload
      }).then(async response => {
        const data = await response.json();
        if (response.statusText === 403) {
          state.error = "No account found";
        } else if (response.statusText === 401) {
          state.error = "Wrong Password";
        } else if (response.statusText === 200) {
          state.current_user = data['data']['token'];
          state.user = data['data'];
        }
      })
    },
    get_users_with_userid(state, payload = null) {
      state.user = [];
      if (payload === "undefined") {
        state.current_user = undefined;
        return;
      }
      fetch(state.urlBase + '/users/' + state.current_user)
        .then(response => response.json())
        .then(data => {
          state.user = data['data'];
        });
    },
    get_users_with_username_email(state, payload) {
      state.user = [];

      fetch(state.urlBase + '/users?username=' + payload["username"] + '&email=' + payload["email"])
        .then(response => response.json())
        .then(data => {
          state.user = data['data'];
        });
    },
    create_user(state, payload) {
      let user = {"users": {"username": payload['username'], "email": payload['email'], "job": payload['job']}};
      let element = JSON.stringify(user);

      fetch(state.urlBase + '/users', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: element
      }).then(response => {
        console.log(response)
      });
    },
    update_user(state, payload) {
      let user = {"users": {"username": payload.username, "email": payload.email}};
      let element = JSON.stringify(user)

      fetch(state.urlBase + '/users/' + state.current_user, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: element
      }).then(response => console.log(response));
    },
    delete_user(state, payload) {
      fetch(state.urlBase + '/users/' + payload, {method: 'DELETE'})
        .then(response => console.log(response))
    },
    //workingtime route
    get_workingtime_with_userid(state, payload) {
      fetch(state.urlBase + '/workingtimes/' + payload)
        .then(response => response.json())
        .then(data => {
          state.workingtime = data['data'];
        });
    },
    get_all_workingtimes(state, payload) {
      fetch(state.urlBase + '/workingtimes')
        .then(response => response.json())
        .then(data => {
          state.all_workingtimes = data['data']
        })
    },
    get_workingtimes_with_id(state, payload) {
      fetch(state.urlBase + '/workingtimes/id/' + payload)
        .then(response => response.json())
        .then(data => {
          state.workingtimes = data['data']
        })
    },
    //workingtimes route
    create_workingtimes(state, payload) {
      let workingtimes = {"workingtimes": {"start": payload.start, "end": payload.end, "users": state.current_user}};
      let element = JSON.stringify(workingtimes);
      fetch(state.urlBase + '/workingtimes/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: element
      }).then(response => {
        console.log(response)
      });
    },
    update_workingtimes(state, payload) {
      let workingtimes = {"workingtimes": {"start": payload.start, "end": payload.end}};
      let element = JSON.stringify(workingtimes)

      fetch(state.urlBase + '/workingtimes/' + payload.id, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },
        body: element
      }).then(response => console.log(response.data));
    },
    delete_workingtimes(state, payload) {
      fetch(state.urlBase + '/workingtimes/' + payload, {
          method: 'DELETE'
        }
      )
        .then(response => {
          console.log(response)
        })
    },
    //Clocks route
    get_clock_with_userid(state, payload) {
      state.clock = []
      fetch(state.urlBase + '/clocks/' + payload)
        .then(response => response.json())
        .then(data => {
          state.clock = data['data'];
        });
    },
    create_clock(state, payload) {
      fetch(state.urlBase + '/clocks/' + payload, {method: 'POST'})
        .then(response => {
        console.log(response)
      });
    },
    update_clock(state, payload) {
      fetch(state.urlBase + '/clocks?userid=' + payload.username + '&status=' + payload.status + "&time=" + payload.time, {method: 'PUT'})
        .then(response => {
          console.log(response)
        });
    },
    get_team_by_userid(state, payload) {
      state.team = [];
      fetch(state.urlBase + '/teams/user/' + payload)
        .then(response => {
          switch (response.status) {
            case 400:
              console.log('400 error');  // not getting here
              break;
            default:
              console.log('some other error');  // end up here all the time
              break;
          }
          if (response.status < 300) {
            response.json()
          }
        })
        .then(data => {
          if (data !== undefined) {
            state.team = data['data'];
          }
        })
    },
    get_team_members_by_id_team(state) {
      state.team_members = [];
      fetch(state.urlBase + '/users/members/' + state.team.id)
        .then(response => response.json())
        .then(data => {
          state.team_members = data['data'];
        })
    }

  },
  actions: {},
  modules: {}
})
