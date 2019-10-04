import 'package:activity_pub/activity_pub.dart';
import 'package:http_parser/http_parser.dart';

/*
{
  "@context": ["https://www.w3.org/ns/activitystreams",
               {"@language": "en"}],
  "type": "Like",
  "actor": "https://dustycloud.org/chris/",
  "summary": "Chris liked 'Minimal ActivityPub update client'",
  "object": "https://rhiaro.co.uk/2016/05/minimal-activitypub",
  "to": ["https://rhiaro.co.uk/#amy",
         "https://dustycloud.org/followers",
         "https://rhiaro.co.uk/followers/"],
  "cc": "https://e14n.com/evan"
}
*/

main() {
  var like = Activity()
    ..type = 'Like'
    ..actor = APActor(link: 'https://dustycloud.org/chris/')
    ..summary = "Chris liked 'Minimal ActivityPub update client'"
    ..cc = APObjectOrLink(link: 'https://e14n.com/evan');
  print(like.toJson());
  print(activitySerializer.decode(like.toJson()));
}
