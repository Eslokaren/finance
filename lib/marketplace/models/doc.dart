import 'dart:convert';

import 'package:finance/marketplace/models/publisher.dart';

class Doc {
  Doc._({
    this.userId,
    this.type,
    this.id,
    this.author,
    this.duration,
    this.thumbnail,
    this.price,
    this.docIsPaid,
    this.visibility,
    this.youLikedThis,
    this.youSavedThis,
    this.youDownloadedThis,
    this.youCommentedThis,
    this.docYouFollowThisProfile,
    this.thisProfileFollowsYou,
    this.youHaveThisProfileInFavorites,
    this.thisProfileHasYouInFavorites,
    this.youAreSubscribedToThisProfile,
    this.thisProfileIsSubscribedToYou,
    this.youBoughtThis,
    this.likes,
    this.comments,
    this.views,
    this.isPaid,
    this.hasInformation,
    this.youFollowThisProfile,
    this.canSeeMedia,
    this.publisher,
    this.file,
    this.canLike,
    this.canComment,
    this.canShare,
    this.viewed,
    this.title,
    this.hasRequestedAccess,
  });

  int? userId;
  String? type;
  int? id;
  int? duration;
  String? author;
  String? thumbnail;
  double? price;
  bool? docIsPaid;
  String? visibility;
  bool? youLikedThis;
  bool? youSavedThis;
  bool? youDownloadedThis;
  bool? youCommentedThis;
  bool? docYouFollowThisProfile;
  bool? thisProfileFollowsYou;
  bool? youHaveThisProfileInFavorites;
  bool? thisProfileHasYouInFavorites;
  bool? youAreSubscribedToThisProfile;
  bool? thisProfileIsSubscribedToYou;
  bool? youBoughtThis;
  int? likes;
  int? comments;
  int? views;
  bool? isPaid;
  bool? hasInformation;
  bool? youFollowThisProfile;
  bool? canSeeMedia;
  Publisher? publisher;
  String? file;
  bool? canLike;
  bool? canComment;
  bool? canShare;
  bool? viewed;
  String? title;
  bool? hasRequestedAccess;

  Doc copyWith({
    int? userId,
    String? type,
    int? id,
    String? author,
    int? duration,
    String? thumbnail,
    double? price,
    bool? docIsPaid,
    String? visibility,
    bool? youLikedThis,
    bool? youSavedThis,
    bool? youDownloadedThis,
    bool? youCommentedThis,
    bool? docYouFollowThisProfile,
    bool? thisProfileFollowsYou,
    bool? youHaveThisProfileInFavorites,
    bool? thisProfileHasYouInFavorites,
    bool? youAreSubscribedToThisProfile,
    bool? thisProfileIsSubscribedToYou,
    bool? youBoughtThis,
    int? likes,
    int? comments,
    int? views,
    bool? isPaid,
    bool? hasInformation,
    bool? youFollowThisProfile,
    bool? canSeeMedia,
    Publisher? publisher,
    String? file,
    bool? canLike,
    bool? canComment,
    bool? canShare,
    bool? viewed,
    String? title,
    bool? hasRequestedAccess,
  }) =>
      Doc._(
        userId: userId ?? this.userId,
        type: type ?? this.type,
        id: id ?? this.id,
        author: author ?? this.author,
        duration: duration ?? this.duration,
        thumbnail: thumbnail ?? this.thumbnail,
        price: price ?? this.price,
        docIsPaid: docIsPaid ?? this.docIsPaid,
        visibility: visibility ?? this.visibility,
        youLikedThis: youLikedThis ?? this.youLikedThis,
        youSavedThis: youSavedThis ?? this.youSavedThis,
        youDownloadedThis: youDownloadedThis ?? this.youDownloadedThis,
        youCommentedThis: youCommentedThis ?? this.youCommentedThis,
        docYouFollowThisProfile:
            docYouFollowThisProfile ?? this.docYouFollowThisProfile,
        thisProfileFollowsYou:
            thisProfileFollowsYou ?? this.thisProfileFollowsYou,
        youHaveThisProfileInFavorites:
            youHaveThisProfileInFavorites ?? this.youHaveThisProfileInFavorites,
        thisProfileHasYouInFavorites:
            thisProfileHasYouInFavorites ?? this.thisProfileHasYouInFavorites,
        youAreSubscribedToThisProfile:
            youAreSubscribedToThisProfile ?? this.youAreSubscribedToThisProfile,
        thisProfileIsSubscribedToYou:
            thisProfileIsSubscribedToYou ?? this.thisProfileIsSubscribedToYou,
        youBoughtThis: youBoughtThis ?? this.youBoughtThis,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        views: views ?? this.views,
        isPaid: isPaid ?? this.isPaid,
        hasInformation: hasInformation ?? this.hasInformation,
        youFollowThisProfile: youFollowThisProfile ?? this.youFollowThisProfile,
        canSeeMedia: canSeeMedia ?? this.canSeeMedia,
        publisher: publisher ?? this.publisher,
        file: file ?? this.file,
        canLike: canLike ?? this.canLike,
        canComment: canComment ?? this.canComment,
        canShare: canShare ?? this.canShare,
        viewed: viewed ?? this.viewed,
        title: title ?? this.title,
        hasRequestedAccess: hasRequestedAccess ?? this.hasRequestedAccess,
      );

  get isOnlyFansAndSubscribe =>
      visibility == "only_my_fans" && (youAreSubscribedToThisProfile ?? false);

  get isOnlyFan => visibility == "only_my_fans";
  get isOnlyFollowers => visibility == "only_my_followers";

  bool canSeeMedia1(bool isMyself) {
    if (!isMyself) {
      if (isOnlyFollowers && !(docYouFollowThisProfile ?? false))
        return false;
      else if ((hasPrice && !(youBoughtThis ?? false)) &&
          (isOnlyFan && !(youAreSubscribedToThisProfile ?? false)))
        return false;
      else if (hasPrice && !(youBoughtThis ?? false) && !isOnlyFan)
        return false;
      else if (isOnlyFan &&
          !(youAreSubscribedToThisProfile ?? false) &&
          !hasPrice)
        return false;
      else
        return true;
    } else {
      return true;
    }
  }

  bool get hasPrice => (price ?? 0.0) > 0.0;

  factory Doc.fromJson(String str) => Doc.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Doc.fromMap(Map<dynamic, dynamic> json) => Doc._(
        userId: json["user_id"],
        type: json["type"],
        id: json["uid"],
        author: json["author"],
        duration: json["duration"],
        thumbnail: json["thumbnail"],
        price: json["price"] == null ? 0.0 : json["price"]?.toDouble(),
        docIsPaid: json["is_paid"],
        visibility: json["visibility"],
        youLikedThis: json["you_liked_this"],
        youSavedThis: json["you_saved_this"],
        youDownloadedThis: json["you_downloaded_this"],
        youCommentedThis: json["you_commented_this"],
        docYouFollowThisProfile: json["you_follow_this_profile"],
        thisProfileFollowsYou: json["this_profile_follows_you"],
        youHaveThisProfileInFavorites:
            json["you_have_this_profile_in_favorites"],
        thisProfileHasYouInFavorites: json["this_profile_has_you_in_favorites"],
        youAreSubscribedToThisProfile:
            json["you_are_subscribed_to_this_profile"],
        thisProfileIsSubscribedToYou: json["this_profile_is_subscribed_to_you"],
        youBoughtThis: json["you_bought_this"],
        likes: json["likes"],
        comments: json["lenOfComments"],
        views: json["views"],
        isPaid: json["isPaid"],
        hasInformation: json["hasInformation"],
        youFollowThisProfile: json["youFollowThisProfile"],
        canSeeMedia: json["canSeeMedia"],
        publisher: Publisher.fromMap(json["publisher"] ?? {}),
        file: json["file"],
        canShare: json["can_share"],
        canComment: json["can_comment"],
        canLike: json["can_like"],
        viewed: json["viewed"],
        title: json["title"],
        hasRequestedAccess: json["has_requested_access"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "type": type,
        "uid": id,
        "author": author,
        "duration": duration,
        "thumbnail": thumbnail,
        "price": price,
        "is_paid": docIsPaid,
        "visibility": visibility,
        "you_liked_this": youLikedThis,
        "you_saved_this": youSavedThis,
        "you_downloaded_this": youDownloadedThis,
        "you_commented_this": youCommentedThis,
        "you_follow_this_profile": docYouFollowThisProfile,
        "this_profile_follows_you": thisProfileFollowsYou,
        "you_have_this_profile_in_favorites": youHaveThisProfileInFavorites,
        "this_profile_has_you_in_favorites": thisProfileHasYouInFavorites,
        "you_are_subscribed_to_this_profile": youAreSubscribedToThisProfile,
        "this_profile_is_subscribed_to_you": thisProfileIsSubscribedToYou,
        "you_bought_this": youBoughtThis,
        "likes": likes,
        "lenOfComments": comments,
        "views": views,
        "isPaid": isPaid,
        "hasInformation": hasInformation,
        "youFollowThisProfile": youFollowThisProfile,
        "canSeeMedia": canSeeMedia,
        "publisher": publisher?.toMap(),
        "file": file,
        "can_share": canShare,
        "can_comment": canComment,
        "can_like": canLike,
        "viewed": viewed,
        "title": title,
        "has_requested_access": hasRequestedAccess,
      };
}
