// https://en.wikipedia.org/wiki/Six_degrees_of_freedom

enum MotionKind {
  // Translational envelopes

  // Accel X
  heavePlus,
  heaveMinus,

  // Accel Y
  surgePlus,
  surgeMinus,

  // Accel Z
  swayPlus,
  swayMinus,

  // Rotational envelopes

  // Gyro X
  yawPlus,
  yawMinus,

  // Gyro Y
  rollPlus,
  rollMinus,

  // Gyro Z
  pitchPlus,
  pitchMinus,
}
