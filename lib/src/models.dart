import 'package:angel_serialize/angel_serialize.dart';
import 'package:http_parser/http_parser.dart';
part 'models.g.dart';

final Uri w3ActivityStreamsContext =
    Uri.parse('https://www.w3.org/ns/activitystreams');

Uri _contextFromString(v) =>
    v is String ? Uri.parse(v) : w3ActivityStreamsContext;
MediaType _mediaTypeFromString(v) => MediaType.parse(v as String);
String _mediaTypeToString(MediaType m) => m.toString();
Uri _uriFromString(v) => Uri.parse(v as String);
String _uriToString(Uri u) => u.toString();

const SerializableField _uriField = SerializableField(
    serializer: #_uriToString,
    deserializer: #_uriFromString,
    serializesTo: String);
const SerializableField _contextField = SerializableField(
    alias: '@context',
    serializer: #_uriToString,
    deserializer: #_contextFromString,
    serializesTo: String);

abstract class ActivityPubObject {
  Uri get context;
  Uri get id;
  String get type;
  _Source get source;
}

@Serializable(autoSnakeCaseNames: false)
abstract class _Actor implements ActivityPubObject {
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
