import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "config.dart";
import "naming.dart";
import "selection_resolver.dart";

class ReqEmitter {
  final BuilderConfig config;
  final Set<String> fragmentsWithVars;
  final DocumentIndex documentIndex;
  final Map<String, String> fragmentSourceUrls;

  ReqEmitter({
    required this.config,
    required this.fragmentsWithVars,
    required this.documentIndex,
    required this.fragmentSourceUrls,
  });

  Library buildLibrary({
    required Iterable<OperationDefinitionNode> ownedOperations,
    required Iterable<FragmentDefinitionNode> ownedFragments,
  }) {
    final specs = <Spec>[];

    for (final operation in ownedOperations) {
      if (operation.name == null) continue;
      specs.add(_buildOperationReq(operation));
    }

    for (final fragment in ownedFragments) {
      specs.add(_buildFragmentReq(fragment));
    }

    return Library((b) => b..body.addAll(specs));
  }

  Class _buildOperationReq(OperationDefinitionNode operation) {
    final operationName = operation.name!.value;
    final hasVars = operation.variableDefinitions.isNotEmpty;
    final className = builtClassName("${operationName}Req");
    final dataTypeRef = Reference(
      builtClassName("${operationName}Data"),
      "#data",
    );
    final varsTypeRef = hasVars
        ? Reference(
            builtClassName("${operationName}Vars"),
            "#var",
          )
        : refer("Null");
    final opTypeRef = TypeReference(
      (b) => b
        ..symbol = "OperationRequest"
        ..url = "package:ferry_exec/ferry_exec.dart"
        ..types.addAll([dataTypeRef, varsTypeRef]),
    );
    final nullableDataType = _nullableReference(dataTypeRef);

    final documentExpr = _documentForOperation(operation);

    final fields = <Field>[
      Field(
        (b) => b
          ..name = "vars"
          ..modifier = FieldModifier.final$
          ..type = varsTypeRef
          ..assignment = hasVars ? null : const Code("null"),
      ),
      Field(
        (b) => b
          ..name = "operation"
          ..modifier = FieldModifier.final$
          ..type = refer("Operation", "package:gql_exec/gql_exec.dart"),
      ),
      Field(
        (b) => b
          ..name = "requestId"
          ..modifier = FieldModifier.final$
          ..type = TypeReference(
            (b) => b
              ..symbol = "String"
              ..isNullable = true,
          ),
      ),
      Field(
        (b) => b
          ..name = "updateResult"
          ..modifier = FieldModifier.final$
          ..type = _nullableReference(
            FunctionType(
              (b) => b
                ..returnType = nullableDataType
                ..requiredParameters.addAll([
                  nullableDataType,
                  nullableDataType,
                ]),
            ),
          ),
      ),
      Field(
        (b) => b
          ..name = "optimisticResponse"
          ..modifier = FieldModifier.final$
          ..type = nullableDataType,
      ),
      Field(
        (b) => b
          ..name = "updateCacheHandlerKey"
          ..modifier = FieldModifier.final$
          ..type = TypeReference(
            (b) => b
              ..symbol = "String"
              ..isNullable = true,
          ),
      ),
      Field(
        (b) => b
          ..name = "updateCacheHandlerContext"
          ..modifier = FieldModifier.final$
          ..type = TypeReference(
            (b) => b
              ..symbol = "Map"
              ..types.addAll([
                refer("String"),
                refer("dynamic"),
              ])
              ..isNullable = true,
          ),
      ),
      Field(
        (b) => b
          ..name = "fetchPolicy"
          ..modifier = FieldModifier.final$
          ..type = TypeReference(
            (b) => b
              ..symbol = "FetchPolicy"
              ..url = "package:ferry_exec/ferry_exec.dart"
              ..isNullable = true,
          ),
      ),
      Field(
        (b) => b
          ..name = "executeOnListen"
          ..modifier = FieldModifier.final$
          ..type = refer("bool"),
      ),
      Field(
        (b) => b
          ..name = "context"
          ..modifier = FieldModifier.final$
          ..type = TypeReference(
            (b) => b
              ..symbol = "Context"
              ..url = "package:gql_exec/gql_exec.dart"
              ..isNullable = true,
          ),
      ),
      Field(
        (b) => b
          ..name = "_document"
          ..static = true
          ..modifier = FieldModifier.final$
          ..type = refer("DocumentNode", "package:gql/ast.dart")
          ..assignment = documentExpr.code,
      ),
      Field(
        (b) => b
          ..name = "_operation"
          ..static = true
          ..modifier = FieldModifier.final$
          ..type = refer("Operation", "package:gql_exec/gql_exec.dart")
          ..assignment = refer(
            "Operation",
            "package:gql_exec/gql_exec.dart",
          ).call(
            [],
            {
              "document": refer("_document"),
              "operationName": literalString(operationName),
            },
          ).code,
      ),
    ];

    final constructorParams = <Parameter>[
      if (hasVars)
        Parameter(
          (b) => b
            ..name = "vars"
            ..named = true
            ..required = true
            ..toThis = true,
        ),
      Parameter(
        (b) => b
          ..name = "operation"
          ..named = true
          ..type = _nullableReference(
            refer("Operation", "package:gql_exec/gql_exec.dart"),
          ),
      ),
      Parameter(
        (b) => b
          ..name = "requestId"
          ..named = true
          ..toThis = true,
      ),
      Parameter(
        (b) => b
          ..name = "updateResult"
          ..named = true
          ..toThis = true,
      ),
      Parameter(
        (b) => b
          ..name = "optimisticResponse"
          ..named = true
          ..toThis = true,
      ),
      Parameter(
        (b) => b
          ..name = "updateCacheHandlerKey"
          ..named = true
          ..toThis = true,
      ),
      Parameter(
        (b) => b
          ..name = "updateCacheHandlerContext"
          ..named = true
          ..toThis = true,
      ),
      Parameter(
        (b) => b
          ..name = "fetchPolicy"
          ..named = true
          ..toThis = true,
      ),
      Parameter(
        (b) => b
          ..name = "executeOnListen"
          ..named = true
          ..toThis = true
          ..defaultTo = const Code("true"),
      ),
      Parameter(
        (b) => b
          ..name = "context"
          ..named = true
          ..toThis = true,
      ),
    ];

    return Class(
      (b) => b
        ..name = className
        ..implements.add(opTypeRef)
        ..fields.addAll(fields)
        ..constructors.add(
          Constructor(
            (b) => b
              ..optionalParameters.addAll(constructorParams)
              ..initializers.add(
                Code("operation = operation ?? _operation"),
              ),
          ),
        )
        ..methods.addAll([
          Method(
            (b) => b
              ..name = "execRequest"
              ..type = MethodType.getter
              ..returns = refer("Request", "package:gql_exec/gql_exec.dart")
              ..lambda = true
              ..body = refer(
                "Request",
                "package:gql_exec/gql_exec.dart",
              ).call(
                [],
                {
                  "operation": refer("operation"),
                  "variables": refer("varsToJson").call([]),
                  "context": refer("context").ifNullThen(
                    refer("Context", "package:gql_exec/gql_exec.dart")
                        .constInstance([]),
                  ),
                },
              ).code,
          ),
          Method(
            (b) => b
              ..name = "parseData"
              ..returns = nullableDataType
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = "json"
                    ..type = refer("Map<String, dynamic>"),
                ),
              )
              ..lambda = true
              ..body =
                  dataTypeRef.property("fromJson").call([refer("json")]).code,
          ),
          Method(
            (b) => b
              ..name = "varsToJson"
              ..returns = refer("Map<String, dynamic>")
              ..lambda = true
              ..body = hasVars
                  ? refer("vars").property("toJson").call([]).code
                  : const Code("const <String, dynamic>{}"),
          ),
          Method(
            (b) => b
              ..name = "dataToJson"
              ..returns = refer("Map<String, dynamic>")
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = "data"
                    ..type = dataTypeRef,
                ),
              )
              ..lambda = true
              ..body = refer("data").property("toJson").call([]).code,
          ),
          Method(
            (b) => b
              ..name = "transformOperation"
              ..returns = opTypeRef
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = "transform"
                    ..type = FunctionType(
                      (b) => b
                        ..returnType =
                            refer("Operation", "package:gql_exec/gql_exec.dart")
                        ..requiredParameters.add(
                          refer(
                            "Operation",
                            "package:gql_exec/gql_exec.dart",
                          ),
                        ),
                    ),
                ),
              )
              ..body =
                  Code(_transformOperationBody(className, hasVars: hasVars)),
          ),
        ]),
    );
  }

  String _transformOperationBody(String className, {required bool hasVars}) =>
      """
return $className(
${hasVars ? "  vars: vars," : ""}
  operation: transform(operation),
  requestId: requestId,
  updateResult: updateResult,
  optimisticResponse: optimisticResponse,
  updateCacheHandlerKey: updateCacheHandlerKey,
  updateCacheHandlerContext: updateCacheHandlerContext,
  fetchPolicy: fetchPolicy,
  executeOnListen: executeOnListen,
  context: context,
);
""";

  Class _buildFragmentReq(FragmentDefinitionNode fragment) {
    final fragmentName = fragment.name.value;
    final hasVars = fragmentsWithVars.contains(fragmentName);
    final className = builtClassName("${fragmentName}Req");
    final dataTypeRef = Reference(
      builtClassName("${fragmentName}Data"),
      "#data",
    );
    final varsTypeRef = hasVars
        ? Reference(
            builtClassName("${fragmentName}Vars"),
            "#var",
          )
        : refer("Null");
    final reqTypeRef = TypeReference(
      (b) => b
        ..symbol = "FragmentRequest"
        ..url = "package:ferry_exec/ferry_exec.dart"
        ..types.addAll([dataTypeRef, varsTypeRef]),
    );
    final nullableDataType = _nullableReference(dataTypeRef);

    final documentExpr = _documentForFragment(fragment);

    return Class(
      (b) => b
        ..name = className
        ..implements.add(reqTypeRef)
        ..fields.addAll([
          Field(
            (b) => b
              ..name = "vars"
              ..modifier = FieldModifier.final$
              ..type = varsTypeRef
              ..assignment = hasVars ? null : const Code("null"),
          ),
          Field(
            (b) => b
              ..name = "document"
              ..modifier = FieldModifier.final$
              ..type = refer("DocumentNode", "package:gql/ast.dart"),
          ),
          Field(
            (b) => b
              ..name = "fragmentName"
              ..modifier = FieldModifier.final$
              ..type = TypeReference(
                (b) => b
                  ..symbol = "String"
                  ..isNullable = true,
              ),
          ),
          Field(
            (b) => b
              ..name = "idFields"
              ..modifier = FieldModifier.final$
              ..type = TypeReference(
                (b) => b
                  ..symbol = "Map"
                  ..types.addAll([
                    refer("String"),
                    refer("dynamic"),
                  ]),
              ),
          ),
          Field(
            (b) => b
              ..name = "_document"
              ..static = true
              ..modifier = FieldModifier.final$
              ..type = refer("DocumentNode", "package:gql/ast.dart")
              ..assignment = documentExpr.code,
          ),
        ])
        ..constructors.add(
          Constructor(
            (b) => b
              ..optionalParameters.addAll([
                if (hasVars)
                  Parameter(
                    (b) => b
                      ..name = "vars"
                      ..named = true
                      ..required = true
                      ..toThis = true,
                  ),
                Parameter(
                  (b) => b
                    ..name = "document"
                    ..named = true
                    ..type = _nullableReference(
                      refer("DocumentNode", "package:gql/ast.dart"),
                    ),
                ),
                Parameter(
                  (b) => b
                    ..name = "fragmentName"
                    ..named = true
                    ..toThis = true
                    ..defaultTo = Code("'$fragmentName'"),
                ),
                Parameter(
                  (b) => b
                    ..name = "idFields"
                    ..named = true
                    ..toThis = true
                    ..defaultTo = const Code("const <String, dynamic>{}"),
                ),
              ])
              ..initializers.add(
                Code("document = document ?? _document"),
              ),
          ),
        )
        ..methods.addAll([
          Method(
            (b) => b
              ..name = "parseData"
              ..returns = nullableDataType
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = "json"
                    ..type = refer("Map<String, dynamic>"),
                ),
              )
              ..lambda = true
              ..body =
                  dataTypeRef.property("fromJson").call([refer("json")]).code,
          ),
          Method(
            (b) => b
              ..name = "varsToJson"
              ..returns = refer("Map<String, dynamic>")
              ..lambda = true
              ..body = hasVars
                  ? refer("vars").property("toJson").call([]).code
                  : const Code("const <String, dynamic>{}"),
          ),
          Method(
            (b) => b
              ..name = "dataToJson"
              ..returns = refer("Map<String, dynamic>")
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..name = "data"
                    ..type = dataTypeRef,
                ),
              )
              ..lambda = true
              ..body = refer("data").property("toJson").call([]).code,
          ),
        ]),
    );
  }

  Expression _documentForOperation(OperationDefinitionNode operation) {
    final name = operation.name?.value;
    if (name == null) {
      throw StateError("Operations must be named");
    }
    final fragmentNames = _collectFragmentSpreads(operation.selectionSet);
    final definitionRefs = _definitionRefsForOperation(
      operationName: name,
      fragmentNames: fragmentNames,
    );
    return _documentExpression(definitionRefs);
  }

  Expression _documentForFragment(FragmentDefinitionNode fragment) {
    final fragmentNames = _collectFragmentSpreads(fragment.selectionSet)
      ..add(fragment.name.value);
    final definitionRefs = _definitionRefsForOperation(
      operationName: null,
      fragmentNames: fragmentNames,
    );
    return _documentExpression(definitionRefs);
  }

  Expression _documentExpression(List<Expression> definitionRefs) =>
      refer("DocumentNode", "package:gql/ast.dart").call(
        [],
        {
          "definitions": literalList(definitionRefs),
        },
      );

  List<Expression> _definitionRefsForOperation({
    required String? operationName,
    required Set<String> fragmentNames,
  }) {
    final refs = <Expression>[];
    var foundOperation = false;
    for (final definition in documentIndex.document.definitions) {
      if (definition is OperationDefinitionNode) {
        final name = definition.name?.value;
        if (name == null || name != operationName) {
          continue;
        }
        refs.add(_definitionRef(name));
        foundOperation = true;
      } else if (definition is FragmentDefinitionNode) {
        final name = definition.name.value;
        if (!fragmentNames.contains(name)) {
          continue;
        }
        refs.add(_definitionRef(name, sourceUrl: fragmentSourceUrls[name]));
      }
    }

    if (operationName != null && !foundOperation) {
      throw StateError("Missing operation definition for $operationName");
    }
    if (refs.isEmpty) {
      throw StateError("No definitions found for request document");
    }
    return refs;
  }

  Expression _definitionRef(
    String definitionName, {
    String? sourceUrl,
  }) {
    final url = sourceUrl == null ? "#ast" : "$sourceUrl#ast";
    return Reference(identifier(definitionName), url);
  }

  Set<String> _collectFragmentSpreads(SelectionSetNode selectionSet) {
    final fragments = <String>{};
    final visited = <String>{};

    void visit(SelectionSetNode set) {
      for (final selection in set.selections) {
        if (selection is FieldNode) {
          final nested = selection.selectionSet;
          if (nested != null) {
            visit(nested);
          }
        } else if (selection is InlineFragmentNode) {
          visit(selection.selectionSet);
        } else if (selection is FragmentSpreadNode) {
          final name = selection.name.value;
          fragments.add(name);
          if (!visited.add(name)) {
            continue;
          }
          final fragment = documentIndex.getFragment(name);
          visit(fragment.selectionSet);
        }
      }
    }

    visit(selectionSet);
    return fragments;
  }

  Reference _nullableReference(Reference reference) {
    if (reference is FunctionType) {
      return reference.rebuild((b) => b..isNullable = true);
    }
    if (reference is TypeReference) {
      return reference.rebuild((b) => b..isNullable = true);
    }
    return TypeReference(
      (b) => b
        ..symbol = reference.symbol
        ..url = reference.url
        ..isNullable = true,
    );
  }
}
