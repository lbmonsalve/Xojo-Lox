#tag Class
Protected Class LoxFunction
Implements ICallable
	#tag Method, Flags = &h0
		Function Arity() As Integer
		  Return mDeclaration.Parameters.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Bind(instance As LoxInstance) As LoxFunction
		  Dim env As Environment= New Environment(mClosure)
		  env.Define "this", instance
		  Return New LoxFunction(mName, mDeclaration, env, mIsInitializer)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Call_(inter As Interpreter, args() As Variant, tok As Token) As Variant
		  Dim env As New Environment(mClosure)
		  
		  For i As Integer= 0 To mDeclaration.Parameters.Ubound
		    env.Define(mDeclaration.Parameters(i).Lexeme, args(i))
		  Next
		  
		  Try
		    inter.ExecuteBlock(mDeclaration.Body, env)
		  Catch exc As ReturnExc
		    If mIsInitializer Then Return mClosure.GetAt(0, "this")
		    Return exc.Value
		  End Try
		  
		  If mIsInitializer Then Return mClosure.GetAt(0, "this")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(name As String, declaration As Lox.Ast.FunctionExpr, closure As Environment, isInitializer As Boolean)
		  mName= name
		  mDeclaration= declaration
		  mClosure= closure
		  mIsInitializer= isInitializer
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As String
		  If mName.Len= 0 Then Return "<fn>"
		  Return "<fn "+ mName+ ">"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mClosure As Environment
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDeclaration As Lox.Ast.FunctionExpr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsInitializer As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mName As String
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
