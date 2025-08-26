'use strict' /*Strict language rules are included */

console.log('Hello!')
console.log(123)
console.log('Hello' , 'I am Nathan', 555) 
let message = 'Hello'
console.log(message)
message = 'Bye'
console.log(message)
const message1 = 'Hello'
const Nathan = 'Nathan'
console.log(Nathan)

/*
const age1 = 26
const age1 = 28 This will cause an error because age1 is already declared with const
*/
const greeting = 'Hello'
const name2 = 'Harry'
const goodbye = 'Bye'

const message3 = `${greeting}, ${name2}!`
console.log(message3)
console.log(99000000000000000091n + 1n) // BigInt addition

const user = {
  surname: 'Smith',
  age: 30,
  isDeveloper: true,
}

console.log(user)

const shouldLearnJs = false
const isAlreadyLate = false

const age = 38
const isChild = age < 18
console.log(isChild) // false

const number = [4, 8, 15, 16, 23, 42]
const map = new Map()
const set = new Set()
const date = new Date()
console.log(number)
console.log( typeof number)

let name

console.log(name) // undefined

/* Operators */

const ageCheck = 20
if (ageCheck === 18) {
  console.log('You are 18 years old')
  console.log('You are young!')
} else if (ageCheck > 18) {
  console.log('OMG! You are older than 18')
} else if (ageCheck < 18) {
  console.log('You are younger than 18')
  console.log('You are so young!')
}

/* Ternary operator! */

const yearCheck = 2027
const Check = yearCheck === 2025 ? 'This is the year 2025' : 'This is not the year 2025' 
console.log(Check)

/* Second variant */ 

const year = 2025
const warning = year === 2025
  ? 'Nowdays!' 
  : year > 2025
    ? 'In the future!'
    : 'In the past!'
console.log(warning)

/* Logical operators (  &&(and) ||(or) !(not) )*/

const ageCheck2 = 17
const DriverLicences = true

if (ageCheck2 >= 18 && DriverLicences) {
  console.log('You are a good fit for us!')
}
else {
  console.log('You are not a good fit for us!')
}

const ageCheck3 = 18
const withParents = false

if (ageCheck3 >= 18 || withParents) {
  console.log('You are in!')
}
else {
  console.log('You are out!')
}

console.log(!true) // false

console.log(!0) // true

console.log(!!0) // false
console.log(Boolean(0)) // false

/* All operators */

const name4 = 'Nathan'
const age4 = 18
const hasMuchMoney = false
const hasGoodJob = false
const isSmart = true
const isHardworking = true

if (name4 !== 'Nathan' ) {
  console.log('You are not Nathan!')
} else if (age4 < 18) {
  console.log('You are too young!')
} else if (!hasMuchMoney || !hasGoodJob || isSmart && isHardworking) {
  console.log('You are a good fit for us!')
} else { 
  console.log('You are not a good fit for us!')
}


/* Zero merge operator (??) If a is not equal to null or undefined, then a, but if a equals null or undefined, then b */

const a = 0
const b = 100

const result1 = a || b
const result2 = a ?? b

console.log(result1)
console.log(result2)

/* alert, prompt, confirm*/

alert('This is an alert!') // Alert box

// const userAge = prompt('What is your age?') // Prompt box

// if (userAge >= 18) {
//   console.log('access granted')
// } else {
//   console.log('access denied')
// }

// const ready_or_not = confirm('Are you ready?') // Confirm box

// if (ready_or_not) {
//   console.log('Great! Let\'s go!')
// } else {
//   console.log('Maybe next time!')
// }

/* Switch case*/ 

const newage = +prompt('Enter your age')

switch (newage) {
  case 0: {
    console.log('Impossible!')
    break
  }
  case 18: {
    console.log('I need a proof!')
    break
  }
  case 1000: {
    console.log('Stop joking!')
    break
  }
  default: {
    console.log('Youre age is ' + newage)
  }
}

// const newage1 = +prompt('Enter your age')

// switch (true) {
//   case newage1 < 1: {
//     console.log('Impossible!')
//     break
//   }
//   case newage1 === 18: {
//     console.log('I need a proof!')
//     break
//   }
//   case newage1 >0 && newage1 <= 100: {
//     console.log('Youre age is ' + newage1)
//     break
//   }
//   default: {
//     console.log('Incorect age!')
//   }
// }


// do while and for

let count = 0

while (count < 10) {
  console.log(count)
  count++
}

console.log('Loop finished!')

// let count =  1000

// do {
//   console.log(count)
//   count++
// } while (count < 10)

for (let i = 0; i < 10; i++) {
  console.log(i)

  if (i === 5) {
    console.log('We reached 5!')
    break
  }
}

console.log('Loop finished!')

console.log('Loop with continue!')

for (let i = 0; i < 10; i++) {
  if (i % 2 === 0) {
    continue
  }

  console.log(i) 
}

console.log('Loop finished!')

// Functions

function getAgeType(age) {
  if (typeof age !== 'number') {
    return 'Incorrect value'
  }
  if (age < 1 || age > 120) {
    return 'Please provide a valid age'
  }
  if (age < 18) {
    return 'Child'
  } else if (age <= 65) {
    return 'Adult'
  } else {
    return 'Senior'
  }
}
console.log(getAgeType(70))

// Arrow Function

const logSum = (a, b) => {
console.log(a + b)
}

logSum(5, 10)

// callback functions

const logMassage = (actionBefore, actionAfter) => {
  actionBefore()
  console.log('Hi!')
  actionAfter()
}
const fn1 = () => console.log('before')
const fn2 = () => console.log('after')

logMassage(
  () => console.log('before'),
  () => console.log('after')
)

