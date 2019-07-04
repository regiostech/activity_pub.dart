import 'package:angel_serialize/angel_serialize.dart';
import 'package:http_parser/http_parser.dart';
part 'models.g.dart';

final Uri w3ActivityStreamsContext =
    Uri.parse('https://www.w3.org/ns/activitystreams');

APActor _apActorFrom(v) => APActor.fromJson(v);
Uri _contextFromString(v) =>
    v is String ? Uri.parse(v) : w3ActivityStreamsContext;
MediaType _mediaTypeFromString(v) => MediaType.parse(v as String);
Object _apActorTo(APActor a) => a.toJson();
String _mediaTypeToString(MediaType m) => m.toString();
Uri _uriFromString(v) => Uri.parse(v as String);
String _uriToString(Uri u) => u.toString();

const SerializableField _actorField = SerializableField(
    serializer: #_apActorTo, deserializer: #_apActorFrom, serializesTo: Object);
const SerializableField _uriField = SerializableField(
    serializer: #_uriToString,
    deserializer: #_uriFromString,
    serializesTo: String);
const SerializableField _contextField = SerializableField(
    alias: '@context',
    serializer: #_uriToString,
    deserializer: #_contextFromString,
    serializesTo: String);

class ObjectOrLink<T extends _APObject> {
  final Codec<T, Map> codec;
  T _object;
  Uri _link;
  List<ObjectOrLink<T>> _list;

  T get object => _object;

  Uri get link => _link;

  List<ObjectOrLink<T>> get list => _list;

  ObjectOrLink(this.codec, {T object, link, Iterable<ObjectOrLink<T>> list}) {
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

  ObjectOrLink.fromJson(this.codec, value, {bool allowList = true}) {
    if (value is String) {
      _link = Uri.parse(value);
    } else if (value is Map) {
      _object = codec.decode(value);
    } else if (value is Iterable) {
      if (!allowList) {
        throw FormatException('A list is not allowed here.', value);
      }

      _list = value
          .map((x) => ObjectOrLink.fromJson(codec, x, allowList: false))
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
      return codec.encode(_object);
    } else if (_list != null) {
      return _list.map((i) => i.toJson()).toList();
    } else {
      return null;
    }
  }
}

class APActor extends ObjectOrLink<Actor> {
  APActor({Actor object, link, Iterable<ObjectOrLink<Actor>> list})
      : super(actorSerializer, object: object, link: link, list: list);

  APActor.fromJson(value, {bool allowList = true})
      : super.fromJson(actorSerializer, value, allowList: allowList);
}

@Serializable(autoSnakeCaseNames: false)
abstract class _APObject {
  @_contextField
  Uri get context;
  @_uriField
  Uri get id;
  _Source get source;
  String get summary;
  String get type;
}

@Serializable(autoSnakeCaseNames: false)
abstract class _Activity implements _APObject {
  @_contextField
  Uri get context;
  @_uriField
  Uri get id;
  _Source get source;
  String get summary;
  String get type;
  @_actorField
  APActor get actor;
}

@Serializable(autoSnakeCaseNames: false)
abstract class _Actor implements _APObject {
  @_contextField
  Uri get context;
  @_uriField
  Uri get id;
  String get type;
  _Source get source;

  String get name;
  String get summary;
  Uri get inbox;
  Uri get outbox;
  Uri get following;
  Uri get followers;
  Uri get liked;
  String get preferredUsername;
}

@Serializable(autoSnakeCaseNames: false)
abstract class _Source {
  String get content;
  @SerializableField(
      serializer: #_mediaTypeToString,
      deserializer: #_mediaTypeFromString,
      serializesTo: String)
  MediaType get mediaType;
}
