// https://en.wikipedia.org/wiki/Six_degrees_of_freedom

enum MotionKind {
  heave, // Accel X
  surge, // Accel Y
  sway, // Accel Z
  yaw, // Gyro X
  roll, // Gyro Y
  pitch, // Gyro Z
}
