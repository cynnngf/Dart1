import 'dart:async';

// 异步函数示例
Future<String> lookUpVersion() async {
  // 模拟一个耗时操作
  await Future.delayed(Duration(seconds: 2));
  return '1.0.0';
}

Future<void> checkVersion() async {
  try {
    var version = await lookUpVersion();
    print('版本号是：$version');
    // 进行版本处理
  } catch (e) {
    print('无法查找版本：$e');
    // 处理无法查找版本的情况
  }
}

// 处理流示例
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

void main() async {
  // 调用异步函数
  print('开始检查版本...');
  await checkVersion();
  print('检查版本完成.');

  // 使用异步 for 循环处理流
  print('开始计数...');
  await for (var count in countStream(5)) {
    print('当前计数: $count');
  }
  print('计数完成.');
}
