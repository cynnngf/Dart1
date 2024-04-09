/*流程控制语句
你可以使用下面的语句来控制 Dart 代码的执行流程：

if 和 else

for 循环

while 和 do-while 循环

break 和 continue

switch 和 case

assert
*/
/*使用 try-catch 和 throw 也能影响控制流

If 和 Else
Dart 支持 if - else 语句，其中 else 是可选的，比如下面的例子。*/

if (isRaining()) {
you.bringRainCoat();
} else if (isSnowing()) {
you.wearJacket();
} else {
car.putTopDown();
}

/*Dart 的 if 语句中的条件必须是布尔值而不能为其它类型。

For 循环
你可以使用标准的 for 循环进行迭代。例如：*/

var message = StringBuffer('Dart is fun');
for (var i = 0; i &lt; 5; i++) {
message.write('!');
}

//在 Dart 语言中，for 循环中的闭包会自动捕获循环的 索引值 以避免 JavaScript 中一些常见的陷阱。假设有如下代码：

var callbacks = [];
for (var i = 0; i &lt; 2; i++) {
callbacks.add(() =&gt; print(i));
}

for (final c in callbacks) {
c();
}

/*上述代码执行后会输出 0 和 1，但是如果在 JavaScript 中执行同样的代码则会输出两个 2。

如果要遍历的对象是一个可迭代对象（例如 List 或 Set），并且你不需要知道当前的遍历索引，则可以使用 for-in 方法进行遍历*/

for (final candidate in candidates) {
candidate.interview();
}

//可迭代对象同时可以使用 forEach()方法作为另一种选择：
var collection = [1, 2, 3];
collection.forEach(print); // 1 2 3

While 和 Do-While
while 循环会在执行循环体前先判断条件：
while (!isDone()) {
doSomething();
}

do-while 循环则会 先执行一遍循环体 再判断条件：
do {
printLine();
} while (!atEndOfPage());

/*Break 和 Continue
使用 break 可以中断循环：*/

while (true) {
if (shutDownRequested()) break;
processIncomingRequests();
}

//使用 continue 可以跳过本次循环直接进入下一次循环：

for (int i = 0; i < candidates.length; i++) {
var candidate = candidates[i];
if (candidate.yearsExperience < 5) {
continue;
}
candidate.interview();
}

//如果你正在使用诸如 List 或 Set 之类的 Iterable 对象，你可以用以下方式重写上述例子:

candidates
    .where((c) => c.yearsExperience >= 5)
    .forEach((c) => c.interview());

/*Switch 和 Case
Switch 语句在 Dart 中使用 == 来比较整数、字符串或编译时常量，比较的两个对象必须是同一个类型且不能是子类并且没有重写 == 操作符。 枚举类型非常适合在 Switch 语句中使用。

备注:

Dart 中的 Switch 语句仅适用于有限的情况，比如使用解释器和扫描器的场景。

每一个非空的 case 子句都必须有一个 break 语句，也可以通过 continue、throw 或者 return 来结束非空 case 语句。

不匹配任何 case 语句的情况下，会执行 default 子句中的代码：*/

var command = 'OPEN';
switch (command) {
case 'CLOSED':
executeClosed();
break;
case 'PENDING':
executePending();
break;
case 'APPROVED':
executeApproved();
break;
case 'DENIED':
executeDenied();
break;
case 'OPEN':
executeOpen();
break;
default:
executeUnknown();
}

//下面的例子忽略了 case 子句的 break 语句，因此会产生错误：
var command = 'OPEN';
switch (command) {
case 'OPEN':
executeOpen();
// ERROR: Missing break

case ‘CLOSED’:
executeClosed();
break;
}

//是，Dart 支持空的 case 语句，允许其以 fall-through 的形式执行。

var command = 'CLOSED';
switch (command) {
case 'CLOSED': // Empty case falls through.
case 'NOW_CLOSED':
// Runs for both CLOSED and NOW_CLOSED.
executeNowClosed();
break;
}
/*
在非空 case 语句中想要实现 fall-through 的形式，可以使用 continue 语句配合 label 的方式实现:*/

var command = 'CLOSED';
switch (command) {
case 'CLOSED':
executeClosed();
continue nowClosed;
// Continues executing at the nowClosed label.
1
2
3
4
5
6
nowClosed:
case ‘NOW_CLOSED’:
// Runs for both CLOSED and NOW_CLOSED.
executeNowClosed();
break;
}

/*每个 case 子句都可以有局部变量且仅在该 case 语句内可见。

断言
在开发过程中，可以在条件表达式为 false 时使用 — assert(条件, 可选信息); — 语句来打断代码的执行。你可以在本文中找到大量使用 assert 的例子。下面是相关示例：*/

// Make sure the variable has a non-null value.
assert(text != null);

// Make sure the value is less than 100.
assert(number < 100);

// Make sure this is an https URL.
assert(urlString.startsWith(‘https’));

//assert 的第二个参数可以为其添加一个字符串消息。

assert(urlString.startsWith('https'),
'URL ($urlString) should start with "https".');
/*
assert 的第一个参数可以是值为布尔值的任何表达式。如果表达式的值为 true，则断言成功，继续执行。如果表达式的值为 false，则断言失败，抛出一个AssertionError 异常。

如何判断断言是否生效？断言是否生效依赖开发工具和使用的框架：

Flutter 在 调试模式 时生效。

一些开发工具比如 [webdev serve][] 通常情况下是默认生效的。

其他一些工具，比如 dart run 以及 [dart compile js][] 通过在运行 Dart 程序时添加命令行参数 --enable-asserts 使 assert 生效。

在生产环境代码中，断言会被忽略，与此同时传入 assert 的参数不被判断。*/
*