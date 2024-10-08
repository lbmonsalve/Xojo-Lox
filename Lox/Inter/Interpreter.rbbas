#tag Class
Protected Class Interpreter
Implements Lox.Ast.IExprVisitor,Lox.Ast.IStmtVisitor
	#tag Method, Flags = &h21
		Private Sub CheckNumberOperand(operator As Lox.Token, operand As Variant)
		  If operand.IsNumberLox Then Return
		  
		  HadRuntimeError= True
		  #pragma BreakOnExceptions Off
		  Raise New RuntimeError(operator, "Operand must be a number.")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckNumberOperands(operator As Lox.Token, left As Variant, right As Variant)
		  If left.IsNumberLox And right.IsNumberLox Then Return
		  
		  HadRuntimeError= True
		  #pragma BreakOnExceptions Off
		  Raise New RuntimeError(operator, "Operands must be numbers.")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Reset
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Evaluate(expr As Lox.Ast.Expr) As Variant
		  Return expr.Accept(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub execute(stmt As Lox.Ast.Stmt)
		  Call stmt.Accept Self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExecuteBlock(statements() As Lox.Ast.Stmt, env As Environment)
		  Dim previous As Environment= mEnvironment
		  
		  Try
		    mEnvironment= env
		    
		    For Each statement As Lox.Ast.Stmt In statements
		      execute statement
		    Next
		  Catch exp As StackOverflowException
		    HadRuntimeError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(New Token(Lox.TokenType.NIL_, "",Nil,  -1), _
		    "StackOverflowException")
		  Finally
		    mEnvironment= previous
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Interpret(expression As Lox.Ast.Expr) As Variant
		  Try
		    Dim value As Variant= Evaluate(expression)
		    Return Stringify(value)
		  Catch exc As RuntimeError
		    RuntimeError exc
		    Return Nil
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Interpret(statements() As Lox.Ast.Stmt)
		  Try
		    For Each statement As Lox.Ast.Stmt In statements
		      execute statement
		    Next
		  Catch exc As RuntimeError
		    RuntimeError exc
		  Catch exc As RuntimeException
		    DbgLog CurrentMethodName+ " unexpected error"
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsEqual(left As Variant, right As Variant) As Boolean
		  If left.IsNull And right.IsNull Then Return True
		  If left.IsNull Then Return False
		  If left.Type<> right.Type Then Return False
		  
		  Return left.Equals(right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsTruthy(obj As Variant) As Boolean
		  If obj.IsNull Then Return False
		  If obj.Type= 11 Then Return obj.BooleanValue
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function lookUpVariable(name As Token, expr As Lox.Ast.Expr) As Variant
		  If mLocals.HasKey(expr) Then
		    Dim distance As Integer= mLocals.Value(expr).IntegerValue
		    Return mEnvironment.GetAt(distance, name.Lexeme)
		  Else
		    Return Globals.Get(name)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NotArbitraryArgs(callee As ICallable) As Boolean
		  If callee IsA Lox.Inter.Std.DateTime Then
		    Return False
		  ElseIf callee IsA Lox.Inter.Std.RegExLox Then
		    Return False
		  ElseIf callee IsA Lox.Inter.Std.RegExLoxMatch Then
		    Return False
		  ElseIf callee IsA Lox.Inter.LoxArray Then
		    Return False
		  ElseIf callee IsA Lox.Inter.LoxArrayMethods Then
		    Return False
		  ElseIf callee IsA Lox.Inter.LoxHashMap Then
		    Return False
		  ElseIf callee IsA Lox.Inter.LoxHashMapMethods Then
		    Return False
		  ElseIf callee IsA Lox.Inter.Std.File Then
		    Return False
		  ElseIf callee IsA Lox.Inter.Std.FileMethods Then
		    Return False
		  ElseIf callee IsA Lox.Inter.Std.System Then
		    Return False
		  ElseIf callee IsA Lox.Inter.Std.SystemMethods Then
		    Return False
		  ElseIf callee IsA Lox.Inter.Std.Math Then
		    Return False
		  ElseIf callee IsA Lox.Inter.Std.MathMethods Then
		    Return False
		  ElseIf callee IsA Lox.Inter.Std.Text Then
		    Return False
		  ElseIf callee IsA Lox.Inter.Std.TextMethods Then
		    Return False
		    
		  End If
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  mGlobals= New Environment
		  mGlobals.Define "clock", New LoxClock
		  mGlobals.Define "Array", New LoxArray
		  mGlobals.Define "HashMap", New LoxHashMap
		  mGlobals.Define "System", New Lox.Inter.Std.System
		  mGlobals.Define "Math", New Lox.Inter.Std.Math
		  mGlobals.Define "Text", New Lox.Inter.Std.Text
		  mGlobals.Define "DateTime", New Lox.Inter.Std.DateTime
		  mGlobals.Define "RegEx", New Lox.Inter.Std.RegExLox
		  mGlobals.Define "File", New Lox.Inter.Std.File
		  
		  mEnvironment= mGlobals
		  
		  mLocals= New Lox.Misc.CSDictionary
		  
		  mImportFiles= New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Resolve(expr As Lox.Ast.Expr, depth As Integer)
		  mLocals.Value(expr)= depth
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Stringify(obj As Variant) As String
		  If obj.Type= 8 Then
		    If obj.StringValue.InStr("${")= 0 Then Return obj.ToStringLox
		  Else
		    Return obj.ToStringLox
		  End If
		  
		  // string interpolation (?<=\{).+?(?=\})
		  Dim buffer As String= obj.StringValue
		  
		  Dim rg as New RegEx
		  rg.SearchPattern= "(?<=\{).+?(?=\})"
		  
		  Dim varNames() As String
		  Dim match As RegExMatch= rg.search(buffer)
		  While match<> Nil
		    varNames.Append match.SubExpressionString(0)
		    match= rg.search
		  Wend
		  
		  For Each varName As String In varNames
		    Dim tok As New Token(TokenType.IDENTIFIER, varName.Trim, Nil, -1)
		    Dim expr As New Lox.Ast.Variable(tok)
		    Dim value As Variant= lookUpVariable(expr.Name, expr)
		    buffer= buffer.Replace("${"+ varName+ "}", value.ToStringLox)
		  Next
		  
		  Return buffer
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitArrayAssign(expr As Lox.Ast.ArrayAssign) As Variant
		  // https://github.com/gkjpettet/roo/blob/master/src/core/Roo/Interpreter/RooInterpreter.xojo_xml_code
		  // The user wants to assign a value to an element in an array.
		  // The array's identifer is expr.Name
		  // The index of the element to assign to is the expr.Index expression (to be evaluated).
		  // The value to assign to the specified element is expr.Value
		  // compound assignment is permitted (+=, -=, /=, *=, %=) as well as simple assignment (=).
		  
		  Dim current, newValue, assigneeVariant As Variant
		  Dim index As Integer
		  Dim assignee As LoxArray
		  
		  // Get the array we are assigning to.
		  Dim distance As Integer= mLocals.Lookup(expr, -1)
		  If distance= -1 Then // Global variable.
		    assigneeVariant= Globals.Get(expr.Name)
		  Else // Locally scoped variable.
		    assigneeVariant= Environment.GetAt(distance, expr.Name.Lexeme)
		  End If
		  If assigneeVariant= Nil Then
		    // Non-initialised variable. Initialise it as an empty array object.
		    assigneeVariant = New LoxArray
		  End If
		  
		  // Evaluate the right hand side of the assignment.
		  newValue= Evaluate(expr.Value)
		  
		  // Help the Xojo compiler by telling it that we're working with a RooArray, not a Variant.
		  assignee= LoxArray(assigneeVariant)
		  
		  Try
		    index= Evaluate(expr.Index)
		  Catch err
		    Raise New RuntimeError(expr.Name, _
		    "Expected an integer index value for the element to assign to.")
		  End Try
		  
		  // Is there an element at this index?
		  If index< 0 Then
		    Raise New RuntimeError(expr.Name, "Expected an integer index >= 0.")
		  ElseIf index<= assignee.Elements.Ubound Then
		    current= assignee.Elements(index)
		  Else
		    current= Nil
		  End If
		  
		  // Prohibit the compound assignment operators with non-existent elements.
		  If current.IsNull And expr.Operator.TypeToken<> TokenType.EQUAL Then
		    Raise New RuntimeError(expr.Name, "Cannot use a compound assigment operator on Nothing.")
		  End If
		  
		  // What type of assignment is this?
		  Select Case expr.Operator.TypeToken
		  Case TokenType.PLUS_EQUAL
		    If current.IsNumberLox And newValue.IsNumberLox Then
		      // Arithmetic addition.
		      newValue= current+ newValue
		    Else // Text concatenation.
		      newValue= current.StringValue+ newValue.StringValue
		    End If
		    
		  Case TokenType.MINUS_EQUAL // Compound subtraction (-=).
		    AssertAreNumbers expr.Operator, current, newValue
		    newValue= current- newValue
		    
		  Case TokenType.SLASH_EQUAL // Compound division (/=).
		    AssertAreNumbers expr.Operator, current, newValue
		    If newValue= 0 Then Raise New RuntimeError(expr.Operator, "Division by zero")
		    newValue= current/ newValue
		    
		  Case TokenType.STAR_EQUAL // Compound multiplication (*=).
		    AssertAreNumbers expr.Operator, current, newValue
		    newValue= current* newValue
		    
		    'Case Roo.TokenType.PERCENT_EQUAL // Compound modulo (%=).
		    'Roo.AssertAreNumbers(expr.Operator, current, newValue)
		    'If RooNumber(newValue).Value = 0 Then Raise New RooRuntimeError(expr.Operator, "Modulo with zero")
		    'newValue = New RooNumber(RooNumber(current).Value Mod RooNumber(newValue).Value)
		  End Select
		  
		  // Assign the new value to the correct element.
		  If index> assignee.Elements.Ubound Then
		    // Increase the size of this array to accomodate this new element, filling the
		    // preceding elements with Nothing.
		    Dim numNothings As Integer= index- assignee.Elements.Ubound
		    For i As Integer= 1 To numNothings
		      assignee.Elements.Append Nil
		    Next i
		  End If
		  assignee.Elements(index)= newValue
		  
		  // Assign the newly updated array to the correct environment.
		  If distance= -1 Then // Global variable.
		    Globals.Assign expr.Name, assignee
		  Else // Locally scoped variable.
		    Environment.AssignAt distance, expr.Name, assignee
		  End If
		  
		  // Return the value we assigned to the element to allow nesting (e.g: `print(a[2] = "hi")`)
		  Return newValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitArrayExpr(expr As Lox.Ast.ArrayExpr) As Variant
		  // Return the requested element from this array.
		  // The identifier of the array is expr.Name
		  // The index of the element to return is the result of evaluating expr.Index
		  
		  Dim index As Variant
		  Dim arr As LoxArray
		  
		  // Get the requested array.
		  Try
		    #pragma BreakOnExceptions Off
		    arr= LookupVariable(expr.Name, expr)
		  Catch
		    Raise New RuntimeError(expr.Name, "You are treating `" + expr.Name.Lexeme + _
		    "` like an array but it isn't one.")
		  End Try
		  
		  // Evaluate the index.
		  Try
		    #pragma BreakOnExceptions Off
		    index= Evaluate(expr.Index)
		  Catch err As IllegalCastException
		    Raise New RuntimeError(expr.Name, "Integer array index expected")
		  End Try
		  
		  // Ensure that an integer index has been passed.
		  If Not index.IsUIntegerLox Then
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(expr.Name, "Array indices must be integers, not fractional numbers.")
		  End If
		  
		  // Return the correct element or Nothing if out of bounds.
		  Try
		    #pragma BreakOnExceptions Off
		    Return arr.Elements(index)
		  Catch OutOfBoundsException
		    Return Nil
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitArrayLiteral(expr As Lox.Ast.ArrayLiteral) As Variant
		  // The interpreter is visiting an array literal node. E.g:
		  // [1, 2, "hello"]
		  // a = ["a", True]
		  
		  // Create a new runtime representation for the array.
		  Dim ret As New LoxArray
		  
		  // Evaluate each of the elements in the array literal.
		  For Each element As Lox.Ast.Expr In expr.Elements
		    ret.Elements.Append Evaluate(element)
		  Next
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitAssign(expr As Lox.Ast.Assign) As Variant
		  Dim value As Variant= Evaluate(expr.Value)
		  
		  If mLocals.HasKey(expr) Then
		    Dim distance As Integer= mLocals.Value(expr).IntegerValue
		    mEnvironment.AssignAt(distance, expr.Name, value)
		  Else
		    Globals.Assign(expr.Name, value)
		  End If
		  
		  Return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBinary(expr As Lox.Ast.Binary) As Variant
		  Dim left As Variant= Evaluate(expr.Left)
		  Dim right As Variant= Evaluate(expr.Right)
		  
		  Select Case expr.Operator.TypeToken
		  Case TokenType.GREATER
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue> right.DoubleValue
		  Case TokenType.GREATER_EQUAL
		    
		    CheckNumberOperands expr.Operator, left, right
		    If left.DoubleValue> right.DoubleValue Then Return True
		    Return AreEqual(left.DoubleValue, right.DoubleValue)
		  Case TokenType.LESS
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue< right.DoubleValue
		  Case TokenType.LESS_EQUAL
		    
		    CheckNumberOperands expr.Operator, left, right
		    If left.DoubleValue< right.DoubleValue Then Return True
		    Return AreEqual(left.DoubleValue, right.DoubleValue)
		  Case TokenType.BANG_EQUAL
		    
		    Return Not IsEqual(left, right)
		  Case TokenType.EQUAL_EQUAL
		    
		    Return IsEqual(left, right)
		  Case TokenType.MINUS
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue- right.DoubleValue
		  Case TokenType.PLUS
		    
		    If left.IsNumeric And right.IsNumeric Then
		      Return left.DoubleValue+ right.DoubleValue
		    ElseIf left.IsNull Or right.IsNull Then
		    ElseIf left.IsBooleanLox Or right.IsBooleanLox Then
		    Else // otherwise returns string
		      Return left.ToStringLox+ right.ToStringLox
		    End If
		    
		    HadRuntimeError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(expr.Operator, "Operands must be two numbers or two strings.")
		  Case TokenType.SLASH
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue/ right.DoubleValue
		  Case TokenType.STAR
		    
		    CheckNumberOperands expr.Operator, left, right
		    Return left.DoubleValue* right.DoubleValue
		  Case TokenType.AMPERSAND, TokenType.PIPE, TokenType.LESS_LESS, TokenType.GREATER_GREATER
		    
		    // assure positive integers
		    If left.IsUIntegerLox And right.IsUIntegerLox Then
		      Dim leftUInt As UInt64= left.UInt64Value
		      Dim rightUInt As UInt64= right.UInt64Value
		      
		      // select
		      Select Case expr.Operator.TypeToken
		      Case TokenType.AMPERSAND
		        Return leftUInt And rightUInt
		      Case TokenType.PIPE
		        Return leftUInt Or rightUInt
		      Case TokenType.LESS_LESS
		        Return Bitwise.ShiftLeft(leftUInt, rightUInt)
		      Case TokenType.GREATER_GREATER
		        Return Bitwise.ShiftRight(leftUInt, rightUInt)
		      End Select
		    Else
		      HadRuntimeError= True
		      #pragma BreakOnExceptions Off
		      Raise New RuntimeError(expr.Operator, "Operands must be two positive integers.")
		    End If
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(stmt As Lox.Ast.Block) As Variant
		  ExecuteBlock stmt.Statements, New Environment(mEnvironment)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBreakStmt(stmt As Lox.Ast.BreakStmt) As Variant
		  #pragma BreakOnExceptions Off
		  Raise New BreakExc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitCallExpr(expr As Lox.Ast.CallExpr) As Variant
		  Dim callee As Variant= Evaluate(expr.Callee)
		  
		  Dim arguments() As Variant
		  For Each argument As Variant In expr.Arguments
		    arguments.Append Evaluate(argument)
		  Next
		  
		  If Not (callee IsA ICallable) Then
		    HadRuntimeError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(expr.Paren, "Can only call functions and classes.")
		  End If
		  
		  Dim func As ICallable= ICallable(callee)
		  
		  // TODO: change to chk arbitrary num args
		  If NotArbitraryArgs(func) And arguments.CountLox<> func.Arity Then
		    HadRuntimeError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(expr.Paren, "Expected "+ _
		    Str(func.Arity)+ " arguments but got "+ Str(arguments.CountLox) + ".")
		  End If
		  
		  Return func.Call_(Self, arguments, expr.Paren)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitClassStmt(stmt As Lox.Ast.ClassStmt) As Variant
		  Dim superclass As Variant
		  If Not (stmt.SuperClass Is Nil) THEN
		    superclass= Evaluate(stmt.SuperClass)
		    If Not (superclass ISA LoxClass) Then
		      HadRuntimeError= True
		      #pragma BreakOnExceptions Off
		      Raise New RuntimeError(stmt.Superclass.Name, "Superclass must be a class.")
		    End If
		  END IF
		  
		  mEnvironment.Define stmt.Name.Lexeme, Nil
		  
		  If Not (stmt.SuperClass Is Nil) Then
		    mEnvironment= New Environment(mEnvironment)
		    mEnvironment.Define "super", superclass
		  End If
		  
		  Dim classMethods As New Lox.Misc.CSDictionary
		  For Each method As Lox.Ast.FunctionStmt In stmt.ClassMethods
		    Dim func As New LoxFunction(method.Name.Lexeme, method.Func, mEnvironment, False)
		    classMethods.Value(method.Name.Lexeme)= func
		  Next
		  
		  Dim metaclass As LoxClass= New LoxClass(Nil, stmt.Name.Lexeme+ " metaclass", superclass, classMethods)
		  
		  Dim methods As New Lox.Misc.CSDictionary
		  For Each method As Lox.Ast.FunctionStmt In stmt.Methods
		    Dim func As New LoxFunction(method.Name.Lexeme, method.Func, mEnvironment, _
		    method.Name.Lexeme= "init")
		    methods.Value(method.Name.Lexeme)= func
		  Next
		  
		  Dim klass As New LoxClass(metaclass, stmt.Name.Lexeme, LoxClass(superClass), methods)
		  
		  If Not (superclass Is Nil) Then mEnvironment= mEnvironment.Enclosing
		  
		  mEnvironment.Assign(stmt.Name, klass)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitContinueStmt(stmt As Lox.Ast.ContinueStmt) As Variant
		  #pragma BreakOnExceptions Off
		  Raise New ContinueExc
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitElvis(expr As Lox.Ast.Elvis) As Variant
		  Dim condition As Variant= Evaluate(expr.Condition)
		  If isTruthy(condition) Then Return condition
		  
		  Return Evaluate(expr.RightExp)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitElvisDot(expr As Lox.Ast.ElvisDot) As Variant
		  Dim condition As Variant= Evaluate(expr.Condition)
		  If condition.IsNull Then Return Nil
		  
		  Return Evaluate(expr.RightExp)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitExpression(stmt As Lox.Ast.Expression) As Variant
		  Call Evaluate stmt.Expression
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFunctionExpr(expr As Lox.Ast.FunctionExpr) As Variant
		  Return New LoxFunction("", expr, Environment, False)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFunctionStmt(stmt As Lox.Ast.FunctionStmt) As Variant
		  Dim func As New LoxFunction(stmt.Name.Lexeme, stmt.Func, mEnvironment, False)
		  mEnvironment.Define stmt.Name.Lexeme, func
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitGet(expr As Lox.Ast.Get) As Variant
		  Dim obj As Variant= Evaluate(expr.Obj)
		  If obj IsA LoxInstance Then
		    Dim objInstance As LoxInstance= LoxInstance(obj)
		    Return objInstance.Get(expr.Name)
		  End If
		  
		  HadRuntimeError= True
		  #pragma BreakOnExceptions Off
		  Raise New RuntimeError(expr.Name, "Only instances have properties.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitGrouping(expr As Lox.Ast.Grouping) As Variant
		  Return Evaluate(expr.Expression)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHashMapAssign(expr As Lox.Ast.HashMapAssign) As Variant
		  // The user wants to assign a value to a Hash.
		  // The Hash's identifer is expr.Name
		  // The key to assign to is expr.Key (to be evaluated).
		  // The value to assign to the specified key is expr.Value
		  // Shorthand assignment is permitted (+=, -=, /=, *=, %=) as well as simple assignment (=).
		  
		  // Evaluate the right hand side of the assignment.
		  Dim value As Variant= Evaluate(expr.Value)
		  
		  // Get this hash variable.
		  Dim variable As Variant
		  Dim distance As Integer= mLocals.Lookup(expr, -1)
		  If distance= -1 Then
		    // Global variable.
		    variable= mGlobals.Get(expr.Name)
		  Else
		    // Locally scoped variable.
		    variable= Environment.GetAt(distance, expr.Name.Lexeme)
		  End If
		  
		  If variable.IsNull Then
		    Raise New RuntimeError(expr.Name, "Error retrieving hash variable `" + expr.Name.Lexeme + "`.")
		  End If
		  
		  // Cast to a LoxHash to help the Xojo IDE with autocompletion, etc.
		  Dim h As Lox.Inter.LoxHashMap= Lox.Inter.LoxHashMap(variable)
		  
		  // Get the key to assign to.
		  // Remember, we use the raw value of RooText, RooNumber and RooBoolean objects as
		  // the key. For other types, we use the actual object.
		  Dim key As Variant= Evaluate(expr.Key)
		  
		  Dim current As Variant
		  
		  // Does this key exist? If so, get the current value of it.
		  If h.HashMap.HasKey(key) Then current= h.HashMap.Value(key) Else current= Nil
		  
		  // Prevent the use of the compound assignment operators (+', -=, /=, *=) on non-existent keys.
		  If current.IsNull And expr.Operator.TypeToken<> TokenType.EQUAL Then
		    Raise New RuntimeError(expr.name, "Cannot use a compound assigment operator on Nothing.")
		  end if
		  
		  // What type of assignment is this?
		  Select Case expr.Operator.TypeToken
		  Case TokenType.PLUS_EQUAL
		    If current.IsNumberLox And value.IsNumberLox Then
		      // Arithmetic addition.
		      value= current+ value
		    Else // Text concatenation.
		      value= current.StringValue+ value.StringValue
		    End If
		    
		  Case TokenType.PLUS_EQUAL // Compound subtraction (-=).
		    AssertAreNumbers(expr.Operator, current, value)
		    value= current- value
		    
		  Case TokenType.SLASH_EQUAL // Compound division (/=).
		    AssertAreNumbers(expr.Operator, current, value)
		    If value= 0 Then Raise New RuntimeError(expr.Operator, "Division by zero")
		    value= current/ value
		    
		  Case TokenType.STAR_EQUAL // Compound multiplication (*=).
		    AssertAreNumbers(expr.Operator, current, value)
		    value= current* value
		    
		  End Select
		  
		  // Assign the new value to this key.
		  h.HashMap.Value(key)= value
		  
		  // Assign the newly updated hash to the correct environment.
		  If distance= -1 Then
		    Globals.Assign(expr.Name, h)
		  Else
		    Environment.AssignAt(distance, expr.Name, h)
		  End If
		  
		  // Return the value we assigned to the key to allow nesting (e.g: `print(h{"name"} = "Garry")`)
		  Return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHashMapExpr(expr As Lox.Ast.HashMapExpr) As Variant
		  // Return the value associated with the specified key for this Hash.
		  // The identifier of the Hash is expr.Name
		  // The key is the result of evaluating expr.Key
		  
		  Dim keyValue As Variant
		  Dim hash As Lox.Inter.LoxHashMap
		  
		  // Get this Hash
		  Try
		    hash= LookupVariable(expr.Name, expr)
		  Catch
		    Raise New RuntimeError(expr.Name, "You are treating `" + expr.Name.Lexeme + _
		    "` like a Hash but it isn't one.")
		  End Try
		  
		  // Evaluate the key.
		  keyValue= Evaluate(expr.Key)
		  
		  // Return the requested value or Nothing if it doesn't exist.
		  // Try a speedy object lookup first.
		  If hash.HashMAp.HasKey(keyValue) Then Return hash.HashMap.Value(keyValue)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHashMapLiteral(expr As Lox.Ast.HashMapLiteral) As Variant
		  // The interpreter has encountered a hash literal (e.g: {"name" => "value"}).
		  
		  // Create a new runtime representation for the hash.
		  Dim h As New Lox.Inter.LoxHashMap
		  Dim key, value As Variant
		  
		  Dim entry As Lox.Misc.CSDictionary= expr.HashMap
		  For i As Integer= 0 To entry.Count- 1
		    key= Evaluate(entry.Key(i))
		    value= Evaluate(entry.Value(entry.Key(i)))
		    
		    h.HashMap.Value(key)= value
		  Next
		  
		  Return h
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIfStmt(stmt As Lox.Ast.IfStmt) As Variant
		  If isTruthy(Evaluate(stmt.Condition)) Then
		    execute stmt.ThenBranch
		    Return Nil
		  End If
		  
		  For i As Integer= 0 To stmt.OrBranch.Ubound
		    Dim orStmt As Lox.Ast.IfStmt= Lox.Ast.IfStmt(stmt.OrBranch(i))
		    If isTruthy(Evaluate(orStmt.Condition)) Then
		      execute orStmt.ThenBranch
		      Return Nil
		    End If
		  Next
		  
		  If Not (stmt.ElseBranch Is Nil) Then
		    execute stmt.ElseBranch
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitImport(stmt As Lox.Ast.Import) As Variant
		  Dim file As FolderItem= Findfile(stmt.Name.Literal.StringValue)
		  If file Is Nil Or Not file.Exists Then
		    HadRuntimeError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(stmt.Name, "Couldn't find a module on "+ _
		    file.AbsoluteNativePathLox+ ".")
		  End If
		  
		  If mImportFiles.HasKey(file.AbsoluteNativePathLox) Then Return Nil
		  
		  Dim statements() As Lox.Ast.Stmt= ResolveFile(file, stmt.Name, Self)
		  
		  mImportFiles.Value(file.AbsoluteNativePathLox)= True
		  
		  For Each statement As Lox.Ast.Stmt In statements
		    execute statement
		  Next
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInterpolatedStr(expr As Lox.Ast.InterpolatedStr) As Variant
		  Dim sb() As String
		  
		  For Each part As Lox.Ast.Expr In expr.Parts
		    sb.Append Evaluate(part).ToStringLox
		  Next
		  
		  Return Join(sb, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLiteral(expr As Lox.Ast.Literal) As Variant
		  Return expr.Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitLogical(expr As Lox.Ast.Logical) As Variant
		  Dim left As Variant= evaluate(expr.Left)
		  
		  If expr.Operator.TypeToken= TokenType.OR_ Then
		    If IsTruthy(left) Then Return left
		  Else
		    If Not IsTruthy(left) Then Return left
		  End If
		  
		  Return Evaluate(expr.Right)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitModuleStmt(stmt As Lox.Ast.ModuleStmt) As Variant
		  Dim func As LoxFunction
		  
		  // Define the module's name in the current environment.
		  mEnvironment.Define stmt.Name.Lexeme, Nil
		  
		  // Store the current environment and then immediately create a new one that
		  // will act as the module's namespace.
		  Dim oldEnv As Environment= mEnvironment
		  mEnvironment= New Environment(oldEnv)
		  
		  // Convert any methods in the module to RooFunctions.
		  Dim functions As New Lox.Misc.CSDictionary
		  For Each fun As Lox.Ast.FunctionStmt In stmt.Functions
		    func= New LoxFunction(fun.Name.Lexeme, fun.Func, mEnvironment, False)
		    functions.Value(fun.Name.Lexeme)= func
		  Next
		  
		  // Create a metaclass for this module to enable the use of the above
		  // methods (which are essentially static).
		  Dim metaclass As New LoxClass(Nil, stmt.Name.Lexeme+ " metaclass", Nil, functions)
		  
		  // Convert any sub-module declarations to RooModules within this module's namespace.
		  Dim modules() As LoxModule
		  For Each modul As Lox.Ast.ModuleStmt In stmt.Modules
		    Call VisitModuleStmt(modul)
		    modules.Append mEnvironment.Get(modul.Name)
		  Next
		  
		  // Convert any class declarations to RooClasses within this module's namespace.
		  Dim classes() As LoxClass
		  For Each cls As Lox.Ast.ClassStmt In stmt.Classes
		    Call VisitClassStmt(cls)
		    classes.Append mEnvironment.Get(cls.Name)
		  Next
		  
		  // Convert the passed module statement node into its runtime representation.
		  Dim mo As New LoxModule(metaclass, stmt.Name.Lexeme, modules, classes, functions)
		  
		  // Store the module object in the variable we previously declared.
		  mEnvironment.Assign stmt.Name, mo
		  
		  mEnvironment= oldEnv
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitPostfix(expr As Lox.Ast.Postfix) As Variant
		  Dim value As Variant= Evaluate(expr.Left)
		  
		  Dim distance As Integer= mLocals.Lookup(expr.Left, -1)
		  
		  Dim valueAssign As Variant= value
		  If expr.Operator.TypeToken= TokenType.PLUS_PLUS Then
		    valueAssign= valueAssign+ 1
		  Else // MINUS_MINUS
		    valueAssign= valueAssign- 1
		  End If
		  
		  // Assign the newly updated hash to the correct environment.
		  If distance= -1 Then
		    Globals.Assign(expr.Name, valueAssign)
		  Else
		    Environment.AssignAt(distance, expr.Name, valueAssign)
		  End If
		  
		  Return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitPrint(stmt As Lox.Ast.Print) As Variant
		  Dim value As Variant= Evaluate(stmt.Expression)
		  Dim msg As String= Stringify(value)
		  
		  // TODO: add logging system
		  If PrintOut Is Nil Then
		    DbgLog msg
		  Else
		    PrintOut.Write msg+ EndOfLine
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitReturnStmt(stmt As Lox.Ast.ReturnStmt) As Variant
		  Dim value As Variant
		  If Not (stmt.Value Is Nil) Then value= Evaluate(stmt.Value)
		  
		  #pragma BreakOnExceptions Off
		  Raise New ReturnExc(value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSet(expr As Lox.Ast.Set) As Variant
		  Dim obj As Variant= Evaluate(expr.Obj)
		  
		  If Not (obj IsA LoxInstance) Then
		    HadRuntimeError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(expr.Name, "Only instances have fields.")
		  End If
		  
		  Dim value As Variant= Evaluate(expr.Value)
		  Dim objInstance As LoxInstance= LoxInstance(obj)
		  objInstance.Set(expr.Name, value)
		  
		  Return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSuperExpr(expr As Lox.Ast.SuperExpr) As Variant
		  Dim distance As Integer= mLocals.Value(expr)
		  Dim superClass As LoxClass= LoxClass(mEnvironment.GetAt(distance, "super"))
		  Dim obj As LoxInstance= LoxInstance(mEnvironment.GetAt(distance- 1, "this"))
		  Dim methodObj As Variant= superClass.FindMethod(expr.Method.Lexeme)
		  Dim method As LoxFunction
		  If methodObj IsA LoxFunction Then method= LoxFunction(methodObj)
		  
		  If method Is Nil Then
		    HadRuntimeError= True
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(expr.Method, "Undefined property '" + expr.Method.Lexeme + "'.")
		  End If
		  
		  Return method.Bind(obj)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitTernary(expr As Lox.Ast.Ternary) As Variant
		  If isTruthy(Evaluate(expr.Expression)) Then
		    Return Evaluate(expr.ThenBranch)
		  End If
		  
		  If Not (expr.ElseBranch Is Nil) Then
		    Return Evaluate(expr.ElseBranch)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitThis(expr As Lox.Ast.This) As Variant
		  Return lookUpVariable(expr.Keyword, expr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitUnary(expr As Lox.Ast.Unary) As Variant
		  Dim right As Variant= Evaluate(expr.Right)
		  
		  Select Case expr.Operator.TypeToken
		  Case TokenType.BANG
		    
		    Return Not IsTruthy(right)
		  Case TokenType.MINUS
		    
		    CheckNumberOperand expr.Operator, right
		    Return -right.DoubleValue
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitVariable(expr As Lox.Ast.Variable) As Variant
		  Return lookUpVariable(expr.Name, expr)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitVarStmt(stmt As Lox.Ast.VarStmt) As Variant
		  Dim value As Variant
		  If Not (stmt.Initializer Is Nil) Then
		    value= Evaluate(stmt.Initializer)
		  End If
		  
		  mEnvironment.Define stmt.Name.Lexeme, value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitWhileStmt(stmt As Lox.Ast.WhileStmt) As Variant
		  Try
		    While IsTruthy(Evaluate(stmt.Condition))
		      Try
		        execute stmt.Body
		      Catch exc As BreakExc
		        #pragma BreakOnExceptions Off
		        Raise exc
		      Catch exc As ContinueExc
		        'DbgLog CurrentMethodName+ " continue!"
		      End Try
		    Wend
		  Catch exc As BreakExc
		    Return Nil
		  End Try
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mEnvironment
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mEnvironment= value
			End Set
		#tag EndSetter
		Environment As Environment
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mGlobals
			End Get
		#tag EndGetter
		Globals As Environment
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		HadRuntimeError As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEnvironment As Environment
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mGlobals As Environment
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImportFiles As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLocals As Lox.Misc.CSDictionary
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="HadRuntimeError"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
