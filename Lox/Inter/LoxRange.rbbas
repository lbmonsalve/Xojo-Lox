#tag Class
Protected Class LoxRange
Inherits Lox.Inter.LoxClass
	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  Try
		    #pragma BreakOnExceptions Off
		    Select Case args.Ubound
		    Case -1
		      Return New Lox.Inter.LoxRange
		      
		    Case 1 // from, to
		      Return New Lox.Inter.LoxRange(args(0).DoubleValue, args(1).DoubleValue)
		      
		    Case 2 // from, to, by
		      Return New Lox.Inter.LoxRange(args(0).DoubleValue, args(1).DoubleValue, args(2).DoubleValue)
		      
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

	#tag Method, Flags = &h1000
		Sub Constructor(from As Double, to_ As Double)
		  Super.Constructor Self
		  
		  Self.From= from
		  Self.To_= to_
		  Self.By= 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(from As Double, to_ As Double, by As Double)
		  Super.Constructor Self
		  
		  Self.From= from
		  Self.To_= to_
		  Self.By= by
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(copy As Lox.Inter.LoxRange)
		  Super.Constructor Self
		  
		  Self.From= copy.From
		  Self.To_= copy.To_
		  Self.By= copy.By
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As Variant
		  Select Case name
		  Case "from"
		    Return From
		  Case "to"
		    Return To_
		  Case "by"
		    Return By
		  Case "makeIterator", "next"
		    Return New Lox.Inter.LoxRangeMethods(name, Self)
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "<class Range>"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		By As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Current As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		From As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		To_ As Double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="By"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Current"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="From"
			Group="Behavior"
			Type="Double"
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
		#tag ViewProperty
			Name="To_"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
