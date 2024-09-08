#tag Class
Protected Class LoxArrayMethods
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant) As Variant
		  Select Case MethodName
		  Case "pop"
		    Return Owner.Elements.Pop
		  Case "push"
		    Dim arr As New Lox.Inter.LoxArray(Owner.Elements)
		    Dim elems() As Variant= arr.Elements
		    For Each arg As Variant In args
		      elems.Append arg
		    Next
		    Return arr
		  Case "each"
		    Return DoEach(inter, args)
		  Case "indexOf"
		    'Return Owner.Elements.IndexOf(args(0))
		    Dim elems() As Variant= Owner.Elements
		    Dim search As Variant= args(0)
		    Dim idxFound As Integer
		    For i As Integer= 0 To elems.Ubound
		      If search.Equals(elems(i)) Then
		        idxFound= i
		        Exit
		      End If
		    Next
		    Return idxFound
		  Case "map"
		    Return DoMap(inter, args)
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(methodName As String, owner As Lox.Inter.LoxArray)
		  Self.MethodName= methodName
		  Self.Owner= owner
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoEach(inter As Interpreter, args() As Variant) As Variant
		  // Check that `func` is invokable.
		  If Not args(0).IsCallableLox Then
		    Raise New RuntimeError(New Token(TokenType.NIL_, "", Nil, -1), "Expected an callable operand")
		  End If
		  
		  Dim func As Lox.Inter.ICallable= args(0)
		  
		  // If a second argument has been passed, check that it's an Array object.
		  Dim funcArgs() As Variant
		  If args.Ubound>= 1 And args(1).IsArray Then
		    // Get an array of the additional arguments to pass to the function we will invoke.
		    Dim elems() As Variant= Lox.Inter.LoxArray(args(1)).Elements
		    For Each elem As Variant In elems
		      funcArgs.Append elem
		    Next
		  End If
		  
		  // Check that we have the correct number of arguments for `func`.
		  // NB: +2 as we will pass in each element as the first argument.
		  'If Not Interpreter.CorrectArity(func, funcArgs.Ubound+ 2) Then
		  'Raise New RooRuntimeError(where, "Incorrect number of arguments passed to the " +_
		  'Stringable(func).StringValue + " function.")
		  'End If
		  
		  For i As Integer= 0 To Owner.Elements.Ubound
		    funcArgs.Insert 0, Owner.Elements(i) // Inject the element as the first argument to `func`.
		    Call func.Call_(inter, funcArgs)
		    funcArgs.Remove 0 // Remove this element from the argument list prior to the next iteration.
		  Next i
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoMap(inter As Interpreter, args() As Variant) As Variant
		  // Check that `func` is invokable.
		  If Not args(0).IsCallableLox Then
		    Raise New RuntimeError(New Token(TokenType.NIL_, "", Nil, -1), "Expected an callable operand")
		  End If
		  
		  Dim func As Lox.Inter.ICallable= args(0)
		  
		  // If a second argument has been passed, check that it's an Array object.
		  Dim funcArgs() As Variant
		  If args.Ubound>= 1 And args(1).IsArray Then
		    // Get an array of the additional arguments to pass to the function we will invoke.
		    Dim elems() As Variant= Lox.Inter.LoxArray(args(1)).Elements
		    For Each elem As Variant In elems
		      funcArgs.Append elem
		    Next
		  End If
		  
		  // Check that we have the correct number of arguments for `func`.
		  // NB: +2 as we will pass in each element as the first argument.
		  'If Not Interpreter.CorrectArity(func, funcArgs.Ubound+ 2) Then
		  'Raise New RooRuntimeError(where, "Incorrect number of arguments passed to the " +_
		  'Stringable(func).StringValue + " function.")
		  'End If
		  
		  Dim result() As Variant
		  
		  For i As Integer= 0 To Owner.Elements.Ubound
		    funcArgs.Insert 0, Owner.Elements(i) // Inject the element as the first argument to `func`.
		    result.Append func.Call_(inter, funcArgs)
		    funcArgs.Remove 0 // Remove this element from the argument list prior to the next iteration.
		  Next
		  
		  Return New Lox.Inter.LoxArray(result)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		MethodName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Owner As Lox.Inter.LoxArray
	#tag EndProperty


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
			Name="MethodName"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
