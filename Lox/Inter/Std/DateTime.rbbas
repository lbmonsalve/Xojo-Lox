#tag Class
Protected Class DateTime
Inherits Lox.Inter.LoxClass
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant) As Variant
		  Try
		    #pragma BreakOnExceptions Off
		    Select Case args.Ubound
		    Case -1
		      Return New Lox.Inter.Std.DateTime(DataDate.Now)
		      
		    Case 0
		      Return New Lox.Inter.Std.DateTime(DataDate.From(args(0).UInt64Value))
		      
		    Case 2
		      Return New Lox.Inter.Std.DateTime(New DataDate(New Date(args(0), args(1), args(2))))
		      
		    Case 5
		      Dim d1 As New Date(args(0), args(1), args(2), args(3), args(4), args(5))
		      Return New Lox.Inter.Std.DateTime(New DataDate(d1))
		      
		    End Select
		  Catch
		    #pragma BreakOnExceptions Off
		    Raise New RuntimeError(New Token(TokenType.NIL_, "", Nil, -1), "mismatch in num/type of arguments.")
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  Super.Constructor Self
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(value As IDataDate)
		  Constructor
		  
		  Self.Value= value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As Variant
		  Select Case name
		  Case "year"
		    Return Value.Year
		    
		  Case "month"
		    Return Value.Month
		    
		  Case "day"
		    Return Value.Day
		    
		  Case "hour"
		    Return Value.Hour
		    
		  Case "minute"
		    Return Value.Minute
		    
		  Case "second"
		    Return Value.Second
		    
		  Case "SQLDate"
		    Return Value.SQLDate
		    
		  Case "SQLDatetime"
		    Return Value.SQLDateTime
		    
		  Case "toString"
		    Return Value.ToString
		    
		  Case "dayOfWeek"
		    Return Value.DayOfWeek
		    
		  Case "dayOfYear"
		    Return Value.DayOfYear
		    
		  Case "weekOfYear"
		    Return Value.WeekOfYear
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  Return "<class DateTime>"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Value As IDataDate
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
