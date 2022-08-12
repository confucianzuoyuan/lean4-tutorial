# Lean函数式编程

## 介绍

Lean是微软研究院开发的基于依赖类型理论的交互式定理证明器。依赖类型理论结合了程序和证明的世界；因此，Lean也是一种编程语言。Lean认真对待它的双重性质，它被设计成适合用作通用编程语言——Lean甚至是自举的。这本书是关于用Lean编写程序的。

当Lean被视为一种编程语言时，Lean是一种具有依赖类型的严格的纯函数式编程语言。学习Lean编程的很大一部分包括学习这些属性如何影响程序的编写方式，以及如何像函数式程序员一样思考。严格意味着Lean中的函数调用与大多数b编程语言中的工作方式相似：参数在函数体开始运行之前已经求值完毕。“纯”意味着Lean程序不会产生副作用，例如在没有程序类型说明的情况下修改内存中的位置、发送电子邮件或删除文件。Lean是一种功能从某种意义上说，函数与任何其他语言一样是一等值，并且执行模型受到数学表达式求值的启发。依赖类型是Lean最不寻常的特性，它使类型成为编程语言的一等公民，允许类型包含程序和程序来计算类型。

本书适用于想要学习Lean但以前不一定使用过函数式编程语言的程序员。不需要熟悉Haskell、OCaml或F#等函数式语言。另一方面，这本书确实假设了读者熟悉大多数编程语言常见的循环、函数和数据结构等概念的知识。虽然本书旨在成为一本很好的学习函数式编程的第一本书，但一般来说它并不是一本很好的编程第一本书。

使用Lean作为证明助手的数学家可能需要在某些时候编写自定义证明自动化工具。这本书也是为他们准备的。随着这些工具变得越来越复杂，它们开始类似于函数式语言的程序，但大多数工作的数学家都接受过Python和Mathematica等语言的培训。这本书可以帮助弥合差距，使更多的数学家能够编写可维护和可理解的证明自动化工具。

本书旨在从头到尾以线性方式阅读。一次介绍一个概念，后面的部分假定读者熟悉前面的部分。有时，后面的章节会深入讨论一个之前只是简要讨论过的主题。本书的某些部分包含练习。这些都是值得做的，以巩固读者对该部分的理解。在阅读本书时探索Lean也很有用，可以找到创造性的新方法来使用所学知识。

### 获取Lean

在编写和运行用Lean编写的程序之前，读者需要在自己的计算机上设置Lean。Lean工具包括以下内容：

- `elan`管理Lean编译器工具链，类似于`rustup`或者`ghcup`。
- `lake`构建Lean包及其依赖项，类似于cargo、make或Gradle。
- `lean`类型检查和编译单个Lean文件，并向程序员工具提供有关当前正在编写的文件的信息。通常，`lean`由其他工具调用，而不是由用户直接调用。
- 用于编辑器的插件，例如Visual Studio Code或Emacs，可`lean`方便地与其信息进行通信和呈现。

有关安装Lean的最新说明，请参阅Lean手册。

## 排版约定

作为输入提供给Lean的代码示例格式如下：

```lean
def add1 (n : Nat) : Nat := n + 1

#eval add1 7
```

上面的最后一行（以 开头#eval）是指示 Lean 计算答案的命令。Lean 的回复格式如下：

```
8
```

Lean 返回的错误消息格式如下：

```
application type mismatch
  add1 "seven"
argument
  "seven"
has type
  String : Type
but is expected to have type
  Nat : Type
```

### Unicode

惯用Lean代码使用不属于ASCII的各种Unicode字符。例如，希腊字母`α`和`β`和箭头`→`都出现在本书的第一章。这使得Lean代码更接近于普通的数学符号。

使用默认的Lean设置，Visual Studio Code和Emacs都允许使用反斜杠(`\`)后跟名称来键入这些字符。例如，要输入`α`，请键入`\alpha`。要了解如何在Visual Studio Code中键入字符，请将鼠标指向它并查看工具提示。在Emacs中，`C-c C-k`在有问题的字符上使用with point。

## 了解Lean

按照传统，应该通过编译和运行显示"Hello, world!"在控制台上的程序来引入编程语言。这个简单的程序可确保正确安装语言工具并且程序员能够运行编译后的代码。

然而，自1970年代以来，编程发生了变化。今天，编译器通常集成到文本编辑器中，编程环境在程序编写时提供反馈。Lean也不例外：它实现了语言服务器协议的扩展版本，允许它与文本编辑器通信并在用户键入时提供反馈。

Python、Haskell和JavaScript等多种语言都提供了读取-求值-打印-循环 (REPL)，也称为交互式顶层或浏览器控制台，可以在其中输入表达式或语句。然后该语言计算并显示用户输入的结果。另一方面，Lean将这些功能集成到与编辑器的交互中，提供使文本编辑器显示集成到程序文本本身中的反馈的命令。本章简要介绍在编辑器中与Lean交互，而Hello, World!描述了如何在批处理模式下传统地从命令行使用Lean。

最好是在编辑器中打开Lean来阅读本书，然后输入每个示例。请使用示例，看看会发生什么！

### 对表达式进行求值

作为一名学习Lean的程序员，最重要的是要了解求值是如何工作的。求值是寻找表达式值的过程，就像在算术中所做的那样。例如，`15 - 6`的值为`9`，`2 × (3 + 1)`的值为`8`。要找到后一个表达式的值，首先将`3 + 1`替换为`4`，得到`2 × 4`，它本身可以归约到`8`。有时，数学表达式包含变量：在我们知道`x`的值是什么之前，无法计算`x + 1`的值。在Lean中，程序首先是表达式，考虑计算的主要方式是对表达式求值以找到它们的值。

大多数编程语言都是命令式的，其中一个程序由一系列语句组成，这些语句应该执行以找到程序的结果。程序可以访问可变内存，因此变量引用的值会随着时间而改变。除了可变状态之外，程序可能还有其他副作用，例如删除文件、建立传出网络连接、抛出或捕获异常以及从数据库中读取数据。“副作用”本质上是一个包罗万象的术语，用于描述程序中可能发生的事情，这些事情不遵循求值数学表达式的模型。

然而，在Lean中，程序的工作方式与数学表达式相同。一旦给定一个值，就不能重新分配变量。对表达式求值不会有副作用。如果两个表达式具有相同的值，那么用另一个替换一个不会导致程序计算出不同的结果。这并不意味着Lean不能用于写入`Hello, world!`控制台，但执行I/O并不是以同样方式使用Lean的体验的核心部分。因此，本章重点介绍如何使用Lean交互地对表达式求值，而下一章将介绍如何编写、编译和运行`Hello, world!`程序。

要让Lean求值一个表达式，`#eval`请在您的编辑器中在它之前写，然后它会报告结果。通常，将光标或鼠标指针放在 上即可找到结果`#eval`。例如，

```lean
#eval 1 + 2
```

产生值3。

Lean遵循算术运算符的普通优先级和结合性规则。那是，

```lean
#eval 1 + 2 * 5
```

产生值`11`而不是`15`。

虽然普通的数学符号和大多数编程语言都使用括号（例如`f(x)`）将函数应用于其参数，但Lean只是将函数写在其参数旁边（例如`f x`）。函数应用是最常见的操作之一，因此保持简洁是值得的。而不是写

```lean
#eval String.append("Hello, ", "Lean!")
```

为了计算`"Hello, Lean!"`，人们会改为写

```lean
#eval String.append "Hello, " "Lean!"
```

其中函数的两个参数只是用空格写在它旁边。

正如算术运算的顺序规则要求表达式中的`(1 + 2) * 5`括号一样，当要通过另一个函数调用计算函数的参数时，括号也是必需的。例如，括号是必需的

```lean
#eval String.append "great " (String.append "oak " "tree")
```

因为否则第二个`String.append`将被解释为第一个的参数，而不是作为传递的函数`"oak "`和`"tree"`参数。`String.append`必须首先找到内部调用的值，然后才能将其附加到`"great "`，产生最终值`"great oak tree"`。

命令式语言通常有两种条件：条件语句根据布尔值确定执行哪些指令，条件表达式根据布尔值确定要对两个表达式中的哪一个进行求值。例如，在C和C++中，条件语句使用`if`和`else`编写，而条件表达式使用三元运算符`?`和`:`编写。在Python中，条件语句以`if`开头，而条件表达式放在`if`中间。因为Lean是一种面向表达式的函数式语言，所以没有条件语句，只有条件表达式。它们是使用`if`、`then`和`else`编写。例如，

```lean
String.append "it is " (if 1 > 2 then "yes" else "no")
```

求值为

```lean
String.append "it is " (if false then "yes" else "no")
```

求值为

```lean
String.append "it is " "no"
```

最终求值为`"it is no"`。

为了简洁起见，像这样的一系列求值步骤有时会在它们之间用箭头表示：

```lean
String.append "it is " (if 1 > 2 then "yes" else "no")
===>
String.append "it is " (if false then "yes" else "no")
===>
String.append "it is " "no"
===>
"it is no"
```

#### 可能会遇到的消息

要求Lean求值缺少参数的函数应用程序将导致错误消息。特别是，示例

```lean
#eval String.append "it is "
```

产生一条很长的错误消息：

```
expression
  String.append "it is "
has type
  String → String
but instance
  Lean.MetaEval (String → String)
failed to be synthesized, this instance instructs Lean on how to display the resulting value, recall that any type implementing the `Repr` class also implements the `Lean.MetaEval` class
```

出现此消息是因为仅应用于其部分参数的Lean函数返回正在等待其余参数的新函数。Lean无法向用户显示功能，因此在被要求这样做时会返回错误。

#### 练习

以下表达式的值是什么？手动计算它们，然后将它们输入Lean以检查您的工作。

- `42 + 19`
- `String.append "A" (String.append "B" "C")`
- `String.append (String.append "A" "B") "C"`
- `if 3 == 3 then 5 else 7`
- `if 3 == 4 then "equal" else "not equal"`

### 类型

类型根据它们可以计算的值对程序进行分类。类型在程序中扮演多种角色：

1. 它们允许编译器决定值的内存表示。
2. 它们帮助程序员将他们的意图传达给其他人，作为编译器可以确保程序遵守的函数的输入和输出的轻量级规范。
3. 它们可以防止各种潜在的错误，例如在字符串中添加数字，从而减少程序所需的测试次数。
4. 它们帮助Lean编译器自动生成可以节省样板的辅助代码。

Lean的类型系统异常富有表现力。类型可以编码诸如“此排序函数返回其输入的排列”之类的强规范和诸如“此函数具有不同的返回类型，具体取决于其参数的值”之类的灵活规范。类型系统甚至可以用作证明数学定理的成熟逻辑。然而，这种尖端的表达能力并不能排除对更简单类型的需求，理解这些更简单的类型是使用更高级功能的先决条件。

Lean中的每个程序都必须有一个类型。特别是，每个表达式都必须具有类型才能对其求值。在到目前为止的示例中，Lean已经能够自己发现一种类型，但有时需要提供一个类型。这是使用冒号运算符完成的：

```lean
#eval (1 + 2 : Nat)
```

这里，`Nat`是自然数的类型，它是任意精度的无符号整数。在Lean中，`Nat`是非负整数字面量的默认类型。此默认类型并不总是最佳选择。在C中，无符号整数下溢到最大的可表示数字，否则减法会产生小于零的结果。但是`Nat`，可以表示任意大的无符号数，因此没有最大的数可以下溢。因此，如果答案是否定的，则`Nat`返回减法。0例如，

```lean
#eval 1 - 2
```

求值为`0`而不是`-1`。要使用可以表示负整数的类型，请直接提供它：

```lean
#eval (1 - 2 : Int)
```

使用这种类型，结果`-1`如预期的那样。

要检查表达式的类型而不对其进行求值，请使用`#check`而不是`#eval`。例如：

```lean
#check (1 - 2 : Int)
```

报告`1 - 2 : Int`而不实际执行减法。

当不能给程序指定类型时， 和 都会返回`#check`错误`#eval`。例如：

```lean
#check String.append "hello" [" ", "world"]
```

输出

```
application type mismatch
  String.append "hello" [" ", "world"]
argument
  [" ", "world"]
has type
  List String : Type
but is expected to have type
  String : Type
```

因为`to`的第二个参数应该`String.append`是一个字符串，但是提供了一个字符串列表。

### 函数和定义

在Lean中，定义是使用`def`关键字引入的。例如，要定义`hello`引用字符串的名称，请`"Hello"`编写：

```lean
def hello := "Hello"
```

在Lean中，新名称是使用冒号等号运算符`:=`而不是`=`。这是因为`=`用于描述现有表达式之间的相等性，并且使用两个不同的运算符有助于防止混淆。

在`hello`的定义中，表达式`"Hello"`很简单，以至于Lean能够自动确定定义的类型。然而，大多数定义并不是那么简单，所以通常需要添加一个类型。这是在定义名称后使用冒号完成的。

```lean
def lean : String := "Lean"
```

既然已经定义了名称，就可以使用它们了，所以

```lean
#eval String.append hello (String.append " " lean)
```

输出

```
"Hello Lean"
```

在Lean中，定义的名称只能在定义之后使用。

在许多语言中，函数的定义使用与其他值定义不同的语法。例如，Python函数定义以`def`关键字开头，而其他定义以等号定义。在Lean中，函数是使用与`def`其他值相同的关键字来定义的。尽管如此，诸如引入直接`hello`引用其值的名称之类的定义，而不是每次调用时返回等效结果的零参数函数。

#### 定义函数

有多种方法可以在Lean中定义函数。最简单的方法是将函数的参数放在定义的类型之前，用空格分隔。例如，可以编写一个向其参数添加`1`的函数：

```lean
def add1 (n : Nat) : Nat := n + 1
```

正如预期的那样，使用`#eval`测试此函数`：8`

```lean
#eval add1 7
```

正如函数仅通过在每个参数之间写入空格来应用于多个参数一样，接受多个参数的函数在参数名称和类型之间使用空格来定义。该`maximum`函数的结果等于它的两个参数中的最大值，它接受两个`Nat`参数`n`并`k`返回一个`Nat`。

```lean
def maximum (n : Nat) (k : Nat) : Nat :=
  if n < k then
    k
  else n
```

当一个已定义的函数如`maximum`已经提供了它的参数时，结果是通过首先将参数名称替换为主体中提供的值，然后求值结果主体来确定的。例如：

```
maximum (5 + 8) (2 * 7)
===>
maximum 13 14
===>
if 13 < 14 then 14 else 13
===>
14
```

计算结果为自然数、整数和字符串的表达式具有这样的类型（`Nat`分别为`Int`、和`String`）。函数也是如此。接受 aNat并返回`a`的函数`Bool`具有类型`Nat → Bool`，而接受两个`Nat`并返回`a`的函数`Nat`具有类型`Nat → Nat → Nat`。输入`#check add1`产量`add1 : Nat → Nat`和`#check maximum`产量`maximum : Nat → Nat → Nat`。这个箭头也可以写成ASCII替代箭头`->`，所以前面的函数类型可以分别写成`Nat -> Bool`和`Nat -> Nat -> Nat`。

在幕后，所有函数实际上都只需要一个参数。像这样的函数`maximum`似乎接受多个参数，实际上是接受一个参数然后返回一个新函数的函数。这个新函数接受下一个参数，并且该过程继续进行，直到不需要更多参数为止。这可以通过为多参数函数提供一个参数来看出：`#check maximum 3`产生`maximum 3 : Nat → Nat`和`#check String.append "Hello "`产生`String.append "Hello " : String → String`。使用返回函数的函数来实现多参数函数，在数学家Haskell Curry之后被称为柯里化。函数箭头关联到右侧，这意味着`Nat → Nat → Nat`应该用括号括起来`Nat → (Nat → Nat)`。

##### 练习

- 通过将其第一个参数放在其第二个和第三个参数之间来定义具有创建新字符串的`joinStringsWith`类型的函数。应求值为：`String -> String -> String -> String joinStringsWith ", " "one" "and another""one, and another"`
- 是什么类型的`joinStringsWith ": "`？用Lean检查你的答案。
- 定义一个函数`volume`，其类型`Nat → Nat → Nat → Nat`计算具有给定高度、宽度和深度的矩形棱柱的体积。

#### 定义类型

大多数类型化编程语言都有一些定义类型别名的方法，例如C语言`typedef`。然而，在Lean中，类型是语言的一等公民——它们和其他任何表达式一样。这意味着定义可以像引用其他值一样引用类型。

例如，如果`String`输入太多，`Str`可以定义一个更短的缩写：

```lean
def Str : Type := String
```

然后可以将其`Str`用作定义的类型，而不是`String`：

```lean
def aStr : Str := "This is a string."
```

这样做的原因是类型遵循与Lean的其余部分相同的规则。类型是表达式，在表达式中，定义的名称可以替换为其定义。因为`Str`已经定义了mean String，所以定义`aStr`才有意义。

##### 可能会遇到的消息

由于尚未引入Lean的一个特性，尝试使用类型定义变得更加复杂。如果`Nat`太短，`NaturalNumber`可以定义更长的名称：

```lean
def NaturalNumber : Type := Nat
```

但是，使用NaturalNumber作为定义的类型而不是Nat没有预期的效果。特别是定义：

```lean
def thirtyEight : NaturalNumber := 38
```

导致以下错误：

```
failed to synthesize instance
  OfNat NaturalNumber 38
```

发生此错误是因为Lean允许重载数字文字。当这样做有意义时，自然数文字可用于新类型，就像这些类型内置于系统中一样。这是 Lean 使命的一部分，即让数学表示变得方便，不同的数学分支使用数字符号来实现非常不同的目的。允许此重载的特定功能不会在查找重载之前将所有定义的名称替换为其定义，这就是导致上述错误消息的原因。

解决此限制的一种方法是Nat在定义的右侧提供类型，从而Nat将 的重载规则用于38：

```lean
def thirtyEight : NaturalNumber := (38 : Nat)
```

该定义仍然是类型正确的，因为NaturalNumber它的类型与Nat— 根据定义！

另一种解决方案是定义一个与 forNaturalNumber等效的重载Nat。然而，这需要Lean的更高级功能。

最后，为Natusingabbrev而不是定义新名称def允许重载解析将定义的名称替换为其定义。使用编写的定义abbrev总是展开。例如，

```lean
abbrev N : Type := Nat
```

和

```lean
def thirtyNine : N := 39
```

被毫无问题地接受。

在幕后，一些定义在内部标记为在重载解决期间可展开，而其他定义则不是。要展开的定义称为可还原的。对可还原性的控制对于让Lean扩展至关重要：完全展开所有定义可能会导致机器处理速度缓慢且用户难以理解的非常大的类型。产生的定义abbrev被标记为可还原的。

### 结构

编写程序的第一步通常是识别问题域的概念，然后在代码中为它们找到合适的表示。有时，域概念是其他更简单概念的集合。在这种情况下，将这些更简单的组件组合成一个“包”会很方便，然后可以给它一个有意义的名称。在Lean中，这是使用结构来完成的，类似于structC 或 Rustrecord中的 s 和 C# 中的 s。

定义一个结构为Lean引入了一种全新的类型，它不能被简化为任何其他类型。这很有用，因为多个结构可能代表不同的概念，但它们包含相同的数据。例如，一个点可以使用笛卡尔坐标或极坐标来表示，每个坐标都是一对浮点数。定义单独的结构可以防止 API 客户端将一个与另一个混淆。

Lean的浮点数类型称为`Float`，浮点数用通常的符号表示。

```lean
#check 1.2
```

```
1.2 : Float
```

```lean
#check -454.2123215
```

```
-454.2123215 : Float
```

```lean
#check 0.0
```

```
0.0 : Float
```

当浮点数用小数点写入时，Lean将推断类型`Float`。如果它们是在没有它的情况下编写的，则可能需要类型注释。

```lean
#check 0
```

```
0 : Nat
```

```lean
#check (0 : Float)
```

```
0 : Float
```

笛卡尔点是具有两个`Float`字段的结构，称为`x`和`y`。这是使用`structure`关键字声明的。

```lean
structure Point where
  x : Float
  y : Float
deriving Repr
```

在这个声明之后，`Point`是一个新的结构类型。最后一行`deriving Repr`要求Lean生成代码以显示`type`的值`Point`。此代码用于`#eval`呈现求值结果以供程序员使用，类似于Python和Rust中的`repr`函数。也可以覆盖编译器生成的显示代码。

创建结构类型实例的典型方法是在花括号内为其所有字段提供值。笛卡尔平面的原点是两者`x`都`y`为零：

```lean
def origin : Point := { x := 0.0, y := 0.0 }
```

如果 ' 的定义中的deriving Repr行Point被省略，那么尝试`#eval origin`将产生类似于省略函数参数时发生的错误：

```
expression
  origin
has type
  Point
but instance
  Lean.MetaEval Point
failed to be synthesized, this instance instructs Lean on how to display the resulting value, recall that any type implementing the `Repr` class also implements the `Lean.MetaEval` class
```

该消息表示求值机制不知道如何将求值结果传达给用户。

令人高兴的是，与`deriving Repr`的结果`#eval origin`看起来非常像 的定义`origin`。

```lean
{ x := 0.000000, y := 0.000000 }
```

因为结构的存在是为了“捆绑”数据集合、对其命名并将其视为一个单元，所以能够提取结构的各个字段也很重要。这是使用点表示法完成的，如在 C、Python 或 Rust 中。

```lean
#eval origin.x
```

```
0.000000
```

```lean
#eval origin.y
```

```
0.000000
```

这可用于定义将结构作为参数的函数。例如，通过添加基础坐标值来执行点的添加。应该是`#eval addPoints { x := 1.5, y := 32 } { x := -8, y := 0.2 }`这样

```lean
{ x := -6.500000, y := 32.200000 }
```

该函数本身接受两个`Point`作为参数，称为`p1`和`p2`。结果点基于和的`x`和`y`字段：`p1` `p2`

```lean
def addPoints (p1 : Point) (p2 : Point) : Point :=
  { x := p1.x + p2.x, y := p1.y + p2.y }
```

类似地，两点之间的距离，即它们`x`和`y`分量差的平方和的平方根，可以写成：

```lean
def distance (p1 : Point) (p2 : Point) : Float :=
  Float.sqrt (((p2.x - p1.x) ^ 2.0) + ((p2.y - p1.y) ^ 2.0))
```

例如，`(1, 2)`和`(5, -1)`之间的距离为`5`：

```lean
#eval distance { x := 1.0, y := 2.0 } { x := 5.0, y := -1.0 }
```

```
5.000000
```

多个结构可能具有具有相同名称的字段。例如，一个三维点数据类型可以共享字段`x`和`y`，并使用相同的字段名称进行实例化：

```lean
structure Point3D where
  x : Float
  y : Float
  z : Float
deriving Repr
```

```lean
def origin3D : Point3D := { x := 0.0, y := 0.0, z := 0.0 }
```

这意味着必须知道结构的预期类型才能使用花括号语法。如果类型未知，Lean将无法实例化该结构。例如，

```lean
#check { x := 0.0, y := 0.0 }
```

导致错误

```
invalid {...} notation, expected type is not known
```

像往常一样，可以通过提供类型注释来纠正这种情况。

```lean
#check ({ x := 0.0, y := 0.0 } : Point)
```

```
{ x := 0.0, y := 0.0 } : Point
```

为了使程序更简洁，Lean还允许在花括号内使用结构类型注释。

```lean
#check { x := 0.0, y := 0.0 : Point}
```

```
{ x := 0.0, y := 0.0 } : Point
```

#### 更新结构

想象一个将 a 的字段zeroX替换为的函数。在大多数编程语言社区中，这句话意味着所指向的内存位置将被一个新值覆盖。但是，Lean没有可变状态。在函数式编程社区中，这种语句几乎总是意味着分配一个新的，其中字段指向新值，而所有其他字段都指向输入中的原始值。一种写法是按照字面的描述，填写新值并手动转移：xPoint0.0xPointxzeroXxy

```lean
def zeroX (p : Point) : Point :=
  { x := 0, y := p.y }
```

然而，这种编程风格也有缺点。首先，如果一个新字段被添加到一个结构中，那么每个更新任何字段的站点都必须更新，从而导致维护困难。其次，如果结构包含多个具有相同类型的字段，则存在复制粘贴编码导致字段内容被复制或切换的真正风险。最后，程序变得冗长且官僚化。

Lean提供了一种方便的语法来替换结构中的某些字段，同时不理会其他字段。这是通过`with`在结构初始化中使用关键字来完成的。未更改字段的源出现在`with`之前，新字段出现在之后。例如，`zeroX`可以只用新`x`值编写：

```lean
def zeroX (p : Point) : Point :=
  { p with x := 0 }
```

请记住，这种结构更新语法不会修改现有值——它会创建与旧值共享某些字段的新值。例如，给定点`fourAndThree`：

```lean
def fourAndThree : Point :=
  { x := 4.3, y := 3.4 }
```

求值它，然后使用 求值它的更新zeroX，然后再次求值它产生原始值：

```lean
#eval fourAndThree
```

```
{ x := 4.300000, y := 3.400000 }
```

```lean
#eval zeroX fourAndThree
```

```
{ x := 0.000000, y := 3.400000 }
```

```lean
#eval fourAndThree
```

```
{ x := 4.300000, y := 3.400000 }
```

结构更新不修改原始结构这一事实的一个结果是，更容易推断从旧值计算新值的情况。所有对旧结构的引用继续在提供的所有新值中引用相同的字段值。

#### 幕后花絮

每个结构都有一个构造函数。在这里，术语“构造函数”可能会引起混淆。与Java或Python等语言中的构造函数不同，Lean中的构造函数不是在初始化数据类型时运行的任意代码。相反，构造函数只是收集要存储在新分配的数据结构中的数据。无法提供预处理数据或拒绝无效参数的自定义构造函数。这实际上是“构造函数”一词在两种上下文中具有不同但相关的含义的情况。

默认情况下，名为的结构的构造函数S是 named S.mk。这里，S是一个命名空间限定符，并且mk是构造函数本身的名称。也可以直接应用构造函数，而不是使用花括号初始化语法。

```lean
#check Point.mk 1.5 2.8
```

然而，这通常不被认为是好的Lean风格，Lean甚至使用标准结构初始化语法返回其反馈。

```
{ x := 1.5, y := 2.8 } : Point
```

构造函数具有函数类型，这意味着它们可以在需要函数的任何地方使用。例如，Point.mk是一个接受两个Floats（分别为x和y）并返回一个 new的函数Point。

```lean
#check Point.mk
```

```
Point.mk : Float → Float → Point
```

要覆盖结构的构造函数名称，请在开头使用两个冒号。例如，要使用Point.point代替Point.mk，请编写：

```lean
structure Point where
  point ::
  x : Float
  y : Float
deriving Repr
```

除了构造函数之外，还为结构的每个字段定义了一个访问函数。它们与结构命名空间中的字段具有相同的名称。对于Point, 访问器函数Point.x和Point.y被生成。

```lean
#check Point.x
```

```
Point.x : Point → Float
```

```lean
#check Point.y
```

```
Point.y : Point → Float
```

事实上，就像花括号结构构造语法在幕后转换为对结构构造函数的调用一样，p1.x前面定义中的语法addPoints也转换为对Point.x访问器的调用。也就是说，#eval origin.x两者#eval Point.x origin都产生


0.000000

访问点符号可用于Lean能够确定第一个参数的类型的任何函数。如果EXPR1有类型T，则EXPR1.f EXPR2转换为T.f EXPR1 EXPR2。例如，String.append可以从带有访问器符号的字符串调用，即使String它不是带有append字段的结构。

```lean
#eval "one string".append " and another"
```

```
"one string and another"
```

#### 练习

- 定义一个名为的结构RectangularPrism，其中包含一个矩形棱柱的高度、宽度和深度，每个都为Float.
- 定义一个名为volume : RectangularPrism → Float计算矩形棱柱体积的函数。
- 定义一个以Segment端点表示线段的结构，并定义一个length : Segment → Float计算线段长度的函数。Segment最多应该有两个字段。
- 的声明引入了哪些名称RectangularPrism？
- Hamster以下和的声明引入了哪些名称Book？他们的类型是什么？

```lean
structure Hamster where
  name : String
  fluffy : Bool
```

```lean
structure Book where
  makeBook ::
  title : String
  author : String
  price : Float
```

### 数据类型和模式

结构可以将多个独立的数据组合成一个连贯的整体，以全新的类型表示。将一组值组合在一起的结构等类型称为*积类型*。然而，许多领域概念不能自然地表示为结构。例如，应用程序可能需要跟踪用户权限，其中一些用户是文档所有者，一些用户可能编辑文档，而其他用户可能只阅读它们。计算器有许多二元运算符，例如加法、减法和乘法。结构不提供编码多个选择的简单方法。

同样，虽然结构是跟踪一组固定字段的绝佳方式，但许多应用程序需要可能包含任意数量元素的数据。大多数经典的数据结构，例如树和列表，都具有递归结构，其中列表的尾部本身就是一个列表，或者二叉树的左右分支本身就是二叉树。在上述计算器中，表达式本身的结构是递归的。例如，加法表达式中的和数本身可能是乘法表达式。

允许选择的数据类型称为*和类型*，可以包含自身实例的数据类型称为递归数据类型。递归和类型称为归纳数据类型，因为可以使用数学归纳来证明关于它们的陈述。大多数用户定义的类型都是归纳数据类型。编程时，通过模式匹配和递归函数使用归纳数据类型。

许多内置类型实际上是标准库中的归纳数据类型。例如，`Bool`是一个归纳数据类型：

```lean
inductive Bool where
  | false : Bool
  | true : Bool
```

这个定义有两个主要部分。第一行提供了新类型的名称 (`Bool`)，而其余的每行都描述了一个构造函数。与结构的构造函数一样，归纳数据类型的构造函数只是其他数据的惰性接收器和容器，而不是插入任意初始化和验证代码的地方。与结构不同，归纳数据类型可能有多个构造函数。在这里，有两个构造函数，`true`和`false`，并且都不接受任何参数。正如结构声明将其名称放置在以声明的类型命名的命名空间中一样，归纳数据类型将其构造函数的名称放置在命名空间中。在Lean标准库中，`true`以及`false`从此命名空间中重新导出，以便它们可以单独编写，而不是分别编写为`Bool.true`和`Bool.false`。

从数据建模的角度来看，归纳数据类型用于许多相同的上下文中，而密封抽象类可能用于其他语言。在C#或Java等语言中，人们可能会编写类似的定义定义`Bool`：

```java
abstract class Bool {}
class True : Bool {}
class False : Bool {}
```

然而，这些表示的细节是完全不同的。特别是，每个非抽象类都创建了一种新类型和新的数据分配方式。在面向对象的示例中，`True`和`False`都是比`Bool`更具体的类型，而Lean定义只引入了新类型`Bool`。

`Nat`非负整数的类型是归纳数据类型：

```lean
inductive Nat where
  | zero : Nat
  | succ (n : Nat) : Nat
```

这里，`zero`代表`0`，而`succ`代表其他数字的后继。的声明`Nat`中提到的正是正在定义的类型。Successor的意思是“大于”，所以`5`的后继是`6`，`32,185`的后继是`32,186`。使用此定义，表示为。这个定义几乎就像名称略有不同的定义。唯一真正的区别是后面是，它指定构造函数接受一个类型的参数，该参数恰好被命名为。名字和succNat4Nat.succ (Nat.succ (Nat.succ (Nat.succ Nat.zero)))Boolsucc(n : Nat)succNatnzerosucc位于以其类型命名的命名空间中，因此它们必须分别称为`Nat.zero`和`Nat.succ`。

参数名称，例如`n`，可能出现在Lean的错误消息和编写数学证明时提供的反馈中。Lean还有一种可选的语法，用于按名称提供参数。然而，一般来说，参数名称的选择不如结构字段名称的选择重要，因为它在API中所占的比例不大。

在C#或Java中，`Nat`可以定义如下：

```java
abstract class Nat {}
class Zero : Nat {}
class Succ : Nat {
  public Nat n;
  public Succ(Nat pred) {
    n = pred;
  }
}
```

就像`Bool`上面的例子一样，这定义了比Lean等价物更多的类型。此外，这个例子强调了Lean数据类型构造函数更像抽象类的子类，而不是像C#或Java中的构造函数，因为这里显示的构造函数包含要执行的初始化代码。

#### 模式匹配

在许多语言中，首先使用`instance-of`运算符来检查已接收到哪个子类，然后读取给定子类中可用字段的值来使用这些类型的数据。`instance-of`检查确定运行哪个代码，确保此代码所需的数据可用，而字段本身提供数据。在Lean中，模式匹配同时满足了这两个目的。

使用模式匹配的函数示例是`isZero`，它是一个函数，当其参数为`true`时返回`Nat.zero`，否则返回`false`。

```lean
def isZero (n : Nat) : Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ k => false
```

该`match`表达式提供了函数的`n`解构参数。如果是由`n`构造的`Nat.zero`，则采用模式匹配的第一个分支，结果为`true`。如果是由`n`构造的`Nat.succ`，则采用第二个分支，结果为`false`。

逐步求值`isZero Nat.zero`收益如下：

```
isZero Nat.zero
===>
match Nat.zero with
| Nat.zero => true
| Nat.succ k => false
===>
true
```

`isZero 5`收益求值类似：

```
isZero 5
===>
isZero (Nat.succ (Nat.succ (Nat.succ (Nat.succ (Nat.succ Nat.zero)))))
===>
match Nat.succ (Nat.succ (Nat.succ (Nat.succ (Nat.succ Nat.zero)))) with
| Nat.zero => true
| Nat.succ k => false
===>
false
```

图案的k第二个分支`isZero`不是装饰性的。它使用提供的名称使`Nat`成为可见的参数。`succ`然后可以使用该较小的数字来计算表达式的最终结果。

正如某个数n的后继比n大 1 （即n + 1）一样，一个数的前驱也比它小 1。如果pred是一个查找 a 的前身的函数Nat，那么以下示例应该是找到预期结果的情况：

```lean
#eval pred 5
```

```
4
```

```lean
#eval pred 839
```

```
838
```

因为`Nat`不能代表负数，0所以有点难。通常，在使用`Nat`时，通常会产生负数的运算符被重新定义为产生0自身：

```lean
#eval pred 0
```

```
0
```

要找到 a 的前身，Nat第一步是检查使用哪个构造函数来创建它。如果是Nat.zero，那么结果就是Nat.zero。如果是Nat.succ，则该名称k用于指代其Nat下方。这Nat是所需的前身，因此Nat.succ分支的结果是k.

```lean
def pred (n : Nat) : Nat :=
  match n with
  | Nat.zero => Nat.zero
  | Nat.succ k => k
```

应用此函数5产生以下步骤：

```
pred 5
===>
pred (Nat.succ 4)
===>
match Nat.succ 4 with
| Nat.zero => Nat.zero
| Nat.succ k => k
===>
4
```

模式匹配可用于结构以及总和类型。例如，从 a 中提取第三维的函数Point3D可以写成如下：

```lean
def depth (p : Point3D) : Float :=
  match p with
  | { x:= h, y := w, z := d } => d
```

在这种情况下，只使用访问器会简单得多z，但结构模式有时是编写函数的最简单方法。

#### 递归函数

引用正在定义的名称的定义称为递归定义。归纳数据类型允许递归；事实上，Nat是这种数据类型的一个例子，因为succ需要另一个Nat. 递归数据类型可以表示任意大的数据，仅受可用内存等技术因素的限制。正如不可能为数据类型定义中的每个自然数写下一个构造函数一样，也不可能为每种可能性写下一个模式匹配案例。

递归数据类型很好地补充了递归函数。一个简单的递归函数Nat检查它的参数是否是偶数。在这种情况下，zero是偶数。像这样的代码的非递归分支称为基本情况。奇数的后继是偶数，偶数的后继是奇数。这意味着一个数字succ是偶数，当且仅当它的参数不是偶数。

```lean
def even (n : Nat) : Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ k => not (even k)
```

这种思维模式对于在Nat. 首先，确定要做什么zero。然后，确定如何将任意Nat结果转换为其后继结果，并将此转换应用于递归调用的结果。这种模式称为结构递归。

与许多语言不同，Lean 默认确保每个递归函数最终都会达到一个基本情况。从编程的角度来看，这排除了意外的无限循环。但是这个特性在证明定理时尤其重要，因为无限循环会造成很大的困难。这样做的结果是 Lean 不会接受even尝试在原始数字上递归调用自身的版本：

```lean
def evenLoops (n : Nat) : Bool :=
  match n with
  | Nat.zero => true
  | Nat.succ k => not (evenLoops n)
```

错误消息的重要部分是 Lean 无法确定递归函数总是达到基本情况（因为它没有）。

```
fail to show termination for
  evenLoops
with errors
structural recursion cannot be used

well-founded recursion cannot be used, 'evenLoops' does not take any (non-fixed) arguments
```

尽管加法需要两个参数，但只需要检查其中一个。要将零添加到数字n，只需返回n。要将 k 的后继添加到 n ，取 k到n的添加结果的后继。

```lean
def plus (n : Nat) (k : Nat) : Nat :=
  match k with
  | Nat.zero => n
  | Nat.succ k' => Nat.succ (plus n k')
```

在 的定义中plus，k'选择名称以表明它与参数 连接但不相同k。例如，通过求值plus 3 2产生以下步骤：

```
plus 3 2
===>
plus 3 (Nat.succ (Nat.succ Nat.zero))
===>
match Nat.succ (Nat.succ Nat.zero) with
| Nat.zero => 3
| Nat.succ k' => Nat.succ (plus 3 k')
===>
Nat.succ (plus 3 (Nat.succ Nat.zero))
===>
Nat.succ (match Nat.succ Nat.zero with
| Nat.zero => 3
| Nat.succ k' => Nat.succ (plus 3 k'))
===>
Nat.succ (Nat.succ (plus 3 Nat.zero))
===>
Nat.succ (Nat.succ (match Nat.zero with
| Nat.zero => 3
| Nat.succ k' => Nat.succ (plus 3 k')))
===>
Nat.succ (Nat.succ 3)
===>
5
```

考虑加法的一种方法是n + k将Nat.succ k次应用于n。类似地，乘法n × k将n添加到自身k次，减法n - k需要n的前任k次。

```lean
def times (n : Nat) (k : Nat) : Nat :=
  match k with
  | Nat.zero => Nat.zero
  | Nat.succ k' => plus n (times n k')

def minus (n : Nat) (k : Nat) : Nat :=
  match k with
  | Nat.zero => n
  | Nat.succ k' => pred (minus n k')
```

并非每个函数都可以使用结构递归轻松编写。将加法理解为迭代Nat.succ，乘法理解为迭代加法，减法理解为迭代前身，这表明除法的实现是迭代减法。在这种情况下，如果分子小于除数，则结果为零。否则，结果是分子减去除数除以除数的后继。

```lean
def div (n : Nat) (k : Nat) : Nat :=
  if n < k then
    0
  else Nat.succ (div (n - k) k)
```

该程序终止所有输入，因为它总是在基本情况下取得进展。但是，它在结构上不是递归的，因为它不遵循寻找零结果并将较小Nat的结果转换为其后继结果的模式。特别是，函数的递归调用应用于另一个函数调用的结果，而不是应用于输入构造函数的参数。因此，Lean使用以下消息拒绝它：

```
fail to show termination for
  div
with errors
argument #1 was not used for structural recursion
  failed to eliminate recursive application
    div (n - k) k

argument #2 was not used for structural recursion
  failed to eliminate recursive application
    div (n - k) k

structural recursion cannot be used

failed to prove termination, use `termination_by` to specify a well-founded relation
```

此消息意味着div需要手动终止证明。这个话题将在后面的章节中探讨。

### 多态性

就像在大多数语言中一样，Lean中的类型可以带参数。例如，该类型List Nat描述自然数列表、List String描述字符串列表和List (List Point)描述点列表列表。这与C#或Java等语言List<Nat>非常相似。正如Lean使用空格将参数传递给函数一样，它使用空格将参数传递给类型。List<String>List<List<Point>>

在函数式编程中，术语多态性通常是指将类型作为参数的数据类型和定义。这与面向对象的编程社区不同，在面向对象的编程社区中，该术语通常指的是可以覆盖其超类的某些行为的子类。在本书中，“多态性”总是指这个词的第一个意义。这些类型参数可以在数据类型或定义中使用，这允许相同的数据类型或定义与任何类型一起使用，这些类型是通过将参数名称替换为某些其他类型而产生的。

该Point结构要求x和y字段都是Floats。但是，对于每个坐标都需要特定表示的点没有任何意义。的多态版本Point，称为PPoint，可以将类型作为参数，然后将该类型用于两个字段：

```lean
structure PPoint (α : Type) where
  x : α
  y : α
deriving Repr
```

就像函数定义的参数紧跟在定义名称之后一样，结构的参数紧跟在结构名称之后。当没有更具体的名称表明自己时，习惯上使用希腊字母来命名Lean中的类型参数。Type是一种描述其他类型的类型，所以Nat, List String, 并且PPoint Int都具有 type Type。

就像List,PPoint可以通过提供特定类型作为其参数来使用：

```lean
def natOrigin : PPoint Nat :=
  { x := Nat.zero, y := Nat.zero }
```

在此示例中，两个字段都应为Nats。就像通过用参数值替换其参数变量来调用函数一样，PPoint将类型Nat作为参数提供会产生一个结构，其中字段x和y具有 type Nat，因为参数名称α已被参数 type 替换Nat。因为类型是 Lean 中的普通表达式，所以将参数传递给多态类型（如PPoint）不需要任何特殊语法。

定义也可以将类型作为参数，这使得它们具有多态性。该函数将a 的字段replaceX替换为新值。为了允许使用任何多态点，它本身必须是多态的。这是通过使其第一个参数是点的字段的类型来实现的，后面的参数引用回第一个参数的名称。xPPointreplaceX

```lean
def replaceX (α : Type) (point : PPoint α) (newX : α) : PPoint α :=
  { point with x := newX }
```

换句话说，当参数的类型point和newX提及时α，它们指的是作为第一个参数提供的任何类型。这类似于函数参数名称引用在函数体中出现时提供的值的方式。

这可以通过让 Lean 检查类型replaceX，然后要求它检查类型来看出replaceX Nat。

```lean
#check replaceX
```

```
replaceX : (α : Type) → PPoint α → α → PPoint α
```

此函数类型包含第一个参数的名称，该类型中的后续参数引用此名称。正如函数应用程序的值是通过用函数体中提供的参数值替换参数名称来找到的，函数应用程序的类型是通过用函数返回类型中提供的值替换参数名称来找到的。提供第一个参数 ，Nat会导致类型的其余部分中所有出现的α被替换为Nat：

```lean
#check replaceX Nat
```

```
replaceX Nat : PPoint Nat → Nat → PPoint Nat
```

因为剩余的参数没有显式命名，所以在提供更多参数时不会发生进一步的替换：

```lean
#check replaceX Nat natOrigin
```

```
replaceX Nat natOrigin : Nat → PPoint Nat
```

```lean
#check replaceX Nat natOrigin 5
```

```
replaceX Nat natOrigin 5 : PPoint Nat
```

整个函数应用程序表达式的类型是通过将类型作为参数传递来确定的，这一事实与求值它的能力无关。

```lean
#eval replaceX Nat natOrigin 5
```

```
{ x := 5, y := 0 }
```

多态函数通过采用命名类型参数并让后面的类型引用参数的名称来工作。但是，类型参数没有什么特别之处，可以命名它们。给定一个表示正号或负号的数据类型：

```lean
inductive Sign where
  | pos
  | neg
```

可以编写一个参数是符号的函数。如果参数为正，则函数返回 a Nat，如果为负，则返回 a Int：

```lean
def posOrNegThree (s : Sign) : match s with | Sign.pos => Nat | Sign.neg => Int :=
  match s with
  | Sign.pos => (3 : Nat)
  | Sign.neg => (-3 : Int)
```

因为类型是第一类并且可以使用Lean语言的普通规则来计算，所以它们可以通过对数据类型的模式匹配来计算。当 Lean 检查这个函数时，它使用函数体模式匹配的事实在类型中运行相同的模式，表明这Nat是pos案例Int的预期类型，也是案例的预期类型neg。

链表
Lean 的标准库包括一个规范的链表数据类型，称为List，以及使其更方便使用的特殊语法。列表写在方括号中。例如，一个包含小于 10 的素数的列表可以写成：


def primesUnder10 : List Nat := [2, 3, 5, 7]
在幕后，List是一个归纳数据类型，定义如下：


inductive List (α : Type) where
  | nil : List α
  | cons : α → List α → List α
标准库中的实际定义略有不同，因为它使用了尚未呈现的功能，但基本相似。这个定义说，List它采用单一类型作为其参数，就像PPoint以前一样。此类型是存储在列表中的条目的类型。根据构造函数， aList α可以使用nil或构建cons。构造函数nil表示空列表，构造函数cons表示链表中的单个元素。第一个参数cons是列表的头部，第二个参数是它的尾部。

该primesUnder10示例可以通过List直接使用 的构造函数来更明确地编写：


def explicitPrimesUnder10 : List Nat :=
  List.cons 2 (List.cons 3 (List.cons 5 (List.cons 7 List.nil)))
这两个定义完全等价，但primesUnder10比explicitPrimesUnder10.

使用 s 的函数List可以以与使用 s 的函数大致相同的方式定义Nat。实际上，将链表理解为Nat一个附加数据字段悬挂在每个succ构造函数上的方法。从这个角度来看，计算列表的长度就是将每个列表替换cons为 asucc并将最后nil一个替换为 a 的过程zero。就像replaceX将点的字段类型作为参数一样，length采用列表条目的类型。例如，如果列表包含字符串，则第一个参数是String: length String ["Sourdough", "bread"]。它应该这样计算：

```
length String ["Sourdough", "bread"]
===>
length String (List.cons "Sourdough" (List.cons "bread" List.nil))
===>
Nat.succ (length String (List.cons "bread" List.nil))
===>
Nat.succ (Nat.succ (length String List.nil))
===>
Nat.succ (Nat.succ Nat.zero)
===>
2
```

的定义length既是多态的（因为它将列表条目类型作为参数）又是递归的（因为它引用自身）。通常，函数遵循数据的形状：递归数据类型导致递归函数，多态数据类型导致多态函数。

```lean
def length (α : Type) (xs : List α) : Nat :=
  match xs with
  | List.nil => Nat.zero
  | List.cons y ys => Nat.succ (length α ys)
```

诸如xs和之类的名称ys通常用于表示未知值的列表。名称中的sthe 表示它们是复数形式，因此它们的发音为“exes”和“whys”，而不是“x s”和“y s”。

为了更容易阅读列表上的函数，[]可以使用括号符号与 进行模式匹配，并且可以使用中nil缀代替：::cons

```lean
def length (α : Type) (xs : List α) : Nat :=
  match xs with
  | [] => 0
  | y :: ys => Nat.succ (length α ys)
```

隐式参数
两者replaceX和length使用起来都有些官僚主义，因为类型参数通常由后面的值唯一确定。事实上，在大多数语言中，编译器完全能够自行确定类型参数，并且只是偶尔需要用户的帮助。在Lean中也是如此。参数可以通过在定义函数时将它们包裹在花括号而不是括号中来声明为隐式。例如，replaceX带有隐式类型参数的版本如下所示：

```lean
def replaceX {α : Type} (point : PPoint α) (newX : α) : PPoint α :=
  { point with x := newX }
```

它可以在natOrigin不Nat显式提供的情况下使用，因为 Lean 可以从后面的参数中推断出的值：α

```lean
#eval replaceX natOrigin 5
```

```
{ x := 5, y := 0 }
```

同样，length可以重新定义以隐式获取条目类型：

```lean
def length {α : Type} (xs : List α) : Nat :=
  match xs with
  | [] => 0
  | y :: ys => Nat.succ (length ys)
```

此length功能可直接应用于primesUnder10：

```lean
#eval length primesUnder10
```

```
4
```

在标准库中，Lean调用了这个函数List.length，这意味着用于结构字段访问的点语法也可以用于查找列表的长度：

```lean
#eval primesUnder10.length
```

```
4
```

正如C#和Java不时需要显式提供类型参数一样，Lean 并不总是能够找到隐式参数。在这些情况下，可以使用它们的名称提供它们。例如，List.length仅适用于整数列表的版本可以通过设置α为Int：

```lean
#check List.length (α := Int)
```

```
List.length : List Int → Nat
```

更多内置数据类型
除了列表之外，Lean 的标准库还包含许多其他结构和归纳数据类型，可以在各种上下文中使用。

Option
不是每个列表都有第一个条目——有些列表是空的。对集合的许多操作可能无法找到他们正在寻找的内容。例如，查找列表中第一个条目的函数可能找不到任何此类条目。因此，它必须有一种方法来表示没有第一个条目。

许多语言都有一个null表示没有值的值。nullLean没有为现有类型配备特殊值，而是提供了一种名为的数据类型，该数据类型Option为其他类型配备了缺失值的指示符。例如，可为空Int的由 表示Option Int，可为空的字符串列表由类型表示Option (List String)。引入一个新类型来表示可空性意味着类型系统确保null不会忘记检查，因为Option Int不能在Int预期 an 的上下文中使用 an。

Option有两个构造函数，称为some和none，分别表示底层类型的非空和空版本。非空构造函数 ,some包含基础值，但none不带参数：

```lean
inductive Option (α : Type) : Type where
  | none : Option α
  | some (val : α) : Option α
```

该Option类型与 C# 和 Kotlin 等语言中的可空类型非常相似，但并不完全相同。在这些语言中，如果一个类型（比如，Boolean）总是引用类型（true和false）的实际值，则该类型Boolean?或Nullable<Boolean>另外承认该null值。在类型系统中跟踪这一点非常有用：类型检查器和其他工具可以帮助程序员记住检查 null，并且通过类型签名明确描述可空性的 API 比没有的 API 提供更多信息。然而，这些可为空的类型Option在一个非常重要的方面与 Lean 不同，那就是它们不允许多层可选性。 Option (Option Int)可以用none, some none, 或some (some 360). 另一方面，C# 通过只允许?添加到不可为空的类型来禁止多层可空性，而 Kotlin 将T??其视为等同于T?. 这种细微的差异在实践中很少相关，但有时可能很重要。

要查找列表中的第一个条目（如果存在），请使用List.head?. 问号是名称的一部分，与在 C# 或 Kotlin 中使用问号指示可空类型无关。在 的定义中List.head?，下划线用于表示列表的尾部。在模式中，下划线完全匹配任何东西，但不引入变量来引用匹配的数据。使用下划线代替名称是一种向读者清楚地传达部分输入被忽略的方式。

```lean
def List.head? {α : Type} (xs : List α) : Option α :=
  match xs with
  | [] => none
  | y :: _ => some y
```

?Lean命名约定是使用返回 的版本、在提供无效输入时崩溃的版本以及在操作将失败时返回默认值的版本Option的!后缀D来定义可能在组中失败的操作。例如，head要求调用者提供列表不为空的数学证据，head?返回一个Option，head!在传递一个空列表时使程序崩溃，并headD在列表为空的情况下返回一个默认值。问号和感叹号是名称的一部分，而不是特殊语法，因为 Lean 的命名规则比许多语言更自由。

因为head?是在命名空间中定义的List，所以它可以与访问器表示法一起使用：


#eval primesUnder10.head?

some 2
但是，尝试在空列表上对其进行测试会导致两个错误：


#eval [].head?

don't know how to synthesize implicit argument
  @List.nil ?m.16394
context:
⊢ Type ?u.16391

don't know how to synthesize implicit argument
  @_root_.List.head? ?m.16394 []
context:
⊢ Type ?u.16391
这是因为 Lean 无法完全确定表达式的类型。特别是，它既找不到 的隐式类型参数List.head?，也找不到 的隐式类型参数List.nil。在 Lean 的输出中，?m.XYZ表示无法推断的程序的一部分。这些未知部分称为元变量，它们出现在一些错误消息中。为了求值一个表达式，Lean 需要能够找到它的类型，并且该类型不可用，因为空列表没有任何可以找到该类型的条目。显式提供类型允许 Lean 继续：


#eval [].head? (α := Int)

none
错误消息提供了有用的线索。两条消息都使用相同的元变量来描述缺失的隐式参数，这意味着 Lean 已经确定这两个缺失的部分将共享一个解决方案，即使它无法确定解决方案的实际值。

Prod
该Prod结构是“产品”的缩写，是一种将两个值连接在一起的通用方式。例如， aProd Nat String包含 aNat和 a String。换句话说，PPoint Nat可以替换为Prod Nat Nat。 Prod非常像 C# 的元组，Kotlin 和C++ 中的Pairand类型。许多应用程序最好通过定义自己的结构来服务，即使对于像 . 这样的简单情况也是如此，因为使用领域术语可以更容易阅读代码。TripletuplePoint

另一方面，在某些情况下，定义新类型的开销是不值得的。此外，一些库足够通用，没有比“对”更具体的概念了。最后，标准库包含各种方便的函数，可以更轻松地使用内置的对类型。

标准对结构称为Prod。

```lean
structure Prod (α : Type) (β : Type) : Type where
  fst : α
  snd : β
```

列表使用如此频繁，以至于有特殊的语法使它们更具可读性。出于同样的原因，产品类型及其构造函数都有特殊的语法。该类型Prod α β通常是书面α × β的，反映了集合的笛卡尔积的通常表示法。类似地，对的常用数学符号可用于Prod. 换句话说，而不是写：

```lean
def fives : String × Int := { fst := "five", snd := 5 }
```

写下就足够了：

```lean
def fives : String × Int := ("five", 5)
```

两种表示法都是右结合的。这意味着以下定义是等价的：

```lean
def sevens : String × Int × Nat := ("VII", 7, 4 + 3)
```

```lean
def sevens : String × (Int × Nat) := ("VII", (7, 4 + 3))
```

也就是说，所有多于两种类型的乘积，以及它们对应的构造函数，其实都是幕后的嵌套乘积和嵌套对。

Sum
Sum数据类型是允许在两种不同类型的值之间进行选择的通用方式。例如，aSum String Int是 aString或 an Int。Like Prod,Sum应该在编写非常通用的代码时使用，对于没有合理的特定领域类型的非常小的代码部分，或者当标准库包含有用的函数时。在大多数情况下，使用自定义归纳类型更具可读性和可维护性。

typeSum α β的值要么是inl应用于 type 值的构造函数，要么是应用于 type值α的构造函数：inrβ

```lean
inductive Sum (α : Type) (β : Type) : Type where
  | inl : α → Sum α β
  | inr : β → Sum α β
```

这些名称分别是“左注射”和“右注射”的缩写。正如笛卡尔积表示法用于Prod，“带圆圈的加号”表示法用于Sum，所以α ⊕ β是另一种写法Sum α β。Sum.inl和没有特殊语法Sum.inr。

例如，如果宠物名可以是狗名或猫名，那么它们的类型可以作为字符串的总和引入：

```lean
def PetName : Type := String ⊕ String
```

在实际程序中，通常最好为此目的定义一个自定义归纳数据类型，并使用信息丰富的构造函数名称。这里，Sum.inlis 用于狗名，Sum.inris 用于猫名。这些构造函数可用于编写动物名称列表：

```lean
def animals : List PetName :=
  [Sum.inl "Spot", Sum.inr "Tiger", Sum.inl "Fifi", Sum.inl "Rex", Sum.inr "Floof"]
```

模式匹配可用于区分两个构造函数。例如，一个计算动物名称列表中狗的数量（即Sum.inl构造函数的数量）的函数如下所示：

```lean
def howManyDogs (pets : List PetName) : Nat :=
  match pets with
  | [] => 0
  | Sum.inl _ :: morePets => howManyDogs morePets + 1
  | Sum.inr _ :: morePets => howManyDogs morePets
```

函数调用在中缀运算符之前进行求值，因此howManyDogs morePets + 1与(howManyDogs morePets) + 1. 正如预期的那样，#eval howManyDogs animals产量3。

Unit
Unit是一种只有一个无参数构造函数的类型，称为unit. 换句话说，它只描述了一个单一的值，它由应用到任何参数的构造函数组成。 Unit定义如下：

```lean
inductive Unit : Type where
  | unit : Unit
```

就其本身而言，Unit并不是特别有用。但是，在多态代码中，它可以用作丢失数据的占位符。例如，以下归纳数据类型表示算术表达式：

```lean
inductive ArithExpr (ann : Type) : Type where
  | int : ann → Int → ArithExpr ann
  | plus : ann → ArithExpr ann → ArithExpr ann → ArithExpr ann
  | minus : ann → ArithExpr ann → ArithExpr ann → ArithExpr ann
  | times : ann → ArithExpr ann → ArithExpr ann → ArithExpr ann
```

类型参数ann代表注解，每个构造函数都有注解。来自解析器的表达式可能会使用源位置进行注释，因此返回类型 ofArithExpr SourcePos可确保解析器将 aSourcePos放在每个子表达式中。但是，不是来自解析器的表达式将没有源位置，因此它们的类型可以是ArithExpr Unit.

此外，由于所有Lean函数都有参数，其他语言中的零参数函数可以表示为带Unit参数的函数。在返回位置，Unit类型类似于void从 C 派生的语言。在 C 系列中，返回的函数void会将控制权返回给它的调用者，但不会返回任何有趣的值。通过作为一个有意无趣的值，Unit允许在不需要void类型系统中的特殊用途特性的情况下表达它。Unit 的构造函数可以写成空括号：() : Unit.

Empty
该Empty数据类型没有任何构造函数。因此，它表示无法访问的代码，因为没有任何一系列调用可以以 type 的值终止Empty。

Empty几乎没有使用Unit. 但是，它在某些特殊情况下很有用。许多多态数据类型不会在其所有构造函数中使用所有类型参数。例如，Sum.inl每个Sum.inr都只使用一个Sum's 类型参数。使用Empty作为类型参数Sum之一可以排除程序中特定点的构造函数之一。这可以允许在具有额外限制的上下文中使用通用代码。

命名：总和、产品和单位
一般来说，提供多个构造函数的类型称为sum 类型，而单个构造函数带有多个参数的类型称为product types。这些术语与普通算术中使用的和和乘积有关。当涉及的类型包含有限数量的值时，这种关系最容易看出。如果α和β是分别包含n和k个不同值的类型，则α ⊕ β包含n + k个不同值并α × β包含n × k个不同值。例如，Bool有两个值：trueand false, andUnit有一个值：Unit.unit. 乘积Bool × Unit具有两个值(true, Unit.unit)和(false, Unit.unit)，总和Bool ⊕ Unit具有三个值Sum.inl true、Sum.inl false和Sum.inr unit。同样，2 × 1 = 2 和 2 + 1 = 3。

您可能会遇到的消息
并非所有可定义的结构或归纳类型都可以具有 type Type。特别是，如果构造函数将任意类型作为参数，则归纳类型必须具有不同的类型。这些错误通常说明“宇宙水平”。例如，对于这种归纳类型：

```lean
inductive MyType : Type where
  | ctor : (α : Type) → α → MyType
```

Lean给出以下错误：

```
invalid universe level in constructor 'MyType.ctor', parameter 'α' has type
  Type
at universe level
  2
it must be smaller than or equal to the inductive datatype universe level
  1
```

后面的章节描述了为什么会出现这种情况，以及如何修改定义以使其工作。现在，尝试将类型作为一个整体的归纳类型的参数，而不是构造函数的参数。

类似地，如果构造函数的参数是一个将被定义的数据类型作为参数的函数，则该定义被拒绝。例如：

```lean
inductive MyType : Type where
  | ctor : (MyType → Int) → MyType
```

产生消息：

```
(kernel) arg #1 of 'MyType.ctor' has a non positive occurrence of the datatypes being declared
```

出于技术原因，允许使用这些数据类型可能会破坏 Lean 的内部逻辑，使其不适合用作定理证明器。

忘记归纳类型的参数也会产生令人困惑的信息。例如，参数α不传递给MyTypeinctor的类型：

```lean
inductive MyType (α : Type) : Type where
  | ctor : α → MyType
```

Lean回复以下错误：

```
type expected
failed to synthesize instance
  CoeSort (Type → Type) ?m.20675
```

发生此错误是因为 Lean 包含一组可扩展的用于在不同类型之间“双关”的规则，这允许方便的数学符号，例如在预期其载体集的上下文中使用表示代数结构的类型。错误消息是说MyType' 类型，即Type → Type，没有这样的规则。当在其他上下文中省略类型参数时，可能会出现相同的消息，例如在定义的类型签名中：

```lean
inductive MyType (α : Type) : Type where
  | ctor : α → MyType α

def ofFive : MyType := ctor 5
```

#### 练习

- 编写一个函数来查找列表中的最后一个条目。它应该返回一个`Option`。
- 编写一个函数，查找列表中满足给定谓词的第一个条目。开始定义`def List.findFirst? {α : Type} (xs : List α) (predicate : α → Bool) : Option α :=`
- 编写一个`Prod.swap`交换成对的两个字段的函数。开始定义`def Prod.swap {α β : Type} (pair : α × β) : β × α :=`
- 重写`PetName`示例以使用自定义数据类型并将其与使用的版本进行比较`Sum`。
- 编写一个函数`zip`，将两个列表组合成一个对列表。结果列表应该与最短的输入列表一样长。以 开始定义`def zip {α β : Type} (xs : List α) (ys : List β) : List (α × β) :=`。
- 编写一个多态函数`take`，返回列表中的前`n`个条目，其中`n`是`a Nat`。如果列表包含少于`n`条目，则结果列表应该是输入列表。`#eval take 3 ["bolete", "oyster"]`应该输出`["bolete", "oyster"]`，也`#eval take 1 ["bolete", "oyster"]`应该输出`["bolete"]`。
- 使用类型和算术之间的类比，编写一个将乘积分配给总和的函数。换句话说，它应该有`type α × (β ⊕ γ) → (α × β) ⊕ (α × γ)`。
- 使用类型和算术之间的类比，编写一个将乘以`2`变为和的函数。换句话说，它应该有`type Bool × α → α ⊕ α`。