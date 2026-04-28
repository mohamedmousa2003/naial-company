abstract class ApiEndPoints {
  static const String baseUrl ="https://exam.elevateegy.com/api/v1";

  static const String login ="/auth/signin";
  static const String register = "/auth/signup";
  static const String enterEmail = '/auth/forgotPassword';
  static const String verifyOtp = '/auth/verifyResetCode';
  static const String getNewPassword = '/auth/resetPassword';

  static const String getAllSubjects = '/subjects';
  static const String getSubjectExams = '/exams';

  static const String getUserData = '/auth/profileData';
  static const String getExamQuestions = '/questions';

  static const String changePassword = '/auth/changePassword';
}
