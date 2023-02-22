import 'package:dio/dio.dart';
import 'Dio Client/dio_client.dart';
import 'Dio Exception Handling/dio_exception_handling.dart';

class AppApi {
  final dioClient = DioClient();

  /// Login API
  Future loginAPI({required FormData body}) {
    try {
      final response =  dioClient.post("login/login-user", data: body);
      return response;
    } on DioError catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Verify OTP API
  Future verifyOtpApi({required FormData body}) {
    try {
      final response =
          dioClient.post("login/user-register-otp-verification", data: body);
      return response;
    } on DioError catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Send OTP API
  Future sendOtpApi({required FormData body}) {
    try {
      final response =
          dioClient.post("login/login-otp-send", data: body);
      return response;
    } on DioError catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Registration API
  Future registrationAPI({required FormData body}) {
    try {
      final response = dioClient.post("login/user-register", data: body);
      return response;
    } on DioError catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Recover Password Store API
  Future recoverPasswordStore({required FormData body}) {
    try {
      final response = dioClient.post("recover/recover-password-store", data: body);
      return response;
    } on DioError catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Recover Password Verification API
  Future recoverPasswordVerify({required FormData body}) {
    try {
      final response = dioClient.post("recover/recover-password-verification", data: body);
      return response;
    } on DioError catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Profile Update API
  Future profileUpdateApi({required FormData body}) {
    try {
      final response = dioClient.post("user/profile-update", data: body);
      return response;
    } on DioError catch (error) {
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Add Bank Detail API
  Future addBankDetailApi({required FormData body}){
    try {
      final response = dioClient.post("withdrawal/bank-request",data: body);
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Withdrawal Request API
  Future withdrawalRequestApi({required FormData body}){
    try {
      final response = dioClient.post("withdrawal/withdrawal-request",data: body);
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Withdrawal All Data API
  Future withdrawalAllDataApi(){
    try {
      final response = dioClient.get("withdrawal/withdrawal-all-data");
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Bank All Data API
  Future bankAllData(){
    try{
      final response = dioClient.get("withdrawal/bank-all-data");
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error);
      throw errorMessage;
    }
  }

  /// Support Create API
  Future supportCreateRequest({required FormData body}){
    try {
      final response = dioClient.post("support/support-create",data: body);
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Support All Data API
  Future supportHistoryAllData(){
    try{
      final response = dioClient.get("support/support-all-data");
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Support Data Id API
  Future supportData(String id){
    try {
      final response = dioClient.get("support/support-data/id-$id");
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Support User Message API
  Future supportUserMessage({required FormData body}){
    try{
      final response = dioClient.post("support/support-user-message",data: body);
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Withdrawal UPI
  Future withdrawalUpi({required FormData body}){
    try{
      final response = dioClient.post("withdrawal/upi",data: body);
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
}

  /// Points Transfer API
  Future pointsTransferApi({required FormData body}){
    try{
      final response = dioClient.post("transfer/point-transfer",data: body);
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Verification API
  Future verificationApi({required FormData body}){
    try{
      final response = dioClient.post("verification/verification-request",data: body);
      return response;
    } on DioError catch (error){
      final errorMessage = DioExceptions.fromDioError(error);
      throw errorMessage;
    }
  }

  /// Refer Check API
  Future referCheckApi(String referCode){
    try{
      final response = dioClient.get("login/refer-check/$referCode");
      return response;
    } on DioError catch(error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Transaction History API
  Future transactionHistoryApi(){
    try{
      final response = dioClient.get("withdrawal/transaction-history");
      return response;
    } on DioError catch(error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Dashboard API
  Future dashboardApi(){
    try{
      final response = dioClient.get("user/dashboard");
      return response;
    } on DioError catch(error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Manual Deposit API
  Future manualDepositApi({required FormData body}){
    try{
      final response = dioClient.post("deposit/deposit-amount", data: body);
      return response;
    } on DioError catch(error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Get Verification Data API
  Future getVerificationDataApi(){
    try{
      final response = dioClient.get("verification/verification-data");
      return response;
    } on DioError catch(error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Get Point Rate API
  Future pointRate(){
    try{
      final response = dioClient.get("transfer/point-rate");
      return response;
    } on DioError catch(error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Notification API
  Future notificationApi(){
    try{
      final response = dioClient.get("notification/get_all");
      return response;
    } on DioError catch(error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }

  /// Notification API
  Future supportDetailsApi(){
    try{
      final response = dioClient.get("get-support-details");
      return response;
    } on DioError catch(error){
      final errorMessage = DioExceptions.fromDioError(error).toString();
      throw errorMessage;
    }
  }
}
