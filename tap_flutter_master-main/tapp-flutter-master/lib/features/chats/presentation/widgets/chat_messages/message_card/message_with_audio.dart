// import 'package:flutter/material.dart';
// import 'package:tapp/features/chats/domain/entities/message.dart';
// import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_card/audio_preview.dart';
// import 'package:tapp/features/chats/presentation/widgets/chat_messages/message_card/message_text.dart';

// class MessageWithAudio extends StatelessWidget {
//   final Alignment alignment;
//   final Radius bottomLeft;
//   final Radius bottomRight;
//   final Color background;
//   final Color textColor;
//   final Message message;

//   const MessageWithAudio({
//     @required this.alignment,
//     @required this.bottomLeft,
//     @required this.bottomRight,
//     @required this.background,
//     @required this.textColor,
//     @required this.message,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Align(
//           alignment: alignment,
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             child: Card(
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(25),
//                   topRight: Radius.circular(25),
//                   bottomLeft: bottomLeft,
//                   bottomRight: bottomRight,
//                 ),
//               ),
//               color: background,
//               child: Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: AudioPreview(
//                   url: message.content.url,
//                   textColor: textColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         message.message.isNotEmpty
//             ? MessageText(
//                 alignment: alignment,
//                 bottomLeft: bottomLeft,
//                 bottomRight: bottomRight,
//                 background: background,
//                 textColor: textColor,
//                 message: message,
//               )
//             : SizedBox(),
//       ],
//     );
//   }
// }
