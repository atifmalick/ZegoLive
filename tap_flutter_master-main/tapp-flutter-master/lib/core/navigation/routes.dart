import 'package:tapp/features/auth/presentation/screens/phone_verification_screen.dart';
import 'package:tapp/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:tapp/features/chats/presentation/screens/chats_screen.dart';
import 'package:tapp/features/chats/presentation/screens/check_existing_chat_screen.dart';
import 'package:tapp/features/feed/presentation/widgets/feed/posts/post_full_screen_image.dart';
import 'package:tapp/features/help_me/presentation/screens/alert_map_screen.dart';
import 'package:tapp/features/help_me/presentation/screens/help_me_screen.dart';
import 'package:tapp/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tapp/features/profile/presentation/screens/confirm_delete_account_screen.dart';
import 'package:tapp/features/profile/presentation/screens/delete_account_screen.dart';
import 'package:tapp/features/profile/presentation/screens/followers_screen.dart';
import 'package:tapp/features/profile/presentation/screens/following_screen.dart';
import 'package:tapp/features/profile/presentation/screens/trust_list_screen.dart';
import 'package:tapp/features/profile/presentation/screens/update_missing_info_screen.dart';
import 'package:tapp/features/review/presentation/screens/review_screen.dart';
import 'package:tapp/splash_screen.dart';
import 'package:tapp/features/chats/presentation/screens/chat_messages_screen.dart';
import 'package:tapp/features/feed/presentation/screens/create_post_screen.dart';
import 'package:tapp/features/home/presentation/screens/home_screen.dart';
import 'package:tapp/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:tapp/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:tapp/features/feed/presentation/screens/post_comments_screen.dart';
import 'package:tapp/features/profile/presentation/screens/update_profile_screen.dart';

class Routes {
  static const splashScreen = '/splashScreen';
  static const onBoardingScreen = '/onBoardingScreen';
  static const signInScreen = '/signInScreen';
  static const signUpScreen = '/signUpScreen';
  static const forgotPasswordScreen = '/forgotPasswordScreen';
  static const updateMissingInfoScreen = '/updateMissingInfoScreen';
  static const phoneVerificationScreen = '/phoneVerificationScreen';
  static const homeScreen = '/homeScreen';
  static const fullImageScreen = '/fullImageScreen';
  static const updateProfileScreen = '/updateProfileScreen';
  static const checkExistingChatScreen = '/checkExistingChatScreen';
  static const chatMessagesScreen = '/chatMessagesScreen';
  static const createPostScreen = '/createPostScreen';
  static const postCommentsScreen = '/postCommentsScreen';
  static const helpMeScreen = '/helpMeScreen';
  static const alertMapScreen = '/alertMapScreen';
  static const trustListScreen = '/trustListScreen';
  static const deleteAccountScreen = '/deleteAccountScreen';
  static const confirmDeleteAccountScreen = '/confirmDeleteAccountScreen';
  static const reviewScreen = '/reviewScreen';
  static const chatsScreen = '/chatsScreen';
  static const followingUsers = '/followingUsers';
  static const followersUsers = '/followersUsers';

  static final routes = {
    splashScreen: (_) => const SplashScreen(),
    onBoardingScreen: (_) => const OnboardingScreen(),
    signInScreen: (_) => const SignInScreen(),
    signUpScreen: (_) => const SignUpScreen(),
    forgotPasswordScreen: (_) => const ResetPasswordScreen(),
    updateMissingInfoScreen: (_) => const UpdateMissingInfoScreen(),
    phoneVerificationScreen: (_) => const PhoneVerificationScreen(),
    homeScreen: (_) => const HomeScreen(),
    fullImageScreen: (_) => const PostFullScreenImage(),
    updateProfileScreen: (_) => const UpdateProfileScreen(),
    checkExistingChatScreen: (_) => const CheckExistingChatScreen(),
    chatMessagesScreen: (_) => const ChatMessagesScreen(),
    createPostScreen: (_) => const CreatePostScreen(),
    postCommentsScreen: (_) => PostCommentsScreen(),
    helpMeScreen: (_) => const HelpMeScreen(),
    alertMapScreen: (_) => const AlertMapScreen(),
    trustListScreen: (_) => TrustListScreen(),
    deleteAccountScreen: (_) => const DeleteAccountScreen(),
    confirmDeleteAccountScreen: (_) => ConfirmDeleteAccountScreen(),
    reviewScreen: (_) => const ReviewScreen(),
    chatsScreen: (_) => const ChatsScreen(),
    followingUsers: (_) => FollowingScreen(),
    followersUsers: (_) => FollowersScreen(),
  };
}
