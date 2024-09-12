#tag Module
Protected Module Lox
	#tag Method, Flags = &h21
		Private Function AreEqual(expected As Double, actual As Double, tolerance As Double = 0.000001) As Boolean
		  Dim diff As Double= Abs(expected- actual)
		  
		  If diff<= (Abs(tolerance) + 0.00000001) Then
		    Return True
		  Else
		    Return False
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AssertAreNumbers(where As Token, ParamArray operands As Variant)
		  // Asserts that the passed operands are Numbers. If any aren't, raise an error.
		  
		  For Each operand As Variant In operands
		    If Not operand.IsNumberLox Then
		      Raise New RuntimeError(where, "Expected a number operand.")
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count(Extends obj() As Token) As Integer
		  Return obj.Ubound+ 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CountLox(Extends obj() As Variant) As Integer
		  Return obj.Ubound+ 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DbgLog(msg As String)
		  System.DebugLog msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EnvVar(name As String) As String
		  Return System.EnvironmentVariable(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Error(line As Integer, message As String)
		  Report line, "", message
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Error(token As Token, message As String)
		  If token.TypeToken= TokenType.EOF Then
		    Report token.Line, " at end", message
		  Else
		    Report token.Line, " at '"+ token.Lexeme+ "'", message
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Error(token As Token, message As String) As ParseError
		  Error token, message
		  
		  Return New ParseError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IIf(stmt As Boolean, ifTrue As TokenType, ifFalse As TokenType) As TokenType
		  If stmt Then Return ifTrue Else Return ifFalse
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsBooleanLox(Extends vart As Variant) As Boolean
		  If vart.Type= 11 Then Return True
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsCallableLox(Extends obj As Variant) As Boolean
		  If obj IsA lox.Inter.ICallable Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsNumberLox(Extends vart As Variant) As Boolean
		  Select Case vart.Type
		  Case 2, 3, 4, 5, 6
		    Return True
		  Case Else
		    Return False
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsStringLox(Extends vart As Variant) As Boolean
		  If vart.Type= 8 Then Return True
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsUIntegerLox(Extends vart As Variant) As Boolean
		  Select Case vart.Type
		  Case 2, 3, 4, 5, 6
		    If vart.DoubleValue>= 0 And vart.DoubleValue= vart.UInt64Value Then
		      Return True
		    Else
		      Return False
		    End If
		  Case Else
		    Return False
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Report(line As Integer, where As String, message As String)
		  Dim msg As String= "[line "+ Str(line)+ "] Error"+ where+ ": "+ message
		  
		  // TODO: add logging system
		  If ErrorOut Is Nil Then
		    System.DebugLog msg
		  Else
		    ErrorOut.Write msg+ EndOfLine
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RuntimeError(error As RuntimeError)
		  Dim msg As String= error.Message+ EndOfLine+ "[line "+ _
		  Str(error.Token.Line)+ "]"
		  
		  // TODO: add logging system
		  If ErrorOut Is Nil Then
		    DbgLog msg
		  Else
		    ErrorOut.Write msg+ EndOfLine
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SubstringLox(Extends obj As String, startIndex As Integer, endIndex As Integer) As String
		  Return obj.Mid(startIndex, endIndex- startIndex)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(Extends obj As Lox.TokenType) As String
		  Select Case obj
		  Case TokenType.LEFT_PAREN
		    Return "LEFT_PAREN"
		  Case TokenType.RIGHT_PAREN
		    Return "RIGHT_PAREN"
		  Case TokenType.LEFT_BRACE
		    Return "LEFT_BRACE"
		  Case TokenType.RIGHT_BRACE
		    Return "RIGHT_BRACE"
		  Case TokenType.COMMA
		    Return "COMMA"
		  Case TokenType.DOT
		    Return "DOT"
		  Case TokenType.MINUS
		    Return "MINUS"
		  Case TokenType.PLUS
		    Return "PLUS"
		  Case TokenType.SEMICOLON
		    Return "SEMICOLON"
		  Case TokenType.SLASH
		    Return "SLASH"
		  Case TokenType.STAR
		    Return "STAR"
		  Case TokenType.BANG
		    Return "BANG"
		  Case TokenType.BANG_EQUAL
		    Return "BANG_EQUAL"
		  Case TokenType.EQUAL
		    Return "EQUAL"
		  Case TokenType.EQUAL_EQUAL
		    Return "EQUAL_EQUAL"
		  Case TokenType.GREATER
		    Return "GREATER"
		  Case TokenType.GREATER_EQUAL
		    Return "GREATER_EQUAL"
		  Case TokenType.LESS
		    Return "LESS"
		  Case TokenType.LESS_EQUAL
		    Return "LESS_EQUAL"
		  Case TokenType.IDENTIFIER
		    Return "IDENTIFIER"
		  Case TokenType.STRING_
		    Return "STRING"
		  Case TokenType.NUMBER
		    Return "NUMBER"
		  Case TokenType.AND_
		    Return "AND"
		  Case TokenType.CLASS_
		    Return "CLASS"
		  Case TokenType.ELSE_
		    Return "ELSE"
		  Case TokenType.FALSE_
		    Return "FALSE"
		  Case TokenType.FUN
		    Return "FUN"
		  Case TokenType.FOR_
		    Return "FOR"
		  Case TokenType.IF_
		    Return "IF"
		  Case TokenType.NIL_
		    Return "NIL"
		  Case TokenType.OR_
		    Return "OR"
		  Case TokenType.PRINT_
		    Return "PRINT"
		  Case TokenType.RETURN_
		    Return "RETURN"
		  Case TokenType.SUPER_
		    Return "SUPER"
		  Case TokenType.THIS
		    Return "THIS"
		  Case TokenType.TRUE_
		    Return "TRUE"
		  Case TokenType.VAR_
		    Return "VAR"
		  Case TokenType.WHILE_
		    Return "WHILE"
		  Case TokenType.EOF
		    Return "EOF"
		  Case TokenType.PLUS_PLUS
		    Return "PLUS_PLUS"
		  Case TokenType.MINUS_MINUS
		    Return "MINUS_MINUS"
		  Case TokenType.QUESTION
		    Return "QUESTION"
		  Case TokenType.COLON
		    Return "COLON"
		  Case TokenType.PLUS_EQUAL
		    Return "PLUS_EQUAL"
		  Case TokenType.MINUS_EQUAL
		    Return "MINUS_EQUAL"
		  Case TokenType.STAR_EQUAL
		    Return "STAR_EQUAL"
		  Case TokenType.SLASH_EQUAL
		    Return "SLASH_EQUAL"
		  Case TokenType.BREAK_
		    Return "BREAK"
		  Case TokenType.CONTINUE_
		    Return "CONTINUE"
		  Case TokenType.MODULE_
		    Return "MODULE"
		  Case TokenType.AMPERSAND
		    Return "AMPERSAND"
		  Case TokenType.PIPE
		    Return "PIPE"
		  Case TokenType.LESS_LESS
		    Return "LESS_LESS"
		  Case TokenType.GREATER_GREATER
		    Return "GREATER_GREATER"
		  Case TokenType.ELVIS
		    Return "ELVIS"
		  Case TokenType.ELVIS_DOT
		    Return "ELVIS_DOT"
		  Case TokenType.USING_
		    Return "USING"
		  Case TokenType.LEFT_BRACKET
		    Return "LEFT_BRACKET"
		  Case TokenType.RIGHT_BRACKET
		    Return "RIGHT_BRACKET"
		  Case TokenType.FAT_ARROW
		    Return "FAT_ARROW"
		  Case TokenType.HASHTAG_BRACE
		    Return "HASHTAG_BRACE"
		    
		  Case Else
		    Return "STRINGIFY->"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToStringLox(Extends obj As Variant) As String
		  Select Case obj.Type
		  Case 0
		    Return "null"
		  Case 2, 3, 4, 5, 6
		    #if TargetConsole
		      Return Str(obj.DoubleValue) // TODO: "-###########0.0#####"
		    #else
		      Return Str(obj.DoubleValue, "-###########0.0#####")
		    #endif
		  Case 7 // date
		    Return obj.DateValue.SQLDateTime
		  Case 8, 16
		    Return obj.StringValue
		  Case 11 // boolean
		    Return obj.StringValue.Lowercase
		  Case 9 // obj TODO: cache methods
		    Dim ti As Introspection.TypeInfo= Introspection.GetType(obj)
		    Dim methods() As Introspection.MethodInfo= ti.GetMethods
		    For i As Integer= methods.Ubound DownTo 0
		      Dim method As Introspection.MethodInfo= methods(i)
		      If method.ReturnType Is Nil Then Continue
		      Dim mathodParams() As Introspection.ParameterInfo= method.GetParameters
		      If method.Name.Lowercase= "tostring" And _
		        method.ReturnType.Name.Lowercase= "string" And _
		        mathodParams.Ubound= -1 Then
		        Dim params() As Variant
		        Return method.Invoke(obj, params)
		      End If
		    Next
		    'For Each method As Introspection.MethodInfo In methods
		    'Next
		    Return ti.FullName
		  Case Else
		    Return "other"
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValChar(asc As UInt8) As UInt64
		  Select Case asc
		  Case 48
		    Return 0
		  Case 49
		    Return 1
		  Case 50
		    Return 2
		  Case 51
		    Return 3
		  Case 52
		    Return 4
		  Case 53
		    Return 5
		  Case 54
		    Return 6
		  Case 55
		    Return 7
		  Case 56
		    Return 8
		  Case 57
		    Return 9
		  Case 97
		    Return 10
		  Case 98
		    Return 11
		  Case 99
		    Return 12
		  Case 100
		    Return 13
		  Case 101
		    Return 14
		  Case 102
		    Return 15
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValHexLox(extends cad As String) As Double
		  Dim len As Integer= cad.Len
		  If len> 16 Then Return &hffffffffffffffff
		  
		  Dim num3 As UInt64= ValChar(cad.Mid(len, 1).Lowercase.Asc)
		  Dim num4 As UInt64= num3
		  Dim i As Integer= 1
		  
		  For j As Integer= len- 1 DownTo 1 // bigendian
		    num3= ValChar(cad.Mid(j, 1).Lowercase.Asc)
		    num4= num4 Or Bitwise.ShiftLeft(num3, i* 4)
		    i= i+ 1
		  Next
		  
		  Return CType(num4, Double)
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetConsole
			    If mErrorOut Is Nil Then mErrorOut= StdErr
			  #endif
			  
			  return mErrorOut
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mErrorOut = value
			End Set
		#tag EndSetter
		ErrorOut As Writeable
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mInterpreter Is Nil Then mInterpreter= New Lox.Inter.Interpreter
			  
			  return mInterpreter
			End Get
		#tag EndGetter
		Interpreter As Lox.Inter.Interpreter
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mErrorOut As Writeable
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInterpreter As Lox.Inter.Interpreter
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPrintOut As Writeable
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetConsole
			    If mPrintOut Is Nil Then mPrintOut= StdOut
			  #endif
			  
			  return mPrintOut
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mPrintOut = value
			End Set
		#tag EndSetter
		PrintOut As Writeable
	#tag EndComputedProperty


	#tag Constant, Name = Version, Type = String, Dynamic = False, Default = \"0.0.240912", Scope = Public
	#tag EndConstant


	#tag Enum, Name = TokenType, Type = Integer, Flags = &h1
		LEFT_PAREN
		  RIGHT_PAREN
		  LEFT_BRACE
		  RIGHT_BRACE
		  COMMA
		  DOT
		  MINUS
		  PLUS
		  SEMICOLON
		  SLASH
		  STAR
		  BANG
		  BANG_EQUAL
		  EQUAL
		  EQUAL_EQUAL
		  GREATER
		  GREATER_EQUAL
		  LESS
		  LESS_EQUAL
		  IDENTIFIER
		  STRING_
		  NUMBER
		  AND_
		  CLASS_
		  ELSE_
		  FALSE_
		  FUN
		  FOR_
		  IF_
		  NIL_
		  OR_
		  PRINT_
		  RETURN_
		  SUPER_
		  THIS
		  TRUE_
		  VAR_
		  WHILE_
		  EOF
		  PLUS_PLUS
		  MINUS_MINUS
		  QUESTION
		  COLON
		  PLUS_EQUAL
		  MINUS_EQUAL
		  STAR_EQUAL
		  SLASH_EQUAL
		  BREAK_
		  CONTINUE_
		  MODULE_
		  AMPERSAND
		  PIPE
		  LESS_LESS
		  GREATER_GREATER
		  ELVIS
		  ELVIS_DOT
		  USING_
		  LEFT_BRACKET
		  RIGHT_BRACKET
		  FAT_ARROW
		HASHTAG_BRACE
	#tag EndEnum


	#tag ViewBehavior
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
End Module
#tag EndModule
