#tag Class
Protected Class SystemMethods
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant) As Variant
		  Select Case mMethodName
		  Case "osEnvVar"
		    Return EnvVar(args(0)) // conflict in v2022
		  Case "debugLog"
		    DbgLog(args(0)) // conflict in v2022
		    Return mSystem
		  Case "assert"
		    Dim eval As Variant= args(0)
		    Dim mess As String= args(1).StringValue
		    
		    If eval.IsNull Then
		      Raise New RuntimeError(New Token(TokenType.NIL_, "", Nil, -1), "Failed assertion: " + mess)
		    End If
		    
		    If eval.BooleanValue= False Then
		      Raise New RuntimeError(New Token(TokenType.NIL_, "", Nil, -1), "Failed assertion: " + mess)
		    End If
		    
		    Return True
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(methodName As String, sys As Lox.Inter.Std.System)
		  mMethodName= methodName
		  mSystem= sys
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mMethodName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSystem As Lox.Inter.Std.System
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
