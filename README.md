# Xojo-Lox
Lox language implementation in Xojo. Taken from the [Crafting Interpreters](http://craftinginterpreters.com/) Book. JUST FOR LEARNING, NO for production.

## The Language

A dynamic typing, automatic memory management, 'first class' functions and object-oriented scripting language.

[The Lox Language](https://craftinginterpreters.com/the-lox-language.html)

Example:
```c
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

print System.osName;
print System.osEnvVar("HOMEPATH"); // windows
print System.assert(true, "pass");
print System.debugLog("test");

```
### syntactic sugar

#### Identifiers extended. emoji's friendly.

```c
var año=2024; print año; // expect: 2024.0
var Σ= "sigma"; print Σ; // expect: sigma
var 😃= "smileyface";
print 😃; // expect: smileyface
```

#### HEX, OCT, BIN literals.

```c
var h = 0x2324; 
var o = 0o1056; 
var b = 0b1110;
```

#### Bitwise.

```c
print 7 & 5;
print 7 | 5;
print 7 << 2;
print 40 >> 2;
```

#### Compound assingnment.

```c
var a=5;
a+=5;
print a; // expect: 10.0
a-=3;
print a; // expect: 7.0
a*=5;
print a; // expect: 35.0
a/=2;
print a; // expect: 17.5
```


#### Postfix.

```c
var i=1; i++;
print i;

i--;
print i;
```


#### Ternary.

```c
a>b ? 1 : 2
```


#### Elvis operator.

```c
print false?.true; // expect: true
print nil?.true; // expect: null
print true?.nil?.false?.true; // expect: null

print true?.false?.nil?.true?:"default"; // expect: default
```


#### Break, continue keywords.

```c
var bb=0;
while (true) {
  if (bb=10) break;
  bb++;
}
print bb; // expect: 10.0

var a = 0;
while (a < 10) {
  a = a + 1;
  if (a== 6) continue;
  print a;
}
```

#### if or else.

```c
if (false) {print "if";}
  or (true) {print "or";} // expect: or
  else {print "else";} 
```


#### Modules.

```c
module M {
  class C {
    parse(cc) {print cc;}
  }
  fun F() {print "hello";}
  fun hello() {return "hello!";}
}
M.hello2= "hello2";

M.F();
var a= M.C();
a.parse("b");

var hello= M.hello();
print hello;
print M.hello2;
```

#### Datetime, arrays, hashmaps, regex.

```c
var d= DateTime();

var a=[1,2,3]; // array

var hm= #{"a"=>1,"b"=>2, "c"=>100}; // hashmap

var r= RegEx("\d+");
print r.caseSensitive; // expect: false
print r.greedy; // expect: true
print r.match("10"); // expect: 10
print r.match("rr"); // expect: null
```

#### File.

```c
var f1= File("test1.txt");
f1.write("hello");
print f1.length;

var txt= f1.read();

var f2= File("test2.txt");
f2.write(txt+ " world");
print f2.length;
```

#### String interpolation.

```c
var name="luis";
print "welcome ${name}!";
```


## [grammar](https://craftinginterpreters.com/appendix-i.html)

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
                 "{" functionBody* "}" ;
funDecl        → "fun" functionBody ;
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
               ( "or" statement )*
               ( "else" statement )? ;
printStmt      → "print" expression ";" ;
returnStmt     → "return" expression? ";" ;
whileStmt      → "while" "(" expression ")" statement ;
breakStmt      → "break" ";" ;
continueStmt   → "continue" ";" ;
block          → "{" declaration* "}";

// expressions:
expression     → assignment ;

assignment     → ( call "." )? IDENTIFIER ( "[" elvis "]" )?
                 ("=" | "+=" | "-=" | "*=" | "/=") assignment
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
postfix        → call ("++" | "--")? ;
call           → suscript ( "(" arguments? ")" | "." IDENTIFIER )* ;
suscript       → primary ( "[" elvis "]" )? ;
primary        → "true" | "false" | "nil" | "this" | "fun" "(" parameters? ")" block
               | NUMBER | IDENTIFIER | "(" expression ")"
               | STRING ( "${" expression "}" STRING? )*
               | "super" "." IDENTIFIER | "[" arguments? "]" ;

// utility rules:
functionBody   → IDENTIFIER "(" parameters? ")" block ;
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
