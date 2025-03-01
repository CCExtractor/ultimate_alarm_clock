// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTimerModelCollection on Isar {
  IsarCollection<TimerModel> get timerModels => this.collection();
}

const TimerModelSchema = CollectionSchema(
  name: r'TimerModel',
  id: 1326376837060457485,
  properties: {
    r'isPaused': PropertySchema(
      id: 0,
      name: r'isPaused',
      type: IsarType.long,
    ),
    r'ringtoneName': PropertySchema(
      id: 1,
      name: r'ringtoneName',
      type: IsarType.string,
    ),
    r'startedOn': PropertySchema(
      id: 2,
      name: r'startedOn',
      type: IsarType.string,
    ),
    r'timeElapsed': PropertySchema(
      id: 3,
      name: r'timeElapsed',
      type: IsarType.long,
    ),
    r'timerName': PropertySchema(
      id: 4,
      name: r'timerName',
      type: IsarType.string,
    ),
    r'timerValue': PropertySchema(
      id: 5,
      name: r'timerValue',
      type: IsarType.long,
    )
  },
  estimateSize: _timerModelEstimateSize,
  serialize: _timerModelSerialize,
  deserialize: _timerModelDeserialize,
  deserializeProp: _timerModelDeserializeProp,
  idName: r'timerId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _timerModelGetId,
  getLinks: _timerModelGetLinks,
  attach: _timerModelAttach,
  version: '3.1.8',
);

int _timerModelEstimateSize(
  TimerModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.ringtoneName.length * 3;
  bytesCount += 3 + object.startedOn.length * 3;
  bytesCount += 3 + object.timerName.length * 3;
  return bytesCount;
}

void _timerModelSerialize(
  TimerModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.isPaused);
  writer.writeString(offsets[1], object.ringtoneName);
  writer.writeString(offsets[2], object.startedOn);
  writer.writeLong(offsets[3], object.timeElapsed);
  writer.writeString(offsets[4], object.timerName);
  writer.writeLong(offsets[5], object.timerValue);
}

TimerModel _timerModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TimerModel(
    isPaused: reader.readLongOrNull(offsets[0]) ?? 0,
    ringtoneName: reader.readString(offsets[1]),
    startedOn: reader.readString(offsets[2]),
    timeElapsed: reader.readLongOrNull(offsets[3]) ?? 0,
    timerName: reader.readString(offsets[4]),
    timerValue: reader.readLong(offsets[5]),
  );
  object.timerId = id;
  return object;
}

P _timerModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _timerModelGetId(TimerModel object) {
  return object.timerId;
}

List<IsarLinkBase<dynamic>> _timerModelGetLinks(TimerModel object) {
  return [];
}

void _timerModelAttach(IsarCollection<dynamic> col, Id id, TimerModel object) {
  object.timerId = id;
}

extension TimerModelQueryWhereSort
    on QueryBuilder<TimerModel, TimerModel, QWhere> {
  QueryBuilder<TimerModel, TimerModel, QAfterWhere> anyTimerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TimerModelQueryWhere
    on QueryBuilder<TimerModel, TimerModel, QWhereClause> {
  QueryBuilder<TimerModel, TimerModel, QAfterWhereClause> timerIdEqualTo(
      Id timerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: timerId,
        upper: timerId,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterWhereClause> timerIdNotEqualTo(
      Id timerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: timerId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: timerId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: timerId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: timerId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterWhereClause> timerIdGreaterThan(
      Id timerId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: timerId, includeLower: include),
      );
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterWhereClause> timerIdLessThan(
      Id timerId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: timerId, includeUpper: include),
      );
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterWhereClause> timerIdBetween(
    Id lowerTimerId,
    Id upperTimerId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerTimerId,
        includeLower: includeLower,
        upper: upperTimerId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TimerModelQueryFilter
    on QueryBuilder<TimerModel, TimerModel, QFilterCondition> {
  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> isPausedEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPaused',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      isPausedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isPaused',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> isPausedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isPaused',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> isPausedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isPaused',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
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

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
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

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
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

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
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

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
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

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
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

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      ringtoneNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ringtoneName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      ringtoneNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ringtoneName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      ringtoneNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringtoneName',
        value: '',
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      ringtoneNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ringtoneName',
        value: '',
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> startedOnEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      startedOnGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> startedOnLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> startedOnBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedOn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      startedOnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> startedOnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> startedOnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startedOn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> startedOnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startedOn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      startedOnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedOn',
        value: '',
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      startedOnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startedOn',
        value: '',
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timeElapsedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeElapsed',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timeElapsedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeElapsed',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timeElapsedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeElapsed',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timeElapsedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeElapsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timerId',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timerIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timerId',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timerId',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timerName',
        value: '',
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timerName',
        value: '',
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerValueEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timerValue',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timerValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timerValue',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition>
      timerValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timerValue',
        value: value,
      ));
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterFilterCondition> timerValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timerValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TimerModelQueryObject
    on QueryBuilder<TimerModel, TimerModel, QFilterCondition> {}

extension TimerModelQueryLinks
    on QueryBuilder<TimerModel, TimerModel, QFilterCondition> {}

extension TimerModelQuerySortBy
    on QueryBuilder<TimerModel, TimerModel, QSortBy> {
  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByIsPausedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByRingtoneName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByRingtoneNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByStartedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedOn', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByStartedOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedOn', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByTimeElapsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeElapsed', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByTimeElapsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeElapsed', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByTimerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerName', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByTimerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerName', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByTimerValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerValue', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> sortByTimerValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerValue', Sort.desc);
    });
  }
}

extension TimerModelQuerySortThenBy
    on QueryBuilder<TimerModel, TimerModel, QSortThenBy> {
  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByIsPausedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByRingtoneName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByRingtoneNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByStartedOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedOn', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByStartedOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedOn', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByTimeElapsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeElapsed', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByTimeElapsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeElapsed', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByTimerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerId', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByTimerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerId', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByTimerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerName', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByTimerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerName', Sort.desc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByTimerValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerValue', Sort.asc);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QAfterSortBy> thenByTimerValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timerValue', Sort.desc);
    });
  }
}

extension TimerModelQueryWhereDistinct
    on QueryBuilder<TimerModel, TimerModel, QDistinct> {
  QueryBuilder<TimerModel, TimerModel, QDistinct> distinctByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaused');
    });
  }

  QueryBuilder<TimerModel, TimerModel, QDistinct> distinctByRingtoneName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ringtoneName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QDistinct> distinctByStartedOn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedOn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QDistinct> distinctByTimeElapsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeElapsed');
    });
  }

  QueryBuilder<TimerModel, TimerModel, QDistinct> distinctByTimerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TimerModel, TimerModel, QDistinct> distinctByTimerValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timerValue');
    });
  }
}

extension TimerModelQueryProperty
    on QueryBuilder<TimerModel, TimerModel, QQueryProperty> {
  QueryBuilder<TimerModel, int, QQueryOperations> timerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timerId');
    });
  }

  QueryBuilder<TimerModel, int, QQueryOperations> isPausedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaused');
    });
  }

  QueryBuilder<TimerModel, String, QQueryOperations> ringtoneNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ringtoneName');
    });
  }

  QueryBuilder<TimerModel, String, QQueryOperations> startedOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedOn');
    });
  }

  QueryBuilder<TimerModel, int, QQueryOperations> timeElapsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeElapsed');
    });
  }

  QueryBuilder<TimerModel, String, QQueryOperations> timerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timerName');
    });
  }

  QueryBuilder<TimerModel, int, QQueryOperations> timerValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timerValue');
    });
  }
}
