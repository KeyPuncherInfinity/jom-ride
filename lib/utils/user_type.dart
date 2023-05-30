enum UserType {
  passenger,
  driver,
}

void validate() {
  assert(UserType.passenger.index == 0);
  assert(UserType.driver.index == 1);
}
