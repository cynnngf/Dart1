
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

// 定义一个表示远程错误的类
class RemoteError {
final String message;
final String stackTrace;

RemoteError(this.message, this.stackTrace);
}

class Worker {
// 用于发送命令的 SendPort
final SendPort _commands;
// 用于接收响应的 ReceivePort
final ReceivePort _responses;

// 用于存储待处理请求的Completer，以及分配给每个请求的唯一ID
final Map<int, Completer<Object?>> _activeRequests = {};
int _idCounter = 0;

// 构造函数，用于初始化对象
Worker._(this._responses, this._commands) {
// 监听来自worker isolate的响应消息
_responses.listen(_handleResponsesFromIsolate);
}

// 发送要解析的JSON给worker isolate，并返回解析后的结果
Future<Object?> parseJson(String message) async {
// 检查端口是否已关闭
if (_closed) throw StateError('Closed');

// 创建一个Completer
final completer = Completer<Object?>.sync();
// 分配唯一ID
final id = _idCounter++;
// 将Completer与请求ID关联起来
_activeRequests[id] = completer;
// 将消息发送给worker isolate，消息包括ID和JSON文本
_commands.send((id, message));
// 等待Completer的future，并返回解析后的结果
return await completer.future;
}

// 关闭worker isolate和主isolate之间的通信端口
void close() {
if (!_closed) {
_closed = true;
// 发送关闭命令
_commands.send('shutdown');
// 如果没有待处理的请求，关闭主isolate的ReceivePort
if (_activeRequests.isEmpty) _responses.close();
print('--- port closed --- ');
}
}

// 处理来自worker isolate的响应消息
void _handleResponsesFromIsolate(dynamic message) {
// 解构消息，获取ID和响应
final (int id, Object? response) = message as (int, Object?);

// 从活跃请求列表中获取对应的Completer
final completer = _activeRequests.remove(id)!;

// 如果响应是一个远程错误，则将错误信息传递给Completer的错误处理程序
if (response is RemoteError) {
completer.completeError(response);
}
// 否则，将响应传递给Completer的完成处理程序
else {
completer.complete(response);
}
}

// 表示端口是否已关闭的标志
bool _closed = false;
}

void main() async {
// 创建worker isolate并获取Worker对象
final worker = await Worker.spawn();

try {
// 向worker isolate发送消息并解析JSON
final jsonData = await worker.parseJson('{"key": "value"}');
print('Parsed JSON: $jsonData');
} catch (e) {
print('Error: $e');
} finally {
// 关闭worker isolate和主isolate之间的通信端口
worker.close();
}
}

// 创建并返回一个Worker实例
// 该实例与一个新的worker isolate相关联
// 此方法为异步方法
// 在此方法中，创建了一个RawReceivePort，用于接收来自worker isolate的初始化消息
// 并将SendPort包含在完成器中，以便在isolate启动后将其分配给_workerCommands属性
// 然后使用Isolate.spawn启动新的isolate，并在初始化消息中发送initPort的SendPort
// 返回一个Worker实例，该实例与新的worker isolate相关联
// 如果启动isolate失败，将关闭initPort并抛出错误
// 如果在关闭initPort时出现错误，也会抛出错误
// 否则，将启动的isolate与新的Worker实例相关联
// 注意：此方法是Worker类的静态方法
extension WorkerExtension on Worker {
static Future<Worker> spawn() async {
// 创建一个原始ReceivePort
final initPort = RawReceivePort();
// 创建一个完成器
final connection = Completer<(ReceivePort, SendPort)>.sync();

// 设置原始ReceivePort的消息处理程序
initPort.handler = (initialMessage) {
// 从初始化消息中获取SendPort
final commandPort = initialMessage as SendPort;
// 将新的ReceivePort和从初始化消息中获取的SendPort作为参数完成连接
connection.complete((
ReceivePort.fromRawReceivePort(initPort),
commandPort,
));
};

// 尝试在新的isolate中启动worker
try {
// 在新的isolate中启动worker，并发送SendPort
await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
}
// 捕获任何启动isolate期间可能抛出的错误
// 如果发生错误，则关闭原始ReceivePort并重新抛出错误
on Object {
initPort.close();
rethrow;
}

// 等待连接完成，并获取连接中的ReceivePort和SendPort
final (ReceivePort receivePort, SendPort sendPort) =
await connection.future;

// 返回一个新的Worker实例，该实例与新的worker isolate相关联
return Worker._(sendPort, receivePort);
}

// 在新的worker isolate中初始化通信端口
// 此方法用作Isolate.spawn的参数，当isolate启动时将执行此方法
// 接收一个SendPort参数，该参数是主isolate的SendPort，用于向主isolate发送消息
// 在此方法中，创建一个新的ReceivePort，用于接收来自主isolate的消息
// 并将此ReceivePort的SendPort发送回主isolate
// 然后，将主isolate的SendPort和新的ReceivePort传递给_handleCommandsToIsolate方法
static void _startRemoteIsolate(SendPort sendPort) {
// 创建一个新的ReceivePort
final receivePort = ReceivePort();
// 将新的ReceivePort的SendPort发送回主isolate
sendPort.send(receivePort.sendPort);
// 初始化worker isolate的通信端口
_handleCommandsToIsolate(receivePort, sendPort);
}


// 处理来自主isolate的命令消息
// 此方法接收来自主isolate的命令消息，并执行相应的操作
// 接收一个ReceivePort参数，用于接收来自主isolate的消息
// 接收一个SendPort参数，用于向主isolate发送响应消息
// 在此方法中，设置消息处理程序来接收来自主isolate的命令消息
// 当接收到命令消息时，执行相应的操作，并将结果发送回主isolate
static void _handleCommandsToIsolate(
ReceivePort commandPort, SendPort responsePort) {
// 设置消息处理程序来接收来自主isolate的命令消息
commandPort.listen((dynamic message) {
// 如果收到的消息是一个字符串，且内容为"shutdown"，则关闭通信端口并退出
if (message == 'shutdown') {
commandPort.close();
return;
}

// 解构消息，获取请求ID和要解析的JSON字符串
final (int id, String json) = message as (int, String);

try {
// 将JSON字符串解析为对象
final parsedJson = jsonDecode(json);
// 将解析后的对象作为响应发送回主isolate
responsePort.send((id, parsedJson));
} catch (e, stackTrace) {
// 如果发生错误，则将错误信息发送回主isolate
responsePort.send((id, RemoteError('$e', '$stackTrace')));
}
});
}
}
