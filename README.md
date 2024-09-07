# Xojo-Lox
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

for (var a = 1; a < 10; a++ ) {
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
declaration    → moduleDecl
               | classDecl
               | funDecl
               | varDecl
               | statement ;

moduleDecl     → "module" IDENTIFIER "{" 
                 classDecl+ | funDecl+ | moduleDecl+
                 "}" ;

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
               | breakStmt
               | continueStmt
               | block ;

exprStmt       → expression ";" ;
forStmt        → "for" "(" ( varDecl | exprStmt | ";" )
                 expression? ";"
                 expression? ")" statement ;
ifStmt         → "if" "(" expression ")" statement
               ( "or" statement )?
               ( "else" statement )? ;
printStmt      → "print" expression ";" ;
returnStmt     → "return" expression? ";" ;
whileStmt      → "while" "(" expression ")" statement ;
breakStmt      → "break" ";" ;
continueStmt   → "continue" ";" ;
block          → "{" declaration* "}";

// expressions:
expression     → assignment ;

assignment     → ( call "." )? IDENTIFIER ("=" | "+=" | "-=" | "*=" | "/=")* assignment
               | elvis ;

elvis          → ternary (("?:" | "?.") ternary)* ;
ternary        → expression "?" expression ":" expression ";"
               | logic_or ;

logic_or       → logic_and ( "or" logic_and )* ;
logic_and      → equality ( "and" equality )* ;
equality       → comparison ( ( "!=" | "==" ) comparison )* ;
comparison     → bitwise ( ( "&" | "|" | ">>" | "<<" ) bitwise )* ;
bitwise        → term ( ( ">" | ">=" | "<" | "<=" ) term )* ;
term           → factor ( ( "-" | "+" ) factor )* ;
factor         → unary ( ( "/" | "*" ) unary )* ;

unary          → ( "!" | "-" ) unary | postfix ;
postfix        → call ("++" | "--")* ;
call           → primary ( "(" arguments? ")" | "." IDENTIFIER )* ;
primary        → "true" | "false" | "nil" | "this"
               | NUMBER | STRING | IDENTIFIER | "(" expression ")"
               | "super" "." IDENTIFIER ;

// utility rules:
function       → IDENTIFIER "(" parameters? ")" block ;
parameters     → IDENTIFIER ( "," IDENTIFIER )* ;
arguments      → expression ( "," expression )* ;

// lexical grammar:
NUMBER         → DIGIT+ ( "." DIGIT+ )? | HEX | OCT | BIN ;
STRING         → "\"" <any char except "\"">* "\"" ;
IDENTIFIER     → ALPHA ( ALPHA | DIGIT )* ;
ALPHA          → "a" ... "z" 
               | "A" ... "Z" 
               | "\u00c0" ... "\u00d6" 
               | "\u00d8" ... "\u00f6" 
               | "\u0370" ... "\u037d" 
               | "\u037f" ... "\u1fff" 
               | "\u200c" ... "\u200d" 
               | "\u2070" ... "\u218f" 
               | "\u2c00" ... "\u2fef" 
               | "\u3001" ... "\ud7ff" 
               | "\uf900" ... "\uhfdcf" 
               | "\uhfdf0" ... "\ufffd" 
               | "\u1f600" ... "\u1f64f" // emojis
               | "_" ;
DIGIT          → "0" ... "9" ;
HEX            → "0x" [a-fA-F0-9]* ;
OCT            → "0o" [0-7]* ;
BIN            → "0b" [01]* ;

```
