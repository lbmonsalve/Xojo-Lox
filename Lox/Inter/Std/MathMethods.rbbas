#tag Class
Protected Class MathMethods
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  Const kPiDiv180= 0.01745329251
		  Const k180DivPI= 57.2957795131
		  
		  Try
		    #pragma BreakOnExceptions Off
		    Select Case mMethodName
		    Case "sin"
		      Return sin(args(0).DoubleValue* kPiDiv180)
		      
		    Case "cos"
		      Return cos(args(0).DoubleValue* kPiDiv180)
		      
		    Case "tan"
		      Return tan(args(0).DoubleValue* kPiDiv180)
		      
		    Case "sqrt"
		      Return sqrt(args(0).DoubleValue)
		      
		    Case "abs"
		      Return abs(args(0).DoubleValue)
		      
		    Case "acos"
		      Return acos(args(0).DoubleValue)* k180DivPI
		      
		    Case "asin"
		      Return asin(args(0).DoubleValue)* k180DivPI
		      
		    Case "atan"
		      Return atan(args(0).DoubleValue)* k180DivPI
		      
		    Case "atan2"
		      Return atan2(args(0).DoubleValue, args(1).DoubleValue)* k180DivPI
		      
		    Case "bin"
		      Return bin(args(0).DoubleValue)
		      
		    Case "cdbl"
		      Return CDbl(args(0).StringValue)
		      
		    Case "ceil"
		      Return Ceil(args(0).DoubleValue)
		      
		    Case "exp"
		      Return Exp(args(0).DoubleValue)
		      
		    Case "floor"
		      Return Floor(args(0).DoubleValue)
		      
		    Case "hex"
		      Return Hex(args(0).IntegerValue)
		      
		    Case "log"
		      Return Log(args(0).DoubleValue)
		      
		    Case "max"
		      Return Max(args(0).DoubleValue, args(1).DoubleValue)
		      
		    Case "min"
		      Return Min(args(0).DoubleValue, args(1).DoubleValue)
		      
		    Case "oct"
		      Return Oct(args(0).IntegerValue)
		      
		    Case "pow"
		      Return Pow(args(0).DoubleValue, args(1).DoubleValue)
		      
		    Case "round"
		      Return Round(args(0).DoubleValue)
		      
		    Case "val"
		      Return val(args(0).StringValue)
		      
		    Case "str"
		      If args.Ubound= 0 Then
		        Return str(args(0).DoubleValue)
		      ElseIf args.Ubound= 1 Then
		        Return str(args(0).DoubleValue, args(1).StringValue)
		      End If
		      
		    End Select
		  Catch
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "mismatch in num/type of arguments.")
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(methodName As String, math As Lox.Inter.Std.Math)
		  mMethodName= methodName
		  mMath= math
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mMath As Lox.Inter.Std.Math
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMethodName As String
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
