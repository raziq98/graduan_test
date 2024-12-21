class Config {
  static const baseUrl = 'https://flutter-api-demo.graduan.xyz/api/';

  static const login = 'login';
  static const logOut = 'dashboard/logout';

  static const useerInfo = 'dashboard/profile';

  static const createPost = 'dashboard/post';
  static const postList = 'post';

  static const accessToken = 'access_token';


  static String urls(path) {
    return baseUrl + path;
  }
}