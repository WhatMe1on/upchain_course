import { createApp } from 'vue'
import erc20 from './pages/erc20/App.vue'
import erc721 from './pages/erc721/App.vue'

// const erc20App = createApp(erc20)
// erc20App.mount('#app')

const erc721App = createApp(erc721)
erc721App.mount('#app')

