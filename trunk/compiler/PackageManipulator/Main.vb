'==========================================================================
'
'  File:        Main.vb
'  Location:    CitiesXLLoc <Visual Basic .Net>
'  Description: CitiesXL 文件包导出导入工具
'  Version:     2010.03.27.
'  Copyright(C) F.R.C. / 3DMGame
'
'==========================================================================

Option Compare Text

Imports System
Imports System.Text.RegularExpressions
Imports System.IO
Imports Firefly
Imports Firefly.Packaging
Imports PackageManager

Public Module Main

    Public Function Main() As Integer
        If System.Diagnostics.Debugger.IsAttached Then
            Return MainInner()
        Else
            Try
                Return MainInner()
            Catch ex As Exception
                ExceptionHandler.PopupException(ex, "发生以下异常:", My.Application.Info.ProductName)
            End Try
        End If
    End Function

    Public Sub Usage()
        Console.WriteLine("CitiesXLLoc.PackageManipulator")
        Console.WriteLine("F.R.C. / 3DMGame")
        Console.WriteLine("")
        Console.WriteLine("Usage:")
        Console.WriteLine("Export:")
        Console.WriteLine("PackageManipulator <pak Path> e <InnerPathRegex> <OuterPathReplacement>")
        Console.WriteLine("Import(Replace):")
        Console.WriteLine("PackageManipulator <pak Path> r <InnerPathRegex> <OuterPathReplacement> [/I]")
        Console.WriteLine("/I Ignore file that does not exist")
        Console.WriteLine("List:")
        Console.WriteLine("PackageManipulator <pak Path> l <ListFilePath>")
        Console.WriteLine("Create:")
        Console.WriteLine("PackageManipulator <pak Path> c <ListFilePath>")
        Console.WriteLine("")
        Console.WriteLine("Example:")
        Console.WriteLine("PackageManipulator all_fnt.pak e ""(?<Name>.*)"" ""${Name}""")
        Console.WriteLine("PackageManipulator all_fnt.pak r ""(?<Name>.*)"" ""${Name}"" /I")
        Console.WriteLine("PackageManipulator all_fnt.pak l all_fnt.xml")
        Console.WriteLine("PackageManipulator all_fnt.pak c all_fnt.xml")
    End Sub

    Public Function MainInner() As Integer
        Dim CmdLine = CommandLine.GetCmdLine()
        Dim argv = CmdLine.Arguments
        Dim opt = CmdLine.Options

        If argv.Length < 2 Then
            Usage()
            Return -1
        End If

        Dim PackagePath = argv(0)
        Dim Command = argv(1)

        Select Case Command
            Case "e"
                If argv.Length <> 4 Then
                    Usage()
                    Return -1
                End If

                Using p = Open(PackagePath)
                    Export(p, argv(2), argv(3))
                End Using
            Case "r"
                If argv.Length <> 4 Then
                    Usage()
                    Return -1
                End If

                Dim IgnoreNonExist As Boolean = False
                For Each o In opt
                    Select Case o.Name
                        Case "I"
                            IgnoreNonExist = True
                    End Select
                Next

                Using p = Open(PackagePath)
                    Replace(p, argv(2), argv(3), IgnoreNonExist)
                End Using
            Case "l"
                If argv.Length <> 3 Then
                    Usage()
                    Return -1
                End If

                Dim XmlPath = argv(2)

                Using p = Open(PackagePath)
                    Dim pa = TryCast(p, PAK)
                    If pa Is Nothing Then Throw New NotSupportedException
                    pa.WriteToXml(XmlPath)
                End Using
            Case "c"
                If argv.Length <> 3 Then
                    Usage()
                    Return -1
                End If

                Dim XmlPath = argv(2)

                Using p = PAK.CreateFromXml(PackagePath, XmlPath)
                End Using
            Case Else
                Usage()
                Return -1
        End Select
    End Function

    Public Function Open(ByVal Path As String) As PackageBase
        Dim FileExt = GetExtendedFileName(Path)
        Select Case FileExt
            Case "pak", "patch"
                Return PAK.Open(Path)
            Case Else
                Throw New InvalidDataException
        End Select
    End Function

    Public Sub Export(ByVal p As PackageBase, ByVal InnerPathRegex As String, ByVal OuterPathReplacement As String)
        Dim r As New Regex("^" & InnerPathRegex & "$", RegexOptions.ExplicitCapture Or RegexOptions.IgnoreCase)
        For Each f In p.Files
            Dim m = r.Match(f.Path)
            If m.Success Then
                Dim Path = m.Result(OuterPathReplacement)
                p.Extract(f, Path)
            End If
        Next
    End Sub

    Public Sub Replace(ByVal p As PackageBase, ByVal InnerPathRegex As String, ByVal OuterPathReplacement As String, ByVal IgnoreNonExist As Boolean)
        Dim r As New Regex("^" & InnerPathRegex & "$", RegexOptions.ExplicitCapture Or RegexOptions.IgnoreCase)
        For Each f In p.Files
            Dim m = r.Match(f.Path)
            If m.Success Then
                Dim Path = m.Result(OuterPathReplacement)
                If IgnoreNonExist Then
                    If Not File.Exists(Path) Then Continue For
                End If
                p.Replace(f, Path)
            End If
        Next
    End Sub
End Module
