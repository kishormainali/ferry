import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "config.dart";
import "naming.dart";

class ReqEmitter {
  final BuilderConfig config;
  final Set<String> fragmentsWithVars;

  ReqEmitter({required this.config, required this.fragmentsWithVars});

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
              "document": Reference("document", "#ast"),
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
                    ..type = config.dataToJsonMode
                        .getDataToJsonParamType(dataTypeRef),
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
              ..assignment = Reference("document", "#ast").code,
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
                    ..type = config.dataToJsonMode
                        .getDataToJsonParamType(dataTypeRef),
                ),
              )
              ..lambda = true
              ..body = refer("data").property("toJson").call([]).code,
          ),
        ]),
    );
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
