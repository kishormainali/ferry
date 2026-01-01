import "package:code_builder/code_builder.dart";
import "package:gql/ast.dart";

import "config.dart";
import "naming.dart";
import "schema.dart";
import "selection_resolver.dart";
import "type_utils.dart";

class DataEmitter {
  final SchemaIndex schema;
  final BuilderConfig config;
  final DocumentIndex documentIndex;
  final SelectionResolver resolver;
  final Map<String, String> fragmentSourceUrls;
  final Set<String> extraImports = {};

  final Map<String, FragmentInfo> _fragmentInfo = {};
  final Set<String> _generatedClasses = {};
  final Set<String> _generatedInterfaces = {};
  final Map<String, ResolvedSelectionSet> _fragmentInterfaceSelections = {};
  final Map<String, String> _interfaceKeyToFragmentName = {};

  DataEmitter({
    required this.schema,
    required this.config,
    required this.documentIndex,
    required this.resolver,
    required this.fragmentSourceUrls,
  }) {
    _indexFragments();
  }

  Library buildLibrary({
    required Iterable<FragmentDefinitionNode> ownedFragments,
    required Iterable<OperationDefinitionNode> ownedOperations,
  }) {
    final specs = <Spec>[];

    for (final fragment in ownedFragments) {
      specs.addAll(_buildFragmentInterfaces(fragment));
      specs.addAll(_buildFragmentData(fragment));
    }

    for (final operation in ownedOperations) {
      specs.addAll(_buildOperationData(operation));
    }

    return Library(
      (b) => b
        ..directives.addAll(
          extraImports.map(Directive.import),
        )
        ..body.addAll(specs),
    );
  }

  void _indexFragments() {
    for (final fragment in documentIndex.fragments.values) {
      final resolved = resolver.resolveFragment(fragment);
      _fragmentInfo[fragment.name.value] = FragmentInfo(
        name: fragment.name.value,
        typeCondition: fragment.typeCondition.on.name.value,
        selectionSet: resolved,
        inlineTypes: resolved.inlineFragments.keys.toSet(),
      );
      _indexFragmentInterfaceSelections(fragment.name.value, resolved);
    }
  }

  List<Spec> _buildFragmentInterfaces(FragmentDefinitionNode fragment) {
    final info = _fragmentInfo[fragment.name.value];
    if (info == null) return [];

    final specs = <Spec>[];
    final baseKey = fragment.name.value;
    specs.add(
      _buildFragmentInterfaceClass(
        interfaceKey: baseKey,
        selectionSet: info.selectionSet,
        implementsRefs: const [],
      ),
    );
    specs.addAll(
      _buildFragmentNestedInterfaces(
        interfaceKey: baseKey,
        selectionSet: info.selectionSet,
      ),
    );

    for (final entry in info.selectionSet.inlineFragments.entries) {
      final typeName = entry.key;
      final inlineKey = "${fragment.name.value}__as$typeName";
      specs.add(
        _buildFragmentInterfaceClass(
          interfaceKey: inlineKey,
          selectionSet: entry.value,
          implementsRefs: [refer(builtClassName(fragment.name.value))],
        ),
      );
      specs.addAll(
        _buildFragmentNestedInterfaces(
          interfaceKey: inlineKey,
          selectionSet: entry.value,
        ),
      );
    }

    return specs;
  }

  List<Spec> _buildFragmentData(FragmentDefinitionNode fragment) {
    final resolved = _fragmentInfo[fragment.name.value]?.selectionSet;
    if (resolved == null) return [];

    final baseName = "${fragment.name.value}Data";
    return _buildSelectionSetClasses(
      baseName: baseName,
      selectionSet: resolved,
      parentTypeName: resolved.parentTypeName,
      fragmentSpreads: resolved.fragmentSpreads,
      classImplements: [
        refer(builtClassName(fragment.name.value)),
      ],
      fragmentName: fragment.name.value,
    );
  }

  List<Spec> _buildOperationData(OperationDefinitionNode operation) {
    if (operation.name == null) return [];
    final resolved = resolver.resolveOperation(operation);
    final baseName = "${operation.name!.value}Data";
    return _buildSelectionSetClasses(
      baseName: baseName,
      selectionSet: resolved,
      parentTypeName: resolved.parentTypeName,
      fragmentSpreads: resolved.fragmentSpreads,
      classImplements: const [],
      fragmentName: null,
    );
  }

  List<Spec> _buildSelectionSetClasses({
    required String baseName,
    required ResolvedSelectionSet selectionSet,
    required String parentTypeName,
    required Set<String> fragmentSpreads,
    required List<Reference> classImplements,
    required String? fragmentName,
  }) {
    final className = builtClassName(baseName);
    if (!_generatedClasses.add(className)) {
      return [];
    }

    final specs = <Spec>[];

    if (selectionSet.inlineFragments.isEmpty) {
      final fields = _buildFieldSpecs(
        baseName: baseName,
        selectionSet: selectionSet,
        parentTypeName: parentTypeName,
        fieldContext: FieldContext.base,
      );
      final implementsRefs = _interfaceRefs(
        fragmentSpreads,
        parentTypeName,
        classImplements,
      );
      specs.add(
        _buildConcreteClass(
          className: className,
          fields: fields,
          implementsRefs: implementsRefs,
          extendsRef: null,
          superFields: const [],
          usesSuperToJson: false,
        ),
      );
      specs.addAll(_buildNestedClasses(baseName, fields, implementsRefs));
      return specs;
    }

    final baseFields = _buildFieldSpecs(
      baseName: baseName,
      selectionSet: selectionSet,
      parentTypeName: parentTypeName,
      fieldContext: FieldContext.base,
    );

    final baseImplements = _interfaceRefs(
      fragmentSpreads,
      parentTypeName,
      classImplements,
    );
    specs.add(
      _buildPolymorphicBaseClass(
        className: className,
        baseFields: baseFields,
        inlineTypeNames: selectionSet.inlineFragments.keys.toList(),
        implementsRefs: baseImplements,
      ),
    );
    final whenExtension = _buildWhenExtension(
      baseName: baseName,
      inlineTypeNames: selectionSet.inlineFragments.keys.toList(),
    );
    if (whenExtension != null) {
      specs.add(whenExtension);
    }
    specs.addAll(_buildNestedClasses(baseName, baseFields, baseImplements));

    for (final entry in selectionSet.inlineFragments.entries) {
      final typeName = entry.key;
      final inlineBaseName = "${baseName}__as$typeName";
      final inlineFields = _buildFieldSpecs(
        baseName: inlineBaseName,
        selectionSet: entry.value,
        parentTypeName: typeName,
        fieldContext: FieldContext.inline,
      );
      final baseKeys = baseFields.map((field) => field.responseKey).toSet();
      final mergedFields = [
        ...baseFields,
        ...inlineFields.where(
          (field) => !baseKeys.contains(field.responseKey),
        ),
      ];
      final inlineImplements = _interfaceRefs(
        entry.value.fragmentSpreads,
        typeName,
        classImplements,
      );
      final fragmentInfo =
          fragmentName == null ? null : _fragmentInfo[fragmentName];
      if (fragmentInfo != null && fragmentInfo.inlineTypes.contains(typeName)) {
        inlineImplements.add(
          refer(builtClassName("${fragmentName}__as$typeName")),
        );
      }
      specs.add(
        _buildConcreteClass(
          className: builtClassName(inlineBaseName),
          fields: mergedFields,
          implementsRefs: inlineImplements,
          extendsRef: refer(className),
          superFields: baseFields,
          usesSuperToJson: true,
        ),
      );
      specs.addAll(
        _buildNestedClasses(
          inlineBaseName,
          inlineFields
              .where((field) => !baseKeys.contains(field.responseKey))
              .toList(),
          inlineImplements,
        ),
      );
    }

    specs.add(
      _buildConcreteClass(
        className: builtClassName("${baseName}__unknown"),
        fields: baseFields,
        implementsRefs: _interfaceRefs(
          fragmentSpreads,
          parentTypeName,
          classImplements,
        ),
        extendsRef: refer(className),
        superFields: baseFields,
        usesSuperToJson: true,
      ),
    );

    return specs;
  }

  Extension? _buildWhenExtension({
    required String baseName,
    required List<String> inlineTypeNames,
  }) {
    if (inlineTypeNames.isEmpty) return null;
    if (!config.whenExtensionConfig.generateWhenExtensionMethod &&
        !config.whenExtensionConfig.generateMaybeWhenExtensionMethod) {
      return null;
    }

    final className = builtClassName(baseName);
    final usedNames = <String>{"orElse", "_T"};
    final paramNames = <String, String>{};

    String uniqueParamName(String typeName) {
      var name = identifier(_uncapitalize(typeName));
      while (usedNames.contains(name)) {
        name = identifier("g$name");
      }
      usedNames.add(name);
      return name;
    }

    for (final typeName in inlineTypeNames) {
      paramNames[typeName] = uniqueParamName(typeName);
    }

    final methods = <Method>[];
    if (config.whenExtensionConfig.generateWhenExtensionMethod) {
      methods.add(
        Method(
          (b) => b
            ..name = "when"
            ..returns = refer("_T")
            ..types.add(refer("_T"))
            ..optionalParameters.addAll([
              for (final typeName in inlineTypeNames)
                Parameter(
                  (b) => b
                    ..name = paramNames[typeName]!
                    ..type = FunctionType(
                      (b) => b
                        ..returnType = refer("_T")
                        ..requiredParameters.add(
                          refer(
                            builtClassName("${baseName}__as$typeName"),
                          ),
                        ),
                    )
                    ..named = true
                    ..required = true,
                ),
              Parameter(
                (b) => b
                  ..name = "orElse"
                  ..type = FunctionType((b) => b..returnType = refer("_T"))
                  ..named = true
                  ..required = true,
              ),
            ])
            ..body = Block.of([
              const Code("switch(G__typename) {"),
              for (final typeName in inlineTypeNames)
                Code(
                  "case '$typeName': return ${paramNames[typeName]}(this as ${builtClassName("${baseName}__as$typeName")});",
                ),
              const Code("default: return orElse();"),
              const Code("}"),
            ]),
        ),
      );
    }

    if (config.whenExtensionConfig.generateMaybeWhenExtensionMethod) {
      methods.add(
        Method(
          (b) => b
            ..name = "maybeWhen"
            ..returns = refer("_T")
            ..types.add(refer("_T"))
            ..optionalParameters.addAll([
              for (final typeName in inlineTypeNames)
                Parameter(
                  (b) => b
                    ..name = paramNames[typeName]!
                    ..type = FunctionType(
                      (b) => b
                        ..returnType = refer("_T")
                        ..isNullable = true
                        ..requiredParameters.add(
                          refer(
                            builtClassName("${baseName}__as$typeName"),
                          ),
                        ),
                    )
                    ..named = true
                    ..required = false,
                ),
              Parameter(
                (b) => b
                  ..name = "orElse"
                  ..type = FunctionType((b) => b..returnType = refer("_T"))
                  ..named = true
                  ..required = true,
              ),
            ])
            ..body = Block.of([
              const Code("switch(G__typename) {"),
              for (final typeName in inlineTypeNames)
                Code(
                  "case '$typeName': return ${paramNames[typeName]} == null ? orElse() : ${paramNames[typeName]}(this as ${builtClassName("${baseName}__as$typeName")});",
                ),
              const Code("default: return orElse();"),
              const Code("}"),
            ]),
        ),
      );
    }

    return Extension(
      (b) => b
        ..name = "${className}WhenExtension"
        ..on = refer(className)
        ..methods.addAll(methods),
    );
  }

  String _uncapitalize(String value) {
    if (value.isEmpty) return value;
    return "${value[0].toLowerCase()}${value.substring(1)}";
  }

  List<Spec> _buildNestedClasses(
    String baseName,
    List<FieldSpec> fields,
    List<Reference> parentInterfaces,
  ) {
    final specs = <Spec>[];
    for (final field in fields) {
      if (field.selectionSet == null || field.fragmentSpreadOnlyName != null) {
        continue;
      }
      final nestedName = "${baseName}_${field.responseKey}";
      final nestedInterfaces = _nestedInterfaceRefsForField(
        parentInterfaces,
        field,
      );
      specs.addAll(
        _buildSelectionSetClasses(
          baseName: nestedName,
          selectionSet: field.selectionSet!,
          parentTypeName: field.selectionSet!.parentTypeName,
          fragmentSpreads: field.selectionSet!.fragmentSpreads,
          classImplements: nestedInterfaces,
          fragmentName: null,
        ),
      );
    }
    return specs;
  }

  List<Reference> _interfaceRefs(
    Set<String> fragmentSpreads,
    String parentTypeName,
    List<Reference> baseImplements,
  ) {
    final refs = <Reference>[...baseImplements];
    for (final fragmentName in fragmentSpreads) {
      final interfaceName =
          _fragmentInterfaceForType(fragmentName, parentTypeName);
      final fragmentUrl = fragmentSourceUrls[fragmentName];
      if (fragmentUrl == null) continue;
      refs.add(
        Reference(
          interfaceName,
          "$fragmentUrl#data",
        ),
      );
    }
    return refs;
  }

  String _fragmentInterfaceForType(String fragmentName, String typeName) {
    final info = _fragmentInfo[fragmentName];
    if (info == null) return builtClassName(fragmentName);
    if (info.inlineTypes.contains(typeName)) {
      return builtClassName("${fragmentName}__as$typeName");
    }
    return builtClassName(fragmentName);
  }

  Class _buildPolymorphicBaseClass({
    required String className,
    required List<FieldSpec> baseFields,
    required List<String> inlineTypeNames,
    required List<Reference> implementsRefs,
  }) {
    return Class(
      (b) => b
        ..name = className
        ..abstract = true
        ..sealed = true
        ..implements.addAll(implementsRefs)
        ..fields.addAll(baseFields.map(_buildField))
        ..constructors.addAll([
          _buildConstructor(baseFields, null),
          _buildFromJsonFactory(
            className,
            baseFields,
            inlineTypeNames,
          ),
        ])
        ..methods.add(
          _buildToJsonMethod(baseFields, usesSuper: false),
        ),
    );
  }

  Class _buildConcreteClass({
    required String className,
    required List<FieldSpec> fields,
    required List<Reference> implementsRefs,
    required Reference? extendsRef,
    required List<FieldSpec> superFields,
    required bool usesSuperToJson,
  }) {
    final methods = <Method>[
      _buildToJsonMethod(fields, usesSuper: usesSuperToJson),
    ];
    if (config.generateCopyWith) {
      methods.add(_buildCopyWithMethod(className, fields));
    }
    if (config.generateEquals) {
      methods.add(_buildEqualsMethod(className, fields));
    }
    if (config.generateHashCode) {
      methods.add(_buildHashCodeGetter(fields));
    }
    if (config.generateToString) {
      methods.add(_buildToStringMethod(className, fields));
    }

    return Class(
      (b) => b
        ..name = className
        ..implements.addAll(implementsRefs)
        ..extend = extendsRef
        ..fields.addAll(
          fields
              .where((field) => !superFields.contains(field))
              .map(_buildField),
        )
        ..constructors.addAll([
          _buildConstructor(fields, extendsRef, superFields: superFields),
          _buildConcreteFromJson(className, fields),
        ])
        ..methods.addAll(methods),
    );
  }

  Constructor _buildConstructor(
    List<FieldSpec> fields,
    Reference? extendsRef, {
    List<FieldSpec> superFields = const [],
  }) {
    final namedParameters = fields.map((field) {
      final isRequired = field.typeRef is TypeReference
          ? !((field.typeRef as TypeReference).isNullable ?? false)
          : true;
      return Parameter(
        (b) => b
          ..name = field.propertyName
          ..named = true
          ..required = isRequired
          ..toThis = !superFields.contains(field),
      );
    });

    final initializers = <Code>[];
    if (extendsRef != null && superFields.isNotEmpty) {
      final args = superFields
          .map((field) => "${field.propertyName}: ${field.propertyName}")
          .join(", ");
      initializers.add(Code("super($args)"));
    }

    return Constructor(
      (b) => b
        ..constant = true
        ..optionalParameters.addAll(namedParameters)
        ..initializers.addAll(initializers),
    );
  }

  Constructor _buildFromJsonFactory(
    String className,
    List<FieldSpec> baseFields,
    List<String> inlineTypeNames,
  ) {
    final switchCases = inlineTypeNames
        .map(
          (typeName) => Code(
            "case '$typeName': return ${builtClassName("${_stripPrefix(className)}__as$typeName")}.fromJson(json);",
          ),
        )
        .toList();
    final body = [
      Code("switch(json['__typename'] as String) {"),
      ...switchCases,
      Code(
        "default: return ${builtClassName("${_stripPrefix(className)}__unknown")}.fromJson(json);",
      ),
      Code("}"),
    ];

    return Constructor(
      (b) => b
        ..name = "fromJson"
        ..factory = true
        ..requiredParameters.add(
          Parameter((b) => b
            ..name = "json"
            ..type = refer("Map<String, dynamic>")),
        )
        ..body = Block.of(body),
    );
  }

  Constructor _buildConcreteFromJson(
    String className,
    List<FieldSpec> fields,
  ) {
    final args = <String, Expression>{};
    for (final field in fields) {
      args[field.propertyName] = _fromJsonExpression(field);
    }
    final constructorCall = refer(className).call([], args);

    return Constructor(
      (b) => b
        ..name = "fromJson"
        ..factory = true
        ..requiredParameters.add(
          Parameter((b) => b
            ..name = "json"
            ..type = _mapStringDynamicType()),
        )
        ..body = Block.of([constructorCall.returned.statement]),
    );
  }

  Method _buildToJsonMethod(
    List<FieldSpec> fields, {
    required bool usesSuper,
  }) {
    final statements = <Code>[];
    if (usesSuper) {
      statements.add(const Code("final result = super.toJson();"));
    } else {
      statements.add(const Code("final result = <String, dynamic>{};"));
    }
    for (final field in fields) {
      Expression valueRef = refer(field.propertyName);
      if (_isNullableField(field)) {
        final localName = "${field.propertyName}Value";
        statements.add(Code("final $localName = ${field.propertyName};"));
        valueRef = refer(localName);
      }
      final target = refer("result").index(literalString(field.responseKey));
      final valueExpr = _toJsonExpression(field, valueExpr: valueRef);
      statements.add(target.assign(valueExpr).statement);
    }
    statements.add(refer("result").returned.statement);

    return Method(
      (b) => b
        ..name = "toJson"
        ..returns = _mapStringDynamicType()
        ..body = Block.of(statements),
    );
  }

  Method _buildCopyWithMethod(String className, List<FieldSpec> fields) {
    final parameters = <Parameter>[];
    final args = <String, Expression>{};

    for (final field in fields) {
      final isNullable = _isNullableField(field);
      final paramType =
          isNullable ? field.typeRef : _nullableTypeReference(field.typeRef);
      parameters.add(
        Parameter(
          (b) => b
            ..name = field.propertyName
            ..type = paramType
            ..named = true,
        ),
      );

      if (isNullable) {
        final isSetName = _copyWithIsSetName(field.propertyName);
        parameters.add(
          Parameter(
            (b) => b
              ..name = isSetName
              ..type = refer("bool")
              ..named = true
              ..defaultTo = const Code("false"),
          ),
        );
        args[field.propertyName] = _conditionalExpression(
          refer(isSetName),
          refer(field.propertyName),
          refer("this").property(field.propertyName),
        );
      } else {
        args[field.propertyName] = refer(field.propertyName)
            .ifNullThen(refer("this").property(field.propertyName));
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

  Method _buildEqualsMethod(String className, List<FieldSpec> fields) {
    final comparisons = fields
        .map((field) => "${field.propertyName} == other.${field.propertyName}")
        .join(" && ");
    final body = fields.isEmpty
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

  Method _buildHashCodeGetter(List<FieldSpec> fields) {
    final entries = [
      "runtimeType",
      ...fields.map((field) => field.propertyName)
    ];
    final body = Code("return Object.hashAll([${entries.join(", ")}]);");
    return Method(
      (b) => b
        ..annotations.add(refer("override"))
        ..name = "hashCode"
        ..type = MethodType.getter
        ..returns = refer("int")
        ..body = body,
    );
  }

  Method _buildToStringMethod(String className, List<FieldSpec> fields) {
    final parts = fields
        .map((field) => "${field.propertyName}: \$${field.propertyName}")
        .join(", ");
    final value = fields.isEmpty ? "$className()" : "$className($parts)";
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

  Reference _nullableTypeReference(Reference typeRef) {
    if (typeRef is TypeReference) {
      return typeRef.rebuild((b) => b..isNullable = true);
    }
    return TypeReference(
      (b) => b
        ..symbol = typeRef.symbol
        ..url = typeRef.url
        ..isNullable = true,
    );
  }

  Field _buildField(FieldSpec field) => Field(
        (b) => b
          ..name = field.propertyName
          ..type = field.typeRef
          ..modifier = FieldModifier.final$,
      );

  Method _buildGetter(FieldSpec field, {required bool isOverride}) {
    return Method(
      (b) => b
        ..annotations.addAll(
          isOverride ? [refer("override")] : const <Expression>[],
        )
        ..returns = field.typeRef
        ..type = MethodType.getter
        ..name = field.propertyName,
    );
  }

  void _indexFragmentInterfaceSelections(
    String fragmentName,
    ResolvedSelectionSet selectionSet,
  ) {
    _registerInterfaceSelection(fragmentName, fragmentName, selectionSet);
    for (final entry in selectionSet.inlineFragments.entries) {
      _registerInterfaceSelection(
        fragmentName,
        "${fragmentName}__as${entry.key}",
        entry.value,
      );
    }
  }

  void _registerInterfaceSelection(
    String fragmentName,
    String interfaceKey,
    ResolvedSelectionSet selectionSet,
  ) {
    if (_fragmentInterfaceSelections.containsKey(interfaceKey)) {
      return;
    }
    _fragmentInterfaceSelections[interfaceKey] = selectionSet;
    _interfaceKeyToFragmentName[interfaceKey] = fragmentName;

    for (final field in selectionSet.fields.values) {
      if (field.selectionSet == null) continue;
      if (config.dataClassConfig.reuseFragments &&
          field.fragmentSpreadOnlyName != null) {
        continue;
      }
      final nestedKey = "${interfaceKey}_${field.responseKey}";
      _registerInterfaceSelection(
        fragmentName,
        nestedKey,
        field.selectionSet!,
      );
    }
  }

  Class _buildFragmentInterfaceClass({
    required String interfaceKey,
    required ResolvedSelectionSet selectionSet,
    required List<Reference> implementsRefs,
  }) {
    final fields = _buildFragmentInterfaceFieldSpecs(
      interfaceKey: interfaceKey,
      selectionSet: selectionSet,
    );

    return Class(
      (b) => b
        ..abstract = true
        ..name = builtClassName(interfaceKey)
        ..implements.addAll(implementsRefs)
        ..methods.addAll(
          fields.map((field) => _buildGetter(field, isOverride: false)),
        ),
    );
  }

  List<Spec> _buildFragmentNestedInterfaces({
    required String interfaceKey,
    required ResolvedSelectionSet selectionSet,
  }) {
    final specs = <Spec>[];
    for (final field in selectionSet.fields.values) {
      if (field.selectionSet == null) continue;
      if (config.dataClassConfig.reuseFragments &&
          field.fragmentSpreadOnlyName != null) {
        continue;
      }
      final nestedKey = "${interfaceKey}_${field.responseKey}";
      if (_generatedInterfaces.add(nestedKey)) {
        specs.add(
          _buildFragmentInterfaceClass(
            interfaceKey: nestedKey,
            selectionSet: field.selectionSet!,
            implementsRefs: const [],
          ),
        );
      }
      specs.addAll(
        _buildFragmentNestedInterfaces(
          interfaceKey: nestedKey,
          selectionSet: field.selectionSet!,
        ),
      );
    }
    return specs;
  }

  List<FieldSpec> _buildFragmentInterfaceFieldSpecs({
    required String interfaceKey,
    required ResolvedSelectionSet selectionSet,
  }) {
    final fields = <FieldSpec>[];
    for (final selection in selectionSet.fields.values) {
      final fieldName = selection.responseKey;
      final propertyName = identifier(fieldName);
      final namedTypeName = unwrapNamedTypeName(selection.typeNode) ?? "Object";
      final typeDef = schema.lookupType(NameNode(value: namedTypeName));

      final fragmentName = config.dataClassConfig.reuseFragments
          ? selection.fragmentSpreadOnlyName
          : null;
      Reference namedTypeRef;

      if (fragmentName != null) {
        namedTypeRef = _fragmentInterfaceReference(fragmentName);
      } else if (selection.selectionSet != null) {
        namedTypeRef = Reference(
          builtClassName("${interfaceKey}_$fieldName"),
        );
      } else if (typeDef is EnumTypeDefinitionNode ||
          typeDef is InputObjectTypeDefinitionNode) {
        namedTypeRef = Reference(
          builtClassName(namedTypeName),
          "#schema",
        );
      } else if (typeDef is ScalarTypeDefinitionNode) {
        namedTypeRef = _scalarReference(namedTypeName);
      } else {
        namedTypeRef = refer("Object");
      }

      final typeRef = _typeReferenceForTypeNode(
        selection.typeNode,
        namedTypeRef,
      );

      fields.add(
        FieldSpec(
          responseKey: fieldName,
          propertyName: propertyName,
          typeNode: selection.typeNode,
          typeRef: typeRef,
          namedTypeRef: namedTypeRef,
          selectionSet: selection.selectionSet,
          fragmentSpreadOnlyName: fragmentName,
        ),
      );
    }
    return fields;
  }

  List<Reference> _nestedInterfaceRefsForField(
    List<Reference> parentInterfaces,
    FieldSpec field,
  ) {
    if (field.selectionSet == null) return const [];
    final refs = <Reference>[];
    for (final interfaceRef in parentInterfaces) {
      final symbol = interfaceRef.symbol;
      if (symbol == null || !symbol.startsWith("G")) continue;
      final interfaceKey = symbol.substring(1);
      final selectionSet = _fragmentInterfaceSelections[interfaceKey];
      if (selectionSet == null) continue;
      final nestedField = selectionSet.fields[field.responseKey];
      if (nestedField?.selectionSet == null) continue;
      if (config.dataClassConfig.reuseFragments &&
          nestedField!.fragmentSpreadOnlyName != null) {
        continue;
      }
      final nestedKey = "${interfaceKey}_${field.responseKey}";
      final fragmentName = _interfaceKeyToFragmentName[nestedKey] ??
          _interfaceKeyToFragmentName[interfaceKey];
      if (fragmentName == null) continue;
      final url = fragmentSourceUrls[fragmentName];
      refs.add(
        Reference(
          builtClassName(nestedKey),
          url == null ? "#data" : "$url#data",
        ),
      );
    }
    return refs;
  }

  List<FieldSpec> _buildFieldSpecs({
    required String baseName,
    required ResolvedSelectionSet selectionSet,
    required String parentTypeName,
    required FieldContext fieldContext,
  }) {
    final fields = <FieldSpec>[];
    for (final selection in selectionSet.fields.values) {
      final fieldName = selection.responseKey;
      final propertyName = identifier(fieldName);
      final nestedBaseName = "${baseName}_$fieldName";
      final namedTypeName = unwrapNamedTypeName(selection.typeNode) ?? "Object";
      final typeDef = schema.lookupType(NameNode(value: namedTypeName));

      String? fragmentName = config.dataClassConfig.reuseFragments
          ? selection.fragmentSpreadOnlyName
          : null;
      Reference? namedTypeRef;

      if (fragmentName != null) {
        namedTypeRef = _fragmentDataReference(fragmentName);
      } else if (typeDef is ObjectTypeDefinitionNode ||
          typeDef is InterfaceTypeDefinitionNode ||
          typeDef is UnionTypeDefinitionNode) {
        namedTypeRef = Reference(
          builtClassName(nestedBaseName),
          "#data",
        );
      } else if (typeDef is EnumTypeDefinitionNode ||
          typeDef is InputObjectTypeDefinitionNode) {
        namedTypeRef = Reference(
          builtClassName(namedTypeName),
          "#schema",
        );
      } else if (typeDef is ScalarTypeDefinitionNode) {
        namedTypeRef = _scalarReference(namedTypeName);
      } else {
        namedTypeRef = refer("Object");
      }

      final typeRef = _typeReferenceForTypeNode(
        selection.typeNode,
        namedTypeRef,
      );

      fields.add(
        FieldSpec(
          responseKey: fieldName,
          propertyName: propertyName,
          typeNode: selection.typeNode,
          typeRef: typeRef,
          namedTypeRef: namedTypeRef,
          selectionSet: selection.selectionSet,
          fragmentSpreadOnlyName: fragmentName,
        ),
      );
    }
    return fields;
  }

  Reference _fragmentDataReference(String fragmentName) {
    final url = fragmentSourceUrls[fragmentName];
    if (url == null) {
      return Reference(builtClassName("${fragmentName}Data"), "#data");
    }
    return Reference(builtClassName("${fragmentName}Data"), "$url#data");
  }

  Reference _fragmentInterfaceReference(String fragmentName) {
    final url = fragmentSourceUrls[fragmentName];
    if (url == null) {
      return Reference(builtClassName(fragmentName), "#data");
    }
    return Reference(builtClassName(fragmentName), "$url#data");
  }

  Reference _scalarReference(String typeName) {
    final override = config.typeOverrides[typeName];
    if (override?.type != null) {
      if (override!.import != null) {
        extraImports.add(override.import!);
      }
      return Reference(override.type);
    }

    return switch (typeName) {
      "Int" => refer("int"),
      "Float" => refer("double"),
      "Boolean" => refer("bool"),
      "ID" => refer("String"),
      "String" => refer("String"),
      _ => refer("Object"),
    };
  }

  Reference _typeReferenceForTypeNode(
    TypeNode typeNode,
    Reference namedTypeRef,
  ) {
    if (typeNode is ListTypeNode) {
      return TypeReference(
        (b) => b
          ..symbol = "List"
          ..isNullable = !typeNode.isNonNull
          ..types.add(_typeReferenceForTypeNode(typeNode.type, namedTypeRef)),
      );
    }
    if (typeNode is NamedTypeNode) {
      if (namedTypeRef is TypeReference) {
        return namedTypeRef.rebuild((b) => b..isNullable = !typeNode.isNonNull);
      }
      return TypeReference(
        (b) => b
          ..symbol = namedTypeRef.symbol
          ..url = namedTypeRef.url
          ..isNullable = !typeNode.isNonNull,
      );
    }
    throw StateError("Invalid type node");
  }

  Expression _fromJsonExpression(FieldSpec field) {
    final accessExpr = refer("json").index(literalString(field.responseKey));
    return _fromJsonForTypeNode(
      field.typeNode,
      field,
      accessExpr,
    );
  }

  Expression _fromJsonForTypeNode(
    TypeNode node,
    FieldSpec field,
    Expression valueExpr,
  ) {
    if (node is ListTypeNode) {
      final innerExpr = _fromJsonForTypeNode(node.type, field, refer("e"));
      final castExpr = valueExpr.asA(_listDynamicType());
      final mapped = castExpr
          .property("map")
          .call([
            Method(
              (b) => b
                ..requiredParameters.add(
                  Parameter((b) => b..name = "e"),
                )
                ..lambda = true
                ..body = innerExpr.code,
            ).closure,
          ])
          .property("toList")
          .call([]);
      if (node.isNonNull) {
        return mapped;
      }
      return _nullGuard(valueExpr, mapped);
    }
    if (node is NamedTypeNode) {
      final typeName = node.name.value;
      final override = config.typeOverrides[typeName];
      final typeDef = schema.lookupType(NameNode(value: typeName));
      final inner = _fromJsonForNamedType(
        typeName: typeName,
        typeDef: typeDef,
        override: override,
        field: field,
        valueExpr: valueExpr,
      );
      if (node.isNonNull) {
        return inner;
      }
      return _nullGuard(valueExpr, inner);
    }
    throw StateError("Invalid type node");
  }

  Expression _fromJsonForNamedType({
    required String typeName,
    required TypeDefinitionNode? typeDef,
    required TypeOverrideConfig? override,
    required FieldSpec field,
    required Expression valueExpr,
  }) {
    if (override?.fromJsonFunctionName != null) {
      return refer(override!.fromJsonFunctionName!).call([valueExpr]);
    }
    if (typeDef is EnumTypeDefinitionNode) {
      return field.namedTypeRef.property("fromJson").call([
        valueExpr.asA(refer("String")),
      ]);
    }
    if (typeDef is ObjectTypeDefinitionNode ||
        typeDef is InterfaceTypeDefinitionNode ||
        typeDef is UnionTypeDefinitionNode ||
        typeDef is InputObjectTypeDefinitionNode) {
      return field.namedTypeRef.property("fromJson").call([
        valueExpr.asA(_mapStringDynamicType()),
      ]);
    }

    final scalarType = _scalarReference(typeName);
    return valueExpr.asA(scalarType);
  }

  bool _isNullableField(FieldSpec field) {
    final typeRef = field.typeRef;
    if (typeRef is TypeReference) {
      return typeRef.isNullable ?? false;
    }
    return false;
  }

  Expression _toJsonExpression(
    FieldSpec field, {
    Expression? valueExpr,
  }) {
    final targetExpr = valueExpr ?? refer(field.propertyName);
    return _toJsonForTypeNode(
      field.typeNode,
      field,
      targetExpr,
    );
  }

  Expression _toJsonForTypeNode(
    TypeNode node,
    FieldSpec field,
    Expression valueExpr,
  ) {
    if (node is ListTypeNode) {
      final innerExpr = _toJsonForTypeNode(node.type, field, refer("e"));
      final mapped = valueExpr
          .property("map")
          .call([
            Method(
              (b) => b
                ..requiredParameters.add(
                  Parameter((b) => b..name = "e"),
                )
                ..lambda = true
                ..body = innerExpr.code,
            ).closure,
          ])
          .property("toList")
          .call([]);
      if (node.isNonNull) {
        return mapped;
      }
      return _nullGuard(valueExpr, mapped);
    }
    if (node is NamedTypeNode) {
      final typeName = node.name.value;
      final override = config.typeOverrides[typeName];
      final typeDef = schema.lookupType(NameNode(value: typeName));
      final inner = _toJsonForNamedType(
        typeName: typeName,
        typeDef: typeDef,
        override: override,
        field: field,
        valueExpr: valueExpr,
      );
      if (node.isNonNull) {
        return inner;
      }
      return _nullGuard(valueExpr, inner);
    }
    throw StateError("Invalid type node");
  }

  Expression _toJsonForNamedType({
    required String typeName,
    required TypeDefinitionNode? typeDef,
    required TypeOverrideConfig? override,
    required FieldSpec field,
    required Expression valueExpr,
  }) {
    if (override?.toJsonFunctionName != null) {
      return refer(override!.toJsonFunctionName!).call([valueExpr]);
    }
    if (typeDef is EnumTypeDefinitionNode) {
      return valueExpr.property("toJson").call([]);
    }
    if (typeDef is ObjectTypeDefinitionNode ||
        typeDef is InterfaceTypeDefinitionNode ||
        typeDef is UnionTypeDefinitionNode ||
        typeDef is InputObjectTypeDefinitionNode) {
      return valueExpr.property("toJson").call([]);
    }
    return valueExpr;
  }
}

class FragmentInfo {
  final String name;
  final String typeCondition;
  final ResolvedSelectionSet selectionSet;
  final Set<String> inlineTypes;

  const FragmentInfo({
    required this.name,
    required this.typeCondition,
    required this.selectionSet,
    required this.inlineTypes,
  });
}

class FieldSpec {
  final String responseKey;
  final String propertyName;
  final TypeNode typeNode;
  final Reference typeRef;
  final Reference namedTypeRef;
  final ResolvedSelectionSet? selectionSet;
  final String? fragmentSpreadOnlyName;

  const FieldSpec({
    required this.responseKey,
    required this.propertyName,
    required this.typeNode,
    required this.typeRef,
    required this.namedTypeRef,
    required this.selectionSet,
    required this.fragmentSpreadOnlyName,
  });
}

enum FieldContext { base, inline }

String _stripPrefix(String name) {
  if (name.startsWith("G")) {
    return name.substring(1);
  }
  return name;
}

Expression _nullGuard(Expression valueExpr, Expression innerExpr) {
  return CodeExpression(
    Block.of([
      valueExpr.code,
      const Code(" == null ? null : "),
      innerExpr.code,
    ]),
  );
}

Expression _conditionalExpression(
  Expression condition,
  Expression whenTrue,
  Expression whenFalse,
) {
  return CodeExpression(
    Block.of([
      condition.code,
      const Code(" ? "),
      whenTrue.code,
      const Code(" : "),
      whenFalse.code,
    ]),
  );
}

TypeReference _mapStringDynamicType() => TypeReference(
      (b) => b
        ..symbol = "Map"
        ..types.addAll([
          refer("String"),
          refer("dynamic"),
        ]),
    );

TypeReference _listDynamicType() => TypeReference(
      (b) => b
        ..symbol = "List"
        ..types.add(refer("dynamic")),
    );
