import 'package:angel_serialize/angel_serialize.dart';
import 'package:http_parser/http_parser.dart';
part 'models.g.dart';

const String w3ActivityStreamsContext = 'https://www.w3.org/ns/activitystreams';
final Uri w3ActivityStreamsContextUri = Uri.parse(w3ActivityStreamsContext);

APActor _apActorFrom(v) => APActor.fromJson(v);
APObjectOrLink _apObjectFrom(v) => APObjectOrLink.fromJson(v as Map);
Uri _contextFromString(v) =>
    v is String ? Uri.parse(v) : w3ActivityStreamsContextUri;
MediaType _mediaTypeFromString(v) => MediaType.parse(v as String);
Object _apActorTo(APActor a) => a.toJson();
Object _apObjectTo(APObjectOrLink a) => a.toJson();
String _mediaTypeToString(MediaType m) => m.toString();
Uri _uriFromString(v) => Uri.parse(v as String);
String _uriToString(Uri u) => u.toString();

const SerializableField _actorField = SerializableField(
    serializer: #_apActorTo, deserializer: #_apActorFrom, serializesTo: Object);
const SerializableField _objectField = SerializableField(
    serializer: #_apObjectTo,
    deserializer: #_apObjectFrom,
    serializesTo: Object);
const SerializableField _uriField = SerializableField(
    serializer: #_uriToString,
    deserializer: #_uriFromString,
    serializesTo: String);
// TODO: Find a way to default to w3 context.
const SerializableField _contextField = SerializableField(
    alias: '@context',
    serializer: #_uriToString,
    deserializer: #_contextFromString,
    serializesTo: String);

class ObjectOrLink<T extends _APObject> {
  final T Function(Map) decode;
  T _object;
  Uri _link;
  List<ObjectOrLink<T>> _list;

  T get object => _object;

  Uri get link => _link;

  List<ObjectOrLink<T>> get list => _list;

  ObjectOrLink(this.decode, {T object, link, Iterable<ObjectOrLink<T>> list}) {
    if (object != null && link != null) {
      throw FormatException(
          'An object, link, and/or list cannot be present together.');
    } else {
      _list = list is List<ObjectOrLink<T>> ? list : list?.toList();
      _object = object;
      if (link != null) {
        if (link is Uri) {
          _link = link;
        } else if (link is String) {
          _link = Uri.parse(link);
        } else {
          throw FormatException(
              'Link must be either a Uri, or a String.', link);
        }
      }
    }
  }

  ObjectOrLink.fromJson(this.decode, value, {bool allowList = true}) {
    if (value is String) {
      _link = Uri.parse(value);
    } else if (value is Map) {
      _object = decode(value);
    } else if (value is Iterable) {
      if (!allowList) {
        throw FormatException('A list is not allowed here.', value);
      }

      _list = value
          .map((x) => ObjectOrLink.fromJson(decode, x, allowList: false))
          .toList();
    } else if (value != null) {
      throw FormatException(
          'Value must be a String, Map, or Iterable; got ${value.runtimeType}',
          value);
    }
  }

  Object toJson() {
    if (_link != null) {
      return _link.toString();
    } else if (_object != null) {
      return _object.toJson();
    } else if (_list != null) {
      return _list.map((i) => i.toJson()).toList();
    } else {
      return null;
    }
  }
}

class APActor extends ObjectOrLink<Actor> {
  APActor({Actor object, link, Iterable<ObjectOrLink<Actor>> list})
      : super(ActorSerializer.fromMap, object: object, link: link, list: list);

  APActor.fromJson(value, {bool allowList = true})
      : super.fromJson(ActorSerializer.fromMap, value, allowList: allowList);
}

class APObjectOrLink extends ObjectOrLink<APObject> {
  APObjectOrLink({APObject object, link, Iterable<ObjectOrLink<APObject>> list})
      : super(APObjectSerializer.fromMap,
            object: object, link: link, list: list);

  APObjectOrLink.fromJson(value, {bool allowList = true})
      : super.fromJson(APObjectSerializer.fromMap, value, allowList: allowList);
}

@Serializable(autoSnakeCaseNames: false)
abstract class _APObject {
  @_contextField
  Uri specContext;
  @_uriField
  Uri id;
  @_objectField
  APObjectOrLink attachment;
  @_objectField
  APObjectOrLink attributedTo;
  @_objectField
  APObjectOrLink audience;
  @_objectField
  APObjectOrLink bcc;
  @_objectField
  APObjectOrLink bto;
  @_objectField
  APObjectOrLink cc;
  @_objectField
  APObjectOrLink context;
  _Source source;
  String summary;
  String type;
  Map<String, dynamic> toJson();
}

@Serializable(autoSnakeCaseNames: false)
abstract class _Activity extends _APObject {
  @_actorField
  APActor actor;
}

@Serializable(autoSnakeCaseNames: false)
abstract class _Actor extends _APObject {
  String name;
  Uri inbox;
  Uri outbox;
  Uri following;
  Uri followers;
  Uri liked;
  String preferredUsername;
}

@Serializable(autoSnakeCaseNames: false)
class _Source {
  String content;
  @SerializableField(
      serializer: #_mediaTypeToString,
      deserializer: #_mediaTypeFromString,
      serializesTo: String)
  MediaType mediaType;
}
