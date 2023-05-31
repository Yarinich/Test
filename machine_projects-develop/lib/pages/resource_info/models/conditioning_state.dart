enum ConditioningState {
  conditioning('CONDITIONING'),
  conditioningVentilation('CONDITIONING_VENTILATION'),
  ventilation('VENTILATION'),
  heating('HEATING'),
  heatingVentilation('HEATING_VENTILATION'),
  recirculation('RECIRCULATION'),
  demisting('DEMISTING');

  const ConditioningState(this.backendValue);

  final String backendValue;
}
