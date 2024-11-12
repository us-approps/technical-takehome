/*!
* Question 1: VueJS
* Create a simple counter component using Vue.js. The component should have the following features:

* A display area showing the current count.
* Buttons to increment and decrement the count.
* A button to reset the count to zero.
* The provided starter code includes only the .vue Single-File Component. You do not need to load the component
* into a VueJS application, but you may do so if you wish. Our goal is to evaluate your knowledge of VueJS—or your
* ability to pick it up—but we are not concerned with minor syntax or API errors.

* Note: If you are more comfortable using another frontend framework (like React),
* you may do so, but you will not have starter code.

* Additional Notes
* If you'd like, use this space to include thoughts, questions, or documentation you'd like to supplement your code.
*/

<template>
  <div class="counter">
    <h2>Counter</h2>
    <p>Current Count: {{ count }}</p>
    <button @click="increment">Increment</button>
    <button @click="decrement">Decrement</button>
    <button @click="reset">Reset</button>
  </div>
</template>

<script>
export default {
  name: "CounterComponent",
  data() {
    return {
      count: 0
    };
  },
  methods: {
    increment() {
      this.count++;
    },
    decrement() {
      if (this.count > 0) this.count--;
    },
    reset() {
      this.count = 0;
    }
  }
};
</script>

<style scoped>
.counter {
  text-align: center;
  margin-top: 20px;
}

button {
  margin: 5px;
  padding: 10px;
  font-size: 16px;
  cursor: pointer;
}

button:hover {
  background-color: #f0f0f0;
}
</style>
