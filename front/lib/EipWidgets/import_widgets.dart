import 'package:front/EipWidgets/content_based_router.dart';
import 'package:front/EipWidgets/message.dart';
import 'package:front/EipWidgets/message_endpoint.dart';
import 'package:front/EipWidgets/message_filter.dart';
import 'package:front/EipWidgets/message_translator.dart';

Map<String, dynamic> eipWidgets = {
	'ContentBasedRouter': ContentBasedRouter(100, 100),
	'Message': Message(100, 100),
	'MessageEndpoint': MessageEndpoint(100, 100),
	'MessageFilter': MessageFilter(100, 100),
	'MessageTranslator': MessageTranslator(100, 100),
};