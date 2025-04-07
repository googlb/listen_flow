// Enum 写法 (之前建议的)
enum AppRoute {
  home('/'),
  reading('/reading'),
  profile('/profile'),
  detail('/detail');

  const AppRoute(this.path);
  final String path;

  // 可以直接在 Enum 内部添加 name getter (虽然 GoRouter 也能自动从枚举名推断)
  String get name => toString().split('.').last;

  // 也可以在这里添加 getter 来判断是否需要认证
  // bool get requiresAuth => [AppRoute.profile, ...].contains(this);
}