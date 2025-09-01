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