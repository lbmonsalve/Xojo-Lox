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

	#tag Method, Flags = &h1
		Protected Sub Error(line As Integer, message As String)
		  Report line, "", message
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IIf(stmt As Boolean, ifTrue As TokenType, ifFalse As TokenType) As TokenType
		  If stmt Then Return ifTrue Else Return ifFalse
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsNumber(Extends vart As Variant) As Boolean
		  Select Case vart.Type
		  Case 2, 3, 4, 5, 6
		    Return True
		  Case Else
		    Return False
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsString(Extends vart As Variant) As Boolean
		  Select Case vart.Type
		  Case 8, 11, 16
		    Return True
		  Case Else
		    Return False
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Report(line As Integer, where As String, message As String)
		  Dim txt As String= "[line "+ Str(line)+ "] error"+ where+ ": "+ message
		  
		  System.DebugLog txt
		  StdErr.WriteLine txt
		  
		  HadError= True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RuntimeError(error As RuntimeError)
		  StdErr.WriteLine error.Message+ EndOfLine+ "[line "+ Str(error.Token.Line)+ "]"
		  HadRuntimeError= True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Substring(Extends txt As String, startIndex As Integer, endIndex As Integer) As String
		  Return txt.Mid(startIndex, endIndex- startIndex)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(Extends tok As Lox.TokenType) As String
		  Select Case tok
		  Case Lox.TokenType.LEFT_PAREN
		    Return "LEFT_PAREN"
		  Case Lox.TokenType.RIGHT_PAREN
		    Return "RIGHT_PAREN"
		  Case Lox.TokenType.LEFT_BRACE
		    Return "LEFT_BRACE"
		  Case Lox.TokenType.RIGHT_BRACE
		    Return "RIGHT_BRACE"
		  Case Lox.TokenType.COMMA
		    Return "COMMA"
		  Case Lox.TokenType.DOT
		    Return "DOT"
		  Case Lox.TokenType.MINUS
		    Return "MINUS"
		  Case Lox.TokenType.PLUS
		    Return "PLUS"
		  Case Lox.TokenType.SEMICOLON
		    Return "SEMICOLON"
		  Case Lox.TokenType.SLASH
		    Return "SLASH"
		  Case Lox.TokenType.STAR
		    Return "STAR"
		  Case Lox.TokenType.BANG
		    Return "BANG"
		  Case Lox.TokenType.BANG_EQUAL
		    Return "BANG_EQUAL"
		  Case Lox.TokenType.EQUAL
		    Return "EQUAL"
		  Case Lox.TokenType.EQUAL_EQUAL
		    Return "EQUAL_EQUAL"
		  Case Lox.TokenType.GREATER
		    Return "GREATER"
		  Case Lox.TokenType.GREATER_EQUAL
		    Return "GREATER_EQUAL"
		  Case Lox.TokenType.LESS
		    Return "LESS"
		  Case Lox.TokenType.LESS_EQUAL
		    Return "LESS_EQUAL"
		  Case Lox.TokenType.IDENTIFIER
		    Return "IDENTIFIER"
		  Case Lox.TokenType.STRING_
		    Return "STRING"
		  Case Lox.TokenType.NUMBER
		    Return "NUMBER"
		  Case Lox.TokenType.AND_
		    Return "AND"
		  Case Lox.TokenType.CLASS_
		    Return "CLASS"
		  Case Lox.TokenType.ELSE_
		    Return "ELSE"
		  Case Lox.TokenType.FALSE_
		    Return "FALSE"
		  Case Lox.TokenType.FUN
		    Return "LEFT_PAREN"
		  Case Lox.TokenType.FOR_
		    Return "FUN"
		  Case Lox.TokenType.IF_
		    Return "IF"
		  Case Lox.TokenType.NIL_
		    Return "NIL"
		  Case Lox.TokenType.OR_
		    Return "OR"
		  Case Lox.TokenType.PRINT_
		    Return "PRINT"
		  Case Lox.TokenType.RETURN_
		    Return "RETURN"
		  Case Lox.TokenType.SUPER_
		    Return "SUPER"
		  Case Lox.TokenType.THIS
		    Return "THIS"
		  Case Lox.TokenType.TRUE_
		    Return "TRUE"
		  Case Lox.TokenType.VAR_
		    Return "VAR"
		  Case Lox.TokenType.WHILE_
		    Return "WHILE"
		  Case Lox.TokenType.EOF
		    Return "EOF"
		  Case Else
		    Return ""
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(Extends vart As Variant) As String
		  Select Case vart.Type
		  Case 0
		    Return ""
		  Case 2, 3, 4, 5, 6
		    Return Str(vart.DoubleValue) // TODO: "-###########0.0#######"
		  Case 8, 11, 16
		    Return vart.StringValue
		  Case 7 // date
		    Return vart.DateValue.SQLDateTime
		  Case Else
		    Return "other"
		  End Select
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		HadError As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		HadRuntimeError As Boolean
	#tag EndProperty

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
		Private mInterpreter As Lox.Inter.Interpreter
	#tag EndProperty


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
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="HadError"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
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
End Module
#tag EndModule
