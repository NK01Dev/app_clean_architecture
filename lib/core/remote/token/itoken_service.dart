import '../../common/dtos/refresh_token_response.dart';

abstract class ITokenService {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();

  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<void> clearTokens();
  Future<RefreshTokenResponse> refreshToken(String? refreshToken);
}
