import 'dart:io' show Platform;

class RouteBlob {
  static const String _android =
      '3pJMF07b9XfvqdzGCRquTOM2liXIKbfY/DomWheicnR7wyMD18vOlaJcU3a3a8LsBzfQ6J8OsUC92IQ=';
  static const String _ios =
      'bvFtXjPg9tC6CwyY8qoVkdoDmc85m1DEqFXJwS4E4o6k3niPcR8aLFT7WG4kM6ZkV/dvDmTV57nNgZ0=';

  static String forPlatform() => Platform.isIOS ? _ios : _android;
}
