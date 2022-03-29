import 'dart:convert';

class MediaDetails {
  MediaDetails({
    this.id,
    this.location,
    this.licenseOwner,
    this.musicBy,
    this.composers,
    this.makeupArtists,
    this.photographers,
    this.mediaModels,
    this.photographyDirectors,
    this.actorsOrTalents,
    this.stylists,
    this.directors,
    this.singers,
    this.skills,
    this.categories,
    this.description,
    this.publisher,
    this.premiereDate,
    this.dateTaken,
    this.releaseDate,
    this.isPaid,
    this.userId,
    this.shares,
    this.likes,
    this.comments,
    this.views,
    this.canSeeMedia,
    this.socialLinks,
    this.websites,
    this.type,
    this.title,
    this.publicationDate,
    this.youLikedThis,
    this.youAreSubscribedToThisProfile,
    this.youBoughtThis,
    this.price,
    this.visibility,
  });

  final int? id;
  final Location? location;
  final Profile? licenseOwner;
  final List? musicBy;
  final List? composers;
  final List? makeupArtists;
  final List? photographers;
  final List? mediaModels;
  final List? photographyDirectors;
  final List? actorsOrTalents;
  final List? stylists;
  final List? directors;
  final List? singers;
  final List? skills;
  final List? categories;
  final String? visibility;
  final String? description;
  final String? publisher;
  final DateTime? premiereDate;
  final DateTime? dateTaken;
  final DateTime? releaseDate;
  final int? price;
  final bool? isPaid;
  final int? userId;
  final int? shares;
  final int? likes;
  final int? comments;
  final int? views;
  final bool? canSeeMedia;
  final List<String>? socialLinks;
  final List<String>? websites;
  final String? type;
  final String? title;
  final DateTime? publicationDate;
  final bool? youLikedThis;
  final bool? youAreSubscribedToThisProfile;
  final bool? youBoughtThis;

  MediaDetails copyWith({
    int? id,
    Location? location,
    Profile? licenseOwner,
    List<Profile>? musicBy,
    List<Profile>? composers,
    List<Profile>? photographers,
    List<Profile>? mediaModels,
    List<Profile>? photographyDirectors,
    List<Profile>? actorsOrTalents,
    List<Profile>? stylists,
    List<Profile>? directors,
    List<Profile>? singers,
    List<Profile>? skills,
    List<Profile>? categories,
    String? visibility,
    String? description,
    String? musicalGender,
    String? publisher,
    DateTime? premiereDate,
    DateTime? dateTaken,
    DateTime? releaseDate,
    bool? isPaid,
    int? userId,
    int? shares,
    int? likes,
    int? comments,
    int? views,
    bool? canSeeMedia,
    List<String>? socialLinks,
    List<String>? websites,
    String? file,
    String? type,
    String? title,
    DateTime? publicationDate,
    int? price,
    DateTime? createdAt,
    bool? youLikedThis,
    bool? youFollowThisProfile,
    bool? youAreSubscribedToThisProfile,
    bool? youBoughtThis,
  }) =>
      MediaDetails(
        id: id ?? this.id,
        location: location ?? this.location,
        licenseOwner: licenseOwner ?? this.licenseOwner,
        musicBy: musicBy ?? this.musicBy,
        makeupArtists: makeupArtists ?? this.makeupArtists,
        photographers: photographers ?? this.photographers,
        mediaModels: mediaModels ?? this.mediaModels,
        photographyDirectors: photographyDirectors ?? this.photographyDirectors,
        actorsOrTalents: actorsOrTalents ?? this.actorsOrTalents,
        stylists: stylists ?? this.stylists,
        directors: directors ?? this.directors,
        singers: singers ?? this.singers,
        skills: skills ?? this.skills,
        categories: categories ?? this.categories,
        description: description ?? this.description,
        publisher: publisher ?? this.publisher,
        premiereDate: premiereDate ?? this.premiereDate,
        dateTaken: dateTaken ?? this.dateTaken,
        releaseDate: releaseDate ?? this.releaseDate,
        isPaid: isPaid ?? this.isPaid,
        userId: userId ?? this.userId,
        shares: shares ?? this.shares,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        views: views ?? this.views,
        canSeeMedia: canSeeMedia ?? this.canSeeMedia,
        socialLinks: socialLinks ?? this.socialLinks,
        websites: websites ?? this.websites,
        type: type ?? this.type,
        title: title ?? this.title,
        publicationDate: publicationDate ?? this.publicationDate,
        youLikedThis: youLikedThis ?? this.youLikedThis,
        youAreSubscribedToThisProfile:
            youAreSubscribedToThisProfile ?? this.youAreSubscribedToThisProfile,
        youBoughtThis: youBoughtThis ?? this.youBoughtThis,
      );

  factory MediaDetails.fromJson(String str) =>
      MediaDetails.fromMap(json.decode(str)['media']);

  factory MediaDetails.fromMap(json) {
    bool listIsNotEmpty(String key) {
      return json[key] != null && json[key].length > 0 ? true : false;
    }

    return MediaDetails(
      id: json["id"],
      location:
          json["location"] != null ? Location.fromMap(json["location"]) : null,
      licenseOwner: listIsNotEmpty("license_owner")
          ? Profile.fromMap(json["license_owner"])
          : null,
      musicBy: listIsNotEmpty("music_by")
          ? List<Profile>.from(json["music_by"].map((x) => Profile.fromMap(x)))
          : null,
      makeupArtists: listIsNotEmpty("makeup_artists")
          ? List<Profile>.from(
              json["makeup_artists"].map((x) => Profile.fromMap(x)))
          : null,
      photographers: listIsNotEmpty("photographers")
          ? List<Profile>.from(
              json["photographers"].map((x) => Profile.fromMap(x)))
          : null,
      mediaModels: listIsNotEmpty("media_models")
          ? List<Profile>.from(
              json["media_models"].map((x) => Profile.fromMap(x)))
          : null,
      photographyDirectors: listIsNotEmpty("photography_directors")
          ? List<Profile>.from(
              json["photography_directors"].map((x) => Profile.fromMap(x)))
          : null,
      actorsOrTalents: listIsNotEmpty("actors_or_talents")
          ? List<Profile>.from(
              json["actors_or_talents"].map((x) => Profile.fromMap(x)))
          : null,
      stylists: listIsNotEmpty("stylists")
          ? List<Profile>.from(json["stylists"].map((x) => Profile.fromMap(x)))
          : null,
      directors: listIsNotEmpty("directors")
          ? List<Profile>.from(json["directors"].map((x) => Profile.fromMap(x)))
          : null,
      skills: listIsNotEmpty("skills")
          ? List<String>.from(json["skills"].map((x) => x["name"]))
          : null,
      categories: listIsNotEmpty("categories")
          ? List<String>.from(json["categories"].map((x) => x["name"]))
          : null,
      description: json["description"],
      // publisher: json["publisher"],
      premiereDate: json["premiere_date"] != null
          ? DateTime.tryParse(json["premiere_date"])
          : null,
      dateTaken: json["date_taken"] != null
          ? DateTime.tryParse(json["date_taken"])
          : null,
      releaseDate: json["release_date"] != null
          ? DateTime.tryParse(json["release_date"])
          : null,
      isPaid: json["is_paid"],
      userId: json["user_id"],
      shares: json["shares"],
      likes: json["likes"],
      comments: json["comments"],
      views: json["views"],
      canSeeMedia: json["can_see_media"],
      socialLinks: listIsNotEmpty("social_links")
          ? List<String>.from(json["social_links"].map((x) => x))
          : null,
      websites: listIsNotEmpty("websites")
          ? List<String>.from(json["websites"].map((x) => x))
          : null,
      type: json["type"],
      title: json["title"],
      publicationDate: json["publication_date"] != null
          ? DateTime.tryParse(json["publication_date"])
          : null,
      price: json["price"],
      youLikedThis: json["you_liked_this"],
      youAreSubscribedToThisProfile: json["you_are_subscribed_to_this_profile"],
      youBoughtThis: json["you_bought_this"],
    );
  }
  @override
  List<Object?> get props => [
        id,
        location,
        licenseOwner,
        musicBy,
        composers,
        makeupArtists,
        photographers,
        mediaModels,
        photographyDirectors,
        actorsOrTalents,
        stylists,
        directors,
        singers,
        skills,
        categories,
        visibility,
        description,
        publisher,
        premiereDate,
        dateTaken,
        releaseDate,
        isPaid,
        userId,
        shares,
        likes,
        comments,
        views,
        canSeeMedia,
        socialLinks,
        websites,
        type,
        title,
        publicationDate,
        price,
        youLikedThis,
        youAreSubscribedToThisProfile,
        youBoughtThis
      ];

  bool istNotEmpty() {
    var media = this;
    if ((media.description ?? '').isNotEmpty) return true;
    return (media.categories?.length ?? 0) > 0 ||
        (media.location?.address != null) ||
        ((media.skills?.length ?? 0) > 0) ||
        (media.dateTaken != null) ||
        ((media.websites?.length ?? 0) > 0) ||
        (media.licenseOwner?.id != null) ||
        ((media.type == 'video') && (media.actorsOrTalents?.length ?? 0) > 0) ||
        ((media.type == 'image') && (media.actorsOrTalents?.length ?? 0) > 0) ||
        ((media.type == 'image') && (media.makeupArtists?.length ?? 0) > 0) ||
        ((media.type == 'image') && (media.stylists?.length ?? 0) > 0) ||
        ((media.type == 'image') && (media.photographers?.length ?? 0) > 0) ||
        ((media.type == 'image') && (media.singers?.length ?? 0) > 0) ||
        ((media.type == 'video') &&
            (media.photographyDirectors?.length ?? 0) > 0) ||
        ((media.type == 'audio') && (media.composers?.length ?? 0) > 0) ||
        ((media.type == 'audio') && (media.musicBy?.length ?? 0) > 0);
  }

  bool canSeeMediaX(bool isMySelf) {
    bool canSeeMedia;
    bool isOnlyFans = visibility == "only_my_fans";
    bool isSubscribe = youAreSubscribedToThisProfile ?? false;
    bool isBought = youBoughtThis ?? true;
    bool hasPrice = (price ?? 0.0) > 0.0;
    if (!isMySelf) {
      if ((hasPrice && !isBought) && (isOnlyFans && !isSubscribe))
        canSeeMedia = false;
      else if (hasPrice && !isBought && !isOnlyFans)
        canSeeMedia = false;
      else if (isOnlyFans && !isSubscribe && !hasPrice)
        canSeeMedia = false;
      else
        canSeeMedia = true;
    } else {
      canSeeMedia = true;
    }
    return canSeeMedia;
  }
}

class Profile {
  Profile(
      {this.id,
      this.username,
      this.displayName,
      this.hasAvatar,
      this.avatar,
      this.gender});

  final int? id;
  final String? username;
  final String? displayName;
  final bool? hasAvatar;
  final String? avatar;
  final String? gender;

  Profile copyWith(
          {int? id,
          String? username,
          String? displayName,
          String? avatar,
          bool? hasAvatar,
          String? gender}) =>
      Profile(
          id: id ?? this.id,
          username: username ?? this.username,
          displayName: displayName ?? this.displayName,
          avatar: avatar ?? this.avatar,
          hasAvatar: hasAvatar ?? this.hasAvatar,
          gender: gender ?? this.gender);

  factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
      id: json["id"],
      username: json["username"],
      displayName: json["display_name"],
      hasAvatar: json["profile_has_avatar"],
      avatar: json["avatar"] != null ? json["avatar"]["file"] : null,
      gender: json["gender"]);
}

class Location {
  Location({
    this.address,
    this.country,
  });

  final String? address;
  final String? country;

  Location copyWith({
    String? address,
    String? country,
  }) =>
      Location(
        address: address ?? this.address,
        country: country ?? this.country,
      );

  factory Location.fromJson(String str) => Location.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        address: json["address"],
        country: json["country"],
      );

  Map<String, dynamic> toMap() => {
        "address": address,
        "country": country,
      };
}
