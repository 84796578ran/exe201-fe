class ApiErrorResponse {
  int? statusCode;
  String? message;

  ApiErrorResponse({this.statusCode, this.message});
}

class ApiSuccessResponse<T> {
  int? statusCode;
  T? data;

  ApiSuccessResponse({this.statusCode, this.data});
}