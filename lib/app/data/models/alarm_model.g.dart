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
    r'activityConditionType': PropertySchema(
      id: 0,
      name: r'activityConditionType',
      type: IsarType.long,
    ),
    r'activityInterval': PropertySchema(
      id: 1,
      name: r'activityInterval',
      type: IsarType.long,
    ),
    r'activityMonitor': PropertySchema(
      id: 2,
      name: r'activityMonitor',
      type: IsarType.long,
    ),
    r'alarmDate': PropertySchema(
      id: 3,
      name: r'alarmDate',
      type: IsarType.string,
    ),
    r'alarmID': PropertySchema(
      id: 4,
      name: r'alarmID',
      type: IsarType.string,
    ),
    r'alarmTime': PropertySchema(
      id: 5,
      name: r'alarmTime',
      type: IsarType.string,
    ),
    r'days': PropertySchema(
      id: 6,
      name: r'days',
      type: IsarType.boolList,
    ),
    r'deleteAfterGoesOff': PropertySchema(
      id: 7,
      name: r'deleteAfterGoesOff',
      type: IsarType.bool,
    ),
    r'firestoreId': PropertySchema(
      id: 8,
      name: r'firestoreId',
      type: IsarType.string,
    ),
    r'gradient': PropertySchema(
      id: 9,
      name: r'gradient',
      type: IsarType.long,
    ),
    r'guardian': PropertySchema(
      id: 10,
      name: r'guardian',
      type: IsarType.string,
    ),
    r'guardianTimer': PropertySchema(
      id: 11,
      name: r'guardianTimer',
      type: IsarType.long,
    ),
    r'intervalToAlarm': PropertySchema(
      id: 12,
      name: r'intervalToAlarm',
      type: IsarType.long,
    ),
    r'isActivityEnabled': PropertySchema(
      id: 13,
      name: r'isActivityEnabled',
      type: IsarType.bool,
    ),
    r'isCall': PropertySchema(
      id: 14,
      name: r'isCall',
      type: IsarType.bool,
    ),
    r'isEnabled': PropertySchema(
      id: 15,
      name: r'isEnabled',
      type: IsarType.bool,
    ),
    r'isGuardian': PropertySchema(
      id: 16,
      name: r'isGuardian',
      type: IsarType.bool,
    ),
    r'isLocationEnabled': PropertySchema(
      id: 17,
      name: r'isLocationEnabled',
      type: IsarType.bool,
    ),
    r'isMathsEnabled': PropertySchema(
      id: 18,
      name: r'isMathsEnabled',
      type: IsarType.bool,
    ),
    r'isOneTime': PropertySchema(
      id: 19,
      name: r'isOneTime',
      type: IsarType.bool,
    ),
    r'isPedometerEnabled': PropertySchema(
      id: 20,
      name: r'isPedometerEnabled',
      type: IsarType.bool,
    ),
    r'isQrEnabled': PropertySchema(
      id: 21,
      name: r'isQrEnabled',
      type: IsarType.bool,
    ),
    r'isShakeEnabled': PropertySchema(
      id: 22,
      name: r'isShakeEnabled',
      type: IsarType.bool,
    ),
    r'isSharedAlarmEnabled': PropertySchema(
      id: 23,
      name: r'isSharedAlarmEnabled',
      type: IsarType.bool,
    ),
    r'isSunriseEnabled': PropertySchema(
      id: 24,
      name: r'isSunriseEnabled',
      type: IsarType.bool,
    ),
    r'isWeatherEnabled': PropertySchema(
      id: 25,
      name: r'isWeatherEnabled',
      type: IsarType.bool,
    ),
    r'label': PropertySchema(
      id: 26,
      name: r'label',
      type: IsarType.string,
    ),
    r'lastEditedUserId': PropertySchema(
      id: 27,
      name: r'lastEditedUserId',
      type: IsarType.string,
    ),
    r'location': PropertySchema(
      id: 28,
      name: r'location',
      type: IsarType.string,
    ),
    r'locationConditionType': PropertySchema(
      id: 29,
      name: r'locationConditionType',
      type: IsarType.long,
    ),
    r'mainAlarmTime': PropertySchema(
      id: 30,
      name: r'mainAlarmTime',
      type: IsarType.string,
    ),
    r'mathsDifficulty': PropertySchema(
      id: 31,
      name: r'mathsDifficulty',
      type: IsarType.long,
    ),
    r'maxSnoozeCount': PropertySchema(
      id: 32,
      name: r'maxSnoozeCount',
      type: IsarType.long,
    ),
    r'minutesSinceMidnight': PropertySchema(
      id: 33,
      name: r'minutesSinceMidnight',
      type: IsarType.long,
    ),
    r'mutexLock': PropertySchema(
      id: 34,
      name: r'mutexLock',
      type: IsarType.bool,
    ),
    r'note': PropertySchema(
      id: 35,
      name: r'note',
      type: IsarType.string,
    ),
    r'numMathsQuestions': PropertySchema(
      id: 36,
      name: r'numMathsQuestions',
      type: IsarType.long,
    ),
    r'numberOfSteps': PropertySchema(
      id: 37,
      name: r'numberOfSteps',
      type: IsarType.long,
    ),
    r'ownerId': PropertySchema(
      id: 38,
      name: r'ownerId',
      type: IsarType.string,
    ),
    r'ownerName': PropertySchema(
      id: 39,
      name: r'ownerName',
      type: IsarType.string,
    ),
    r'profile': PropertySchema(
      id: 40,
      name: r'profile',
      type: IsarType.string,
    ),
    r'qrValue': PropertySchema(
      id: 41,
      name: r'qrValue',
      type: IsarType.string,
    ),
    r'ringOn': PropertySchema(
      id: 42,
      name: r'ringOn',
      type: IsarType.bool,
    ),
    r'ringtoneName': PropertySchema(
      id: 43,
      name: r'ringtoneName',
      type: IsarType.string,
    ),
    r'shakeTimes': PropertySchema(
      id: 44,
      name: r'shakeTimes',
      type: IsarType.long,
    ),
    r'sharedUserIds': PropertySchema(
      id: 45,
      name: r'sharedUserIds',
      type: IsarType.stringList,
    ),
    r'showMotivationalQuote': PropertySchema(
      id: 46,
      name: r'showMotivationalQuote',
      type: IsarType.bool,
    ),
    r'snoozeDuration': PropertySchema(
      id: 47,
      name: r'snoozeDuration',
      type: IsarType.long,
    ),
    r'sunriseColorScheme': PropertySchema(
      id: 48,
      name: r'sunriseColorScheme',
      type: IsarType.long,
    ),
    r'sunriseDuration': PropertySchema(
      id: 49,
      name: r'sunriseDuration',
      type: IsarType.long,
    ),
    r'sunriseIntensity': PropertySchema(
      id: 50,
      name: r'sunriseIntensity',
      type: IsarType.double,
    ),
    r'volMax': PropertySchema(
      id: 51,
      name: r'volMax',
      type: IsarType.double,
    ),
    r'volMin': PropertySchema(
      id: 52,
      name: r'volMin',
      type: IsarType.double,
    ),
    r'weatherConditionType': PropertySchema(
      id: 53,
      name: r'weatherConditionType',
      type: IsarType.long,
    ),
    r'weatherTypes': PropertySchema(
      id: 54,
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
  bytesCount += 3 + object.alarmDate.length * 3;
  bytesCount += 3 + object.alarmID.length * 3;
  bytesCount += 3 + object.alarmTime.length * 3;
  bytesCount += 3 + object.days.length;
  {
    final value = object.firestoreId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.guardian.length * 3;
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.lastEditedUserId.length * 3;
  bytesCount += 3 + object.location.length * 3;
  {
    final value = object.mainAlarmTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.note.length * 3;
  bytesCount += 3 + object.ownerId.length * 3;
  bytesCount += 3 + object.ownerName.length * 3;
  bytesCount += 3 + object.profile.length * 3;
  bytesCount += 3 + object.qrValue.length * 3;
  bytesCount += 3 + object.ringtoneName.length * 3;
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
  writer.writeLong(offsets[0], object.activityConditionType);
  writer.writeLong(offsets[1], object.activityInterval);
  writer.writeLong(offsets[2], object.activityMonitor);
  writer.writeString(offsets[3], object.alarmDate);
  writer.writeString(offsets[4], object.alarmID);
  writer.writeString(offsets[5], object.alarmTime);
  writer.writeBoolList(offsets[6], object.days);
  writer.writeBool(offsets[7], object.deleteAfterGoesOff);
  writer.writeString(offsets[8], object.firestoreId);
  writer.writeLong(offsets[9], object.gradient);
  writer.writeString(offsets[10], object.guardian);
  writer.writeLong(offsets[11], object.guardianTimer);
  writer.writeLong(offsets[12], object.intervalToAlarm);
  writer.writeBool(offsets[13], object.isActivityEnabled);
  writer.writeBool(offsets[14], object.isCall);
  writer.writeBool(offsets[15], object.isEnabled);
  writer.writeBool(offsets[16], object.isGuardian);
  writer.writeBool(offsets[17], object.isLocationEnabled);
  writer.writeBool(offsets[18], object.isMathsEnabled);
  writer.writeBool(offsets[19], object.isOneTime);
  writer.writeBool(offsets[20], object.isPedometerEnabled);
  writer.writeBool(offsets[21], object.isQrEnabled);
  writer.writeBool(offsets[22], object.isShakeEnabled);
  writer.writeBool(offsets[23], object.isSharedAlarmEnabled);
  writer.writeBool(offsets[24], object.isSunriseEnabled);
  writer.writeBool(offsets[25], object.isWeatherEnabled);
  writer.writeString(offsets[26], object.label);
  writer.writeString(offsets[27], object.lastEditedUserId);
  writer.writeString(offsets[28], object.location);
  writer.writeLong(offsets[29], object.locationConditionType);
  writer.writeString(offsets[30], object.mainAlarmTime);
  writer.writeLong(offsets[31], object.mathsDifficulty);
  writer.writeLong(offsets[32], object.maxSnoozeCount);
  writer.writeLong(offsets[33], object.minutesSinceMidnight);
  writer.writeBool(offsets[34], object.mutexLock);
  writer.writeString(offsets[35], object.note);
  writer.writeLong(offsets[36], object.numMathsQuestions);
  writer.writeLong(offsets[37], object.numberOfSteps);
  writer.writeString(offsets[38], object.ownerId);
  writer.writeString(offsets[39], object.ownerName);
  writer.writeString(offsets[40], object.profile);
  writer.writeString(offsets[41], object.qrValue);
  writer.writeBool(offsets[42], object.ringOn);
  writer.writeString(offsets[43], object.ringtoneName);
  writer.writeLong(offsets[44], object.shakeTimes);
  writer.writeStringList(offsets[45], object.sharedUserIds);
  writer.writeBool(offsets[46], object.showMotivationalQuote);
  writer.writeLong(offsets[47], object.snoozeDuration);
  writer.writeLong(offsets[48], object.sunriseColorScheme);
  writer.writeLong(offsets[49], object.sunriseDuration);
  writer.writeDouble(offsets[50], object.sunriseIntensity);
  writer.writeDouble(offsets[51], object.volMax);
  writer.writeDouble(offsets[52], object.volMin);
  writer.writeLong(offsets[53], object.weatherConditionType);
  writer.writeLongList(offsets[54], object.weatherTypes);
}

AlarmModel _alarmModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlarmModel(
    activityConditionType: reader.readLong(offsets[0]),
    activityInterval: reader.readLong(offsets[1]),
    activityMonitor: reader.readLong(offsets[2]),
    alarmDate: reader.readString(offsets[3]),
    alarmID: reader.readString(offsets[4]),
    alarmTime: reader.readString(offsets[5]),
    days: reader.readBoolList(offsets[6]) ?? [],
    deleteAfterGoesOff: reader.readBool(offsets[7]),
    gradient: reader.readLong(offsets[9]),
    guardian: reader.readString(offsets[10]),
    guardianTimer: reader.readLong(offsets[11]),
    intervalToAlarm: reader.readLong(offsets[12]),
    isActivityEnabled: reader.readBool(offsets[13]),
    isCall: reader.readBool(offsets[14]),
    isEnabled: reader.readBoolOrNull(offsets[15]) ?? true,
    isGuardian: reader.readBool(offsets[16]),
    isLocationEnabled: reader.readBool(offsets[17]),
    isMathsEnabled: reader.readBool(offsets[18]),
    isOneTime: reader.readBool(offsets[19]),
    isPedometerEnabled: reader.readBool(offsets[20]),
    isQrEnabled: reader.readBool(offsets[21]),
    isShakeEnabled: reader.readBool(offsets[22]),
    isSharedAlarmEnabled: reader.readBool(offsets[23]),
    isSunriseEnabled: reader.readBool(offsets[24]),
    isWeatherEnabled: reader.readBool(offsets[25]),
    label: reader.readString(offsets[26]),
    lastEditedUserId: reader.readString(offsets[27]),
    location: reader.readString(offsets[28]),
    locationConditionType: reader.readLong(offsets[29]),
    mainAlarmTime: reader.readStringOrNull(offsets[30]),
    mathsDifficulty: reader.readLong(offsets[31]),
    maxSnoozeCount: reader.readLongOrNull(offsets[32]) ?? 3,
    minutesSinceMidnight: reader.readLong(offsets[33]),
    mutexLock: reader.readBool(offsets[34]),
    note: reader.readString(offsets[35]),
    numMathsQuestions: reader.readLong(offsets[36]),
    numberOfSteps: reader.readLong(offsets[37]),
    ownerId: reader.readString(offsets[38]),
    ownerName: reader.readString(offsets[39]),
    profile: reader.readString(offsets[40]),
    qrValue: reader.readString(offsets[41]),
    ringOn: reader.readBool(offsets[42]),
    ringtoneName: reader.readString(offsets[43]),
    shakeTimes: reader.readLong(offsets[44]),
    sharedUserIds: reader.readStringList(offsets[45]),
    showMotivationalQuote: reader.readBool(offsets[46]),
    snoozeDuration: reader.readLong(offsets[47]),
    sunriseColorScheme: reader.readLong(offsets[48]),
    sunriseDuration: reader.readLong(offsets[49]),
    sunriseIntensity: reader.readDouble(offsets[50]),
    volMax: reader.readDouble(offsets[51]),
    volMin: reader.readDouble(offsets[52]),
    weatherConditionType: reader.readLong(offsets[53]),
    weatherTypes: reader.readLongList(offsets[54]) ?? [],
  );
  object.firestoreId = reader.readStringOrNull(offsets[8]);
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
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBoolList(offset) ?? []) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    case 19:
      return (reader.readBool(offset)) as P;
    case 20:
      return (reader.readBool(offset)) as P;
    case 21:
      return (reader.readBool(offset)) as P;
    case 22:
      return (reader.readBool(offset)) as P;
    case 23:
      return (reader.readBool(offset)) as P;
    case 24:
      return (reader.readBool(offset)) as P;
    case 25:
      return (reader.readBool(offset)) as P;
    case 26:
      return (reader.readString(offset)) as P;
    case 27:
      return (reader.readString(offset)) as P;
    case 28:
      return (reader.readString(offset)) as P;
    case 29:
      return (reader.readLong(offset)) as P;
    case 30:
      return (reader.readStringOrNull(offset)) as P;
    case 31:
      return (reader.readLong(offset)) as P;
    case 32:
      return (reader.readLongOrNull(offset) ?? 3) as P;
    case 33:
      return (reader.readLong(offset)) as P;
    case 34:
      return (reader.readBool(offset)) as P;
    case 35:
      return (reader.readString(offset)) as P;
    case 36:
      return (reader.readLong(offset)) as P;
    case 37:
      return (reader.readLong(offset)) as P;
    case 38:
      return (reader.readString(offset)) as P;
    case 39:
      return (reader.readString(offset)) as P;
    case 40:
      return (reader.readString(offset)) as P;
    case 41:
      return (reader.readString(offset)) as P;
    case 42:
      return (reader.readBool(offset)) as P;
    case 43:
      return (reader.readString(offset)) as P;
    case 44:
      return (reader.readLong(offset)) as P;
    case 45:
      return (reader.readStringList(offset)) as P;
    case 46:
      return (reader.readBool(offset)) as P;
    case 47:
      return (reader.readLong(offset)) as P;
    case 48:
      return (reader.readLong(offset)) as P;
    case 49:
      return (reader.readLong(offset)) as P;
    case 50:
      return (reader.readDouble(offset)) as P;
    case 51:
      return (reader.readDouble(offset)) as P;
    case 52:
      return (reader.readDouble(offset)) as P;
    case 53:
      return (reader.readLong(offset)) as P;
    case 54:
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
      activityConditionTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityConditionType',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityConditionTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityConditionType',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityConditionTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityConditionType',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityConditionTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityConditionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityMonitorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityMonitor',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityMonitorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityMonitor',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityMonitorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityMonitor',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      activityMonitorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityMonitor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      alarmDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alarmDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alarmDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alarmDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      alarmDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'alarmDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'alarmDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmDateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'alarmDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> alarmDateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'alarmDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      alarmDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmDate',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      alarmDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'alarmDate',
        value: '',
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
      deleteAfterGoesOffEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deleteAfterGoesOff',
        value: value,
      ));
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> gradientEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gradient',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      gradientGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gradient',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> gradientLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gradient',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> gradientBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gradient',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> guardianEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guardian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      guardianGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'guardian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> guardianLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'guardian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> guardianBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'guardian',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      guardianStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'guardian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> guardianEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'guardian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> guardianContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'guardian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> guardianMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'guardian',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      guardianIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guardian',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      guardianIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'guardian',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      guardianTimerEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guardianTimer',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      guardianTimerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'guardianTimer',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      guardianTimerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'guardianTimer',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      guardianTimerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'guardianTimer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> isCallEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCall',
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> isGuardianEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isGuardian',
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
      isPedometerEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPedometerEnabled',
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
      isSunriseEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSunriseEnabled',
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
      locationConditionTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationConditionType',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      locationConditionTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'locationConditionType',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      locationConditionTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'locationConditionType',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      locationConditionTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'locationConditionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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
      maxSnoozeCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxSnoozeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      maxSnoozeCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxSnoozeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      maxSnoozeCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxSnoozeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      maxSnoozeCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxSnoozeCount',
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> noteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> noteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> noteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> noteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      numberOfStepsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      numberOfStepsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      numberOfStepsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfSteps',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      numberOfStepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfSteps',
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> profileEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      profileGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> profileLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> profileBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profile',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> profileStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> profileEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> profileContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profile',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> profileMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profile',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> profileIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profile',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      profileIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profile',
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> ringOnEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringOn',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      ringtoneNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ringtoneName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      ringtoneNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ringtoneName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      ringtoneNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringtoneName',
        value: '',
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      ringtoneNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ringtoneName',
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
      showMotivationalQuoteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showMotivationalQuote',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      snoozeDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snoozeDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      snoozeDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snoozeDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      snoozeDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snoozeDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      snoozeDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snoozeDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseColorSchemeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sunriseColorScheme',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseColorSchemeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sunriseColorScheme',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseColorSchemeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sunriseColorScheme',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseColorSchemeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sunriseColorScheme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sunriseDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sunriseDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sunriseDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sunriseDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseIntensityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sunriseIntensity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseIntensityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sunriseIntensity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseIntensityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sunriseIntensity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      sunriseIntensityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sunriseIntensity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> volMaxEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> volMaxGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'volMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> volMaxLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'volMax',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> volMaxBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'volMax',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> volMinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'volMin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> volMinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'volMin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> volMinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'volMin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition> volMinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'volMin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherConditionTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weatherConditionType',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherConditionTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weatherConditionType',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherConditionTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weatherConditionType',
        value: value,
      ));
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterFilterCondition>
      weatherConditionTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weatherConditionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
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
  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByActivityConditionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityConditionType', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByActivityConditionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityConditionType', Sort.desc);
    });
  }

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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByActivityMonitor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityMonitor', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByActivityMonitorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityMonitor', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByAlarmDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmDate', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByAlarmDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmDate', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByDeleteAfterGoesOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterGoesOff', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByDeleteAfterGoesOffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterGoesOff', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByGradient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gradient', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByGradientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gradient', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByGuardian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guardian', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByGuardianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guardian', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByGuardianTimer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guardianTimer', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByGuardianTimerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guardianTimer', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsCall() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCall', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsCallDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCall', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsGuardian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGuardian', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsGuardianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGuardian', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIsPedometerEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPedometerEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIsPedometerEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPedometerEnabled', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByIsSunriseEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSunriseEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByIsSunriseEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSunriseEnabled', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByLocationConditionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationConditionType', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByLocationConditionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationConditionType', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByMaxSnoozeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSnoozeCount', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByMaxSnoozeCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSnoozeCount', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByNumberOfSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSteps', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByNumberOfStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSteps', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByProfile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profile', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByProfileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profile', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByRingOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringOn', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByRingOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringOn', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByRingtoneName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByRingtoneNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByShowMotivationalQuote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showMotivationalQuote', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByShowMotivationalQuoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showMotivationalQuote', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortBySnoozeDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeDuration', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortBySnoozeDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeDuration', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortBySunriseColorScheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseColorScheme', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortBySunriseColorSchemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseColorScheme', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortBySunriseDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseDuration', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortBySunriseDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseDuration', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortBySunriseIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseIntensity', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortBySunriseIntensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseIntensity', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByVolMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volMax', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByVolMaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volMax', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByVolMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volMin', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> sortByVolMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volMin', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByWeatherConditionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherConditionType', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      sortByWeatherConditionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherConditionType', Sort.desc);
    });
  }
}

extension AlarmModelQuerySortThenBy
    on QueryBuilder<AlarmModel, AlarmModel, QSortThenBy> {
  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByActivityConditionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityConditionType', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByActivityConditionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityConditionType', Sort.desc);
    });
  }

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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByActivityMonitor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityMonitor', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByActivityMonitorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityMonitor', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByAlarmDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmDate', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByAlarmDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmDate', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByDeleteAfterGoesOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterGoesOff', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByDeleteAfterGoesOffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deleteAfterGoesOff', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByGradient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gradient', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByGradientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gradient', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByGuardian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guardian', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByGuardianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guardian', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByGuardianTimer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guardianTimer', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByGuardianTimerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guardianTimer', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsCall() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCall', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsCallDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCall', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsGuardian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGuardian', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsGuardianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGuardian', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIsPedometerEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPedometerEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIsPedometerEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPedometerEnabled', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByIsSunriseEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSunriseEnabled', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByIsSunriseEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSunriseEnabled', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByLocationConditionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationConditionType', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByLocationConditionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationConditionType', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByMaxSnoozeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSnoozeCount', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByMaxSnoozeCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSnoozeCount', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByNumberOfSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSteps', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByNumberOfStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfSteps', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByProfile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profile', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByProfileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profile', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByRingOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringOn', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByRingOnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringOn', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByRingtoneName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByRingtoneNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneName', Sort.desc);
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

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByShowMotivationalQuote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showMotivationalQuote', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByShowMotivationalQuoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showMotivationalQuote', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenBySnoozeDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeDuration', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenBySnoozeDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeDuration', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenBySunriseColorScheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseColorScheme', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenBySunriseColorSchemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseColorScheme', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenBySunriseDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseDuration', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenBySunriseDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseDuration', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenBySunriseIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseIntensity', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenBySunriseIntensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseIntensity', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByVolMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volMax', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByVolMaxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volMax', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByVolMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volMin', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy> thenByVolMinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'volMin', Sort.desc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByWeatherConditionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherConditionType', Sort.asc);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QAfterSortBy>
      thenByWeatherConditionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weatherConditionType', Sort.desc);
    });
  }
}

extension AlarmModelQueryWhereDistinct
    on QueryBuilder<AlarmModel, AlarmModel, QDistinct> {
  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByActivityConditionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityConditionType');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByActivityInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityInterval');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByActivityMonitor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityMonitor');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByAlarmDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alarmDate', caseSensitive: caseSensitive);
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

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByDeleteAfterGoesOff() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deleteAfterGoesOff');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByFirestoreId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firestoreId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByGradient() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gradient');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByGuardian(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'guardian', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByGuardianTimer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'guardianTimer');
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

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsCall() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCall');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEnabled');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsGuardian() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isGuardian');
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

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByIsPedometerEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPedometerEnabled');
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

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByIsSunriseEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSunriseEnabled');
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

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByLocationConditionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locationConditionType');
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

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByMaxSnoozeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxSnoozeCount');
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

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByNumMathsQuestions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numMathsQuestions');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByNumberOfSteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfSteps');
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

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByProfile(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profile', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByQrValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qrValue', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByRingOn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ringOn');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByRingtoneName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ringtoneName', caseSensitive: caseSensitive);
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

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByShowMotivationalQuote() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showMotivationalQuote');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctBySnoozeDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snoozeDuration');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctBySunriseColorScheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sunriseColorScheme');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctBySunriseDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sunriseDuration');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctBySunriseIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sunriseIntensity');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByVolMax() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volMax');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct> distinctByVolMin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'volMin');
    });
  }

  QueryBuilder<AlarmModel, AlarmModel, QDistinct>
      distinctByWeatherConditionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weatherConditionType');
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

  QueryBuilder<AlarmModel, int, QQueryOperations>
      activityConditionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityConditionType');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> activityIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityInterval');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> activityMonitorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityMonitor');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> alarmDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarmDate');
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

  QueryBuilder<AlarmModel, bool, QQueryOperations>
      deleteAfterGoesOffProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deleteAfterGoesOff');
    });
  }

  QueryBuilder<AlarmModel, String?, QQueryOperations> firestoreIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firestoreId');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> gradientProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gradient');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> guardianProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'guardian');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> guardianTimerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'guardianTimer');
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

  QueryBuilder<AlarmModel, bool, QQueryOperations> isCallProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCall');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEnabled');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> isGuardianProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isGuardian');
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

  QueryBuilder<AlarmModel, bool, QQueryOperations>
      isPedometerEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPedometerEnabled');
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

  QueryBuilder<AlarmModel, bool, QQueryOperations> isSunriseEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSunriseEnabled');
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

  QueryBuilder<AlarmModel, int, QQueryOperations>
      locationConditionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationConditionType');
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

  QueryBuilder<AlarmModel, int, QQueryOperations> maxSnoozeCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxSnoozeCount');
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

  QueryBuilder<AlarmModel, String, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> numMathsQuestionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numMathsQuestions');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> numberOfStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfSteps');
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

  QueryBuilder<AlarmModel, String, QQueryOperations> profileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profile');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> qrValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qrValue');
    });
  }

  QueryBuilder<AlarmModel, bool, QQueryOperations> ringOnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ringOn');
    });
  }

  QueryBuilder<AlarmModel, String, QQueryOperations> ringtoneNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ringtoneName');
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

  QueryBuilder<AlarmModel, bool, QQueryOperations>
      showMotivationalQuoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showMotivationalQuote');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> snoozeDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snoozeDuration');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> sunriseColorSchemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sunriseColorScheme');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations> sunriseDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sunriseDuration');
    });
  }

  QueryBuilder<AlarmModel, double, QQueryOperations>
      sunriseIntensityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sunriseIntensity');
    });
  }

  QueryBuilder<AlarmModel, double, QQueryOperations> volMaxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volMax');
    });
  }

  QueryBuilder<AlarmModel, double, QQueryOperations> volMinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'volMin');
    });
  }

  QueryBuilder<AlarmModel, int, QQueryOperations>
      weatherConditionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weatherConditionType');
    });
  }

  QueryBuilder<AlarmModel, List<int>, QQueryOperations> weatherTypesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weatherTypes');
    });
  }
}
