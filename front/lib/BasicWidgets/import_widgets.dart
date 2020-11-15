import 'package:front/BasicWidgets/assign_statement.dart';
import 'package:front/BasicWidgets/for_statement.dart';
import 'package:front/BasicWidgets/goto_statement.dart';
import 'package:front/BasicWidgets/if_statement.dart';
import 'package:front/BasicWidgets/print_statement.dart';

Map<String, dynamic> basicWidgets= {
	'AssignStatement': assignstatement,
	'ForStatement': forstatement,
	'GotoStatement': gotostatement,
	'IfStatement': ifstatement,
	'PrintStatement': printstatement,
};
dynamic assignstatement() {
	return AssignStatement(100, 100);
}
dynamic forstatement() {
	return ForStatement(100, 100);
}
dynamic gotostatement() {
	return GotoStatement(100, 100);
}
dynamic ifstatement() {
	return IfStatement(100, 100);
}
dynamic printstatement() {
	return PrintStatement(100, 100);
}
