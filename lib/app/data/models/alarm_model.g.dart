// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAlarmModelCollection on Isar {
  IsarCollection<AlarmModel> get alarmModels => this.collection();
}

const AlarmModelSchema = CollectionSchema(
  name: r'AlarmModel',
  id: 1796575337475990193,
  properties: {
    r'activityInterval': PropertySchema(
      id: 0,
      name: r'activityInterval',
      type: IsarType.long,
    ),
    r'alarmID': PropertySchema(
      id: 1,
      name: r'alarmID',
      type: IsarType.string,
    ),
    r'alarmTime': PropertySchema(
      id: 2,
      name: r'alarmTime',
      type: IsarType.string,
    ),
    r'days': PropertySchema(
      id: 3,
      name: r'days',
      type: IsarType.boolList,
    ),
    r'firestoreId': PropertySchema(
      id: 4,
      name: r'firestoreId',
      type: IsarType.string,
    ),
    r'intervalToAlarm': PropertySchema(
      id: 5,
      name: r'intervalToAlarm',
      type: IsarType.long,
    ),
    r'isActivityEnabled': PropertySchema(
      id: 6,
      name: r'isActivityEnabled',
      type: IsarType.bool,
    ),
    r'isEnabled': PropertySchema(
      id: 7,
      name: r'isEnabled',
      type: IsarType.bool,
    ),
    r'isLocationEnabled': PropertySchema(
      id: 8,
      name: r'isLocationEnabled',
      type: IsarType.bool,
    ),
    r'isMathsEnabled': PropertySchema(
      id: 9,
      name: r'isMathsEnabled',
      type: IsarType.bool,
    ),
    r'isOneTime': PropertySchema(
      id: 10,
      name: r'isOneTime',
      type: IsarType.bool,
    ),
    r'isQrEnabled': PropertySchema(
      id: 11,
      name: r'isQrEnabled',
      type: IsarType.bool,
    ),
    r'isShakeEnabled': PropertySchema(
      id: 12,
      name: r'isShakeEnabled',
      type: IsarType.bool,
    ),
    r'isSharedAlarmEnabled': PropertySchema(
      id: 13,
      name: r'isSharedAlarmEnabled',
      type: IsarType.bool,
    ),
    r'isWeatherEnabled': PropertySchema(
      id: 14,
      name: r'isWeatherEnabled',
      type: IsarType.bool,
    ),
    r'label': PropertySchema(
      id: 15,
      name: r'label',
      type: IsarType.string,
    ),
    r'lastEditedUserId': PropertySchema(
      id: 16,
      name: r'lastEditedUserId',
      type: IsarType.string,
    ),
    r'location': PropertySchema(
      id: 17,
      name: r'location',
      type: IsarType.string,
    ),
    r'mainAlarmTime': PropertySchema(
      id: 18,
      name: r'mainAlarmTime',
      type: IsarType.string,
    ),
    r'mathsDifficulty': PropertySchema(
      id: 19,
      name: r'mathsDifficulty',
      type: IsarType.long,
    ),
    r'minutesSinceMidnight': PropertySchema(
      id: 20,
      name: r'minutesSinceMidnight',
      type: IsarType.long,
    ),
    r'mutexLock': PropertySchema(
      id: 21,
      name: r'mutexLock',
      type: IsarType.bool,
    ),
    r'numMathsQuestions': PropertySchema(
      id: 22,
      name: r'numMathsQuestions',
      type: IsarType.long,
    ),
    r'ownerId': PropertySchema(
      id: 23,
      name: r'ownerId',
      type: IsarType.string,
    ),
    r'ownerName': PropertySchema(
      id: 24,
      name: r'ownerName',
      type: IsarType.string,
    ),
    r'qrValue': PropertySchema(
      id: 25,
      name: r'qrValue',
      type: IsarType.string,
    ),
    r'shakeTimes': PropertySchema(
      id: 26,
      name: r'shakeTimes',
      type: IsarType.long,
    ),
    r'sharedUserIds': PropertySchema(
      id: 27,
      name: r'sharedUserIds',
      type: IsarType.stringList,
    ),
    r'weatherTypes': PropertySchema(
      id: 28,
      name: r'weatherTypes',
      type: IsarType.longList,
    )
  },
  estimateSize: _alarmModelEstimateSize,
  serialize: _alarmModelSerialize,
  deserialize: _alarmModelDeserialize,
  deserializeProp: _alarmModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _alarmModelGetId,
  getLinks: _alarmModelGetLinks,
  attach: _alarmModelAttach,
  version: '3.1.0+1',
);

int _alarmModelEstimateSize(
  AlarmModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.alarmID.length * 3;
  bytesCount += 3 + object.alarmTime.length * 3;
  bytesCount += 3 + object.days.length;
  {
    final value = object.firestoreId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.lastEditedUserId.length * 3;
  bytesCount += 3 + object.location.length * 3;
  {
    final value = object.mainAlarmTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.ownerId.length * 3;
  bytesCount += 3 + object.ownerName.length * 3;
  bytesCount += 3 + object.qrValue.length * 3;
  {
    final list = object.sharedUserIds;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.weatherTypes.length * 8;
  return bytesCount;
}

void _alarmModelSerialize(
  AlarmModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.activityInterval);
  writer.writeString(offsets[1], object.alarmID);
  writer.writeString(offsets[2], object.alarmTime);
  writer.writeBoolList(offsets[3], object.days);
  writer.writeString(offsets[4], object.firestoreId);
  writer.writeLong(offsets[5], object.intervalToAlarm);
  writer.writeBool(offsets[6], object.isActivityEnabled);
  writer.writeBool(offsets[7], object.isEnabled);
  writer.writeBool(offsets[8], object.isLocationEnabled);
  writer.writeBool(offsets[9], object.isMathsEnabled);
  writer.writeBool(offsets[10], object.isOneTime);
  writer.writeBool(offsets[11], object.isQrEnabled);
  writer.writeBool(offsets[12], object.isShakeEnabled);
  writer.writeBool(offsets[13], object.isSharedAlarmEnabled);
  writer.writeBool(offsets[14], object.isWeatherEnabled);
  writer.writeString(offsets[15], object.label);
  writer.writeString(offsets[16], object.lastEditedUserId);
  writer.writeString(offsets[17], object.location);
  writer.writeString(offsets[18], object.mainAlarmTime);
  writer.writeLong(offsets[19], object.mathsDifficulty);
  writer.writeLong(offsets[20], object.minutesSinceMidnight);
  writer.writeBool(offsets[21], object.mutexLock);
  writer.writeLong(offsets[22], object.numMathsQuestions);
  writer.writeString(offsets[23], object.ownerId);
  writer.writeString(offsets[24], object.ownerName);
  writer.writeString(offsets[25], object.qrValue);
  writer.writeLong(offsets[26], object.shakeTimes);
  writer.writeStringList(offsets[27], object.sharedUserIds);
  writer.writeLongList(offsets[28], object.weatherTypes);
}

AlarmModel _alarmModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlarmModel(
    activityInterval: reader.readLong(offsets[0]),
    alarmID: reader.readString(offsets[1]),
    alarmTime: reader.readString(offsets[2]),
    days: reader.readBoolList(offsets[3]) ?? [],
    intervalToAlarm: reader.readLong(offsets[5]),
    isActivityEnabled: reader.readBool(offsets[6]),
    isEnabled: reader.readBoolOrNull(offsets[7]) ?? true,
    isLocationEnabled: reader.readBool(offsets[8]),
    isMathsEnabled: reader.readBool(offsets[9]),
    isOneTime: reader.readBool(offsets[10]),
    isQrEnabled: reader.readBool(offsets[11]),
    isShakeEnabled: reader.readBool(offsets[12]),
    isSharedAlarmEnabled: reader.readBool(offsets[13]),
    isWeatherEnabled: reader.readBool(offsets[14]),
    label: reader.readString(offsets[15]),
    lastEditedUserId: reader.readString(offsets[16]),
    location: reader.readString(offsets[17]),
    mainAlarmTime: reader.readStringOrNull(offsets[18]),
    mathsDifficulty: reader.readLong(offsets[19]),
    minutesSinceMidnight: reader.readLong(offsets[20]),
    mutexLock: reader.readBool(offsets[21]),
    numMathsQuestions: reader.readLong(offsets[22]),
    ownerId: reader.readString(offsets[23]),
    ownerName: reader.readString(offsets[24]),
    qrValue: reader.readString(offsets[25]),
    shakeTimes: reader.readLong(offsets[26]),
    sharedUserIds: reader.readStringList(offsets[27]),
    weatherTypes: reader.readLongList(offsets[28]) ?? [],
  );
  object.firestoreId = reader.readStringOrNull(offsets[4]);
  object.isarId = id;
  return object;
}

P _alarmModelDeserializeProp<P>(
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
    case 3:
      return (reader.readBoolList(offset) ?? []) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readBool(offset)) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    case 23:
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readString(offset)) as P;
    case 25:
      return (reader.readString(offset)) as P;
    case 26:
      return (reader.readLong(offset)) as P;
    case 27:
      return (reader.readStringList(offset)) as P;
    case 28:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _alarmModelGetId(AlarmModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _alarmModelGetLinks(AlarmModel object) {
  return [];
}

void _alarmModelAttach(IsarCollection<dynamic> col, Id id, AlarmModel object) {
  object.isarId = id;
}

extension AlarmModelQueryWhereSort
    on QueryBuilder<AlarmModel, AlarmModel, QWhere> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AlarmModelQueryWhere
    on QueryBuilder<AlarmModel, AlarmModel, QWhereClause> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterWhereClause> isarIdBetween(
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

extension AlarmModelQueryFilter
    on QueryBuilder<AlarmModel, AlarmModel, QFilterCondition> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityIntervalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityIntervalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityIntervalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityIntervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityInterval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmIDEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      alarmIDGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alarmID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmIDLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alarmID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmIDBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alarmID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'alarmID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'alarmID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmIDContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'alarmID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmIDMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'alarmID',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmID',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      alarmIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'alarmID',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      alarmTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alarmTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      alarmTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'alarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'alarmTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      alarmTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmTime',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      alarmTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'alarmTime',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      daysElementEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'days',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> daysLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> daysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> daysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      daysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      daysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> daysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firestoreId',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firestoreId',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firestoreId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'firestoreId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'firestoreId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firestoreId',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      firestoreIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'firestoreId',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      intervalToAlarmEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalToAlarm',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      intervalToAlarmGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalToAlarm',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      intervalToAlarmLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalToAlarm',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      intervalToAlarmBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalToAlarm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      isActivityEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActivityEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> isEnabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      isLocationEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isLocationEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      isMathsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMathsEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> isOneTimeEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOneTime',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      isQrEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isQrEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      isShakeEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isShakeEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      isSharedAlarmEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSharedAlarmEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      isWeatherEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isWeatherEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> labelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> labelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      lastEditedUserIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEditedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      lastEditedUserIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastEditedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      lastEditedUserIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastEditedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      lastEditedUserIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastEditedUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      lastEditedUserIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastEditedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      lastEditedUserIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastEditedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      lastEditedUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastEditedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      lastEditedUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastEditedUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      lastEditedUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEditedUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      lastEditedUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastEditedUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> locationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      locationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> locationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> locationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'location',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      locationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> locationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> locationContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> locationMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'location',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mainAlarmTime',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mainAlarmTime',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mainAlarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mainAlarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mainAlarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mainAlarmTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mainAlarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mainAlarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mainAlarmTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mainAlarmTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mainAlarmTime',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mainAlarmTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mainAlarmTime',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mathsDifficultyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mathsDifficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mathsDifficultyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mathsDifficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mathsDifficultyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mathsDifficulty',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      mathsDifficultyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mathsDifficulty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      minutesSinceMidnightEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minutesSinceMidnight',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      minutesSinceMidnightGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minutesSinceMidnight',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      minutesSinceMidnightLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minutesSinceMidnight',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      minutesSinceMidnightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minutesSinceMidnight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> mutexLockEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mutexLock',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      numMathsQuestionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numMathsQuestions',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      numMathsQuestionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numMathsQuestions',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      numMathsQuestionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numMathsQuestions',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      numMathsQuestionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numMathsQuestions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      ownerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerId',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      ownerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerId',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      ownerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      ownerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ownerNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      ownerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerName',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      ownerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerName',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> qrValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qrValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      qrValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qrValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> qrValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qrValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> qrValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qrValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> qrValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'qrValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> qrValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'qrValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> qrValueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qrValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> qrValueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qrValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> qrValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qrValue',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      qrValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'qrValue',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> shakeTimesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shakeTimes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      shakeTimesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shakeTimes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      shakeTimesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shakeTimes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> shakeTimesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shakeTimes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sharedUserIds',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sharedUserIds',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sharedUserIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sharedUserIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sharedUserIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sharedUserIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sharedUserIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sharedUserIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sharedUserIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sharedUserIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sharedUserIds',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sharedUserIds',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedUserIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedUserIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedUserIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedUserIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedUserIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sharedUserIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sharedUserIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherTypesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weatherTypes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherTypesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weatherTypes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherTypesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weatherTypes',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherTypesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weatherTypes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherTypesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weatherTypes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherTypesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weatherTypes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherTypesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weatherTypes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherTypesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weatherTypes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherTypesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weatherTypes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherTypesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weatherTypes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension AlarmModelQueryObject
    on QueryBuilder<AlarmModel, AlarmModel, QFilterCondition> {}

extension AlarmModelQueryLinks
    on QueryBuilder<AlarmModel, AlarmModel, QFilterCondition> {}

extension AlarmModelQuerySortBy
    on QueryBuilder<AlarmModel, AlarmModel, QSortBy> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByActivityInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityInterval', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByActivityIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityInterval', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByAlarmID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmID', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByAlarmIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmID', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByAlarmTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByFirestoreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestoreId', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByFirestoreIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestoreId', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIntervalToAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalToAlarm', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIntervalToAlarmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalToAlarm', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsActivityEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActivityEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIsActivityEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActivityEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsLocationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocationEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIsLocationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocationEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsMathsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMathsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIsMathsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMathsEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsOneTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOneTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsOneTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOneTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsQrEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isQrEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsQrEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isQrEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsShakeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShakeEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIsShakeEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShakeEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIsSharedAlarmEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSharedAlarmEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIsSharedAlarmEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSharedAlarmEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsWeatherEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeatherEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIsWeatherEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeatherEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLastEditedUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEditedUserId', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByLastEditedUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEditedUserId', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByMainAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainAlarmTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByMainAlarmTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainAlarmTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByMathsDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathsDifficulty', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByMathsDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathsDifficulty', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByMinutesSinceMidnight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceMidnight', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByMinutesSinceMidnightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceMidnight', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByMutexLock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mutexLock', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByMutexLockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mutexLock', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByNumMathsQuestions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numMathsQuestions', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByNumMathsQuestionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numMathsQuestions', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByQrValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrValue', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByQrValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrValue', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByShakeTimes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shakeTimes', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByShakeTimesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shakeTimes', Sort.desc);
    });
  }
}

extension AlarmModelQuerySortThenBy
    on QueryBuilder<AlarmModel, AlarmModel, QSortThenBy> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByActivityInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityInterval', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByActivityIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityInterval', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByAlarmID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmID', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByAlarmIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmID', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByAlarmTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByFirestoreId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestoreId', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByFirestoreIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestoreId', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIntervalToAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalToAlarm', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIntervalToAlarmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalToAlarm', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsActivityEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActivityEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIsActivityEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActivityEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsLocationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocationEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIsLocationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLocationEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsMathsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMathsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIsMathsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMathsEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsOneTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOneTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsOneTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOneTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsQrEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isQrEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsQrEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isQrEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsShakeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShakeEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIsShakeEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShakeEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIsSharedAlarmEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSharedAlarmEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIsSharedAlarmEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSharedAlarmEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsWeatherEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeatherEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIsWeatherEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWeatherEnabled', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLastEditedUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEditedUserId', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByLastEditedUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEditedUserId', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByMainAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainAlarmTime', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByMainAlarmTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainAlarmTime', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByMathsDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathsDifficulty', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByMathsDifficultyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mathsDifficulty', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByMinutesSinceMidnight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceMidnight', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByMinutesSinceMidnightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesSinceMidnight', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByMutexLock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mutexLock', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByMutexLockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mutexLock', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByNumMathsQuestions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numMathsQuestions', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByNumMathsQuestionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numMathsQuestions', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByQrValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrValue', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByQrValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qrValue', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByShakeTimes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shakeTimes', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByShakeTimesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shakeTimes', Sort.desc);
    });
  }
}

extension AlarmModelQueryWhereDistinct
    on QueryBuilder<AlarmModel, AlarmModel, QDistinct> {
  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByActivityInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityInterval');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByAlarmID(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alarmID', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByAlarmTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alarmTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'days');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByFirestoreId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firestoreId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIntervalToAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalToAlarm');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByIsActivityEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActivityEnabled');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEnabled');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByIsLocationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isLocationEnabled');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsMathsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMathsEnabled');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsOneTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOneTime');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsQrEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isQrEnabled');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsShakeEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isShakeEnabled');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByIsSharedAlarmEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSharedAlarmEnabled');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsWeatherEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWeatherEnabled');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByLastEditedUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastEditedUserId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByLocation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'location', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByMainAlarmTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mainAlarmTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByMathsDifficulty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mathsDifficulty');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByMinutesSinceMidnight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minutesSinceMidnight');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByMutexLock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mutexLock');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByNumMathsQuestions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numMathsQuestions');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByOwnerId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByOwnerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByQrValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qrValue', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByShakeTimes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shakeTimes');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctBySharedUserIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sharedUserIds');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByWeatherTypes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weatherTypes');
    });
  }
}

extension AlarmModelQueryProperty
    on QueryBuilder<AlarmModel, AlarmModel, QQueryProperty> {
  QueryBuilder<AlarmModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> activityIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityInterval');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> alarmIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarmID');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> alarmTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarmTime');
    });
  }

  QueryBuilder<AlarmModel, List<bool>, QQueryOperations> daysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'days');
    });
  }

  QueryBuilder<AlarmModel, String?, QQueryOperations> firestoreIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firestoreId');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> intervalToAlarmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalToAlarm');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isActivityEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActivityEnabled');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEnabled');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isLocationEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isLocationEnabled');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isMathsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMathsEnabled');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isOneTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOneTime');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isQrEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isQrEnabled');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isShakeEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isShakeEnabled');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations>
      isSharedAlarmEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSharedAlarmEnabled');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isWeatherEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWeatherEnabled');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations>
      lastEditedUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastEditedUserId');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> locationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'location');
    });
  }

  QueryBuilder<AlarmModel, String?, QQueryOperations> mainAlarmTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mainAlarmTime');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> mathsDifficultyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mathsDifficulty');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations>
      minutesSinceMidnightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minutesSinceMidnight');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> mutexLockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mutexLock');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> numMathsQuestionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numMathsQuestions');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> ownerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerId');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> ownerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerName');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> qrValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qrValue');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> shakeTimesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shakeTimes');
    });
  }

  QueryBuilder<AlarmModel, List<String>?, QQueryOperations>
      sharedUserIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sharedUserIds');
    });
  }

  QueryBuilder<AlarmModel, List<int>, QQueryOperations> weatherTypesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weatherTypes');
    });
  }
}
