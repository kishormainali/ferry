import "package:gql/ast.dart";
import "package:gql/language.dart";

const defaultRootTypes = <OperationType, String>{
  OperationType.query: "Query",
  OperationType.mutation: "Mutation",
  OperationType.subscription: "Subscription",
};

const _introspectionFields = <FieldDefinitionNode>[
  FieldDefinitionNode(
    name: NameNode(value: "__typename"),
    type: NamedTypeNode(name: NameNode(value: "String"), isNonNull: true),
  ),
];

const _queryIntrospectionFields = <FieldDefinitionNode>[
  FieldDefinitionNode(
    name: NameNode(value: "__schema"),
    type: NamedTypeNode(name: NameNode(value: "__Schema"), isNonNull: true),
  ),
  FieldDefinitionNode(
    name: NameNode(value: "__type"),
    type: NamedTypeNode(name: NameNode(value: "__Type"), isNonNull: false),
    args: [
      InputValueDefinitionNode(
        name: NameNode(value: "name"),
        type: NamedTypeNode(name: NameNode(value: "String"), isNonNull: true),
      ),
    ],
  ),
];

final _builtInSchema = parseString("""
scalar Int
scalar String
scalar Float
scalar Boolean
scalar ID

type __Schema {
  description: String
  types: [__Type!]!
  queryType: __Type!
  mutationType: __Type
  subscriptionType: __Type
  directives: [__Directive!]!
}

type __Type {
  kind: __TypeKind!
  name: String
  description: String
  fields(includeDeprecated: Boolean = false): [__Field!]
  interfaces: [__Type!]
  possibleTypes: [__Type!]
  enumValues(includeDeprecated: Boolean = false): [__EnumValue!]
  inputFields: [__InputValue!]
  ofType: __Type
  specifiedByURL: String
}

enum __TypeKind {
  SCALAR
  OBJECT
  INTERFACE
  UNION
  ENUM
  INPUT_OBJECT
  LIST
  NON_NULL
}

type __Field {
  name: String!
  description: String
  args: [__InputValue!]!
  type: __Type!
  isDeprecated: Boolean!
  deprecationReason: String
}

type __InputValue {
  name: String!
  description: String
  type: __Type!
  defaultValue: String
}

type __EnumValue {
  name: String!
  description: String
  isDeprecated: Boolean!
  deprecationReason: String
}

type __Directive {
  name: String!
  description: String
  locations: [__DirectiveLocation!]!
  args: [__InputValue!]!
  isRepeatable: Boolean!
}

enum __DirectiveLocation {
  QUERY
  MUTATION
  SUBSCRIPTION
  FIELD
  FRAGMENT_DEFINITION
  FRAGMENT_SPREAD
  INLINE_FRAGMENT
  VARIABLE_DEFINITION
  SCHEMA
  SCALAR
  OBJECT
  FIELD_DEFINITION
  ARGUMENT_DEFINITION
  INTERFACE
  UNION
  ENUM
  ENUM_VALUE
  INPUT_OBJECT
  INPUT_FIELD_DEFINITION
}
""");

class SchemaIndex {
  final DocumentNode document;
  final Map<String, TypeDefinitionNode> _typeDefinitions;
  final Map<String, List<ObjectTypeExtensionNode>> _objectExtensions;
  final Map<String, List<InterfaceTypeExtensionNode>> _interfaceExtensions;
  final Map<String, List<InputObjectTypeExtensionNode>> _inputExtensions;
  final Map<String, List<EnumTypeExtensionNode>> _enumExtensions;
  final Map<String, List<UnionTypeExtensionNode>> _unionExtensions;

  final Map<String, Map<String, FieldDefinitionNode>> _fieldCache = {};
  final Map<String, Map<String, InputValueDefinitionNode>> _inputFieldCache =
      {};
  final Map<OperationType, TypeDefinitionNode?> _operationTypeCache = {};
  Map<String, Set<String>>? _possibleTypesCache;

  SchemaIndex._(
      this.document,
      this._typeDefinitions,
      this._objectExtensions,
      this._interfaceExtensions,
      this._inputExtensions,
      this._enumExtensions,
      this._unionExtensions);

  factory SchemaIndex.fromDocuments(Iterable<DocumentNode> documents) {
    final definitions = <DefinitionNode>[
      ...documents.expand((doc) => doc.definitions),
      ..._builtInSchema.definitions,
    ];
    final document = DocumentNode(definitions: definitions);
    final typeDefinitions = <String, TypeDefinitionNode>{};
    final objectExtensions = <String, List<ObjectTypeExtensionNode>>{};
    final interfaceExtensions = <String, List<InterfaceTypeExtensionNode>>{};
    final inputExtensions = <String, List<InputObjectTypeExtensionNode>>{};
    final enumExtensions = <String, List<EnumTypeExtensionNode>>{};
    final unionExtensions = <String, List<UnionTypeExtensionNode>>{};

    for (final def in definitions) {
      if (def is TypeDefinitionNode) {
        typeDefinitions.putIfAbsent(def.name.value, () => def);
      } else if (def is ObjectTypeExtensionNode) {
        objectExtensions.putIfAbsent(def.name.value, () => []).add(def);
      } else if (def is InterfaceTypeExtensionNode) {
        interfaceExtensions.putIfAbsent(def.name.value, () => []).add(def);
      } else if (def is InputObjectTypeExtensionNode) {
        inputExtensions.putIfAbsent(def.name.value, () => []).add(def);
      } else if (def is EnumTypeExtensionNode) {
        enumExtensions.putIfAbsent(def.name.value, () => []).add(def);
      } else if (def is UnionTypeExtensionNode) {
        unionExtensions.putIfAbsent(def.name.value, () => []).add(def);
      }
    }

    return SchemaIndex._(document, typeDefinitions, objectExtensions,
        interfaceExtensions, inputExtensions, enumExtensions, unionExtensions);
  }

  TypeDefinitionNode? lookupType(NameNode name) => _typeDefinitions[name.value];

  TType? lookupTypeAs<TType extends TypeDefinitionNode>(NameNode name) {
    final def = lookupType(name);
    if (def is TType) return def;
    return null;
  }

  TypeDefinitionNode? lookupOperationType(OperationType operationType) {
    if (_operationTypeCache.containsKey(operationType)) {
      return _operationTypeCache[operationType];
    }
    final opNode =
        document.definitions.expand<OperationTypeDefinitionNode?>((definition) {
      if (definition is SchemaDefinitionNode) {
        return definition.operationTypes;
      }
      if (definition is SchemaExtensionNode) {
        return definition.operationTypes;
      }
      return [];
    }).firstWhere(
      (element) => element != null && element.operation == operationType,
      orElse: () => null,
    );

    final typeName =
        opNode?.type.name ?? NameNode(value: defaultRootTypes[operationType]!);
    return _operationTypeCache[operationType] = lookupType(typeName);
  }

  String determineOperationTypeName(OperationType operationType) {
    return lookupOperationType(operationType)?.name.value ??
        defaultRootTypes[operationType]!;
  }

  Iterable<ObjectTypeDefinitionNode> lookupConcreteTypes(NameNode name) {
    final typeDefinition = lookupType(name);
    if (typeDefinition is ObjectTypeDefinitionNode) {
      return [typeDefinition];
    }
    if (typeDefinition is UnionTypeDefinitionNode) {
      final unionExtensions = _unionExtensions[typeDefinition.name.value] ?? [];
      final types = [
        ...typeDefinition.types,
        ...unionExtensions.expand((extension) => extension.types),
      ];
      return types.expand((typeRef) => lookupConcreteTypes(typeRef.name));
    }

    if (typeDefinition is InterfaceTypeDefinitionNode) {
      return document.definitions.whereType<ObjectTypeDefinitionNode>().where(
            (element) => element.interfaces
                .where((iface) => iface.name.value == name.value)
                .isNotEmpty,
          );
    }

    return [];
  }

  Map<String, Set<String>> possibleTypesMap() {
    final cached = _possibleTypesCache;
    if (cached != null) return cached;
    final possibleTypes = <String, Set<String>>{};

    for (final definition in document.definitions) {
      if (definition is UnionTypeDefinitionNode) {
        final types = possibleTypes[definition.name.value] ?? {};
        for (final tpe in definition.types) {
          types.add(tpe.name.value);
        }
        possibleTypes[definition.name.value] = types;
      } else if (definition is UnionTypeExtensionNode) {
        final types = possibleTypes[definition.name.value] ?? {};
        for (final tpe in definition.types) {
          types.add(tpe.name.value);
        }
        possibleTypes[definition.name.value] = types;
      } else if (definition is ObjectTypeDefinitionNode) {
        for (final tpe in definition.interfaces) {
          final types = possibleTypes[tpe.name.value] ?? {};
          types.add(definition.name.value);
          possibleTypes[tpe.name.value] = types;
        }
      }
    }

    final expanded = possibleTypes.map((key, value) {
      final concrete = value
          .expand<ObjectTypeDefinitionNode>(
              (typeName) => lookupConcreteTypes(NameNode(value: typeName)))
          .map((type) => type.name.value)
          .toSet();
      return MapEntry(key, concrete);
    });

    return _possibleTypesCache = expanded;
  }

  FieldDefinitionNode? lookupFieldDefinitionNode(
    TypeDefinitionNode onType,
    NameNode field,
  ) {
    if (onType is UnionTypeDefinitionNode) {
      if (field.value == "__typename") {
        return _introspectionFields.first;
      }
      return null;
    }
    return _lookupFieldDefinitionsForTypeDefinitionNode(onType)[field.value];
  }

  TypeNode? lookupTypeNodeFromField(
    TypeDefinitionNode onType,
    NameNode field,
  ) {
    return lookupFieldDefinitionNode(onType, field)?.type;
  }

  TypeNode? lookupTypeNodeForArgument(
    TypeDefinitionNode onType,
    NameNode field,
    ArgumentNode argument,
  ) {
    final fieldDefinition = lookupFieldDefinitionNode(onType, field);
    if (fieldDefinition == null) {
      return null;
    }
    return fieldDefinition.args
        .whereType<InputValueDefinitionNode?>()
        .firstWhere(
          (element) => element?.name.value == argument.name.value,
          orElse: () => null,
        )
        ?.type;
  }

  TypeDefinitionNode? lookupTypeDefinitionFromTypeNode(TypeNode node) {
    if (node is ListTypeNode) {
      return lookupTypeDefinitionFromTypeNode(node.type);
    }
    if (node is NamedTypeNode) {
      return lookupType(node.name);
    }
    throw StateError("Invalid node type");
  }

  List<EnumValueDefinitionNode> lookupEnumValueDefinitions(
    EnumTypeDefinitionNode node,
  ) {
    final enumExtensions = _enumExtensions[node.name.value] ?? [];
    return [
      ...node.values,
      ...enumExtensions.expand((extension) => extension.values),
    ];
  }

  InputValueDefinitionNode? lookupInputFieldDefinition(
    InputObjectTypeDefinitionNode node,
    NameNode field,
  ) =>
      _lookupInputFieldDefinitionsForTypeDefinitionNode(node)[field.value];

  List<InputValueDefinitionNode> lookupInputValueDefinitions(
    InputObjectTypeDefinitionNode node,
  ) =>
      _lookupInputFieldDefinitionsForTypeDefinitionNode(node).values.toList();

  Map<String, FieldDefinitionNode> _lookupFieldDefinitionsForTypeDefinitionNode(
    TypeDefinitionNode onType,
  ) {
    if (_fieldCache.containsKey(onType.name.value)) {
      return _fieldCache[onType.name.value] ?? {};
    }
    if (onType is! ObjectTypeDefinitionNode &&
        onType is! InterfaceTypeDefinitionNode &&
        onType is! UnionTypeDefinitionNode) {
      return _fieldCache[onType.name.value] = {};
    }

    final fields = <FieldDefinitionNode>[
      if (onType is ObjectTypeDefinitionNode)
        ..._listObjectTypeDefinitionFields(onType),
      if (onType is InterfaceTypeDefinitionNode)
        ..._listInterfaceTypeDefinitionFields(onType),
      if (onType == lookupOperationType(OperationType.query))
        ..._queryIntrospectionFields,
      ..._introspectionFields,
    ];

    final fieldMap =
        Map.fromEntries(fields.map((e) => MapEntry(e.name.value, e)));
    _fieldCache[onType.name.value] = fieldMap;
    return fieldMap;
  }

  Map<String, InputValueDefinitionNode>
      _lookupInputFieldDefinitionsForTypeDefinitionNode(
    InputObjectTypeDefinitionNode node,
  ) {
    if (_inputFieldCache.containsKey(node.name.value)) {
      return _inputFieldCache[node.name.value] ?? {};
    }
    final fields = <InputValueDefinitionNode>[
      ...node.fields,
      ...(_inputExtensions[node.name.value] ?? [])
          .expand((extension) => extension.fields),
    ];
    final fieldMap =
        Map.fromEntries(fields.map((e) => MapEntry(e.name.value, e)));
    _inputFieldCache[node.name.value] = fieldMap;
    return fieldMap;
  }

  List<FieldDefinitionNode> _listObjectTypeDefinitionFields(
    ObjectTypeDefinitionNode node,
  ) {
    return [
      ...node.fields,
      ...(_objectExtensions[node.name.value] ?? [])
          .expand((extension) => extension.fields),
    ];
  }

  List<FieldDefinitionNode> _listInterfaceTypeDefinitionFields(
    InterfaceTypeDefinitionNode node,
  ) {
    return [
      ...node.fields,
      ...(_interfaceExtensions[node.name.value] ?? [])
          .expand((extension) => extension.fields),
    ];
  }
}
