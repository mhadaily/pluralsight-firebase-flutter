class ApiPath {
  static String get coffees => 'Coffees';
  static String coffee(String id) => 'Coffees/$id';
  static String get users => 'Users';
  static String user(String uid) => 'Users/$uid';
  static String userCart(String uid) => 'Users/$uid/Cart';
  static String userCartItem(String uid, String cid) => 'Users/$uid/Cart/$cid';
  static String get orders => 'Orders';
  static String get logs => 'Logs';
  static String userTokens(String uid) => 'Users/$uid/Tokens';
  static String userToken(String uid, String tokenId) =>
      'Users/$uid/Tokens/$tokenId';
}
