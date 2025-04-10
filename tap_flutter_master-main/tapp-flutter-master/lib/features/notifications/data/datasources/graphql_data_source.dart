import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/exceptions.dart';
import 'package:tapp/features/notifications/data/models/notification_model.dart';

abstract class INotificationsGraphqlDataSource {
  Future<List<TappNotificationModel>> getNotifications(String uid);
  Future<void> reportUser(Map<String, dynamic> data);
}

@Injectable(as: INotificationsGraphqlDataSource)
class NotificationsGraphqlDataSource
    implements INotificationsGraphqlDataSource {
  final GraphQLClient _graphQLClient;

  NotificationsGraphqlDataSource(this._graphQLClient);

  @override
  Future<List<TappNotificationModel>> getNotifications(String uid) async {
    const query = """
      query(\$userId: ID!) {
        notifications(userId: \$userId) {
          date
          from
          id
          msg
          notificationType
          title
          extras
        }
      }
    """;

    final options = QueryOptions(
      document: gql(query),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {'userId': uid},
    );

    final response = await _graphQLClient.query(options);

    if (!response.hasException) {
      final List<dynamic> list = response.data!['notifications'];
      final notifications =
          list.map((n) => TappNotificationModel.fromJson(n)).toList();

      notifications.sort((a, b) => b.date.compareTo(a.date));

      return notifications;
    } else {
      throw GraphqlServerException(
        'Ocurrió un error al obtener las notificaciones, inténtalo más tarde.',
      );
    }
  }

  @override
  Future<void> reportUser(Map<String, dynamic> data) async {
    const mutation = """
      mutation(\$data: NewReportInput!){
        reportUser(data: \$data)
      }
    """;

    final options = MutationOptions(
      document: gql(mutation),
      variables: data,
    );

    final response = await _graphQLClient.mutate(options);

    if (!response.hasException) {
      return;
    } else {
      throw GraphqlServerException(
        'Error al reportar al usuario de la notificación, intenta más tarde.',
      );
    }
  }
}
