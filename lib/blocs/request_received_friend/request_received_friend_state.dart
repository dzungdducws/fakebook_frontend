import 'package:equatable/equatable.dart';
import 'package:fakebook_frontend/models/request_received_friend_model.dart';

enum RequestReceivedFriendStatus { initial, loading, success, failure }

class RequestReceivedFriendState extends Equatable {
  final FriendRequestReceivedList friendRequestReceivedList;

  RequestReceivedFriendState(
      {
        required this.friendRequestReceivedList
      }
      );

  RequestReceivedFriendState.initial()
      : friendRequestReceivedList = FriendRequestReceivedList.initial();



  RequestReceivedFriendState copyWith({
    FriendRequestReceivedList? requestReceivedFriendList,
  }) {
    return RequestReceivedFriendState(
      friendRequestReceivedList: friendRequestReceivedList ?? this.friendRequestReceivedList,
    );
  }

  @override
  String toString() {
    return 'RequestReceivedFriendState{RequestReceivedFriendList: $friendRequestReceivedList}';
  }

  @override
  List<Object> get props => [friendRequestReceivedList];
}
