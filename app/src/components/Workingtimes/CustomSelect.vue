<template>
  <div class="custom-select" :tabindex="tabindex" @blur="open = false">
    <div class="selected" :class="{ open: open }" @click="open = !open">
      {{ selected }}
    </div>
    <div class="items scrollable-y" :class="{ selectHide: !open }">
      <div
        v-for="option of options"
        :key="option.id"
        @click="changeSelected(option)"
      >
        <span v-if="option.username !== undefined">{{ option.username }}</span>
        <span v-else>{{ option.id }}</span>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  props: {
    options: {
      type: Array,
      required: true,
    },
    default: {
      type: String,
      required: false,
      default: null,
    },
    tabindex: {
      type: Number,
      required: false,
      default: 0,
    },
  },
  data() {
    return {
      selected: this.default
        ? this.default
        : this.options.length > 0
        ? this.options[0].id
        : null,
      open: false,
    };
  },
  methods: {
    changeSelected(option) {
      if (option.username !== undefined) {
        this.selected = option.username
        this.$emit('input', option.id);
      } else {
        this.selected = option.id;
        this.$emit('input', option.id);
      }
      this.open = false;
    }
  },
  mounted() {
    this.$emit("input", this.selected);
  },
};
</script>

<style scoped>
.custom-select {
  position: relative;
  width: 100%;
  text-align: left;
  outline: none;
  height: 47px;
  line-height: 47px;
  font-size: 13px;
}

.custom-select .selected {
  background-color: var(--color-3);
  border-radius: 6px;
  border: 1px solid var(--color-2);
  color: var(--color-1);
  padding-left: 1em;
  padding-right: 2em;
  cursor: pointer;
  user-select: none;
}

.custom-select .selected:after {
  position: absolute;
  content: "";
  top: 22px;
  right: 1em;
  width: 0;
  height: 0;
  border: 5px solid transparent;
  border-color: var(--color-1) transparent transparent transparent;
}

.custom-select .items {
  color: var(--color-1);
  border-radius: 0px 0px 6px 6px;
  border-right: 1px solid var(--color-2);
  border-left: 1px solid var(--color-2);
  border-bottom: 1px solid var(--color-2);
  position: absolute;
  background-color: var(--color-3);
  left: 0;
  right: 0;
  z-index: 1;
}

.custom-select .items div {
  color: var(--color-1);
  padding-left: 1em;
  cursor: pointer;
  user-select: none;
}

.custom-select .items div:hover {
  background-color: var(--color-1);
  color: var(--color-3);
}

.selectHide {
  display: none;
}
</style>
