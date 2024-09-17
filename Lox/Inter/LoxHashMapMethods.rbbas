#tag Class
Protected Class LoxHashMapMethods
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  Try
		    #pragma BreakOnExceptions Off
		    Select Case MethodName
		    Case "delete"
		      Try
		        Dim value As Variant= Owner.HashMap.Lookup(args(0), Nil)
		        Owner.HashMap.Remove args(0)
		        Return value
		      Catch exc As KeyNotFoundException
		        inter.HadRuntimeError= True
		        #pragma BreakOnExceptions Off
		        Raise New RuntimeError(New Token(Lox.TokenType.NIL_, "",Nil,  -1), _
		        "KeyNotFoundException")
		      End Try
		    Case "each"
		      Call DoEach(inter, args, tok)
		      Return Owner
		    Case "value"
		      Return Owner.HashMap.Lookup(args(0), Nil)
		    Case "put"
		      Owner.HashMap.Value(args(0))= args(1)
		      Return Owner
		    End Select
		  Catch
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "mismatch in num/type of arguments.")
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(methodName As String, owner As Lox.Inter.LoxHashMap)
		  Self.MethodName= methodName
		  Self.Owner= owner
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoEach(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  // Check that `func` is invokable.
		  If Not args(0).IsCallableLox Then
		    Raise New RuntimeError(tok, "Expected an callable operand")
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
		  
		  Dim hashMap As Lox.Misc.CSDictionary= Owner.HashMap
		  For i As Integer= 0 To hashMap.Count- 1
		    Dim key As Variant= hashMap.Key(i)
		    Dim value As Variant= hashMap.Value(hashMap.Key(i))
		    
		    funcArgs.Insert 0, value // Inject the element as the first argument to `func`.
		    funcArgs.Insert 0, key // Inject the element as the first argument to `func`.
		    Call func.Call_(inter, funcArgs, tok)
		    funcArgs.Remove 0 // Remove this element from the argument list prior to the next iteration.
		    funcArgs.Remove 0 // Remove this element from the argument list prior to the next iteration.
		  Next i
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		MethodName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Owner As Lox.Inter.LoxHashMap
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
