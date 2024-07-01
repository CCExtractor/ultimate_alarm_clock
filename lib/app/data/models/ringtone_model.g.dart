// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ringtone_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRingtoneModelCollection on Isar {
  IsarCollection<RingtoneModel> get ringtoneModels => this.collection();
}

const RingtoneModelSchema = CollectionSchema(
  name: r'RingtoneModel',
  id: 2389700415140569104,
  properties: {
    r'currentCounterOfUsage': PropertySchema(
      id: 0,
      name: r'currentCounterOfUsage',
      type: IsarType.long,
    ),
    r'ringtoneName': PropertySchema(
      id: 1,
      name: r'ringtoneName',
      type: IsarType.string,
    ),
    r'ringtonePath': PropertySchema(
      id: 2,
      name: r'ringtonePath',
      type: IsarType.string,
    )
  },
  estimateSize: _ringtoneModelEstimateSize,
  serialize: _ringtoneModelSerialize,
  deserialize: _ringtoneModelDeserialize,
  deserializeProp: _ringtoneModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _ringtoneModelGetId,
  getLinks: _ringtoneModelGetLinks,
  attach: _ringtoneModelAttach,
  version: '3.1.0+1',
);

int _ringtoneModelEstimateSize(
  RingtoneModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.ringtoneName.length * 3;
  bytesCount += 3 + object.ringtonePath.length * 3;
  return bytesCount;
}

void _ringtoneModelSerialize(
  RingtoneModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentCounterOfUsage);
  writer.writeString(offsets[1], object.ringtoneName);
  writer.writeString(offsets[2], object.ringtonePath);
}

RingtoneModel _ringtoneModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RingtoneModel(
    currentCounterOfUsage: reader.readLong(offsets[0]),
    ringtoneName: reader.readString(offsets[1]),
    ringtonePath: reader.readString(offsets[2]),
  );
  return object;
}

P _ringtoneModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ringtoneModelGetId(RingtoneModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _ringtoneModelGetLinks(RingtoneModel object) {
  return [];
}

void _ringtoneModelAttach(
    IsarCollection<dynamic> col, Id id, RingtoneModel object) {}

extension RingtoneModelQueryWhereSort
    on QueryBuilder<RingtoneModel, RingtoneModel, QWhere> {
  QueryBuilder<RingtoneModel, RingtoneModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RingtoneModelQueryWhere
    on QueryBuilder<RingtoneModel, RingtoneModel, QWhereClause> {
  QueryBuilder<RingtoneModel, RingtoneModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RingtoneModelQueryFilter
    on QueryBuilder<RingtoneModel, RingtoneModel, QFilterCondition> {
  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      currentCounterOfUsageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentCounterOfUsage',
        value: value,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      currentCounterOfUsageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentCounterOfUsage',
        value: value,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      currentCounterOfUsageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentCounterOfUsage',
        value: value,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      currentCounterOfUsageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentCounterOfUsage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtoneNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringtoneName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtoneNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ringtoneName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtoneNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ringtoneName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtoneNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ringtoneName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtoneNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ringtoneName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtoneNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ringtoneName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtoneNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ringtoneName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtoneNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ringtoneName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtoneNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringtoneName',
        value: '',
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtoneNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ringtoneName',
        value: '',
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtonePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringtonePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtonePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ringtonePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtonePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ringtonePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtonePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ringtonePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtonePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ringtonePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtonePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ringtonePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtonePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ringtonePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtonePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ringtonePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtonePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringtonePath',
        value: '',
      ));
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterFilterCondition>
      ringtonePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ringtonePath',
        value: '',
      ));
    });
  }
}

extension RingtoneModelQueryObject
    on QueryBuilder<RingtoneModel, RingtoneModel, QFilterCondition> {}

extension RingtoneModelQueryLinks
    on QueryBuilder<RingtoneModel, RingtoneModel, QFilterCondition> {}

extension RingtoneModelQuerySortBy
    on QueryBuilder<RingtoneModel, RingtoneModel, QSortBy> {
  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      sortByCurrentCounterOfUsage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCounterOfUsage', Sort.asc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      sortByCurrentCounterOfUsageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCounterOfUsage', Sort.desc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      sortByRingtoneName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.asc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      sortByRingtoneNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.desc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      sortByRingtonePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtonePath', Sort.asc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      sortByRingtonePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtonePath', Sort.desc);
    });
  }
}

extension RingtoneModelQuerySortThenBy
    on QueryBuilder<RingtoneModel, RingtoneModel, QSortThenBy> {
  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      thenByCurrentCounterOfUsage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCounterOfUsage', Sort.asc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      thenByCurrentCounterOfUsageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentCounterOfUsage', Sort.desc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      thenByRingtoneName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.asc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      thenByRingtoneNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.desc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      thenByRingtonePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtonePath', Sort.asc);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QAfterSortBy>
      thenByRingtonePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtonePath', Sort.desc);
    });
  }
}

extension RingtoneModelQueryWhereDistinct
    on QueryBuilder<RingtoneModel, RingtoneModel, QDistinct> {
  QueryBuilder<RingtoneModel, RingtoneModel, QDistinct>
      distinctByCurrentCounterOfUsage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentCounterOfUsage');
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QDistinct> distinctByRingtoneName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ringtoneName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RingtoneModel, RingtoneModel, QDistinct> distinctByRingtonePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ringtonePath', caseSensitive: caseSensitive);
    });
  }
}

extension RingtoneModelQueryProperty
    on QueryBuilder<RingtoneModel, RingtoneModel, QQueryProperty> {
  QueryBuilder<RingtoneModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<RingtoneModel, int, QQueryOperations>
      currentCounterOfUsageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentCounterOfUsage');
    });
  }

  QueryBuilder<RingtoneModel, String, QQueryOperations> ringtoneNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ringtoneName');
    });
  }

  QueryBuilder<RingtoneModel, String, QQueryOperations> ringtonePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ringtonePath');
    });
  }
}
