// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class APObject extends _APObject {
  APObject(
      {this.specContext,
      this.id,
      this.attachment,
      this.attributedTo,
      this.audience,
      this.bcc,
      this.bto,
      this.cc,
      this.context,
      this.source,
      this.summary,
      this.type});

  @override
  Uri specContext;

  @override
  Uri id;

  @override
  APObjectOrLink attachment;

  @override
  APObjectOrLink attributedTo;

  @override
  APObjectOrLink audience;

  @override
  APObjectOrLink bcc;

  @override
  APObjectOrLink bto;

  @override
  APObjectOrLink cc;

  @override
  APObjectOrLink context;

  @override
  _Source source;

  @override
  String summary;

  @override
  String type;

  APObject copyWith(
      {Uri specContext,
      Uri id,
      APObjectOrLink attachment,
      APObjectOrLink attributedTo,
      APObjectOrLink audience,
      APObjectOrLink bcc,
      APObjectOrLink bto,
      APObjectOrLink cc,
      APObjectOrLink context,
      _Source source,
      String summary,
      String type}) {
    return APObject(
        specContext: specContext ?? this.specContext,
        id: id ?? this.id,
        attachment: attachment ?? this.attachment,
        attributedTo: attributedTo ?? this.attributedTo,
        audience: audience ?? this.audience,
        bcc: bcc ?? this.bcc,
        bto: bto ?? this.bto,
        cc: cc ?? this.cc,
        context: context ?? this.context,
        source: source ?? this.source,
        summary: summary ?? this.summary,
        type: type ?? this.type);
  }

  bool operator ==(other) {
    return other is _APObject &&
        other.specContext == specContext &&
        other.id == id &&
        other.attachment == attachment &&
        other.attributedTo == attributedTo &&
        other.audience == audience &&
        other.bcc == bcc &&
        other.bto == bto &&
        other.cc == cc &&
        other.context == context &&
        other.source == source &&
        other.summary == summary &&
        other.type == type;
  }

  @override
  int get hashCode {
    return hashObjects([
      specContext,
      id,
      attachment,
      attributedTo,
      audience,
      bcc,
      bto,
      cc,
      context,
      source,
      summary,
      type
    ]);
  }

  @override
  String toString() {
    return "APObject(specContext=$specContext, id=$id, attachment=$attachment, attributedTo=$attributedTo, audience=$audience, bcc=$bcc, bto=$bto, cc=$cc, context=$context, source=$source, summary=$summary, type=$type)";
  }

  Map<String, dynamic> toJson() {
    return APObjectSerializer.toMap(this);
  }
}

@generatedSerializable
class Activity extends _Activity {
  Activity(
      {this.specContext,
      this.id,
      this.attachment,
      this.attributedTo,
      this.audience,
      this.bcc,
      this.bto,
      this.cc,
      this.context,
      this.source,
      this.summary,
      this.type,
      this.actor});

  @override
  Uri specContext;

  @override
  Uri id;

  @override
  APObjectOrLink attachment;

  @override
  APObjectOrLink attributedTo;

  @override
  APObjectOrLink audience;

  @override
  APObjectOrLink bcc;

  @override
  APObjectOrLink bto;

  @override
  APObjectOrLink cc;

  @override
  APObjectOrLink context;

  @override
  _Source source;

  @override
  String summary;

  @override
  String type;

  @override
  APActor actor;

  Activity copyWith(
      {Uri specContext,
      Uri id,
      APObjectOrLink attachment,
      APObjectOrLink attributedTo,
      APObjectOrLink audience,
      APObjectOrLink bcc,
      APObjectOrLink bto,
      APObjectOrLink cc,
      APObjectOrLink context,
      _Source source,
      String summary,
      String type,
      APActor actor}) {
    return Activity(
        specContext: specContext ?? this.specContext,
        id: id ?? this.id,
        attachment: attachment ?? this.attachment,
        attributedTo: attributedTo ?? this.attributedTo,
        audience: audience ?? this.audience,
        bcc: bcc ?? this.bcc,
        bto: bto ?? this.bto,
        cc: cc ?? this.cc,
        context: context ?? this.context,
        source: source ?? this.source,
        summary: summary ?? this.summary,
        type: type ?? this.type,
        actor: actor ?? this.actor);
  }

  bool operator ==(other) {
    return other is _Activity &&
        other.specContext == specContext &&
        other.id == id &&
        other.attachment == attachment &&
        other.attributedTo == attributedTo &&
        other.audience == audience &&
        other.bcc == bcc &&
        other.bto == bto &&
        other.cc == cc &&
        other.context == context &&
        other.source == source &&
        other.summary == summary &&
        other.type == type &&
        other.actor == actor;
  }

  @override
  int get hashCode {
    return hashObjects([
      specContext,
      id,
      attachment,
      attributedTo,
      audience,
      bcc,
      bto,
      cc,
      context,
      source,
      summary,
      type,
      actor
    ]);
  }

  @override
  String toString() {
    return "Activity(specContext=$specContext, id=$id, attachment=$attachment, attributedTo=$attributedTo, audience=$audience, bcc=$bcc, bto=$bto, cc=$cc, context=$context, source=$source, summary=$summary, type=$type, actor=$actor)";
  }

  Map<String, dynamic> toJson() {
    return ActivitySerializer.toMap(this);
  }
}

@generatedSerializable
class Actor extends _Actor {
  Actor(
      {this.specContext,
      this.id,
      this.attachment,
      this.attributedTo,
      this.audience,
      this.bcc,
      this.bto,
      this.cc,
      this.context,
      this.source,
      this.summary,
      this.type,
      this.name,
      this.inbox,
      this.outbox,
      this.following,
      this.followers,
      this.liked,
      this.preferredUsername});

  @override
  Uri specContext;

  @override
  Uri id;

  @override
  APObjectOrLink attachment;

  @override
  APObjectOrLink attributedTo;

  @override
  APObjectOrLink audience;

  @override
  APObjectOrLink bcc;

  @override
  APObjectOrLink bto;

  @override
  APObjectOrLink cc;

  @override
  APObjectOrLink context;

  @override
  _Source source;

  @override
  String summary;

  @override
  String type;

  @override
  String name;

  @override
  Uri inbox;

  @override
  Uri outbox;

  @override
  Uri following;

  @override
  Uri followers;

  @override
  Uri liked;

  @override
  String preferredUsername;

  Actor copyWith(
      {Uri specContext,
      Uri id,
      APObjectOrLink attachment,
      APObjectOrLink attributedTo,
      APObjectOrLink audience,
      APObjectOrLink bcc,
      APObjectOrLink bto,
      APObjectOrLink cc,
      APObjectOrLink context,
      _Source source,
      String summary,
      String type,
      String name,
      Uri inbox,
      Uri outbox,
      Uri following,
      Uri followers,
      Uri liked,
      String preferredUsername}) {
    return Actor(
        specContext: specContext ?? this.specContext,
        id: id ?? this.id,
        attachment: attachment ?? this.attachment,
        attributedTo: attributedTo ?? this.attributedTo,
        audience: audience ?? this.audience,
        bcc: bcc ?? this.bcc,
        bto: bto ?? this.bto,
        cc: cc ?? this.cc,
        context: context ?? this.context,
        source: source ?? this.source,
        summary: summary ?? this.summary,
        type: type ?? this.type,
        name: name ?? this.name,
        inbox: inbox ?? this.inbox,
        outbox: outbox ?? this.outbox,
        following: following ?? this.following,
        followers: followers ?? this.followers,
        liked: liked ?? this.liked,
        preferredUsername: preferredUsername ?? this.preferredUsername);
  }

  bool operator ==(other) {
    return other is _Actor &&
        other.specContext == specContext &&
        other.id == id &&
        other.attachment == attachment &&
        other.attributedTo == attributedTo &&
        other.audience == audience &&
        other.bcc == bcc &&
        other.bto == bto &&
        other.cc == cc &&
        other.context == context &&
        other.source == source &&
        other.summary == summary &&
        other.type == type &&
        other.name == name &&
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
      specContext,
      id,
      attachment,
      attributedTo,
      audience,
      bcc,
      bto,
      cc,
      context,
      source,
      summary,
      type,
      name,
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
    return "Actor(specContext=$specContext, id=$id, attachment=$attachment, attributedTo=$attributedTo, audience=$audience, bcc=$bcc, bto=$bto, cc=$cc, context=$context, source=$source, summary=$summary, type=$type, name=$name, inbox=$inbox, outbox=$outbox, following=$following, followers=$followers, liked=$liked, preferredUsername=$preferredUsername)";
  }

  Map<String, dynamic> toJson() {
    return ActorSerializer.toMap(this);
  }
}

@generatedSerializable
class Source extends _Source {
  Source({this.content, this.mediaType});

  @override
  String content;

  @override
  MediaType mediaType;

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
        specContext: _contextFromString(map['@context']),
        id: _uriFromString(map['id']),
        attachment: _apObjectFrom(map['attachment']),
        attributedTo: _apObjectFrom(map['attributedTo']),
        audience: _apObjectFrom(map['audience']),
        bcc: _apObjectFrom(map['bcc']),
        bto: _apObjectFrom(map['bto']),
        cc: _apObjectFrom(map['cc']),
        context: _apObjectFrom(map['context']),
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
      '@context': _uriToString(model.specContext),
      'id': _uriToString(model.id),
      'attachment': _apObjectTo(model.attachment),
      'attributedTo': _apObjectTo(model.attributedTo),
      'audience': _apObjectTo(model.audience),
      'bcc': _apObjectTo(model.bcc),
      'bto': _apObjectTo(model.bto),
      'cc': _apObjectTo(model.cc),
      'context': _apObjectTo(model.context),
      'source': SourceSerializer.toMap(model.source),
      'summary': model.summary,
      'type': model.type
    };
  }
}

abstract class APObjectFields {
  static const List<String> allFields = <String>[
    specContext,
    id,
    attachment,
    attributedTo,
    audience,
    bcc,
    bto,
    cc,
    context,
    source,
    summary,
    type
  ];

  static const String specContext = '@context';

  static const String id = 'id';

  static const String attachment = 'attachment';

  static const String attributedTo = 'attributedTo';

  static const String audience = 'audience';

  static const String bcc = 'bcc';

  static const String bto = 'bto';

  static const String cc = 'cc';

  static const String context = 'context';

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
        specContext: _contextFromString(map['@context']),
        id: _uriFromString(map['id']),
        attachment: _apObjectFrom(map['attachment']),
        attributedTo: _apObjectFrom(map['attributedTo']),
        audience: _apObjectFrom(map['audience']),
        bcc: _apObjectFrom(map['bcc']),
        bto: _apObjectFrom(map['bto']),
        cc: _apObjectFrom(map['cc']),
        context: _apObjectFrom(map['context']),
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
      '@context': _uriToString(model.specContext),
      'id': _uriToString(model.id),
      'attachment': _apObjectTo(model.attachment),
      'attributedTo': _apObjectTo(model.attributedTo),
      'audience': _apObjectTo(model.audience),
      'bcc': _apObjectTo(model.bcc),
      'bto': _apObjectTo(model.bto),
      'cc': _apObjectTo(model.cc),
      'context': _apObjectTo(model.context),
      'source': SourceSerializer.toMap(model.source),
      'summary': model.summary,
      'type': model.type,
      'actor': _apActorTo(model.actor)
    };
  }
}

abstract class ActivityFields {
  static const List<String> allFields = <String>[
    specContext,
    id,
    attachment,
    attributedTo,
    audience,
    bcc,
    bto,
    cc,
    context,
    source,
    summary,
    type,
    actor
  ];

  static const String specContext = '@context';

  static const String id = 'id';

  static const String attachment = 'attachment';

  static const String attributedTo = 'attributedTo';

  static const String audience = 'audience';

  static const String bcc = 'bcc';

  static const String bto = 'bto';

  static const String cc = 'cc';

  static const String context = 'context';

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
        specContext: _contextFromString(map['@context']),
        id: _uriFromString(map['id']),
        attachment: _apObjectFrom(map['attachment']),
        attributedTo: _apObjectFrom(map['attributedTo']),
        audience: _apObjectFrom(map['audience']),
        bcc: _apObjectFrom(map['bcc']),
        bto: _apObjectFrom(map['bto']),
        cc: _apObjectFrom(map['cc']),
        context: _apObjectFrom(map['context']),
        source: map['source'] != null
            ? SourceSerializer.fromMap(map['source'] as Map)
            : null,
        summary: map['summary'] as String,
        type: map['type'] as String,
        name: map['name'] as String,
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
      '@context': _uriToString(model.specContext),
      'id': _uriToString(model.id),
      'attachment': _apObjectTo(model.attachment),
      'attributedTo': _apObjectTo(model.attributedTo),
      'audience': _apObjectTo(model.audience),
      'bcc': _apObjectTo(model.bcc),
      'bto': _apObjectTo(model.bto),
      'cc': _apObjectTo(model.cc),
      'context': _apObjectTo(model.context),
      'source': SourceSerializer.toMap(model.source),
      'summary': model.summary,
      'type': model.type,
      'name': model.name,
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
    specContext,
    id,
    attachment,
    attributedTo,
    audience,
    bcc,
    bto,
    cc,
    context,
    source,
    summary,
    type,
    name,
    inbox,
    outbox,
    following,
    followers,
    liked,
    preferredUsername
  ];

  static const String specContext = '@context';

  static const String id = 'id';

  static const String attachment = 'attachment';

  static const String attributedTo = 'attributedTo';

  static const String audience = 'audience';

  static const String bcc = 'bcc';

  static const String bto = 'bto';

  static const String cc = 'cc';

  static const String context = 'context';

  static const String source = 'source';

  static const String summary = 'summary';

  static const String type = 'type';

  static const String name = 'name';

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
