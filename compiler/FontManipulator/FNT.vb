'==========================================================================
'
'  File:        FNT.vb
'  Location:    CitiesXLLoc <Visual Basic .Net>
'  Description: CitiesXL 字库图片
'  Version:     2010.03.26.
'  Copyright(C) F.R.C. / 3DMGame
'
'==========================================================================

Imports System
Imports System.Collections.Generic
Imports System.IO
Imports System.Drawing
Imports Firefly
Imports Firefly.TextEncoding
Imports Firefly.Glyphing
Imports Firefly.Imaging

Public Class FNT
    Private Header As Byte()

    Private Size1 As Int32
    Private Size2 As Int32
    Private Size3 As Int32
    Private Size4 As Int32

    Public Glyphs As GlyphDescriptor()
    Public Bitmap As Int32(,)

    Public Sub New(ByVal sp As ZeroPositionStreamPasser)
        Dim s = sp.GetStream

        If s.ReadInt32 <> 1 Then Throw New InvalidDataException
        Dim Width = s.ReadInt32
        Dim Height = s.ReadInt32

        Size1 = s.ReadInt32
        Size2 = s.ReadInt32
        Size3 = s.ReadInt32
        Size4 = s.ReadInt32

        Dim NumChar = s.ReadInt32
        Dim Chars = New Char32(NumChar - 1) {}
        For n = 0 To NumChar - 1
            Chars(n) = s.ReadUInt16
        Next

        Dim NumGlyph = s.ReadInt32
        Dim Glyphs As New List(Of GlyphDescriptor)
        For n = 0 To NumChar - 1
            Dim Left = s.ReadUInt16
            Dim Top = s.ReadUInt16
            Dim Right = s.ReadUInt16
            Dim Bottom = s.ReadUInt16

            Dim GlyphWidth = Right - Left
            Dim GlyphHeight = Bottom - Top

            Glyphs.Add(New GlyphDescriptor With {.c = StringCode.FromUniChar(Chars(n)), .PhysicalBox = New Rectangle(Left, Top, GlyphWidth, GlyphHeight), .VirtualBox = New Rectangle(0, 0, GlyphWidth, GlyphHeight)})
        Next

        Bitmap = New Int32(Width - 1, Height - 1) {}
        For y = 0 To Height - 1
            For x = 0 To Width - 1
                Dim c As Int32 = s.ReadUInt16
                Dim A = c.Bits(15, 12)
                Dim R = c.Bits(11, 8)
                Dim G = c.Bits(7, 4)
                Dim B = c.Bits(3, 0)
                A = ConcatBits(A, 4, A, 4)
                R = ConcatBits(A, 4, A, 4)
                G = ConcatBits(A, 4, A, 4)
                B = ConcatBits(A, 4, A, 4)
                Bitmap(x, y) = ConcatBits(A, 8, R, 8, G, 8, B, 8)
            Next
        Next

        Me.Glyphs = Glyphs.ToArray
    End Sub

    Public Sub Write(ByVal sp As ZeroLengthStreamPasser)
        Dim s = sp.GetStream

        s.WriteInt32(1)
        Dim Width = Bitmap.GetLength(0)
        Dim Height = Bitmap.GetLength(1)
        s.WriteInt32(Width)
        s.WriteInt32(Height)

        s.WriteInt32(Size1)
        s.WriteInt32(Size2)
        s.WriteInt32(Size3)
        s.WriteInt32(Size4)

        Dim NumChar = Glyphs.Length
        Dim NumGlyph = Glyphs.Length

        s.WriteInt32(NumChar)
        For n = 0 To NumChar - 1
            Dim UniStr = Glyphs(n).c.Unicode
            Dim c = Char32.FromString(UniStr)
            s.WriteUInt16(c.Value)
        Next

        s.WriteInt32(NumGlyph)
        For n = 0 To NumChar - 1
            Dim p = Glyphs(n).PhysicalBox
            Dim v = Glyphs(n).VirtualBox

            Dim Left = p.Left + v.Left
            Dim Top = p.Top + v.Top
            Dim Right = p.Left + v.Right
            Dim Bottom = p.Top + v.Bottom

            s.WriteUInt16(Left)
            s.WriteUInt16(Top)
            s.WriteUInt16(Right)
            s.WriteUInt16(Bottom)
        Next

        For y = 0 To Height - 1
            For x = 0 To Width - 1
                Dim ARGB = Bitmap(x, y)
                Dim A = ARGB.Bits(31, 24)
                Dim R = ARGB.Bits(23, 16)
                Dim G = ARGB.Bits(15, 8)
                Dim B = ARGB.Bits(7, 0)
                Dim c As UInt16 = ConcatBits(A.Bits(7, 4), 4, R.Bits(7, 4), 4, G.Bits(7, 4), 4, B.Bits(7, 4), 4)
                s.WriteUInt16(c)
            Next
        Next

        s.SetLength(s.Position)
    End Sub
End Class
