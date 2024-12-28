<template>
  <div id="app">
    <header class="header">
      <h1>ERC721 Apple Style Interaction</h1>
    </header>
    <main>
      <ContractInteraction />
    </main>
  </div>
</template>

<script>
import ContractInteraction from './ContractInteraction.vue';

export default {
  name: 'App',
  components: {
    ContractInteraction,
  },
};
</script>

<style>
@import './styles.css';

body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

header {
  background: #f9f9f9;
  padding: 1rem;
  text-align: center;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

main {
  padding: 1rem;
}
</style>
