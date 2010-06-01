'==========================================================================
'
'  File:        RC4.vb
'  Location:    CitiesXLLoc <Visual Basic .Net>
'  Description: RC4加解密算法
'  Version:     2010.03.24.
'  Copyright(C) F.R.C. / 3DMGame
'
'==========================================================================

Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports Firefly

Public Class RC4
    Private S As Integer()

    Public Sub New(ByVal Key As Byte())
        S = (From b In Enumerable.Range(0, 256) Select b).ToArray

        Dim j = 0
        For i As Integer = 0 To 255
            j = (j + Key(i Mod Key.Length) + S(i)) Mod 256
            Exchange(S(i), S(j))
        Next
    End Sub

    Private i As Integer
    Private j As Integer
    Public Function NextByte() As Byte
        i = (i + 1) Mod 256
        j = (j + S(i)) Mod 256
        Exchange(S(i), S(j))
        Return S((S(i) + S(j)) Mod 256)
    End Function

    Public Shared Function Encrypt(ByVal Key As Byte(), ByVal Data As Byte()) As Byte()
        Dim r As New RC4(Key)
        Return (From b In Data Select b Xor r.NextByte).ToArray
    End Function

    Public Shared Function Decrypt(ByVal Key As Byte(), ByVal Data As Byte()) As Byte()
        Return Encrypt(Key, Data)
    End Function
End Class
