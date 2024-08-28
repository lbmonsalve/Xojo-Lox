# Xojo-Lox
Lox language implementation in Xojo. Taken from the [Crafting Interpreters](http://craftinginterpreters.com/) Book

## The Language



```
program ->  block

BASIC   ->  'int' | 'float' | 'char' | 'bool'
ID      ->  [a-zA-Z0-9_]+
NUM     ->  DIGIT+
REAL    ->  DIGIT+ '.' DIGIT*
CHAR    ->  '"' (.)*? '"'
DIGIT   ->  [0-9]
```
