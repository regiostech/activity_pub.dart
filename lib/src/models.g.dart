// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class APObject implements _APObject {
  const APObject(
      {this.context = 'https://www.w3.org/ns/activitystreams',
      this.id,
      this.source,
      this.summary,
      this.type});

  @override
  final Uri context;

  @override
  final Uri id;

  @override
  final _Source source;

  @override
  final String summary;

  @override
  final String type;

  APObject copyWith(
      {Uri context, Uri id, _Source source, String summary, String type}) {
    return APObject(
        context: context ?? this.context,
        id: id ?? this.id,
        source: source ?? this.source,
        summary: summary ?? this.summary,
        type: type ?? this.type);
  }

  bool operator ==(other) {
    return other is _APObject &&
        other.context == context &&
        other.id == id &&
        other.source == source &&
        other.summary == summary &&
        other.type == type;
  }

  @override
  int get hashCode {
    return hashObjects([context, id, source, summary, type]);
  }

  @override
  String toString() {
    return "APObject(context=$context, id=$id, source=$source, summary=$summary, type=$type)";
  }

  Map<String, dynamic> toJson() {
    return APObjectSerializer.toMap(this);
  }
}

@generatedSerializable
class Activity implements _Activity {
  const Activity(
      {this.context = 'https://www.w3.org/ns/activitystreams',
      this.id,
      this.source,
      this.summary,
      this.type,
      this.actor});

  @override
  final Uri context;

  @override
  final Uri id;

  @override
  final _Source source;

  @override
  final String summary;

  @override
  final String type;

  @override
  final APActor actor;

  Activity copyWith(
      {Uri context,
      Uri id,
      _Source source,
      String summary,
      String type,
      APActor actor}) {
    return Activity(
        context: context ?? this.context,
        id: id ?? this.id,
        source: source ?? this.source,
        summary: summary ?? this.summary,
        type: type ?? this.type,
        actor: actor ?? this.actor);
  }

  bool operator ==(other) {
    return other is _Activity &&
        other.context == context &&
        other.id == id &&
        other.source == source &&
        other.summary == summary &&
        other.type == type &&
        other.actor == actor;
  }

  @override
  int get hashCode {
    return hashObjects([context, id, source, summary, type, actor]);
  }

  @override
  String toString() {
    return "Activity(context=$context, id=$id, source=$source, summary=$summary, type=$type, actor=$actor)";
  }

  Map<String, dynamic> toJson() {
    return ActivitySerializer.toMap(this);
  }
}

@generatedSerializable
class Actor implements _Actor {
  const Actor(
      {this.context = 'https://www.w3.org/ns/activitystreams',
      this.id,
      this.type,
      this.source,
      this.name,
      this.summary,
      this.inbox,
      this.outbox,
      this.following,
      this.followers,
      this.liked,
      this.preferredUsername});

  @override
  final Uri context;

  @override
  final Uri id;

  @override
  final String type;

  @override
  final _Source source;

  @override
  final String name;

  @override
  final String summary;

  @override
  final Uri inbox;

  @override
  final Uri outbox;

  @override
  final Uri following;

  @override
  final Uri followers;

  @override
  final Uri liked;

  @override
  final String preferredUsername;

  Actor copyWith(
      {Uri context,
      Uri id,
      String type,
      _Source source,
      String name,
      String summary,
      Uri inbox,
      Uri outbox,
      Uri following,
      Uri followers,
      Uri liked,
      String preferredUsername}) {
    return Actor(
        context: context ?? this.context,
        id: id ?? this.id,
        type: type ?? this.type,
        source: source ?? this.source,
        name: name ?? this.name,
        summary: summary ?? this.summary,
        inbox: inbox ?? this.inbox,
        outbox: outbox ?? this.outbox,
        following: following ?? this.following,
        followers: followers ?? this.followers,
        liked: liked ?? this.liked,
        preferredUsername: preferredUsername ?? this.preferredUsername);
  }

  bool operator ==(other) {
    return other is _Actor &&
        other.context == context &&
        other.id == id &&
        other.type == type &&
        other.source == source &&
        other.name == name &&
        other.summary == summary &&
        other.inbox == inbox &&
        other.outbox == outbox &&
        other.following == following &&
        other.followers == followers &&
        other.liked == liked &&
        other.preferredUsername == preferredUsername;
  }

  @override
  int get hashCode {
    return hashObjects([
      context,
      id,
      type,
      source,
      name,
      summary,
      inbox,
      outbox,
      following,
      followers,
      liked,
      preferredUsername
    ]);
  }

  @override
  String toString() {
    return "Actor(context=$context, id=$id, type=$type, source=$source, name=$name, summary=$summary, inbox=$inbox, outbox=$outbox, following=$following, followers=$followers, liked=$liked, preferredUsername=$preferredUsername)";
  }

  Map<String, dynamic> toJson() {
    return ActorSerializer.toMap(this);
  }
}

@generatedSerializable
class Source implements _Source {
  const Source({this.content, this.mediaType});

  @override
  final String content;

  @override
  final MediaType mediaType;

  Source copyWith({String content, MediaType mediaType}) {
    return Source(
        content: content ?? this.content,
        mediaType: mediaType ?? this.mediaType);
  }

  bool operator ==(other) {
    return other is _Source &&
        other.content == content &&
        other.mediaType == mediaType;
  }

  @override
  int get hashCode {
    return hashObjects([content, mediaType]);
  }

  @override
  String toString() {
    return "Source(content=$content, mediaType=$mediaType)";
  }

  Map<String, dynamic> toJson() {
    return SourceSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const APObjectSerializer aPObjectSerializer = APObjectSerializer();

class APObjectEncoder extends Converter<APObject, Map> {
  const APObjectEncoder();

  @override
  Map convert(APObject model) => APObjectSerializer.toMap(model);
}

class APObjectDecoder extends Converter<Map, APObject> {
  const APObjectDecoder();

  @override
  APObject convert(Map map) => APObjectSerializer.fromMap(map);
}

class APObjectSerializer extends Codec<APObject, Map> {
  const APObjectSerializer();

  @override
  get encoder => const APObjectEncoder();
  @override
  get decoder => const APObjectDecoder();
  static APObject fromMap(Map map) {
    return APObject(
        context: _contextFromString(map['@context']),
        id: _uriFromString(map['id']),
        source: map['source'] != null
            ? SourceSerializer.fromMap(map['source'] as Map)
            : null,
        summary: map['summary'] as String,
        type: map['type'] as String);
  }

  static Map<String, dynamic> toMap(_APObject model) {
    if (model == null) {
      return null;
    }
    return {
      '@context': _uriToString(model.context),
      'id': _uriToString(model.id),
      'source': SourceSerializer.toMap(model.source),
      'summary': model.summary,
      'type': model.type
    };
  }
}

abstract class APObjectFields {
  static const List<String> allFields = <String>[
    context,
    id,
    source,
    summary,
    type
  ];

  static const String context = '@context';

  static const String id = 'id';

  static const String source = 'source';

  static const String summary = 'summary';

  static const String type = 'type';
}

const ActivitySerializer activitySerializer = ActivitySerializer();

class ActivityEncoder extends Converter<Activity, Map> {
  const ActivityEncoder();

  @override
  Map convert(Activity model) => ActivitySerializer.toMap(model);
}

class ActivityDecoder extends Converter<Map, Activity> {
  const ActivityDecoder();

  @override
  Activity convert(Map map) => ActivitySerializer.fromMap(map);
}

class ActivitySerializer extends Codec<Activity, Map> {
  const ActivitySerializer();

  @override
  get encoder => const ActivityEncoder();
  @override
  get decoder => const ActivityDecoder();
  static Activity fromMap(Map map) {
    return Activity(
        context: _contextFromString(map['@context']),
        id: _uriFromString(map['id']),
        source: map['source'] != null
            ? SourceSerializer.fromMap(map['source'] as Map)
            : null,
        summary: map['summary'] as String,
        type: map['type'] as String,
        actor: _apActorFrom(map['actor']));
  }

  static Map<String, dynamic> toMap(_Activity model) {
    if (model == null) {
      return null;
    }
    return {
      '@context': _uriToString(model.context),
      'id': _uriToString(model.id),
      'source': SourceSerializer.toMap(model.source),
      'summary': model.summary,
      'type': model.type,
      'actor': _apActorTo(model.actor)
    };
  }
}

abstract class ActivityFields {
  static const List<String> allFields = <String>[
    context,
    id,
    source,
    summary,
    type,
    actor
  ];

  static const String context = '@context';

  static const String id = 'id';

  static const String source = 'source';

  static const String summary = 'summary';

  static const String type = 'type';

  static const String actor = 'actor';
}

const ActorSerializer actorSerializer = ActorSerializer();

class ActorEncoder extends Converter<Actor, Map> {
  const ActorEncoder();

  @override
  Map convert(Actor model) => ActorSerializer.toMap(model);
}

class ActorDecoder extends Converter<Map, Actor> {
  const ActorDecoder();

  @override
  Actor convert(Map map) => ActorSerializer.fromMap(map);
}

class ActorSerializer extends Codec<Actor, Map> {
  const ActorSerializer();

  @override
  get encoder => const ActorEncoder();
  @override
  get decoder => const ActorDecoder();
  static Actor fromMap(Map map) {
    return Actor(
        context: _contextFromString(map['@context']),
        id: _uriFromString(map['id']),
        type: map['type'] as String,
        source: map['source'] != null
            ? SourceSerializer.fromMap(map['source'] as Map)
            : null,
        name: map['name'] as String,
        summary: map['summary'] as String,
        inbox: map['inbox'] as Uri,
        outbox: map['outbox'] as Uri,
        following: map['following'] as Uri,
        followers: map['followers'] as Uri,
        liked: map['liked'] as Uri,
        preferredUsername: map['preferredUsername'] as String);
  }

  static Map<String, dynamic> toMap(_Actor model) {
    if (model == null) {
      return null;
    }
    return {
      '@context': _uriToString(model.context),
      'id': _uriToString(model.id),
      'type': model.type,
      'source': SourceSerializer.toMap(model.source),
      'name': model.name,
      'summary': model.summary,
      'inbox': model.inbox,
      'outbox': model.outbox,
      'following': model.following,
      'followers': model.followers,
      'liked': model.liked,
      'preferredUsername': model.preferredUsername
    };
  }
}

abstract class ActorFields {
  static const List<String> allFields = <String>[
    context,
    id,
    type,
    source,
    name,
    summary,
    inbox,
    outbox,
    following,
    followers,
    liked,
    preferredUsername
  ];

  static const String context = '@context';

  static const String id = 'id';

  static const String type = 'type';

  static const String source = 'source';

  static const String name = 'name';

  static const String summary = 'summary';

  static const String inbox = 'inbox';

  static const String outbox = 'outbox';

  static const String following = 'following';

  static const String followers = 'followers';

  static const String liked = 'liked';

  static const String preferredUsername = 'preferredUsername';
}

const SourceSerializer sourceSerializer = SourceSerializer();

class SourceEncoder extends Converter<Source, Map> {
  const SourceEncoder();

  @override
  Map convert(Source model) => SourceSerializer.toMap(model);
}

class SourceDecoder extends Converter<Map, Source> {
  const SourceDecoder();

  @override
  Source convert(Map map) => SourceSerializer.fromMap(map);
}

class SourceSerializer extends Codec<Source, Map> {
  const SourceSerializer();

  @override
  get encoder => const SourceEncoder();
  @override
  get decoder => const SourceDecoder();
  static Source fromMap(Map map) {
    return Source(
        content: map['content'] as String,
        mediaType: _mediaTypeFromString(map['mediaType']));
  }

  static Map<String, dynamic> toMap(_Source model) {
    if (model == null) {
      return null;
    }
    return {
      'content': model.content,
      'mediaType': _mediaTypeToString(model.mediaType)
    };
  }
}

abstract class SourceFields {
  static const List<String> allFields = <String>[content, mediaType];

  static const String content = 'content';

  static const String mediaType = 'mediaType';
}
