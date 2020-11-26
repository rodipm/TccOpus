import 'package:front/BasicWidgets/assign_statement.dart';
import 'package:front/BasicWidgets/call_statement.dart';
import 'package:front/BasicWidgets/def_statement.dart';
import 'package:front/BasicWidgets/else_statement.dart';
import 'package:front/BasicWidgets/expression_statement.dart';
import 'package:front/BasicWidgets/for_statement.dart';
import 'package:front/BasicWidgets/if_statement.dart';
import 'package:front/BasicWidgets/then_statement.dart';

Map<String, dynamic> basicWidgets= {
	'AssignStatement': assignstatement,
	'CallStatement': callstatement,
	'DefStatement': defstatement,
	'ElseStatement': elsestatement,
	'ExpressionStatement': expressionstatement,
	'ForStatement': forstatement,
	'IfStatement': ifstatement,
	'ThenStatement': thenstatement,
};
dynamic assignstatement() {
	return AssignStatement(100, 100);
}
dynamic callstatement() {
	return CallStatement(100, 100);
}
dynamic defstatement() {
	return DefStatement(100, 100);
}
dynamic elsestatement() {
	return ElseStatement(100, 100);
}
dynamic expressionstatement() {
	return ExpressionStatement(100, 100);
}
dynamic forstatement() {
	return ForStatement(100, 100);
}
dynamic ifstatement() {
	return IfStatement(100, 100);
}
dynamic thenstatement() {
	return ThenStatement(100, 100);
}
