/*运算符
Dart 支持下表所示的操作符，它也体现了 Dart 运算符的关联性和 优先级 的从高到低的顺序。这也是 Dart 运算符关系的近似值。你可以将这些运算符实现为 一个类的成员。*/

Description	Operator	Associativity
unary postfix	expr++ expr-- () [] ?[] . ?. !	None
unary prefix	-expr !expr ~expr ++expr --expr await expr	None
multiplicative	* / % ~/	Left
additive	+ -	Left
shift	<< >> >>>	Left
bitwise AND	&	Left
bitwise XOR	^	Left
bitwise OR	|	Left
relational and type test	>= > <= < as is is!	None
equality	== !=	None
logical AND	&&	Left
logical OR	||	Left
if null	??	Left
conditional	expr1 ? expr2 : expr3	Right
cascade	.. ?..	Left
assignment	= *= /= += -= &= ^= etc.	Right
//一旦你使用了运算符，就创建了表达式。下面是一些运算符表达式的示例：

a++
a + b
a = b
a == b
c ? a : b
a is T
//在 运算符表 中，运算符的优先级按先后排列，即第一行优先级最高，最后一行优先级最低，而同一行中，最左边的优先级最高，最右边的优先级最低。例如：% 运算符优先级高于 == ，而 == 高于 &&。根据优先级规则，那么意味着以下两行代码执行的效果相同：

// Parentheses improve readability.
if ((n % i == 0) && (d % i == 0)) ...

// Harder to read, but equivalent.
if (n % i == 0 && d % i == 0) ...

/*算术运算符
Dart 支持常用的算术运算符：

运算符	描述
+	加
-	减
-表达式	一元负, 也可以作为反转（反转表达式的符号）
*	乘
/	除
~/	除并取整
%	取模
示例：*/

<div class="code-excerpt">
<div class="code-excerpt__code"><pre><code class="dart prettyprint lang-dart">assert(2 + 3 == 5);
assert(2 - 3 == -1);
assert(2 * 3 == 6);
assert(5 / 2 == 2.5); // Result is a double
assert(5 ~/ 2 == 2); // Result is an int
assert(5 % 2 == 1); // Remainder
assert('5/2 = ${5 ~/ 2} r ${5 % 2}' == '5/2 = 2 r 1');</code></pre></div>
</div>
1
2
3
4
5
6
7
8
9
//Dart 还支持自增自减操作。

Operator ++ var	var =var + 1 (表达式的值var+1)
var++	var = var + 1 (表达式的值为 var)
--var	var = var - 1 (表达式的值为 var - 1)
var--	var = var - 1 (表达式的值为 var)



int a;
int b;

a = 0;
b = ++a; // Increment a before b gets its value.
assert(a == b); // 1 == 1

a = 0;
b = a++; // Increment a AFTER b gets its value.
assert(a != b); // 1 != 0

a = 0;
b = --a; // Decrement a before b gets its value.
assert(a == b); // -1 == -1

a = 0;
b = a--; // Decrement a AFTER b gets its value.
assert(a != b); // -1 != 0</code></pre></div>

/*关系运算符

下表列出了关系运算符及含义：

Operator	相等
!=	不等
>	大于
<	小于
>=	大于等于
<=	小于等于
要判断两个对象 x 和 y 是否表示相同的事物使用 == 即可。（在极少数情况下，可能需要使用 identical() 函数来确定两个对象是否完全相同）。下面是 == 运算符的一些规则：

当 x 和 y 同时为空时返回 true，而只有一个为空时返回 false。

返回对 x 调用 == 方法的结果，参数为 y。

下面的代码给出了每一种关系运算符的示例：*/

assert(2 == 2);
assert(2 != 3);
assert(3 > 2);
assert(2 < 3);
assert(3 >= 3);
assert(2 <= 3);
/*
类型判断运算符
as、is、is! 运算符是在运行时判断对象类型的运算符。

Operator	Meaning
as	类型转换（也用作指定 库前缀)）
is	如果对象是指定类型则返回 true
is!	如果对象是指定类型则返回 false
当且仅当 obj 实现了 T 的接口，obj is T 才是 true。例如 obj is Object 总为 true，因为所有类都是 Object 的子类。

仅当你确定这个对象是该类型的时候，你才可以使用 as 操作符可以把对象转换为特定的类型。例如：*/

(employee as Person).firstName = 'Bob';
//如果你不确定这个对象类型是不是 T，请在转型前使用 is T 检查类型。

if (employee is Person) {
// Type check
employee.firstName = 'Bob';
}

/*备注:

上述两种方式是有区别的：如果 employee 为 null 或者不为 Person 类型，则第一种方式将会抛出异常，而第二种不会。

赋值运算符
可以使用 = 来赋值，同时也可以使用 ??= 来为值为 null 的变量赋值。*/

// Assign value to a
a = value;
// Assign value to b if b is null; otherwise, b stays the same
b ??= value;

/*像 += 这样的赋值运算符将算数运算符和赋值运算符组合在了一起。

=	*=	%=	>>>=	^=
+=	/=	<<=	&=	|=
-=	~/=	>>=
下表解释了复合运算符的原理：

场景	复合运算	等效表达式
假设有运算符 op：	a op= b	a = a op b
示例：	a += b	a = a + b
下面的例子展示了如何使用赋值以及复合赋值运算符：*/

var a = 2; // Assign using =
a *= 3; // Assign and multiply: a = a * 3
assert(a == 6);

/*逻辑运算符
使用逻辑运算符你可以反转或组合布尔表达式。

运算符	描述
!表达式	对表达式结果取反（即将 true 变为 false，false 变为 true）
||	逻辑或
&&	逻辑与
下面是使用逻辑表达式的示例：*/

if (!done && (col == 0 || col == 3)) {
// ...Do something...
}

/*按位和移位运算符
在 Dart 中，二进制位运算符可以操作二进制的某一位，但仅适用于整数。

运算符	描述
&	按位与
|	按位或
^	按位异或
~表达式	按位取反（即将 “0” 变为 “1”，“1” 变为 “0”）
<<	位左移
>>	位右移
>>>	无符号右移
下面是使用按位和移位运算符的示例：*/

final value = 0x22;
final bitmask = 0x0f;

assert((value & bitmask) == 0x02); // AND
assert((value & ~bitmask) == 0x20); // AND NOT
assert((value | bitmask) == 0x2f); // OR
assert((value ^ bitmask) == 0x2d); // XOR
assert((value << 4) == 0x220); // Shift left
assert((value >> 4) == 0x02); // Shift right
assert((value >>> 4) == 0x02); // Unsigned shift right
assert((-value >> 4) == -0x03); // Shift right
assert((-value >>> 4) > 0); // Unsigned shift right

/*版本提示:

>>> 操作符在 2.14 以上的 Dart 版本 中可用。

条件表达式
Dart 有两个特殊的运算符可以用来替代 if-else 语句：

条件 ? 表达式 1 : 表达式 2
如果条件为 true，执行表达式 1并返回执行结果，否则执行表达式 2 并返回执行结果。

表达式 1 ?? 表达式 2
如果表达式 1 为非 null 则返回其值，否则执行表达式 2 并返回其值。

根据布尔表达式确定赋值时，请考虑使用 ? 和 :*/

var visibility = isPublic ? 'public' : 'private';
//如果赋值是根据判定是否为 null 则考虑使用 ??。

String playerName(String? name) => name ?? 'Guest';
//上述示例还可以写成至少下面两种不同的形式，只是不够简洁：

// Slightly longer version uses ?: operator.
String playerName(String? name) =&gt; name != null ? name : 'Guest';

// Very long version uses if-else statement.
String playerName(String? name) {
if (name != null) {
return name;
} else {
return 'Guest';
}
}

/*联运算符
级联运算符 (.., ?..) 可以让你在同一个对象上连续调用多个对象的变量或方法。

比如下面的代码：*/

var paint = Paint()
..color = Colors.black
..strokeCap = StrokeCap.round
..strokeWidth = 5.0;

The constructor, Paint(), returns a Paint object. The code that follows the cascade notation operates on this object, ignoring any values that might be returned.

The previous example is equivalent to this code:

var paint = Paint();
paint.color = Colors.black;
paint.strokeCap = StrokeCap.round;
paint.strokeWidth = 5.0;

If the object that the cascade operates on can be null, then use a null-shorting cascade (?..) for the first operation. Starting with ?.. guarantees that none of the cascade operations are attempted on that null object.

querySelector('#confirm') // Get an object.
?..text = 'Confirm' // Use its members.
..classes.add('important')
..onClick.listen((e) => window.alert('Confirmed!'))
..scrollIntoView();


//上面的代码相当于：

var button = querySelector('#confirm');
button?.text = 'Confirm';
button?.classes.add('important');
button?.onClick.listen((e) => window.alert('Confirmed!'));
button?.scrollIntoView();

//级联运算符可以嵌套，例如：

final addressBook = (AddressBookBuilder()
..name = 'jenny'
..email = 'jenny@example.com'
..phone = (PhoneNumberBuilder()
..number = '415-555-0100'
..label = 'home')
    .build())
    .build();

//在返回对象的函数中谨慎使用级联操作符。例如，下面的代码是错误的：

var sb = StringBuffer();
sb.write('foo')
..write('bar'); // Error: method 'write' isn't defined for 'void'.

/*上述代码中的 sb.write() 方法返回的是 void，返回值为 void 的方法则不能使用级联运算符。

备注:

严格来说 .. 级联操作并非一个运算符而是 Dart 的特殊语法。

其他运算符
大多数其它的运算符，已经在其它的示例中使用过：

运算符	名字	描述
()	使用方法	代表调用一个方法
[]	访问 List	访问 List 中特定位置的元素
?[]	判空访问 List	左侧调用者不为空时，访问 List 中特定位置的元素
    .	访问成员	成员访问符
    ?.	条件访问成员	与上述成员访问符类似，但是左边的操作对象不能为 null，例如 foo?.bar，如果 foo 为 null 则返回 null ，否则返回 bar
*/