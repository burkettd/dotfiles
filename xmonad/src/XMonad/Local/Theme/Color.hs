module XMonad.Local.Theme.Color (
  HexDigit (..),
  Color (..),
  toString,
  toHashString,
  to0xString,
) where

data HexDigit
  = HexDigit0
  | HexDigit1
  | HexDigit2
  | HexDigit3
  | HexDigit4
  | HexDigit5
  | HexDigit6
  | HexDigit7
  | HexDigit8
  | HexDigit9
  | HexDigitA
  | HexDigitB
  | HexDigitC
  | HexDigitD
  | HexDigitE
  | HexDigitF
  deriving (Show, Eq, Ord, Enum, Bounded)

digitToChar :: HexDigit -> Char
digitToChar = \case
  HexDigit0 -> '0'
  HexDigit1 -> '1'
  HexDigit2 -> '2'
  HexDigit3 -> '3'
  HexDigit4 -> '4'
  HexDigit5 -> '5'
  HexDigit6 -> '6'
  HexDigit7 -> '7'
  HexDigit8 -> '8'
  HexDigit9 -> '9'
  HexDigitA -> 'A'
  HexDigitB -> 'B'
  HexDigitC -> 'C'
  HexDigitD -> 'D'
  HexDigitE -> 'E'
  HexDigitF -> 'F'

data Color = Color
  { colorRed :: (HexDigit, HexDigit)
  , colorGreen :: (HexDigit, HexDigit)
  , colorBlue :: (HexDigit, HexDigit)
  }
  deriving (Show, Eq, Ord)

toString :: Color -> String
toString color =
  let (r1, r2) = colorRed color
      (g1, g2) = colorGreen color
      (b1, b2) = colorBlue color
   in fmap digitToChar [r1, r2, g1, g2, b1, b2]

toHashString :: Color -> String
toHashString color =
  "#" <> toString color

to0xString :: Color -> String
to0xString color =
  "0x" <> toString color
