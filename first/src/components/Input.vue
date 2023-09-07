<script setup>
import { ref, computed } from 'vue'

const input = ref('')
const output = ref('')

const fib = n => {
  if (n === 1) return 1
  if (n === 2) return 1
  return fib(n - 1) + fib(n - 2)  
}

const calculate = () => {
  const n = parseInt(input.value)
  if (!isNaN(n)) {
    output.value = fib(n) 
  }
}
</script>

<template>
  <v-container class="fill-height">
    <v-card class="pa-5" outlined outlined-width="1" theme="dark">
      <div class="d-flex flex-column align-center">

        <h1 class="text-h2 font-weight-bold mb-5">Приветствую!</h1>

        <h3 class="text-h3 font-weight-regular mb-5">Укажи N-ое число из последовательности Фибоначчи</h3>

        <h4 v-if="!output" class="text-h4 font-weight-regular mb-5"></h4>
        <h4 v-else class="text-h4 font-weight-regular mb-5">Результат: {{ output }}</h4>

        <v-text-field
          clearable
          label="Число"
          variant="outlined" 
          min-width="200"
          v-model="input"
          @keyup.enter="calculate"
        />

      </div>
    </v-card>
  </v-container>
</template>

<style scoped>
:deep() .v-text-field {
  width: 400px;
}
</style>