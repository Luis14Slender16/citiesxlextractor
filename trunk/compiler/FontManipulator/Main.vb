'==========================================================================
'
'  File:        Main.vb
'  Location:    CitiesXLLoc <Visual Basic .Net>
'  Description: CitiesXL 字库导出导入工具
'  Version:     2010.03.26.
'  Copyright(C) F.R.C. / 3DMGame
'
'==========================================================================

Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.IO
Imports System.Diagnostics
Imports Firefly
Imports Firefly.Packaging
Imports Firefly.Imaging
Imports Firefly.Glyphing
Imports Firefly.Setting

Public Module Main

    Public Sub Main()
        If System.Diagnostics.Debugger.IsAttached Then
            MainInner()
        Else
            Try
                MainInner()
            Catch ex As Exception
                ExceptionHandler.PopupException(ex)
            End Try
        End If
    End Sub

    Public Sub DisplayInfo()
        Console.WriteLine("CitiesXL 字库导出导入工具")
        Console.WriteLine("CitiesXL.FontManipulator")
        Console.WriteLine("F.R.C. / 3DMGame")
        Console.WriteLine("")
        Console.WriteLine("用法:")
        Console.WriteLine("FontManipulator <fnt/fd Path>*")
        Console.WriteLine("")
        Console.WriteLine("示例:")
        Console.WriteLine("FontManipulator font.fnt")
        Console.WriteLine("FontManipulator font.fd")
    End Sub

    Public Sub MainInner()
        Dim CmdLine = CommandLine.GetCmdLine()
        Dim argv = CmdLine.Arguments

        If argv.Length = 0 AndAlso CmdLine.Options.Length = 0 Then
            DisplayInfo()
            Return
        End If

        For Each opt In CmdLine.Options
            Select Case opt.Name.ToLower
                Case "?", "help"
                    DisplayInfo()
                    Return
                Case Else
                    Throw New ArgumentException(opt.Name)
            End Select
        Next

        For Each f In argv
            Dim FileName = GetFileName(f)

            If IsMatchFileMask(FileName, "*.fnt") Then
                Dim FntPath = f
                Dim FdPath = ChangeExtension(f, "fd")
                Dim ImagePath = ChangeExtension(f, "bmp")

                Using s As New StreamEx(FntPath, FileMode.Open, FileAccess.Read)
                    Dim FNT As New FNT(s)
                    FdGlyphDescriptionFile.WriteFile(FdPath, FNT.Glyphs)
                    Dim Data = FNT.Bitmap
                    Using b As New Bmp(ImagePath, Data.GetLength(0), Data.GetLength(1), 8)
                        b.Palette = (From i In Enumerable.Range(0, 256) Select ConcatBits(255, 8, i, 8, i, 8, i, 8)).ToArray
                        b.SetRectangle(0, 0, Data)
                    End Using
                End Using
            ElseIf IsMatchFileMask(FileName, "*.fd") Then
                Dim FntPath = ChangeExtension(f, "fnt")
                Dim FdPath = f
                Dim ImagePath = ChangeExtension(f, "bmp")

                Using s As New StreamEx(FntPath, FileMode.Open, FileAccess.ReadWrite)
                    Dim FNT As New FNT(s)
                    FNT.Glyphs = FdGlyphDescriptionFile.ReadFile(FdPath).ToArray
                    Using b = Bmp.Open(ImagePath)
                        Dim Data = b.GetRectangleAsARGB(0, 0, b.Width, b.Height)
                        For y = 0 To Data.GetLength(1) - 1
                            For x = 0 To Data.GetLength(0) - 1
                                Dim ARGB = Data(x, y)
                                Dim A = (ARGB.Bits(23, 16) + ARGB.Bits(15, 8) + ARGB.Bits(7, 0)) \ 3
                                Data(x, y) = ConcatBits(A, 8, ARGB, 24)
                            Next
                        Next
                        FNT.Bitmap = Data
                    End Using

                    s.Position = 0
                    s.SetLength(0)
                    FNT.Write(s)
                End Using
            End If
        Next
    End Sub
End Module
