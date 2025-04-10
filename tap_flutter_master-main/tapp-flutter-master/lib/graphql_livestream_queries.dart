const String startNewStreamMutation = r'''
mutation StartNewStream($input: NewPostInput!) {
  startNewStream(data: $input) {
    postId
    message
    userToken
    streamingID
    isStream
    isStreamLive
    recordingUrl
    coordinates {
      latitude
      longitude
    }
  }
}
''';

const String joinStreamMutation = r'''
mutation JoinStream($input: NewPostInput!) {
  joinStream(data: $input) {
    id
    streamUrl
    userId
    joinedAt
  }
}
''';

const String endStreamMutation = r'''
mutation EndStream($input: EndStreamInput!) {
  endStream(data: $input) {
    success
  }
}
''';