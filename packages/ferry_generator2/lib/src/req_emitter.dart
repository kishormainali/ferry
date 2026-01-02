import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "config.dart";
import "data_emitter_context.dart";
import "data_emitter_types.dart";
import "naming.dart";
import "selection_resolver.dart";

class ReqEmitter {
  final BuilderConfig config;
  final Set<String> fragmentsWithVars;
  final DocumentIndex documentIndex;
  final Map<String, String> fragmentSourceUrls;
  final String? utilsUrl;
  bool _needsUtilsImport = false;

  ReqEmitter({
    required this.config,
    required this.fragmentsWithVars,
    required this.documentIndex,
    required this.fragmentSourceUrls,
    required this.utilsUrl,
  });

  Library buildLibrary({
    required Iterable<OperationDefinitionNode> ownedOperations,
    required Iterable<FragmentDefinitionNode> ownedFragments,
  }) {
    final specs = <Spec>[];
    _needsUtilsImport = false;

    for (final operation in ownedOperations) {
      if (operation.name == null) continue;
      specs.add(_buildOperationReq(operation));
    }

    for (final fragment in ownedFragments) {
      specs.add(_buildFragmentReq(fragment));
    }

    return Library(
      (b) => b
        ..directives.addAll(
          _needsUtilsImport && utilsUrl != null
              ? [Directive.import(utilsUrl!, as: utilsImportAlias)]
              : const [],
        )
        ..body.addAll(specs),
    );
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
          ..modifier = FieldModifier.constant
          ..type = refer("DocumentNode", "package:gql/ast.dart")
          ..assignment = documentExpr.code,
      ),
      Field(
        (b) => b
          ..name = "_operation"
          ..static = true
          ..modifier = FieldModifier.constant
          ..type = refer("Operation", "package:gql_exec/gql_exec.dart")
          ..assignment = refer(
            "Operation",
            "package:gql_exec/gql_exec.dart",
          ).constInstance(
            [],
            {
              "document": refer("_document"),
              "operationName": literalString(operationName),
            },
          ).code,
      ),
    ];

    final fieldSpecs = [
      _ReqFieldSpec(
        name: "vars",
        typeRef: varsTypeRef,
        isNullable: !hasVars || _isNullableReference(varsTypeRef),
      ),
      _ReqFieldSpec(
        name: "operation",
        typeRef: refer("Operation", "package:gql_exec/gql_exec.dart"),
        isNullable: false,
      ),
      _ReqFieldSpec(
        name: "requestId",
        typeRef: TypeReference(
          (b) => b
            ..symbol = "String"
            ..isNullable = true,
        ),
        isNullable: true,
      ),
      _ReqFieldSpec(
        name: "updateResult",
        typeRef: _nullableReference(
          FunctionType(
            (b) => b
              ..returnType = nullableDataType
              ..requiredParameters.addAll([
                nullableDataType,
                nullableDataType,
              ]),
          ),
        ),
        isNullable: true,
      ),
      _ReqFieldSpec(
        name: "optimisticResponse",
        typeRef: nullableDataType,
        isNullable: true,
      ),
      _ReqFieldSpec(
        name: "updateCacheHandlerKey",
        typeRef: TypeReference(
          (b) => b
            ..symbol = "String"
            ..isNullable = true,
        ),
        isNullable: true,
      ),
      _ReqFieldSpec(
        name: "updateCacheHandlerContext",
        typeRef: TypeReference(
          (b) => b
            ..symbol = "Map"
            ..types.addAll([
              refer("String"),
              refer("dynamic"),
            ])
            ..isNullable = true,
        ),
        isNullable: true,
        isMap: true,
      ),
      _ReqFieldSpec(
        name: "fetchPolicy",
        typeRef: TypeReference(
          (b) => b
            ..symbol = "FetchPolicy"
            ..url = "package:ferry_exec/ferry_exec.dart"
            ..isNullable = true,
        ),
        isNullable: true,
      ),
      _ReqFieldSpec(
        name: "executeOnListen",
        typeRef: refer("bool"),
        isNullable: false,
      ),
      _ReqFieldSpec(
        name: "context",
        typeRef: TypeReference(
          (b) => b
            ..symbol = "Context"
            ..url = "package:gql_exec/gql_exec.dart"
            ..isNullable = true,
        ),
        isNullable: true,
      ),
    ];
    _markUtilsUsage(fieldSpecs);
    final copyWithFields = hasVars
        ? fieldSpecs
        : fieldSpecs.where((f) => f.name != "vars").toList();

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
          if (config.generateCopyWith)
            _buildCopyWithMethod(
              className,
              copyWithFields,
            ),
          if (config.generateEquals)
            _buildEqualsMethod(
              className,
              fieldSpecs,
            ),
          if (config.generateHashCode)
            _buildHashCodeGetter(
              fieldSpecs,
            ),
          if (config.generateToString)
            _buildToStringMethod(
              className,
              fieldSpecs,
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

    final fieldSpecs = [
      _ReqFieldSpec(
        name: "vars",
        typeRef: varsTypeRef,
        isNullable: !hasVars || _isNullableReference(varsTypeRef),
      ),
      _ReqFieldSpec(
        name: "document",
        typeRef: refer("DocumentNode", "package:gql/ast.dart"),
        isNullable: false,
      ),
      _ReqFieldSpec(
        name: "fragmentName",
        typeRef: TypeReference(
          (b) => b
            ..symbol = "String"
            ..isNullable = true,
        ),
        isNullable: true,
      ),
      _ReqFieldSpec(
        name: "idFields",
        typeRef: TypeReference(
          (b) => b
            ..symbol = "Map"
            ..types.addAll([
              refer("String"),
              refer("dynamic"),
            ]),
        ),
        isNullable: false,
        isMap: true,
      ),
    ];
    _markUtilsUsage(fieldSpecs);
    final copyWithFields = hasVars
        ? fieldSpecs
        : fieldSpecs.where((f) => f.name != "vars").toList();

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
              ..modifier = FieldModifier.constant
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
          if (config.generateCopyWith)
            _buildCopyWithMethod(
              className,
              copyWithFields,
            ),
          if (config.generateEquals)
            _buildEqualsMethod(
              className,
              fieldSpecs,
            ),
          if (config.generateHashCode)
            _buildHashCodeGetter(
              fieldSpecs,
            ),
          if (config.generateToString)
            _buildToStringMethod(
              className,
              fieldSpecs,
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
      refer("DocumentNode", "package:gql/ast.dart").constInstance(
        [],
        {
          "definitions": literalConstList(definitionRefs),
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

  void _markUtilsUsage(List<_ReqFieldSpec> fieldsList) {
    if (!config.generateEquals && !config.generateHashCode) {
      return;
    }
    if (fieldsList.any((field) => field.isMap || field.isList)) {
      _needsUtilsImport = true;
    }
  }
}

class _ReqFieldSpec {
  final String name;
  final Reference typeRef;
  final bool isNullable;
  final bool isMap;
  final bool isList;

  const _ReqFieldSpec({
    required this.name,
    required this.typeRef,
    required this.isNullable,
    this.isMap = false,
    this.isList = false,
  });
}

Method _buildCopyWithMethod(
  String className,
  List<_ReqFieldSpec> fieldsList,
) {
  final parameters = <Parameter>[];
  final args = <String, Expression>{};

  for (final field in fieldsList) {
    final paramType = field.isNullable
        ? field.typeRef
        : _nullableTypeReference(field.typeRef);
    parameters.add(
      Parameter(
        (b) => b
          ..name = field.name
          ..type = paramType
          ..named = true,
      ),
    );

    if (field.isNullable) {
      final isSetName = _copyWithIsSetName(field.name);
      parameters.add(
        Parameter(
          (b) => b
            ..name = isSetName
            ..type = refer("bool")
            ..named = true
            ..defaultTo = const Code("false"),
        ),
      );
      args[field.name] = conditionalExpression(
        refer(isSetName),
        refer(field.name),
        refer("this").property(field.name),
      );
    } else {
      args[field.name] =
          refer(field.name).ifNullThen(refer("this").property(field.name));
    }
  }

  final constructorCall = refer(className).call([], args);
  return Method(
    (b) => b
      ..name = "copyWith"
      ..returns = refer(className)
      ..optionalParameters.addAll(parameters)
      ..body = Block.of([constructorCall.returned.statement]),
  );
}

Method _buildEqualsMethod(
  String className,
  List<_ReqFieldSpec> fieldsList,
) {
  final comparisons = fieldsList
      .map(
        (field) => _equalsExpressionForField(
          field,
          "other.${field.name}",
        ),
      )
      .join(" && ");
  final body = fieldsList.isEmpty
      ? "return identical(this, other) || other is $className;"
      : "return identical(this, other) || "
          "(other is $className && $comparisons);";

  return Method(
    (b) => b
      ..name = "operator =="
      ..annotations.add(refer("override"))
      ..returns = refer("bool")
      ..requiredParameters.add(
        Parameter(
          (b) => b
            ..name = "other"
            ..type = refer("Object"),
        ),
      )
      ..body = Code(body),
  );
}

Method _buildHashCodeGetter(List<_ReqFieldSpec> fieldsList) {
  final entries = [
    "runtimeType",
    ...fieldsList.map(_hashExpressionForField),
  ];
  final body = entries.length == 1
      ? const Code("return runtimeType.hashCode;")
      : entries.length <= 20
          ? Code("return Object.hash(${entries.join(", ")});")
          : Code("return Object.hashAll([${entries.join(", ")}]);");
  return Method(
    (b) => b
      ..annotations.add(refer("override"))
      ..name = "hashCode"
      ..type = MethodType.getter
      ..returns = refer("int")
      ..body = body,
  );
}

Method _buildToStringMethod(
  String className,
  List<_ReqFieldSpec> fieldsList,
) {
  final parts =
      fieldsList.map((field) => "${field.name}: \$${field.name}").join(
            ", ",
          );
  final value = fieldsList.isEmpty ? "$className()" : "$className($parts)";
  return Method(
    (b) => b
      ..annotations.add(refer("override"))
      ..name = "toString"
      ..returns = refer("String")
      ..body = Code("return '$value';"),
  );
}

String _copyWithIsSetName(String propertyName) =>
    identifier("${propertyName}IsSet");

Reference _nullableTypeReference(Reference reference) {
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

bool _isNullableReference(Reference reference) {
  if (reference is FunctionType) {
    return reference.isNullable ?? false;
  }
  if (reference is TypeReference) {
    return reference.isNullable ?? false;
  }
  return reference.symbol == "Null";
}

String _equalsExpressionForField(
  _ReqFieldSpec field,
  String right,
) {
  if (field.isList || field.isMap) {
    return "${utilsPrefix}deepEquals(${field.name}, $right)";
  }
  return "${field.name} == $right";
}

String _hashExpressionForField(_ReqFieldSpec field) {
  if (field.isList || field.isMap) {
    return "${utilsPrefix}deepHash(${field.name})";
  }
  return field.name;
}
