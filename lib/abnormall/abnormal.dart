/*异常
Dart 代码可以抛出和捕获异常。异常表示一些未知的错误情况，如果异常没有捕获则会被抛出从而导致抛出异常的代码终止执行。

与 Java 不同的是，Dart 的所有异常都是非必检异常，方法不必声明会抛出哪些异常，并且你也不必捕获任何异常。

Dart 提供了 Exception 和 Error 两种类型的异常以及它们一系列的子类，你也可以定义自己的异常类型。但是在 Dart 中可以将任何非 null 对象作为异常抛出而不局限于 Exception 或 Error 类型。

抛出异常
下面是关于抛出或者 引发 异常的示例：*/

throw FormatException('Expected at least 1 section');
//你也可以抛出任意的对象：

throw 'Out of llamas!';
//备注:

//优秀的代码通常会抛出 Error 或 Exception 类型的异常。

//因为抛出异常是一个表达式，所以可以在 => 语句中使用，也可以在其他使用表达式的地方抛出异常：

void distanceTo(Point other) => throw UnimplementedError();
/*捕获异常
捕获异常可以避免异常继续传递（重新抛出异常除外）。捕获一个异常可以给你处理它的机会：*/

try {
breedMoreLlamas();
} on OutOfLlamasException {
buyMoreLlamas();
}

//对于可以抛出多种异常类型的代码，也可以指定多个 catch 语句，每个语句分别对应一个异常类型，如果 catch 语句没有指定异常类型则表示可以捕获任意异常类型：

try {
breedMoreLlamas();
} on OutOfLlamasException {
// A specific exception
buyMoreLlamas();
} on Exception catch (e) {
// Anything else that is an exception
print('Unknown exception: $e');
} catch (e) {
// No specified type, handles all
print('Something really unknown: $e');
}

//如上述代码所示可以使用 on 或 catch 来捕获异常，使用 on 来指定异常类型，使用 catch 来捕获异常对象，两者可同时使用。

//你可以为 catch 方法指定两个参数，第一个参数为抛出的异常对象，第二个参数为栈信息 StackTrace 对象：

try {
// ···
} on Exception catch (e) {
print('Exception details:\n $e');
} catch (e, s) {
print('Exception details:\n $e');
print('Stack trace:\n $s');
}

//关键字 rethrow 可以将捕获的异常再次抛出：

void misbehave() {
try {
dynamic foo = true;
print(foo++); // Runtime error
} catch (e) {
print('misbehave() partially handled ${e.runtimeType}.');
rethrow; // Allow callers to see the exception.
}
}

void main() {
try {
misbehave();
} catch (e) {
print('main() finished handling ${e.runtimeType}.');

//Finally
//无论是否抛出异常，finally 语句始终执行，如果没有指定 catch 语句来捕获异常，则异常会在执行完 finally 语句后抛出：

try {
breedMoreLlamas();
} finally {
// Always clean up, even if an exception is thrown.
cleanLlamaStalls();
}

//finally 语句会在任何匹配的 catch 语句后执行：

try {
breedMoreLlamas();
} catch (e) {
print('Error: $e'); // Handle the exception first.
} finally {
cleanLlamaStalls(); // Then clean up.
}
