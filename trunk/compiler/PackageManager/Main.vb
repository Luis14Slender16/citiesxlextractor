'==========================================================================
'
'  File:        Main.vb
'  Location:    CitiesXLLoc <Visual Basic .Net>
'  Description: CitiesXL 文件包管理工具
'  Version:     2010.03.24.
'  Copyright(C) F.R.C. / 3DMGame
'
'==========================================================================

Imports System
Imports System.IO
Imports System.Diagnostics
Imports System.Windows.Forms
Imports Firefly
Imports Firefly.Packaging
Imports Firefly.TextEncoding

Public Module Main
    Public Sub Application_ThreadException(ByVal sender As Object, ByVal e As System.Threading.ThreadExceptionEventArgs)
        ExceptionHandler.PopupException(e.Exception, New StackTrace(4, True), "发生以下异常:", Application.ProductName)
    End Sub

    Public Sub Main()
        If Debugger.IsAttached Then
            Application.SetUnhandledExceptionMode(UnhandledExceptionMode.ThrowException)
            MainInner()
        Else
            Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException)
            Try
                AddHandler Application.ThreadException, AddressOf Application_ThreadException
                MainInner()
            Catch ex As Exception
                ExceptionHandler.PopupException(ex, "发生以下异常:", Application.ProductName)
            Finally
                RemoveHandler Application.ThreadException, AddressOf Application_ThreadException
            End Try
        End If
    End Sub

    Public Sub MainInner()
        PackageRegister.Register(PAK.Filter, AddressOf PAK.Open)
        Application.EnableVisualStyles()
        Application.Run(New GUI.PackageManager())
    End Sub
End Module
