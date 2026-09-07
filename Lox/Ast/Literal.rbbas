#tag Class
Protected Class Literal
Inherits Lox.Ast.Expr
	#tag Method, Flags = &h0
		Function Accept(visitor As IExprVisitor) As Variant
		  Return visitor.VisitLiteral(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(value As Variant)
		  If value.Type= Variant.TypeString Then
		    // escaping
		    Dim tmpValue As String= value.StringValue.ReplaceAll("\0", Chr(0)). _
		    ReplaceAll("\""", """").ReplaceAll("\\", "\").ReplaceAll("\%", "%"). _
		    ReplaceAll("\a", Chr(7)).ReplaceAll("\b", Chr(8)).ReplaceAll("\e", Chr(27)). _
		    ReplaceAll("\f", Chr(12)).ReplaceAll("\n", Chr(10)).ReplaceAll("\r", Chr(13)). _
		    ReplaceAll("\t", Chr(9)).ReplaceAll("\v", Chr(11))
		    
		    Dim strValue As String= tmpValue
		    
		    // search \xNN
		    Dim rg As New RegEx
		    rg.SearchPattern= "\\x?([\da-fA-F]{2})"
		    Dim match As RegExMatch= rg.Search(tmpValue)
		    
		    While Not (match Is Nil)
		      Dim subExpr As String= match.SubExpressionString(1)
		      Dim repExpr As String= DecodeHex(subExpr)
		      strValue= strValue.ReplaceAll(match.SubExpressionString(0), repExpr)
		      
		      match= rg.Search
		    Wend
		    
		    // search \uNNNN
		    rg.SearchPattern= "\\u?([\da-fA-F]{4})"
		    match= rg.Search(tmpValue)
		    
		    While Not (match Is Nil)
		      Dim subExpr As String= match.SubExpressionString(1)
		      Dim repExpr As String= Encodings.UTF8.Chr(Val("&h"+ subExpr))
		      strValue= strValue.ReplaceAll(match.SubExpressionString(0), repExpr)
		      
		      match= rg.Search
		    Wend
		    
		    // search \UNNNNNN
		    rg.SearchPattern= "\\U?([\da-fA-F]{8})"
		    match= rg.Search(tmpValue)
		    
		    While Not (match Is Nil)
		      Dim subExpr As String= match.SubExpressionString(1)
		      Dim repExpr As String= Encodings.UTF8.Chr(Val("&h"+ subExpr))
		      strValue= strValue.ReplaceAll(match.SubExpressionString(0), repExpr)
		      
		      match= rg.Search
		    Wend
		    
		    value= strValue
		  End If
		  
		  Self.Value= value
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Value As Variant
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
