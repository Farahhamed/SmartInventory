import 'package:smartinventory/models/BranchesModel.dart';

class Employee{
  final String name;
  final String position;
  final Branches branchesId;

  const Employee({
    required this.name,
    required this.position,
    required this.branchesId,
  });
}