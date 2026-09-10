#tag Class
Protected Class RandomLox
Inherits Lox.Inter.LoxClass
	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  Try
		    #pragma BreakOnExceptions Off
		    Select Case args.Ubound
		    Case -1
		      Return New Lox.Inter.Std.RandomLox
		      
		    End Select
		  Catch
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(tok, "mismatch in num/type of arguments.")
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor(metaclass As LoxClass, name As String, superClass As LoxClass, methods As Lox.Misc.CSDictionary) -- From LoxClass
		  // Constructor(klass As LoxClass) -- From LoxInstance
		  Super.Constructor Self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As Variant
		  Select Case name
		  Case "next", "int", "number", "float", "sample", "shuffle"
		    Return New Lox.Inter.Std.RandomLoxMethods(name, Self)
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function NextRandom(gamma As UInt64 = &hdeadbeef) As UInt64
		  // http://rosettacode.org/wiki/Pseudo-random_numbers/Splitmix64
		  
		  Static state As UInt64 // The state can be seeded with any (upto) 64 bit integer value.
		  If state= 0 Then state= &h9e3779b97f4a7c15
		  
		  state= state+ gamma // increment the state variable
		  
		  Dim z As UInt64= state // copy the state to a working variable
		  z= (z Xor Bitwise.ShiftRight(z, 30))* &hbf58476d1ce4e5b9 // xor the variable with the variable right bit shifted 30 then multiply by a constant
		  z = (z Xor Bitwise.ShiftRight(z, 27))* &h94d049bb133111eb // xor the variable with the variable right bit shifted 27 then multiply by a constant
		  
		  Return z Xor Bitwise.ShiftRight(z, 31) // return the variable xored with itself right bit shifted 31
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "<class Random>"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Shared Rand As Random
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
