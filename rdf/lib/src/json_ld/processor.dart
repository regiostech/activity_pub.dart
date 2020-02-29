import 'dart:async';
import 'dart:collection';
import 'package:rdf/rdf.dart';
import 'compact_iri.dart';
import 'context.dart';
import 'document_loader.dart';
import 'exception.dart';
import 'keywords.dart';
import 'uri_or.dart';

class Processor {
  final DocumentLoader documentLoader;
  final Uri baseIri;

  Processor(this.baseIri, {DocumentLoader documentLoader})
      : this.documentLoader = documentLoader ?? DocumentLoader();

  Object _copy(obj) {
    if (obj is Map) {
      return obj.map((k, v) => MapEntry(k, _copy(v)));
    } else if (obj is Iterable) {
      return obj.map(_copy).toList();
    } else {
      return obj;
    }
  }

  bool _isScalar(obj) => obj is String || obj is num || obj is bool;

  /// This algorithm expands a JSON-LD document, such that all context definitions are removed, all terms
  /// and compact IRIs are expanded to absolute IRIs, blank node identifiers, or keywords and all JSON-LD
  /// values are expressed in arrays in expanded form.
  Future<Object> expand(Object element,
      {Context activeContext, String activeProperty}) async {
    activeContext ??= Context();
    // 1.) If element is null, return null.
    if (element == null) {
      return null;
    }
    // 2.) If element is a scalar,
    if (_isScalar(element)) {
      // 2.1) If active property is null or @graph, drop the free-floating scalar by returning null.
      if (activeProperty == null || activeProperty == '@graph') {
        return null;
      }
      // 2.2) Return the result of the Value Expansion algorithm, passing the active context, active
      // property, and element as value.
      return await expandValue(activeContext, activeProperty, element);
    }
    // 3.) If element is an array,
    if (element is Iterable) {
      // 3.1) Initialize an empty array, result.
      var result = [];
      // 3.2) For each item in element:
      for (var item in element) {
        // 3.2.1) Initialize expanded item to the result of using this algorithm recursively, passing
        // active context, active property, and item as element.
        var expandedItem = await expand(item,
            activeContext: activeContext, activeProperty: activeProperty);
        // 3.2.2) If the active property is @list or its container mapping is set to @list, the expanded
        // item must not be an array or a list object, otherwise a list of lists error has been detected
        // and processing is aborted.
        if (activeProperty == '@list' ||
            activeContext.termDefinitions[activeProperty]?.containerMapping ==
                '@list') {
          if (expandedItem is Iterable) {
            throw JsonLDException('list of lists');
          }
        }
        // 3.2.3) If expanded item is an array, append each of its items to result. Otherwise, if expanded
        // item is not null, append it to result.
        if (expandedItem is Iterable) {
          result.addAll(expandedItem);
        } else {
          result.add(expandedItem);
        }
      }
      // 3.3) Return result.
      return result;
    }
    // 4.) Otherwise element is a JSON object.
    var elementMap = (element as Map).cast<String, dynamic>();
    // 5.) If element contains the key @context, set active context to the result of the Context Processing
    // algorithm, passing active context and the value of the @context key as local context.
    if (elementMap.containsKey('@context')) {
      activeContext =
          await processLocalContext(activeContext, elementMap['@context']);
    }
    // 6.) Initialize an empty JSON object, result.
    var result = <String, dynamic>{};
    // 7.) For each key and value in element, ordered lexicographically by key:
    var splayElementMap = SplayTreeMap.of(elementMap);
    for (var entry in splayElementMap.entries) {
      var key = entry.key, value = entry.value;
      // 7.1) If key is @context, continue to the next key.
      if (key == '@context') continue;
      // 7.2) Set expanded property to the result of using the IRI Expansion algorithm, passing active context,
      // key for value, and true for vocab.
      var expandedProperty = await expandIri(activeContext, key, vocab: true);
      // 7.3) If expanded property is null or it neither contains a colon (:) nor it is a keyword, drop key by
      // continuing to the next key.
      if (expandedProperty == null ||
          (!keywords.contains(expandedProperty) &&
              ((expandedProperty is! String) ||
                  !((expandedProperty as String).contains(':'))))) {
        continue;
      }
      // 7.4) If expanded property is a keyword:
      if (keywords.contains(expandedProperty)) {
        // 7.4.1.) If active property equals @reverse, an invalid reverse property map error has been detected
        // and processing is aborted.
        if (activeProperty == '@reverse') {
          throw JsonLDException('invalid reverse property map');
        }
        // 7.4.2) If result has already an *expanded property* member, an colliding keywords error has been
        // detected and processing is aborted.
        if (result.containsKey(expandedProperty)) {
          throw JsonLDException('colliding keywords',
              message: expandedProperty as String);
        }
        Object expandedValue;
        // 7.4.3) If expanded property is @id and value is not a string, an invalid @id value error has been
        // detected and processing is aborted. Otherwise, set expanded value to the result of using the IRI
        // Expansion algorithm, passing active context, value, and true for document relative.
        if (expandedProperty == '@id') {
          if (value is String) {
            expandedValue =
                await expandIri(activeContext, value, documentRelative: true);
          } else {
            throw JsonLDException('invalid @id value',
                message: value.toString());
          }
        }
        // 7.4.4.) If expanded property is @type and value is neither a string nor an array of strings, an
        // invalid type value error has been detected and processing is aborted. Otherwise, set expanded
        // value to the result of using the IRI Expansion algorithm, passing active context, true for vocab,
        // and true for document relative to expand the value or each of its items.
        if (expandedProperty == '@type') {
          if (value is! String &&
              ((value is! Iterable) ||
                  ((value as Iterable).any((x) => x is! String)))) {
            throw JsonLDException('invalid type value',
                message: value.toString());
          } else {
            if (value is Iterable) {
              expandedValue =
                  await Future.forEach<String>(value.cast<String>(), (s) {
                return expandIri(activeContext, s,
                    vocab: true, documentRelative: true);
              });
            } else {
              expandedValue = await expandIri(activeContext, value as String,
                  vocab: true, documentRelative: true);
            }
          }
        }
        // 7.4.5) If expanded property is @graph, set expanded value to the result of using this algorithm
        // recursively passing active context, @graph for active property, and value for element.
        if (expandedProperty == '@graph') {
          expandedValue = await expand(value,
              activeContext: activeContext, activeProperty: '@graph');
        }
        // 7.4.6) If expanded property is @value and value is not a scalar or null, an invalid value object
        // value error has been detected and processing is aborted. Otherwise, set expanded value to value.
        // If expanded value is null, set the @value member of result to null and continue with the next key
        // from element. Null values need to be preserved in this case as the meaning of an @type member
        // depends on the existence of an @value member.
        if (expandedProperty == '@value') {
          if (value != null && !_isScalar(value)) {
            throw JsonLDException('invalid value object',
                message: value.toString());
          } else {
            expandedValue = value;
            if (expandedValue == null) {
              result['@value'] = null;
              continue;
            }
          }
        }
        // 7.4.7) If expanded property is @language and value is not a string, an invalid language-tagged string
        // error has been detected and processing is aborted. Otherwise, set expanded value to lowercased value.
        if (expandedProperty == '@language') {
          if (value is String) {
            expandedValue = value.toLowerCase();
          } else {
            throw JsonLDException('invalid language-tagged string',
                message: value.toString());
          }
        }
        // 7.4.8) If expanded property is @index and value is not a string, an invalid @index value error has been
        // detected and processing is aborted. Otherwise, set expanded value to value.
        if (expandedProperty == '@index') {
          if (value is String) {
            expandedValue = value;
          } else {
            throw JsonLDException('invalid @index value',
                message: value.toString());
          }
        }
        // 7.4.9) If expanded property is @list:
        if (expandedProperty == '@list') {
          // 7.4.9.1) If active property is null or @graph, continue with the next key from element to remove the
          // free-floating list.
          if (activeProperty == null || activeProperty == '@graph') {
            continue;
          }
          // 7.4.9.2) Otherwise, initialize expanded value to the result of using this algorithm recursively passing
          // active context, active property, and value for element.
          else {
            expandedValue = await expand(value,
                activeContext: activeContext, activeProperty: activeProperty);
          }
          // 7.4.9.3) If expanded value is a list object, a list of lists error has been detected and processing is
          // aborted.
          if (expandedValue is Iterable) {
            throw JsonLDException('list of lists');
          }
        }
        // 7.4.10) If expanded property is @set, set expanded value to the result of using this algorithm recursively,
        // passing active context, active property, and value for element.
        if (expandedProperty == '@set') {
          expandedValue = await expand(value,
              activeContext: activeContext, activeProperty: activeProperty);
        }
        // 7.4.11) If expanded property is @reverse and value is not a JSON object, an invalid @reverse value error has
        // been detected and processing is aborted. Otherwise
        if (expandedProperty == '@reverse') {
          if (value is! Map) {
            throw JsonLDException('invalid @reverse value',
                message: value.toString());
          }
          // 7.4.11.1) Initialize expanded value to the result of using this algorithm recursively, passing active context,
          // @reverse as active property, and value as element.
          expandedValue = await expand(value,
              activeContext: activeContext, activeProperty: '@reverse');
          // 7.4.11.2) If expanded value contains an @reverse member, i.e., properties that are reversed twice, execute
          // for each of its property and item the following steps:
          if (expandedValue is Map && expandedValue.containsKey('@reverse')) {
            expandedValue.cast<String, dynamic>().forEach((property, item) {
              // 7.4.11.2.1) If result does not have a property member, create one and set its value to an empty array.
              if (!result.containsKey(property)) {
                result[property] = [];
              }
              // 7.4.11.2.2) Append item to the value of the property member of result.
              (result[property] as List).add(item);
            });
          }
          // 7.4.11.3) If expanded value contains members other than @reverse:
          if (expandedValue is Map &&
              expandedValue.keys.any((k) => k != '@reverse')) {
            // 7.4.11.3.1) If result does not have an @reverse member, create one and set its value to an empty JSON object.
            if (!result.containsKey('@reverse')) {
              result['@reverse'] = <String, dynamic>{};
            }
            // 7.4.11.3.2) Reference the value of the @reverse member in result using the variable reverse map.
            var reverseMap = result['@reverse'] as Map<String, dynamic>;
            // 7.4.11.3.3) For each property and items in expanded value other than @reverse:
            expandedValue.cast<String, Iterable>().forEach((property, items) {
              if (property != '@reverse') {
                // 7.4.11.3.3.1) For each item in items:
                for (var item in items) {
                  // 7.4.11.3.3.1.1) If item is a value object or list object, an invalid reverse property value has been
                  // detected and processing is aborted.
                  if (item is Map &&
                      (item.containsKey('@value') ||
                          item.containsKey('@list'))) {
                    throw JsonLDException('invalid reverse property',
                        message: item.toString());
                  }
                  // 7.4.11.3.3.1.2) If reverse map has no property member, create one and initialize its value to an empty
                  // array.
                  reverseMap[property] ??= [];
                  // 7.4.11.3.3.1.3) Append item to the value of the property member in reverse map.
                  (reverseMap[property] as List).add(item);
                }
              }
            });
          }
          // 7.4.11.4) Continue with the next key from element.
          continue;
        }
        // 7.4.12) Unless expanded value is null, set the expanded property member of result to expanded value.
        if (expandedValue != null) {
          result[expandedProperty as String] = expandedValue;
        }
        // 7.4.13) Continue with the next key from element.
        continue;
      }
      // 7.5) Otherwise, if key's container mapping in active context is @language and value is a JSON object then
      // value is expanded from a language map as follows:
      else if (activeContext.termDefinitions[key]?.containerMapping ==
              '@language' &&
          value is Map) {
        // 7.5.1) Initialize expanded value to an empty array.
        var expandedValue = [];
        // 7.5.2) For each key-value pair language-language value in value, ordered lexicographically by language:
        var splayValueMap = SplayTreeMap.of(value.cast<String, dynamic>());
        splayValueMap.forEach((language, value) {
          // 7.5.2.1) If language value is not an array set it to an array containing only language value.
          var languageValue = value is Iterable ? value.toList() : [value];
          // 7.5.2.2) For each item in language value:
          for (var item in languageValue) {
            // 7.5.2.2.1) item must be a string, otherwise an invalid language map value error has been detected
            // and processing is aborted.
            if (item is String) {
              // 7.5.2.2.2) Append a JSON object to expanded value that consists of two key-value pairs: (@value-item)
              // and (@language-lowercased language).
              expandedValue.add({
                '@value': item,
                '@language': language.toLowerCase(),
              });
            } else {
              throw JsonLDException('invalid language map value',
                  message: item.toString());
            }
          }
        });
      }
      // TODO: Resume from 7.6
    }
  }

  Future<Context> processLocalContext(Context activeContext, localContext,
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
        result = await processLocalContext(result, dereferencedContext,
            remoteContexts: remoteContexts);
      }

      /// 3.3) If context is not a JSON object, an invalid local context error has been
      /// detected and processing is aborted.
      if (context is! Map) {
        throw JsonLDException('invalid local context',
            message: context.toString());
      }

      var contextMap = (context as Map).cast<String, dynamic>();

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

  Future<void> createTermDefinition(Context activeContext, Map localContext,
      String term, Map<String, bool> defined) async {
    // 1.) If defined contains the key term and the associated value is true (indicating that the term
    // definition has already been created), return. Otherwise, if the value is false, a cyclic IRI
    // mapping error has been detected and processing is aborted.
    if (defined[term] == true) {
      return;
    } else if (defined[term] == false) {
      throw JsonLDException('cyclic IRI mapping error', message: term);
    }
    // 2.) Set the value associated with defined's term key to false. This indicates that the term
    // definition is now being created but is not yet complete.
    defined[term] = false;
    // 3.) Since keywords cannot be overridden, term must not be a keyword. Otherwise, a keyword
    // redefinition error has been detected and processing is aborted.
    if (keywords.contains(term)) {
      throw JsonLDException('keyword redefinition error', message: term);
    }
    // 4.) Remove any existing term definition for term in active context.
    activeContext.termDefinitions.remove(term);
    // 5.) Initialize value to a copy of the value associated with the key term in local context.
    var value = _copy(localContext[term]);
    // 6.) If value is null or value is a JSON object containing the key-value pair @id-null, set
    // the term definition in active context to null, set the value associated with defined's key
    // term to true, and return.
    if (value == null ||
        (value is Map && value.containsKey('@id') && value['@id'] == null)) {
      activeContext.termDefinitions[term] = null;
      defined[term] = true;
      return;
    }
    // 7.) Otherwise, if value is a string, convert it to a JSON object consisting of a single member
    // whose key is @id and whose value is value.
    Map valueMap;
    if (value is String) {
      valueMap = {'@id': value};
    }
    // 8.) Otherwise, value must be a JSON object, if not, an invalid term definition error has been
    // detected and processing is aborted.
    else if (value is Map) {
      valueMap = value;
    } else {
      throw JsonLDException('invalid term definition',
          message: value?.toString());
    }
    // 9.) Create a new term definition, definition.
    var definition = TermDefinition();
    // 10.) If value contains the key @type:
    if (valueMap.containsKey('@type')) {
      // 10.1) Initialize type to the value associated with the @type key, which must be a string.
      // Otherwise, an invalid type mapping error has been detected and processing is aborted.
      var type = valueMap['@type'];
      if (type is String) {
        // 10.2) Set type to the result of using the IRI Expansion algorithm, passing active context, type
        // for value, true for vocab, false for document relative, local context, and defined. If the
        // expanded type is neither @id, nor @vocab, nor an absolute IRI, an invalid type mapping error
        // has been detected and processing is aborted.
        var expandedType = await expandIri(activeContext, type,
            vocab: true,
            documentRelative: false,
            localContext: localContext,
            defined: defined);
        // 10.3) Set the type mapping for definition to type.
        if (expandedType != '@id' &&
            expandedType != '@vocab' &&
            ((expandedType is! Uri) || (!((expandedType as Uri).isAbsolute)))) {
          throw JsonLDException('invalid type mapping',
              message: expandedType?.toString());
        }
        definition.typeMapping = expandedType;
      } else {
        throw JsonLDException('invalid type mapping', message: type.toString());
      }
    }
    // 11.) If value contains the key @reverse:
    if (valueMap.containsKey('@reverse')) {
      // 11.1) If value contains an @id, member, an invalid reverse property error has been detected
      // and processing is aborted.
      if (valueMap.containsKey('@id')) {
        throw JsonLDException('invalid reverse property');
      }
      // 11.2) If the value associated with the @reverse key is not a string, an invalid IRI mapping error
      // has been detected and processing is aborted.
      if (valueMap['@reverse'] is! String) {
        throw JsonLDException('invalid IRI mapping',
            message: valueMap['@reverse']?.toString());
      }
      // 11.3) Otherwise, set the IRI mapping of definition to the result of using the IRI Expansion algorithm,
      // passing active context, the value associated with the @reverse key for value, true for vocab, false
      // for document relative, local context, and defined. If the result is neither an absolute IRI nor a blank
      // node identifier, i.e., it contains no colon (:), an invalid IRI mapping error has been detected and
      // processing is aborted.
      var reverseValue = valueMap['@reverse'] as String;
      var result = await expandIri(activeContext, reverseValue,
          vocab: true,
          documentRelative: false,
          localContext: localContext,
          defined: defined);
      if (result is! BlankNode &&
          ((result is! Uri) || (!((result as Uri).isAbsolute)))) {
        throw JsonLDException('invalid IRI mapping',
            message: result?.toString());
      }
      definition.iriMapping = result;
      // 11.4) If value contains an @container member, set the container mapping of definition to its value; if
      // its value is neither @set, nor @index, nor null, an invalid reverse property error has been detected
      // (reverse properties only support set- and index-containers) and processing is aborted.
      if (valueMap.containsKey('@container')) {
        var containerValue = valueMap['@container'];
        if (containerValue != null &&
            containerValue != '@set' &&
            containerValue != '@index') {
          throw JsonLDException('invalid reverse property',
              message: containerValue.toString());
        }
        definition.containerMapping = containerValue as String;
      }
      // 11.5) Set the reverse property flag of definition to true.
      definition.reverseProperty = true;
      // 11.6) Set the term definition of term in active context to definition and the value associated with
      // defined's key term to true and return.
      activeContext.termDefinitions[term] = definition;
      defined[term] = true;
      return;
    }
    // 12.) Set the reverse property flag of definition to false.
    definition.reverseProperty = false;
    // 13.) If value contains the key @id and its value does not equal term:
    if (valueMap.containsKey('@id') && valueMap['@id'] != term) {
      // 13.1) If the value associated with the @id key is not a string, an invalid IRI mapping error has been
      // detected and processing is aborted.
      if (valueMap['@id'] is! String) {
        throw JsonLDException('invalid IRI mapping',
            message: valueMap['@id'].toString());
      }
      // 13.2) Otherwise, set the IRI mapping of definition to the result of using the IRI Expansion algorithm,
      // passing active context, the value associated with the @id key for value, true for vocab, false for
      // document relative, local context, and defined. If the resulting IRI mapping is neither a keyword,
      // nor an absolute IRI, nor a blank node identifier, an invalid IRI mapping error has been detected
      // and processing is aborted; if it equals @context, an invalid keyword alias error has been detected
      // and processing is aborted.
      var id = valueMap['@id'] as String;
      var result = await expandIri(activeContext, id,
          vocab: true,
          documentRelative: false,
          localContext: localContext,
          defined: defined);
      if (!keywords.contains(result) &&
          ((result is! Uri) || (!((result as Uri).isAbsolute))) &&
          result is! BlankNode) {
        throw JsonLDException('invalid IRI mapping',
            message: result.toString());
      } else if (result == '@context') {
        throw JsonLDException('invalid keyword alias',
            message: result.toString());
      }
      definition.iriMapping = result;
    }
    // 14.) Otherwise if the term contains a colon (:):
    else if (term.contains(':')) {
      // 14.1) If term is a compact IRI with a prefix that is a key in local context a dependency has been
      // found. Use this algorithm recursively passing active context, local context, the prefix as term,
      // and defined.
      var termUri = Uri.tryParse(term);
      var compactUri = CompactIri.from(termUri);
      if (compactUri != null && localContext.containsKey(compactUri.prefix)) {
        await createTermDefinition(
            activeContext, localContext, compactUri.prefix, defined);
      }
      // 14.2) If term's prefix has a term definition in active context, set the IRI mapping of definition
      // to the result of concatenating the value associated with the prefix's IRI mapping and the term's
      // suffix.
      if (activeContext.termDefinitions.containsKey(compactUri.prefix)) {
        var prefixMapping =
            activeContext.termDefinitions[compactUri.prefix].iriMapping;
        definition.iriMapping = prefixMapping.toString() + compactUri.suffix;
      }
      // 14.3) Otherwise, term is an absolute IRI or blank node identifier. Set the IRI mapping of definition
      // to term.
      else {
        definition.iriMapping = termUri ?? term;
      }
    }
    // 15.) Otherwise, if active context has a vocabulary mapping, the IRI mapping of definition is set to
    // the result of concatenating the value associated with the vocabulary mapping and term. If it does
    // not have a vocabulary mapping, an invalid IRI mapping error been detected and processing is aborted.
    else if (activeContext.vocabularyMapping != null) {
      definition.iriMapping = activeContext.vocabularyMapping.toString() + term;
    } else {
      throw JsonLDException('invalid IRI mapping',
          message: 'active context has not vocabulary mapping');
    }
    // 16.) If value contains the key @container:
    if (valueMap.containsKey('@container')) {
      // 16.1) Initialize container to the value associated with the @container key, which must be either @list,
      // @set, @index, or @language. Otherwise, an invalid container mapping error has been detected and
      // processing is aborted.
      var containerValue = valueMap['@container'];
      if (containerValue != '@list' &&
          containerValue != '@set' &&
          containerValue != '@index' &&
          containerValue != '@language') {
        throw JsonLDException('invalid container mapping',
            message: containerValue.toString());
      }
      // 16.2) Set the container mapping of definition to container.
      definition.containerMapping = containerValue as String;
    }
    // 17.) If value contains the key @language and does not contain the key @type:
    if (valueMap.containsKey('@language') && !valueMap.containsKey('@type')) {
      // 17.1) Initialize language to the value associated with the @language key, which must be either null or a
      // string. Otherwise, an invalid language mapping error has been detected and processing is aborted.
      var language = valueMap['@language'];
      if (language != null && language is! String) {
        throw JsonLDException('invalid language mapping',
            message: language.toString());
      }
      // 17.2) If language is a string set it to lowercased language. Set the language mapping of definition to
      // language.
      definition.languageMapping = (language as String)?.toLowerCase();
    }
    // 18.) Set the term definition of term in active context to definition and set the value associated with
    // defined's key term to true.
    activeContext.termDefinitions[term] = definition;
    defined[term] = true;
  }

  Future<Object> expandIri(Context activeContext, String value,
      {Map localContext,
      Map<String, bool> defined,
      bool vocab = false,
      bool documentRelative = false}) async {
    // 1.) If value is a keyword or null, return value as is.
    if (value == null || keywords.contains(value)) {
      return null;
    }
    // 2.) If local context is not null, it contains a key that equals value, and the value associated
    // with the key that equals value in defined is not true, invoke the Create Term Definition algorithm,
    // passing active context, local context, value as term, and defined. This will ensure that a term
    // definition is created for value in active context during Context Processing.
    if (localContext != null &&
        localContext.containsKey(value) &&
        defined[value] != true) {
      await createTermDefinition(activeContext, localContext, value, defined);
    }
    // 3.) If vocab is true and the active context has a term definition for value, return the associated
    // IRI mapping.
    if (vocab && activeContext.termDefinitions.containsKey(value)) {
      return activeContext.termDefinitions[value].iriMapping;
    }
    // 4.) If value contains a colon (:), it is either an absolute IRI, a compact IRI, or a blank node
    // identifier:
    if (value.contains(':')) {
      // 4.1) Split value into a prefix and suffix at the first occurrence of a colon (:).
      var idx = value.indexOf(':');
      var prefix = value.substring(0, idx);
      var suffix = value.substring(idx);
      // 4.2) If prefix is underscore (_) or suffix begins with double-forward-slash (//), return value as
      // it is already an absolute IRI or a blank node identifier.
      if (prefix == '_') {
        return blankNode;
      } else if (suffix.startsWith('//')) {
        return Uri.parse(value);
      }
      // 4.3) If local context is not null, it contains a key that equals prefix, and the value associated with
      // the key that equals prefix in defined is not true, invoke the Create Term Definition algorithm, passing
      // active context, local context, prefix as term, and defined. This will ensure that a term definition is
      // created for prefix in active context during Context Processing.
      if (localContext != null &&
          localContext.containsKey(prefix) &&
          defined[prefix] != true) {
        await createTermDefinition(
            activeContext, localContext, prefix, defined);
      }
      // 4.4) If active context contains a term definition for prefix, return the result of concatenating the
      // IRI mapping associated with prefix and suffix.
      if (activeContext.termDefinitions.containsKey(prefix)) {
        var mapping = activeContext.termDefinitions[prefix].iriMapping;
        return Uri.parse(mapping.toString() + suffix);
      }
      // 4.5) Return value as it is already an absolute IRI.
      return Uri.parse(value);
    }
    // 5.) If vocab is true, and active context has a vocabulary mapping, return the result of concatenating the
    // vocabulary mapping with value.
    if (vocab && activeContext.vocabularyMapping?.asUri != null) {
      return Uri.parse(
          activeContext.vocabularyMapping.asUri.toString() + value);
    }
    // 6.) Otherwise, if document relative is true, set value to the result of resolving value against the base IRI.
    // Only the basic algorithm in section 5.2 of [RFC3986] is used; neither Syntax-Based Normalization nor
    // Scheme-Based Normalization are performed. Characters additionally allowed in IRI references are treated in
    // the same way that unreserved characters are treated in URI references, per section 6.5 of [RFC3987].
    if (documentRelative) {
      return baseIri.resolve(value);
    }
    // 7.) Return value as is.
    return value;
  }

  Future<Object> expandValue(
      Context activeContext, String activeProperty, Object value) async {
    // 1.) If the active property has a type mapping in active context that is @id, return a new JSON
    // object containing a single key-value pair where the key is @id and the value is the result of
    // using the IRI Expansion algorithm, passing active context, value, and true for document relative.
    if (activeContext.termDefinitions[activeProperty]?.typeMapping == '@id') {
      if (value is String) {
        return {
          '@id': await expandIri(activeContext, value, documentRelative: true)
        };
      } else {
        throw JsonLDException('invalid @id value', message: value.toString());
      }
    }
    // 2.) If active property has a type mapping in active context that is @vocab, return a new JSON
    // object containing a single key-value pair where the key is @id and the value is the result of
    // using the IRI Expansion algorithm, passing active context, value, true for vocab, and true for
    // document relative.
    if (activeContext.termDefinitions[activeProperty]?.typeMapping ==
        '@vocab') {
      if (value is String) {
        return {
          '@id': await expandIri(activeContext, value,
              documentRelative: true, vocab: true)
        };
      } else {
        // TODO: There seems to be no official error for this...?
        throw JsonLDException('invalid @vocab value',
            message: value.toString());
      }
    }
    // 3.) Otherwise, initialize result to a JSON object with an @value member whose value is set to value.
    var result = <String, dynamic>{'@value': value};
    // 4.) If active property has a type mapping in active context, add an @type member to result and set
    // its value to the value associated with the type mapping.
    var typeMapping =
        activeContext.termDefinitions[activeProperty]?.typeMapping;
    if (typeMapping != null) {
      result['@type'] = typeMapping;
    }
    // 5.) Otherwise, if value is a string:
    else if (value is String) {
      // 5.1) If a language mapping is associated with active property in active context, add an @language
      // to result and set its value to the language code associated with the language mapping; unless the
      // language mapping is set to null in which case no member is added.
      if (activeContext.termDefinitions.containsKey(activeProperty)) {
        var languageMapping =
            activeContext.termDefinitions[activeProperty]?.languageMapping;
        if (languageMapping != null) {
          result['@language'] = languageMapping;
        }
      }

      // 5.2) Otherwise, if the active context has a default language, add an @language to result and set
      // its value to the default language.
      else if (activeContext.defaultLanguage != null) {
        result['@language'] = activeContext.defaultLanguage;
      }
    }
    // 6.) Return result.
    return result;
  }
}
