const user1 = { name: 'Nathan'}
const user2 = { name: 'John'}

function logInfo () {
  console.log('this: ', this)
  console.log('this.name: ', this.name)
}

logInfo() // this: Window, this.name: ''

user1.logName = logInfo
user2.logName = logInfo

user1.logName() // this: user1, this.name: 'Nathan'
user2.logName() // this: user2, this.name: 'John'

// Simple calculatorlculator

const calculator = {
  read() {
    this.a = +prompt('First number:', 0)
    this.b = +prompt('Second number:', 0)
  },
  sum() {
    return this.a + this.b
  },
  mul() {
    return this.a * this.b
  }
};

calculator.read()
console.log('calcilator:', calculator)
console.log( 'Sum = ' + calculator.sum() )
console.log( 'Mul = ' + calculator.mul() )

// Stairs

let leader = {
  step: 0,
  up() {
    this.step++
    return this
  },
  down() {
    this.step--
    return this
  },
  showStep: function() { // shows the current step
    console.log( this.step )
    return this
  }
};

// Chaning

leader 
.up()
.up()
.down()
.showStep() // 1
.down()
.showStep() // 0

const price = 99.555

console.log ('price.toFixed(2)', price.toFixed(2)) // 99.56
console.log ('price.toPrecision(2)', price.toPrecision(2)) // 100

const num = 100
const numAsString = num.toString()

console.log('Number:', num) // 100
console.log('Number like a string:', numAsString) // '100'

console.log ('typeof num:', typeof num) // number
console.log ('typeof numAsString:', typeof numAsString) // string

console.log (`Number ${num} in the binary number system:`, num.toString(2)) // 1100100

// Math methods

console.log ('Random value:', Math.random()) // Random value:

function randomIntFromInterval(min, max) {
  return Math.floor(Math.random() * (max - min + 1) + min)
}

const randInt = randomIntFromInterval(1, 10)

console.log('Random integer between 1 and 10:', randInt)

// Module

console.log ('Number with a module:', Math.abs(-10)) // 10

// Power of a number

console.log ('2 in the power of 3:', Math.pow(2, 3)) // 8

// Min and Max

console.log ('Min value from 1, 2, 3, -10, 5:', Math.min(1, 2, 3, -10, 5)) // -10
console.log ('Max value from 1, 2, 3, -10, 5:', Math.max(1, 2, 3, -10, 5)) // 5

const nums = [1, 2, 3, -10, 5]

console.log ('Min value from array:', Math.min(...nums)) // -10

console.log (Math.round(4.6)) // 5
console.log (Math.floor(4.6)) // 4
console.log (Math.ceil(4.2)) // 5
console.log (Math.trunc(4.6)) // 4

const numberAsString = '100.5px'

// console.log ('String to number:', +numberAsString) // 100
// console.log ('String to number:', Number(numberAsString)) // 100

console.log ('parseInt:', parseInt(numberAsString)) // 100
console.log ('parseFloat:', parseFloat(numberAsString)) // 100.5