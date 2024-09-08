#tag Class
Protected Class DateTime
Inherits Lox.Inter.LoxInstance
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant) As Variant
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
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(value As IDataDate)
		  Self.Value= value
		  
		  // fields:
		  Fields.Value("year")= Value.Year
		  Fields.Value("month")= Value.Month
		  Fields.Value("day")= Value.Day
		  
		  Fields.Value("hour")= Value.Hour
		  Fields.Value("minute")= Value.Minute
		  Fields.Value("second")= Value.Second
		  
		  Fields.Value("SQLDate")= Value.SQLDate
		  Fields.Value("SQLDatetime")= Value.SQLDateTime
		  
		  Fields.Value("toString")= Value.ToString
		  
		  Fields.Value("dayOfWeek")= Value.DayOfWeek
		  Fields.Value("dayOfYear")= Value.DayOfYear
		  Fields.Value("weekOfYear")= Value.WeekOfYear
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindMethod(name As String) As Variant
		  Break
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
