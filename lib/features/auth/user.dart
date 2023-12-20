import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final bool? isAdmin;
  final String? displayName;
  final List<String>? forumIds;
  final List<String>? readingListsId;

  UserData(
      {this.isAdmin, this.displayName, this.forumIds, this.readingListsId});

  factory UserData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserData(
      isAdmin: data?['isAdmin'],
      displayName: data?['displayName'],
      forumIds: data?['ReadingListsId'] is Iterable
          ? List.from(data?['ForumIds'])
          : null,
      readingListsId: data?['ReadingListsId'] is Iterable
          ? List.from(data?['ReadingListsId'])
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (isAdmin != null) "isAdmin": isAdmin,
      if (displayName != null) "displayName": displayName,
      if (forumIds != null) "forumIds": forumIds,
      if (readingListsId != null) "readingListsId": readingListsId
    };
  }

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
        isAdmin: data['isAdmin'] as bool,
        displayName: data['displayName'] as String,
        forumIds: data['forumIds'] as List<String>,
        readingListsId: data['readingListsId'] as List<String>);
  }

  Map<String, dynamic> toMap() => {
        'isAdmin': isAdmin,
        'displayName': displayName,
        'forumIds': forumIds,
        'readingListsId': readingListsId
      };

  Map toJson() => {
        'isAdmin': isAdmin,
        'displayName': displayName,
        'forumIds': forumIds,
        'readingListsId': readingListsId
      };
}
