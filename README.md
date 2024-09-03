﻿# Xojo-Lox
Lox language implementation in Xojo. Taken from the [Crafting Interpreters](http://craftinginterpreters.com/) Book

## The Language

A dynamic typing, automatic memory management, 'first class' functions and object-oriented scripting language.

[The Lox Language](https://craftinginterpreters.com/the-lox-language.html)

Example:
```cpp
// Your first Lox program!
print "Hello, world!";

// variables
var condition = true;

// control flow
if (condition) {
  print "yes";
} else {
  print "no";
}

var a = 1;
while (a < 10) {
  print a;
  a = a + 1;
}

for (var a = 1; a < 10; a = a + 1) {
  print a;
}

// functions
fun printSum(a, b) {
  print a + b;
}
printSum(1,2);

// closures
fun addPair(a, b) {
  return a + b;
}

fun identity(a) {
  return a;
}

print identity(addPair)(1, 2); // Prints "3".

// classes
class Breakfast {
  init(meat, bread) {
    this.meat = meat;
    this.bread = bread;
  }

  cook() {
    print "Eggs a-fryin'!";
  }

  serve(who) {
    print "Enjoy your breakfast, " + who + ".";
  }
}

class Brunch < Breakfast {
  drink() {
    print "How about a Bloody Mary?";
  }
}

// Store it in variables.
var breakfast = Breakfast("saug", "sour");
print breakfast; // "Breakfast instance".

breakfast.meat = "sausage";
breakfast.bread = "sourdough";

breakfast.serve("Dear Reader");
// "Enjoy your bacon and toast, Dear Reader."

var benedict = Brunch("ham", "English muffin");
benedict.serve("Noble Reader");
benedict.drink();


fun fib(n) {
  if (n < 2) return n;
  return fib(n - 1) + fib(n - 2); 
}

var before = clock();
print fib(10);
var after = clock();
print after - before;

```

[grammar](https://craftinginterpreters.com/appendix-i.html)

```antlr
// syntax grammar:
program        → declaration* EOF ;

// declarations:
declaration    → classDecl
               | funDecl
               | varDecl
               | statement ;

classDecl      → "class" IDENTIFIER ( "<" IDENTIFIER )?
                 "{" function* "}" ;
funDecl        → "fun" function ;
varDecl        → "var" IDENTIFIER ( "=" expression )? ";" ;

// statements:
statement      → exprStmt
               | forStmt
               | ifStmt
               | printStmt
               | returnStmt
               | whileStmt
               | block ;

exprStmt       → expression ";" ;
forStmt        → "for" "(" ( varDecl | exprStmt | ";" )
                 expression? ";"
                 expression? ")" statement ;
ifStmt         → "if" "(" expression ")" statement
               ( "else" statement )? ;
printStmt      → "print" expression ";" ;
returnStmt     → "return" expression? ";" ;
whileStmt      → "while" "(" expression ")" statement ;
block          → "{" declaration* "}";

// expressions:
expression     → assignment ;

assignment     → ( call "." )? IDENTIFIER "=" assignment
               | logic_or ;

logic_or       → logic_and ( "or" logic_and )* ;
logic_and      → equality ( "and" equality )* ;
equality       → comparison ( ( "!=" | "==" ) comparison )* ;
comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )* ;
term           → factor ( ( "-" | "+" ) factor )* ;
factor         → unary ( ( "/" | "*" ) unary )* ;

unary          → ( "!" | "-" ) unary | call ;
call           → primary ( "(" arguments? ")" | "." IDENTIFIER )* ;
primary        → "true" | "false" | "nil" | "this"
               | NUMBER | STRING | IDENTIFIER | "(" expression ")"
               | IDENTIFIER ("++" | "--")
               | "super" "." IDENTIFIER ;

// utility rules:
function       → IDENTIFIER "(" parameters? ")" block ;
parameters     → IDENTIFIER ( "," IDENTIFIER )* ;
arguments      → expression ( "," expression )* ;

// lexical grammar:
NUMBER         → DIGIT+ ( "." DIGIT+ )? ;
STRING         → "\"" <any char except "\"">* "\"" ;
IDENTIFIER     → ALPHA ( ALPHA | DIGIT )* ;
ALPHA          → "a" ... "z" | "A" ... "Z" | "_" ; // *extended!
DIGIT          → "0" ... "9" ;

```
