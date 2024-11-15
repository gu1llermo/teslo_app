class WrongCredentials implements Exception {}

class InvalidToken implements Exception {}

class ConnectionTimeout implements Exception {}

class CustomError implements Exception {
  final String errorMessage;
  // final int errorCode;
  final bool loggedRequired; // es una idea ésta variable
  // al chequear el error, uno vé si está en true y se puede
  // guaradr el log del error en algún lugar persistente

  CustomError(this.errorMessage, [this.loggedRequired = false]);
  // CustomError(this.errorMessage, this.errorCode);
}
