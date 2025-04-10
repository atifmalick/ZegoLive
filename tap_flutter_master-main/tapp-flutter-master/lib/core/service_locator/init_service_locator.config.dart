// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i3;
import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:graphql/client.dart' as _i9;
import 'package:graphql_flutter/graphql_flutter.dart' as _i6;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart' as _i30;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i45;
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/live_stream_cubit.dart';
import 'package:tapp/live_stream_service.dart';

import '../../features/auth/data/datasources/firebase_data_source.dart' as _i7;
import '../../features/auth/data/datasources/graphql_data_source.dart' as _i8;
import '../../features/auth/data/repositories/auth_repository.dart' as _i11;
import '../../features/auth/domain/repositories/i_auth_repository.dart' as _i10;
import '../../features/auth/presentation/bloc/reset_password_bloc.dart' as _i40;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i63;
import '../../features/auth/presentation/cubit/phone_verification/phone_verification_cubit.dart'
    as _i64;
import '../../features/auth/presentation/cubit/reset_password/reset_password_cubit.dart'
    as _i69;
import '../../features/auth/presentation/cubit/sign_in/sign_in_cubit.dart'
    as _i65;
import '../../features/auth/presentation/cubit/sign_up/sign_up_cubit.dart'
    as _i66;
import '../../features/chats/data/datasources/graphql_data_source.dart' as _i12;
import '../../features/chats/data/repositories/chats_repository.dart' as _i14;
import '../../features/chats/domain/repositories/chats_repository.dart' as _i13;
import '../../features/chats/presentation/cubit/chats/chats_cubit.dart' as _i52;
import '../../features/chats/presentation/cubit/messages/messages_cubit.dart'
    as _i34;
import '../../features/chats/presentation/cubit/send_message/send_message_cubit.dart'
    as _i42;
import '../../features/feed/data/datasources/graphql_data_source.dart' as _i15;
import '../../features/feed/data/repositories/feed_repository.dart' as _i17;
import '../../features/feed/domain/repositories/i_feed_repository.dart' as _i16;
import '../../features/feed/presentation/cubit/add_comment/add_comment_cubit.dart'
    as _i49;
import '../../features/feed/presentation/cubit/block_user/block_user_cubit.dart'
    as _i51;
import '../../features/feed/presentation/cubit/comments/comments_cubit.dart'
    as _i53;
import '../../features/feed/presentation/cubit/create_post/create_post_cubit.dart'
    as _i54;
import '../../features/feed/presentation/cubit/delete_post/delete_post_cubit.dart'
    as _i56;
import '../../features/feed/presentation/cubit/follow_unfollow/folllow_unfollow_cubit.dart'
    as _i58;
import '../../features/feed/presentation/cubit/like_dislike/like_dislike_cubit.dart'
    as _i32;
import '../../features/feed/presentation/cubit/posts/posts_cubit.dart' as _i36;
import '../../features/feed/presentation/cubit/report_post/report_post_cubit.dart'
    as _i38;
import '../../features/feed/presentation/cubit/share_post/share_post_cubit.dart'
    as _i44;
import '../../features/help_me/data/data/graphql_data_source.dart' as _i18;
import '../../features/help_me/data/repositories/help_me_repository.dart'
    as _i20;
import '../../features/help_me/domain/repositories/i_help_me_repository.dart'
    as _i19;
import '../../features/help_me/presentation/cubit/send_help_me_alert/send_help_me_alert_cubit.dart'
    as _i41;
import '../../features/location/presentation/cubit/location_cubit.dart' as _i61;
import '../../features/notifications/data/datasources/graphql_data_source.dart'
    as _i21;
import '../../features/notifications/data/repositories/notifications_repository.dart'
    as _i23;
import '../../features/notifications/domain/repositories/notifications_repository.dart'
    as _i22;
import '../../features/notifications/presentation/cubit/firebase_notifications/firebase_notifications_cubit.dart'
    as _i57;
import '../../features/notifications/presentation/cubit/notifications/notifications_cubit.dart'
    as _i35;
import '../../features/notifications/presentation/cubit/report_user_notification/report_user_notification_cubit.dart'
    as _i39;
import '../../features/profile/data/datasources/graphql_data_source.dart'
    as _i24;
import '../../features/profile/data/repositories/profile_repository.dart'
    as _i26;
import '../../features/profile/domain/repositories/i_profile_repository.dart'
    as _i25;
import '../../features/profile/presentation/cubit/add_user_to_trust_list/add_user_to_trust_list_cubit.dart'
    as _i50;
import '../../features/profile/presentation/cubit/delete_account/delete_account_cubit.dart'
    as _i55;
import '../../features/profile/presentation/cubit/followers_cubit/following_cubit.dart'
    as _i59;
import '../../features/profile/presentation/cubit/following/following_cubit.dart'
    as _i60;
import '../../features/profile/presentation/cubit/following/unfollow_cubit.dart'
    as _i47;
import '../../features/profile/presentation/cubit/profile/profile_cubit.dart'
    as _i62;
import '../../features/profile/presentation/cubit/remove_user_from_trust_list/remove_user_from_trust_list_cubit.dart'
    as _i37;
import '../../features/profile/presentation/cubit/trustList/trust_list_cubit.dart'
    as _i46;
import '../../features/profile/presentation/cubit/update_profile/update_profile_cubit.dart'
    as _i48;
import '../../features/review/data/datasources/graphql_data_source.dart'
    as _i27;
import '../../features/review/data/repositories/review_repository.dart' as _i29;
import '../../features/review/domain/repositories/review_repository.dart'
    as _i28;
import '../../features/review/presentation/cubit/send_review_cubit.dart'
    as _i43;
import '../services/image_picker_service.dart' as _i31;
import '../services/location_service.dart' as _i33;
import 'third_party_module.dart'
    as _i67; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyModule = _$ThirdPartyModule();
  gh.lazySingleton<_i3.Dio>(() => thirdPartyModule.dio);
  gh.lazySingleton<_i4.FirebaseAuth>(() => thirdPartyModule.firebaseAuth);
  gh.lazySingleton<_i5.FlutterLocalNotificationsPlugin>(
      () => thirdPartyModule.flutterLocalNotificationsPlugin);
  gh.factory<_i6.GraphQLClient>(() => thirdPartyModule.graphqlClient);
  gh.factory<_i7.IAuthFirebaseDataSource>(
      () => _i7.AuthFirebaseDataSource(get<_i4.FirebaseAuth>()));
  gh.factory<_i8.IAuthGraphqlDataSource>(
      () => _i8.AuthGraphqlDataSource(get<_i9.GraphQLClient>()));
  gh.lazySingleton<_i10.IAuthRepository>(() => _i11.AuthRepository(
      get<_i7.IAuthFirebaseDataSource>(), get<_i8.IAuthGraphqlDataSource>()));
  gh.factory<_i12.IChatsGraphqlDataSource>(
      () => _i12.ChatsGraphqlDataSource(get<_i9.GraphQLClient>()));
  gh.lazySingleton<_i13.IChatsRepository>(
      () => _i14.ChatsRepository(get<_i12.IChatsGraphqlDataSource>()));
  gh.factory<_i15.IFeedGraphqlDataSource>(
      () => _i15.FeedGraphqlDataSource(get<_i9.GraphQLClient>()));
  gh.lazySingleton<_i16.IFeedRepository>(
      () => _i17.FeedRepository(get<_i15.IFeedGraphqlDataSource>()));
  gh.factory<_i18.IHelpMeGraphqlDataSource>(
      () => _i18.HelpMeGraphqlDataSource(get<_i9.GraphQLClient>()));
  gh.lazySingleton<_i19.IHelpMeRepository>(
      () => _i20.HelpMeRepository(get<_i18.IHelpMeGraphqlDataSource>()));
  gh.factory<_i21.INotificationsGraphqlDataSource>(
      () => _i21.NotificationsGraphqlDataSource(get<_i9.GraphQLClient>()));
  gh.lazySingleton<_i22.INotificationsRepository>(() =>
      _i23.NotificationsRepository(
          get<_i21.INotificationsGraphqlDataSource>()));
  gh.factory<_i24.IProfileGraphqlDataSource>(
      () => _i24.ProfileGraphqlDataSource(get<_i9.GraphQLClient>()));
  gh.lazySingleton<_i25.IProfileRepository>(
      () => _i26.ProfileRepository(get<_i24.IProfileGraphqlDataSource>()));
  gh.factory<_i27.IReviewGraphqlDataSource>(
      () => _i27.ReviewGraphqlDataSource(get<_i9.GraphQLClient>()));
  gh.factory<_i28.IReviewRepository>(
      () => _i29.ReviewRepository(get<_i27.IReviewGraphqlDataSource>()));
  gh.factory<_i30.ImagePicker>(() => thirdPartyModule.imagePicker);
  gh.factory<_i31.ImagePickerService>(
      () => _i31.ImagePickerService(get<_i30.ImagePicker>()));
  gh.factory<_i32.LikeDislikeCubit>(
      () => _i32.LikeDislikeCubit(get<_i16.IFeedRepository>()));
  gh.lazySingleton<_i33.LocationService>(() => _i33.LocationService());
  gh.factory<_i34.MessagesCubit>(
      () => _i34.MessagesCubit(get<_i13.IChatsRepository>()));
  gh.factory<_i35.NotificationsCubit>(
      () => _i35.NotificationsCubit(get<_i22.INotificationsRepository>()));
  gh.factory<_i36.PostsCubit>(
      () => _i36.PostsCubit(get<_i16.IFeedRepository>()));
  gh.factory<_i37.RemoveUserFromTrustListCubit>(
      () => _i37.RemoveUserFromTrustListCubit(get<_i25.IProfileRepository>()));
  gh.factory<_i38.ReportPostCubit>(
      () => _i38.ReportPostCubit(get<_i16.IFeedRepository>()));
  gh.factory<_i39.ReportUserNotificationCubit>(() =>
      _i39.ReportUserNotificationCubit(get<_i22.INotificationsRepository>()));
  gh.factory<_i40.ResetPasswordBloc>(
      () => _i40.ResetPasswordBloc(get<_i10.IAuthRepository>()));
  gh.factory<_i41.SendHelpMeAlertCubit>(
      () => _i41.SendHelpMeAlertCubit(get<_i19.IHelpMeRepository>()));
  gh.factory<_i42.SendMessageCubit>(
      () => _i42.SendMessageCubit(get<_i13.IChatsRepository>()));
  gh.factory<_i43.SendReviewCubit>(
      () => _i43.SendReviewCubit(get<_i28.IReviewRepository>()));

  gh.factory<_i44.SharePostCubit>(() => _i44.SharePostCubit(get<_i3.Dio>()));
  await gh.lazySingletonAsync<_i45.SharedPreferences>(
      () => thirdPartyModule.prefs,
      preResolve: true);
  gh.factory<_i46.TrustListCubit>(
      () => _i46.TrustListCubit(get<_i25.IProfileRepository>()));
  gh.factory<_i47.UnfollowUserCubit>(
      () => _i47.UnfollowUserCubit(get<_i16.IFeedRepository>()));

  gh.factory<_i48.UpdateProfileCubit>(
      () => _i48.UpdateProfileCubit(get<_i25.IProfileRepository>()));
  gh.factory<_i49.AddCommentCubit>(
      () => _i49.AddCommentCubit(get<_i16.IFeedRepository>()));
  gh.factory<_i50.AddUserToTrustListCubit>(
      () => _i50.AddUserToTrustListCubit(get<_i25.IProfileRepository>()));
  gh.factory<_i51.BlockUserCubit>(
      () => _i51.BlockUserCubit(get<_i16.IFeedRepository>()));
  gh.lazySingleton<_i52.ChatsCubit>(
      () => _i52.ChatsCubit(get<_i13.IChatsRepository>()));
  gh.factory<_i53.CommentsCubit>(
      () => _i53.CommentsCubit(get<_i16.IFeedRepository>()));
  gh.factory<_i54.CreatePostCubit>(
      () => _i54.CreatePostCubit(get<_i16.IFeedRepository>()));
  gh.factory<_i55.DeleteAccountCubit>(
      () => _i55.DeleteAccountCubit(get<_i10.IAuthRepository>()));
  gh.factory<_i56.DeletePostCubit>(
      () => _i56.DeletePostCubit(get<_i16.IFeedRepository>()));
  gh.lazySingleton<_i57.FirebaseNotificationsCubit>(() =>
      _i57.FirebaseNotificationsCubit(
          get<_i5.FlutterLocalNotificationsPlugin>()));
  gh.factory<_i58.FollowUnfollowCubit>(
      () => _i58.FollowUnfollowCubit(get<_i16.IFeedRepository>()));
  gh.factory<_i59.FollowersCubit>(
      () => _i59.FollowersCubit(get<_i25.IProfileRepository>()));

  gh.factory<_i60.FollowingCubit>(
      () => _i60.FollowingCubit(get<_i25.IProfileRepository>()));
  gh.lazySingleton<_i61.LocationCubit>(
      () => _i61.LocationCubit(get<_i33.LocationService>()));
  gh.lazySingleton<_i62.ProfileCubit>(() => _i62.ProfileCubit(
      get<_i25.IProfileRepository>(), get<_i57.FirebaseNotificationsCubit>()));
  gh.lazySingleton<_i63.AuthCubit>(() => _i63.AuthCubit(
      get<_i10.IAuthRepository>(),
      get<_i57.FirebaseNotificationsCubit>(),
      get<_i45.SharedPreferences>(),
      get<_i25.IProfileRepository>()));
  gh.factory<_i64.PhoneVerificationCubit>(() => _i64.PhoneVerificationCubit(
      get<_i10.IAuthRepository>(),
      get<_i63.AuthCubit>(),
      get<_i62.ProfileCubit>()));
  gh.factory<_i65.SignInCubit>(() =>
      _i65.SignInCubit(get<_i10.IAuthRepository>(), get<_i63.AuthCubit>()));

  gh.factory<_i69.ResetPasswordCubit>(() => _i69.ResetPasswordCubit(
      get<_i10.IAuthRepository>(), get<_i63.AuthCubit>()));

  // Register LiveStreamService with the registered GraphQLClient
  getIt.registerLazySingleton<LiveStreamService>(
    () => LiveStreamService(getIt<GraphQLClient>()),
  );

  // Now register LiveStreamCubit with LiveStreamService dependency
  getIt.registerFactory<LiveStreamCubit>(
    () => LiveStreamCubit(getIt<LiveStreamService>()),
  );

  gh.factory<_i66.SignUpCubit>(() =>
      _i66.SignUpCubit(get<_i10.IAuthRepository>(), get<_i65.SignInCubit>()));
  return get;
}

class _$ThirdPartyModule extends _i67.ThirdPartyModule {}
