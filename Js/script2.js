

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

console.log(user1.name [0])
console.log(user2.name [3])


// Simple calculatorlculator

// const calculator = {
//   read() {
//     this.a = +prompt('First number:', 0)
//     this.b = +prompt('Second number:', 0)
//   },
//   sum() {
//     return this.a + this.b
//   },
//   mul() {
//     return this.a * this.b
//   }
// };

// calculator.read()
// console.log('calcilator:', calculator)
// console.log( 'Sum = ' + calculator.sum() )
// console.log( 'Mul = ' + calculator.mul() )

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

console.log (
  'parseInt:', parseInt(numberAsString)
) // 100
console.log (
  'parseFloat:', parseFloat(numberAsString
  )) // 100.5

// at, (toLowerCase, toUpperCase), (trim, trimStart, trimEnd), includes, endsWith, (substring, slice), repeat, replace

const guest3 = {
  surname: ' SmIth JoHnSoN '
}

console.log(guest3.surname.at(-2))  // o
console.log(guest3.surname.toLowerCase())  // smith johnson
console.log(guest3.surname.toUpperCase()) // SMITH JOHNSON


const messageFormatted = guest3.surname.trim()
const messageStartFormatted = guest3.surname.trimStart()
const messageEndFormatted = guest3.surname.trimEnd() 

console.log('Trimmed message:', messageFormatted) // 'SmIth JoHnSoN'
console.log('Trimmed start message:', messageStartFormatted) // 'SmIth JoHnSoN '
console.log('Trimmed end message:', messageEndFormatted) // ' SmIth JoHnSoN'

console.log(
  guest3.surname.indexOf('Sm') !== -1
) // true

console.log(
  guest3.surname.indexOf('dsvjsdnvjksdnv') !== -1
) // false

console.log(guest3.surname.includes('Sm', 0)) // true
console.log(guest3.surname.includes('Jo', 9)) // false

console.log(guest3.surname.endsWith('n', 2)) // false
console.log(guest3.surname.endsWith('n', 16)) // true

console.log(guest3.surname.substring(1, 6)) // SmIth

console.log(guest3.surname.slice(1, 6)) // SmIth
console.log(guest3.surname.slice(-8, -1)) // JoHnSoN

console.log('Repeat:', guest3.surname.repeat(3)) // ' SmIth JoHnSoN  SmIth JoHnSoN  SmIth JoHnSoN '

console.log('Replace:', guest3.surname.replace('SmIth', 'Black')) // ' Black JoHnSoN '
console.log('ReplaceAll:', guest3.surname.replaceAll('S', 'SS')) // ' SSmIth JoHnSSoN '

// Check value in the String (Ex!)

// const value = prompt('Enter a name:')

// const clearValue = value.trim().toLowerCase()

// if (clearValue.length === 0) {
//   alert('You did not enter a name, please try again') 
// }

// if (clearValue.includes('admin') || clearValue.includes('administrator')) {
//   alert("You can't use this name")
// }


// Massives

const arr = [
  'Apple',
  100,
  true,
  { name: 'John'},
  () => { console.log('Hello!') },
  [false, false, false]
]

console.log('Array:', arr)
console.log('First element:', arr[0]) // Apple
console.log('Fourth element:', arr[3]['name']) // John
arr[4]() // Hello!
console.log('Sixth element:', arr[5][2]) // false

arr[0] = 'Orange'
arr[6] = 'New element'
console.log('Changed first element:', arr) // ['Orange', 100, true, {name: 'John'}, ƒ, Array(3)]

// Method at can be used in the massive
console.log('Last element:', arr.at(-1)) // New element

// Inserting new element at the beginning and at the end of the massive with unshift and push
// But sometimes this is not usefull in the real life. Better to add elements in the end of the massive
arr.unshift('First element added with unshift')
arr.push('Last element added with push')


// Delete last element in the massive with pop
console.log('Deleted last element:', arr.pop()) // New element


// Delete first element in the massive with shift
console.log('Deleted first element:', arr.shift()) // First element added with unshift


// slice method - creates a new array by extracting a section of an existing array
const arr2 = [1, 2, 3, 4, 5]
const arr3 = arr2.slice(1, 4)

console.log('arr2:', arr2) // [1, 2, 3, 4, 5]
console.log('arr3 (slice of arr2):', arr3) // [2, 3, 4]

// Combine two arrays with concat or with spread operator

const totalArr = arr2.concat(arr3)
console.log('Combined arr2 and arr3:', totalArr) // [1, 2, 3, 4, 5, 2, 3, 4]

const totalArr2 = [...arr2, ...arr3]
console.log('Combined arr2 and arr3 with spread operator:', totalArr2) // [1, 2, 3, 4, 5, 2, 3, 4]

// Array comparison

const arr1 = ['A', 'B', 'C', []]
const arr4 = ['A', 'B', 'C', []]

const areArraysEqual = (array1, array2) => {
  if (array1.length !== array2.length) {
    return false
  }

  for (let i = 0; i < array1.length; i++) {
    const value1 = array1[i]
    const value2 = array2[i]

    const areValuesArrays = 
      Array.isArray(value1) && Array.isArray(value2)

      if (areValuesArrays) {
        if (!areArraysEqual (value1 , value2)) {
          return false
        } else {
          continue
        }
      }
    if (value1 !== value2) {
      return false
    }
  }
  return true
}

console.log('Are arr1 and arr4 equal:', areArraysEqual(arr1, arr4)) // true

// Methods for work with array!
// forEach(Iterate through the array)
// map(To go through, modify by changing each of its elements and return a new array)
// filter (To filter array with condition)
// find(To find concrete element in the array with condition)
// findIndex (To find index of concrete element in the array)
// reduce(Applies the reducer function to each element of the array (from left to right), returning a single result value)
// reduceRight(Same as reduce, but from right to left)
// some(Deep value chacking in the array), 
// every(Check every element in the array), 
// indexOf(lastIndexof), 
// includes(To check value in the array)
// reverse(Reverses the order of the elements in the array)
// sort(Sorts the elements of an array in place and returns the sorted array)

console.log(
  arr1.findIndex((letter) => {
    if(letter === 'B')
      return true
    }
  )
) // 1

console.log(arr4.includes('C', 2)) // true

const users = [
  {
    name: 'John',
    age: 25,
    city: 'Riga'
  },
    {
    name: 'Bob',
    age: 30,
    city: 'Riga'
  },
    {
    name: 'Max',
    age: 20,
    city: 'Cesis'
  },
]

const userFromRiga = users.find((user) => user.city === 'Riga')

const filteredUsers = users.filter(({city, age}) => {
  return city === 'Riga' || age >= 25
})
console.log('User from Riga:', filteredUsers) // [{name: 'John', age: 25, city: 'Riga'}, {name: 'Bob', age: 30, city: 'Riga'}]

// Map method

const usersFormated = users.map((user) => {
  return `${user.name}, ${user.age} years, from ${user.city}`
})

console.log(usersFormated) // ['John, 25 years, from Riga', 'Bob, 30 years, from Riga', 'Max, 20 years, from Cesis']

// Average age of all users in the array


const averageAge = users.reduce((sum, {age}) => sum + age, 0)

console.log('Average age of all users:', averageAge / users.length) // 25

// Reverse method

const reversedUsers = [...users].reverse()

console.log('Reversed users:', reversedUsers) // [{name: 'Max', age: 20, city: 'Cesis'}, {name: 'Bob', age: 30, city: 'Riga'}, {name: 'John', age: 25, city: 'Riga'}]

// Sort method

const numbers = [5, 2, 1, 4, 3]

const sortedNumbers = [...numbers].sort((a, b) => a - b)

console.log('Sorted numbers:', sortedNumbers) // [1, 2, 3, 4, 5]

// Map and Set collections()

const data = new Map()

data.set('name', 'John')
data.set('age', 25)

console.log('Keys', data.keys()) // MapIterator {'name', 'age'}
console.log('Values:', data.values()) // MapIterator {'John', 25}
console.log('Entries:', data.entries()) // MapIterator {'name' => 'John', 'age' => 25}

// For of cycle

for (const key of data.keys()) {
  console.log('Key:', key)
}

for (const value of data.values()) {
  console.log('Value:', value)
}

for (const entry of data.entries()) {
  console.log('Entry:', entry)
}

// Convert an object into a collection

const obj = {
  name: 'John',
  age: 25
}

const objToMap = new Map(Object.entries(obj))

objToMap.forEach((value, key) => {
  console.log(`${key}: ${value}`)
}) // name: John, age: 25

// Convert an map collection into a object

const map = new Map([
  ['name', 'John'],
  ['age', 25],
])

const mapToObj = Object.fromEntries(map)

console.log('Map to object:', mapToObj) // {name: 'John', age: 25}

