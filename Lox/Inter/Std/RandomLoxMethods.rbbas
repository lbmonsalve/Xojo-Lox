#tag Class
Protected Class RandomLoxMethods
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  If mMethodName= "next" Then Return mRand.NextRandom
		  
		  mRand.Rand= New Random
		  mRand.Rand.RandomizeSeed
		  
		  Try
		    #pragma BreakOnExceptions Off
		    Select Case mMethodName
		    Case "int"
		      Select Case args.Ubound
		      Case 0
		        Return mRand.Rand.InRange(0, args(0).IntegerValue)
		      Case 1
		        Return mRand.Rand.InRange(args(0).IntegerValue, args(1).IntegerValue)
		      End Select
		      
		    Case "number"
		      Return mRand.Rand.Number
		      
		    Case "float"
		      Select Case args.Ubound
		      Case -1
		        Return mRand.Rand.Gaussian
		      Case 0
		        Return mRand.Rand.InRange(0, args(0).IntegerValue)+ mRand.Rand.Number
		      Case 1
		        Return mRand.Rand.InRange(args(0).IntegerValue, args(1).IntegerValue)+ mRand.Rand.Number
		      End Select
		      
		    Case "sample"
		      If args(0) IsA Lox.Inter.LoxArray Then
		        Dim arr As Lox.Inter.LoxArray= args(0)
		        Dim ele() As Variant= arr.Elements
		        Dim idx As Integer= mRand.Rand.InRange(0, ele.Ubound)
		        
		        Return ele(idx)
		      Else
		        Return Nil
		      End If
		      
		    Case "shuffle"
		      If args(0) IsA Lox.Inter.LoxArray Then
		        Dim arr As Lox.Inter.LoxArray= args(0)
		        Dim ele() As Variant= arr.Elements
		        
		        For i As Integer= 0 To ele.Ubound
		          Dim from As Integer= mRand.Rand.InRange(i, ele.Ubound)
		          Dim temp As Variant= ele(from)
		          ele(from)= ele(i)
		          ele(i)= temp
		          
		          mRand.Rand= New Random
		          mRand.Rand.RandomizeSeed
		        Next
		        
		        Return ele
		      Else
		        Return Nil
		      End If
		      
		    End Select
		  Catch
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "mismatch in num/type of arguments.")
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(methodName As String, rand As Lox.Inter.Std.RandomLox)
		  mMethodName= methodName
		  mRand= rand
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mMethodName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRand As Lox.Inter.Std.RandomLox
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
