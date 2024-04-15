/*泛型
如果你查看数组的 API 文档，你会发现数组 List 的实际类型为 List<E>。 <…> 符号表示数组是一个 泛型（或 参数化类型） 通常 使用一个字母来代表类型参数，比如 E、T、S、K 和 V 等等。

为什么使用泛型？
泛型常用于需要要求类型安全的情况，但是它也会对代码运行有好处：

适当地指定泛型可以更好地帮助代码生成。

使用泛型可以减少代码重复。

比如你想声明一个只能包含 String 类型的数组，你可以将该数组声明为 List<String>（读作“字符串类型的 list”），这样的话就可以很容易避免因为在该数组放入非 String 类变量而导致的诸多问题，同时编译器以及其他阅读代码的人都可以很容易地发现并定位问题：*/

var names = <String>[];
names.addAll(['Seth', 'Kathy', 'Lars']);
names.add(42); // Error

//另一个使用泛型的原因是可以减少重复代码。泛型可以让你在多个不同类型实现之间共享同一个接口声明，比如下面的例子中声明了一个类用于缓存对象的接口：

abstract class ObjectCache {
Object getByKey(String key);
void setByKey(String key, Object value);
}

//不久后你可能又会想专门为 String 类对象做一个缓存，于是又有了专门为 String 做缓存的类：

abstract class StringCache {
String getByKey(String key);
void setByKey(String key, String value);
}

/*如果过段时间你又想为数字类型也创建一个类，那么就会有很多诸如此类的代码……

这时候可以考虑使用泛型来声明一个类，让不同类型的缓存实现该类做出不同的具体实现即可：*/

abstract class Cache<T> {
T getByKey(String key);
void setByKey(String key, T value);
}

/*在上述代码中，T 是一个替代类型。其相当于类型占位符，在开发者调用该接口的时候会指定具体类型。

使用集合字面量
List、Set 以及 Map 字面量也可以是参数化的。定义参数化的 List 只需在中括号前添加 <type>；定义参数化的 Map 只需要在大括号前添加 <keyType, valueType>：*/

var names = <String>['Seth', 'Kathy', 'Lars'];
var uniqueNames = <String>{'Seth', 'Kathy', 'Lars'};
var pages = <String, String>{
'index.html': 'Homepage',
'robots.txt': 'Hints for web robots',
'humans.txt': 'We are people, not machines'
};

/*使用类型参数化的构造函数
在调用构造方法时也可以使用泛型，只需在类名后用尖括号（<...>）将一个或多个类型包裹即可：*/

var nameSet = Set<String>.from(names);
//下面代码创建了一个键为 Int 类型，值为 View 类型的 Map 对象：

var views = Map<int, View>();
/*泛型集合以及它们所包含的类型
Dart的泛型类型是 固化的，这意味着即便在运行时也会保持类型信息：*/

var names = <String>[];
names.addAll(['Seth', 'Kathy', 'Lars']);

/*备注:

与 Java 不同的是，Java 中的泛型是类型 擦除 的，这意味着泛型类型会在运行时被移除。在 Java 中你可以判断对象是否为 List 但不可以判断对象是否为 List<String>。

限制参数化类型
有时使用泛型的时候，你可能会想限制可作为参数的泛型范围，也就是参数必须是指定类型的子类，这时候可以使用 extends 关键字。

一种常见的非空类型处理方式，是将子类限制继承 Object （而不是默认的 Object?）。*/

class Foo<T extends Object> {
// Any type provided to Foo for T must be non-nullable.
}

class Foo<T extends SomeBaseClass> {
// Implementation goes here...
String toString() => "Instance of 'Foo<$T>'";
}

class Extender extends SomeBaseClass {...}

//这时候就可以使用 SomeBaseClass 或者它的子类来作为泛型参数：

var someBaseClassFoo = Foo<SomeBaseClass>();
var extenderFoo = Foo<Extender>();

//这时候也可以指定无参数的泛型，这时无参数泛型的类型则为 Foo<SomeBaseClass>：

var foo = Foo();
print(foo); // Instance of 'Foo<SomeBaseClass>'

//将非 SomeBaseClass 的类型作为泛型参数则会导致编译错误：

var foo = Foo<Object>();
/*使用泛型方法
方法和参数也可以使用类型参数了:
*/
T first<T>(List<T> ts) {
// Do some initial work or error checking, then...
T tmp = ts[0];
// Do some additional checking or processing...
return tmp;
}

/*方法 first<T> 的泛型 T 可以在如下地方使用：

函数的返回值类型 (T)。

参数的类型 (List<T>)。

局部变量的类型 (T tmp)。*/

