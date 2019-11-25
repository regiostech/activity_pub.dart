import 'dart:async';
import 'package:rdf/rdf.dart';
import 'context.dart';
import 'document_loader.dart';
import 'exception.dart';
import 'uri_or.dart';

class Processor {
  final DocumentLoader documentLoader;

  Processor({DocumentLoader documentLoader})
      : this.documentLoader = documentLoader ?? DocumentLoader();

  Future<Context> processLocalContext(
      Context activeContext, localContext, Uri baseIri,
      {bool isRemoteContext = false, List<Uri> remoteContexts}) async {
    // This algorithm specifies how a new active context is updated with
    // a local context. The algorithm takes three input variables: an
    // active context, a local context, and an array remote contexts which
    // is used to detect cyclical context inclusions. If remote contexts
    // is not passed, it is initialized to an empty array.
    remoteContexts ??= [];
    // 1.) Initialize result to the result of cloning active context.
    var result = activeContext.clone();
    // 2.) If local context is not an array, set it to an array containing only local context.
    List localContexts;
    if (localContext is List) {
      localContexts = localContext;
    } else {
      localContexts = [localContext];
    }
    // 3.) For each item context in local context:
    for (var context in localContexts) {
      // 3.1) If context is null, set result to a newly-initialized active context and continue
      // with the next context. The base IRI of the active context is set to the IRI of the
      // currently being processed document (which might be different from the currently being
      // processed context), if available; otherwise to null. If set, the base option of a
      // JSON-LD API Implementation overrides the base IRI.
      if (context == null) {
        result = Context()..baseIri = baseIri;
      }
      // 3.2) If context is a string,
      else if (context is String) {
        // 3.2.1) Set context to the result of resolving value against the base IRI
        var contextUri = baseIri.resolve(context);
        // 3.2.2.) If context is in the remote contexts array, a recursive context
        // inclusion error has been detected and processing is aborted; otherwise,
        // add context to remote contexts.
        if (remoteContexts.contains(contextUri)) {
          throw JsonLDException('recursive context inclusion',
              message: context);
        } else {
          remoteContexts.add(contextUri);
        }

        /// 3.2.3) Dereference context. If context cannot be dereferenced, a loading
        /// remote context failed error has been detected and processing is aborted.
        /// If the dereferenced document has no top-level JSON object with an @context
        /// member, an invalid remote context has been detected and processing is
        /// aborted; otherwise, set context to the value of that member.
        var dereferencedContext = await documentLoader.dereference(contextUri);
        if (!(dereferencedContext is Map &&
            dereferencedContext.containsKey('@context'))) {
          throw JsonLDException('invalid remote context', message: context);
        }

        /// 3.2.4) Set result to the result of recursively calling this algorithm, passing
        /// result for active context, context for local context, and remote contexts.
        result = await processLocalContext(result, dereferencedContext, baseIri,
            remoteContexts: remoteContexts);
      }

      /// 3.3) If context is not a JSON object, an invalid local context error has been
      /// detected and processing is aborted.
      if (context is! Map) {
        throw JsonLDException('invalid local context',
            message: context.toString());
      }

      var contextMap = context as Map;

      /// 3.4) If context has an @base key and remote contexts is empty, i.e., the currently
      /// being processed context is not a remote context:
      if (contextMap.containsKey('@base') && remoteContexts.isEmpty) {
        // 3.4.1) Initialize value to the value associated with the @base key.
        var value = contextMap['@base'];
        // 3.4.2) If value is null, remove the base IRI of result.
        if (value == null) {
          result.baseIri = null;
        }
        var valueStr = value is String ? value : null;
        var valueIri = Uri.tryParse(valueStr);
        if (valueIri != null) {
          // 3.4.3) Otherwise, if value is an absolute IRI, the base IRI of result is set to value.
          if (valueIri.isAbsolute) {
            result.baseIri = valueIri;
          }
          // 3.4.4) Otherwise, if value is a relative IRI and the base IRI of result is not null,
          // set the base IRI of result to the result of resolving value against the current base IRI of result.
          else if (result.baseIri != null) {
            result.baseIri = result.baseIri.resolveUri(valueIri);
          }
        } else {
          // 3.4.5) Otherwise, an invalid base IRI error has been detected and processing is aborted.
          throw JsonLDException('invalid base IRI', message: value.toString());
        }
      }
      // 3.5) If context has an @vocab key:
      if (contextMap.containsKey('@vocab')) {
        // 3.5.1) Initialize value to the value associated with the @vocab key.
        var value = contextMap['@vocab'];
        // 3.5.2) If value is null, remove any vocabulary mapping from result.
        if (value == null) {
          // result.vocabulary = null;
          result.vocabularyMapping = null;
        }
        // 3.5.3) Otherwise, if value is an absolute IRI or blank node identifier, the vocabulary mapping of
        // result is set to value. If it is not an absolute IRI or blank node identifier, an invalid vocab
        // mapping error has been detected and processing is aborted.
        else {
          var valueStr = value is String ? value : null;
          var valueIri = Uri.tryParse(valueStr);
          if (valueIri != null && valueIri.isAbsolute) {
            result.vocabularyMapping = UriOr.uri(valueIri);
          } else if (valueStr.startsWith('_:')) {
            result.vocabularyMapping = UriOr.value(blankNode);
          } else {
            throw JsonLDException('invalid vocab mapping',
                message: value.toString());
          }
        }
      }
      // 3.6) If context has an @language key:
      if (contextMap.containsKey('@language')) {
        // 3.6.1) Initialize value to the value associated with the @language key.
        var value = contextMap['@language'];
        // 3.6.2) If value is null, remove any default language from result.
        if (value == null) {
          result.defaultLanguage = null;
        }
        // 3.6.3) Otherwise, if value is string, the default language of result is set to lowercased
        // value. If it is not a string, an invalid default language error has been detected and
        // processing is aborted.
        else if (value is String) {
          result.defaultLanguage = value.toLowerCase();
        } else {
          throw JsonLDException('invalid default language',
              message: value.toString());
        }
      }
      // 3.7) Create a JSON object defined to use to keep track of whether or not a term has already been
      // defined or currently being defined during recursion.
      var defined = <String, bool>{};
      // 3.8) For each key-value pair in context where key is not @base, @vocab, or @language, invoke the
      // Create Term Definition algorithm, passing result for active context, context for local context,
      // key, and defined.
      for (var entry in contextMap.entries) {
        if (!const ['@base', '@vocab', '@language'].contains(entry.key)) {
          await createTermDefinition(result, contextMap, entry.key, defined);
        }
      }
    }
    // 4.) Return result.
    return result;
  }
}
