class BaseResponse<T> {
  T? data;
  String? message;
  int? statusCode;

  BaseResponse({this.data, this.message, this.statusCode});
}
