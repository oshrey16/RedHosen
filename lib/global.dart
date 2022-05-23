import 'package:red_hosen/mytools.dart';

late UserType usertype;

institution getinstitution(){
  if (usertype == UserType.hosen) return institution.hosen;
  if (usertype == UserType.social) return institution.social;
  return institution.nil;
}