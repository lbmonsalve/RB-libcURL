#tag Class
Protected Class cURLHandle
Implements ErrorHandler
	#tag Method, Flags = &h1
		Protected Sub Constructor(GlobalInitFlags As Integer)
		  ' Initializes libcURL if necessary. GlobalInitFlags is one of the CURL_GLOBAL_* constants.
		  ' This class keeps track of which flags have already been initialized, and only initializes
		  ' libcURL if GlobalInitFlags is not among them.
		  
		  If Not libcURL.IsAvailable Then
		    Dim err As New PlatformNotSupportedException
		    err.Message = "libcURL is not available or is an unsupported version."
		    Raise err
		  End If
		  
		  If InitFlags = Nil Then InitFlags = New Dictionary
		  If Not InitFlags.HasKey(GlobalInitFlags) Then
		    mLastError = curl_global_init(GlobalInitFlags)
		    If mLastError <> 0 Then Raise New cURLException(Me)
		  End If
		  InitFlags.Value(GlobalInitFlags) = InitFlags.Lookup(GlobalInitFlags, 0) + 1
		  mFlags = GlobalInitFlags
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  InitFlags.Value(mFlags) = InitFlags.Value(mFlags) - 1
		  If InitFlags.Value(mFlags) <= 0 Then 
		    If libcURL.IsAvailable Then curl_global_cleanup()
		    InitFlags.Remove(mFlags)
		  End If
		  If InitFlags.Count = 0 Then InitFlags = Nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Flags() As Integer
		  Return mFlags
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastError() As Integer
		  // Part of the libcURL.ErrorHandler interface.
		  ' All calls into libcURL that return an error code will update LastError
		  ' See:
		  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.Errors
		  ' https://github.com/charonn0/RB-libcURL/wiki/libcURL.FormatError
		  
		  Return mLastError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LastError(Assigns NewError As Integer)
		  // Part of the libcURL.ErrorHandler interface.
		  mLastError = NewError
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared InitFlags As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFlags As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mLastError As Integer
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