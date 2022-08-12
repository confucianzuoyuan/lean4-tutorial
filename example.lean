import Lean.Data.Parsec

open Lean Parsec

inductive LispVal where
  | atom (v : String)
  | number (v : Int)
  | str (v : String)
  | bool (v : Bool)
  | list (v : List LispVal)
  | dottedlist (v : (List LispVal) × LispVal)
  deriving Repr

def symbol : Parsec Char :=
  satisfy fun c => "!#$%&|*+-/:<=>?@^_~".contains c

def letter : Parsec Char :=
  satisfy fun c => "abcdefghijklmnopqrstuvwxyz".contains c

def parseString : Parsec LispVal := do
  skipChar '\"'
  let x ← manyChars anyChar
  skipChar '\"'
  return (LispVal.str x)

def parseAtom : Parsec LispVal := do
  let first ← letter <|> symbol
  let rest ← manyChars (letter <|> digit <|> symbol)
  let atom ← ([first] ++ rest.data).asString
  match atom with
  | "#t" => LispVal.bool true
  | "#f" => LispVal.bool false
  | _   => LispVal.atom atom

def parseNumber : Parsec LispVal := do
  let num ← many1Chars digit
  return (LispVal.number num.toInt!)

mutual

  partial def parseList : Parsec LispVal := do
    let hd ← parseExpr
    let tl ← many (pchar ' ' *> parseExpr)
    let result ← [hd] ++ tl.toList
    return (LispVal.list result)

  partial def parseDottedList : Parsec LispVal := do
    let hd ← parseExpr
    skipChar ' '
    skipChar '.'
    skipChar ' '
    let tl ← parseExpr
    return (LispVal.dottedlist ([hd], tl))

  partial def parseQuoted : Parsec LispVal := do
    skipChar '\''
    let x ← parseExpr
    return (LispVal.list [LispVal.atom "quote", x])

  partial def parseExpr : Parsec LispVal :=
    parseAtom
    <|> parseString
    <|> parseNumber
    <|> parseQuoted
    <|> do skipChar '('
           let x ← attempt parseList <|> parseDottedList
           skipChar ')'
           return x

end

def evalExpr (e : LispVal) : LispVal :=
  match e with
  | v => v

#eval parseExpr "'((aaa ccc) . bbb)".mkIterator

#eval evalExpr (LispVal.atom "a")