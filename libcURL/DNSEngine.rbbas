#tag Class
Protected Class DNSEngine
	#tag Method, Flags = &h0
		Sub AddServer(ServerIP As String)
		  If mServerList.IndexOf(ServerIP) = -1 Then
		    mServerList.Append(ServerIP)
		    Me.FlushServerList
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Owner As libcURL.EasyHandle)
		  mOwner = New WeakRef(Owner)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub FlushOverrides()
		  If Not Owner.SetOption(libcURL.Opts.RESOLVE, mOverrideList) Then Raise New cURLException(Owner)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub FlushServerList()
		  If UBound(mServerList) > -1 Then
		    If Not Owner.SetOption(libcURL.Opts.DNS_SERVERS, Join(mServerList, ",")) Then Raise New cURLException(Owner)
		  Else
		    If Not Owner.SetOption(libcURL.Opts.DNS_SERVERS, Nil) Then Raise New cURLException(Owner)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetOverride(Hostname As String, PortNumber As Integer) As String
		  If Hostname = "" Or PortNumber <= 0 Then Return ""
		  
		  Dim i As Integer = GetOverrideIndex(Hostname, PortNumber)
		  If i > -1 Then Return NthField(mOverrideList.Item(i), ":", 3)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetOverrideIndex(Hostname As String, PortNumber As Integer) As Integer
		  If Hostname = "" Or PortNumber <= 0 Or mOverrideList = Nil Then Return -1
		  
		  Dim c As Integer = mOverrideList.Count
		  For i As Integer = 0 To c - 1
		    Dim h, p, tmp As String
		    tmp = mOverrideList.Item(i)
		    h = NthField(tmp, ":", 1)
		    p = NthField(tmp, ":", 2)
		    If Val(p) = PortNumber And CompareDomains(Hostname, h) Then Return i
		  Next
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Owner() As libcURL.EasyHandle
		  If mOwner <> Nil And Not (mOwner.Value Is Nil) And mOwner.Value IsA libcURL.EasyHandle Then
		    Return libcURL.EasyHandle(mOwner.Value)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveOverride(Hostname As String, PortNumber As Integer)
		  Dim i As Integer = GetOverrideIndex(Hostname, PortNumber)
		  If i <= -1 Then Return
		  RemoveOverrideAtIndex(i)
		  If mOverrideList = Nil Then mOverrideList = New ListPtr(Nil, Owner.Flags)
		  If Not mOverrideList.Append("-" + Hostname + ":" + Str(PortNumber, "####0")) Then Raise New cURLException(mOverrideList)
		  Me.FlushOverrides()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemoveOverrideAtIndex(Index As Integer)
		  If Index > -1 Then
		    Dim s() As String = mOverrideList
		    s.Remove(Index)
		    If UBound(s) > -1 Then mOverrideList = s Else mOverrideList = New ListPtr(Nil, Owner.Flags)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveServer(ServerIP As String)
		  Dim i As Integer = mServerList.IndexOf(ServerIP)
		  If i = -1 Then Return
		  mServerList.Remove(i)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  ReDim mServerList(-1)
		  Me.FlushServerList
		  
		  If mOverrideList = Nil Then mOverrideList = New ListPtr(Nil, Owner.Flags)
		  Dim l As New ListPtr(Nil, Owner.Flags)
		  Dim s() As String = mOverrideList
		  For Each h As String In s
		    If Left(h, 1) <> "-" Then h = "-" + NthField(h, ":", 1) + ":" + NthField(h, ":", 2)
		    If Not l.Append(h) Then Raise New cURLException(l)
		  Next
		  mOverrideList = l
		  Me.FlushOverrides()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ServerList() As String()
		  Return mServerList()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetOverride(Hostname As String, PortNumber As Integer, OverrideResult As String)
		  Dim i As Integer = GetOverrideIndex(Hostname, PortNumber)
		  If i > -1 Then RemoveOverrideAtIndex(i)
		  If mOverrideList = Nil Then mOverrideList = New ListPtr(Nil, Owner.Flags)
		  If Not mOverrideList.Append(Hostname + ":" + Str(PortNumber, "####0") + ":" + OverrideResult) Then Raise New cURLException(mOverrideList)
		  Me.FlushOverrides()
		End Sub
	#tag EndMethod


	#tag Note, Name = About this class
		This class provides accessor methods to specify a proxy server for use with some or
		all transfers performed with a particular EasyHandle.
	#tag EndNote


	#tag Property, Flags = &h21
		Private mOverrideList As libcURL.ListPtr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOwner As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mServerList() As String
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
			Name="Resolver"
			Group="Behavior"
			Type="String"
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
