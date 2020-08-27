import 'package:front/EipWidgets/content_based_router.dart';
import 'package:front/EipWidgets/message.dart';
import 'package:front/EipWidgets/message_endpoint.dart';
import 'package:front/EipWidgets/message_filter.dart';
import 'package:front/EipWidgets/message_translator.dart';

Map<String, dynamic> eipWidgets = {
	'ContentBasedRouter': contentbasedrouter,
	'Message': message,
	'MessageEndpoint': messageendpoint,
	'MessageFilter': messagefilter,
	'MessageTranslator': messagetranslator,
};
dynamic contentbasedrouter() {
	return ContentBasedRouter(100, 100);
}
dynamic message() {
	return Message(100, 100);
}
dynamic messageendpoint() {
	return MessageEndpoint(100, 100);
}
dynamic messagefilter() {
	return MessageFilter(100, 100);
}
dynamic messagetranslator() {
	return MessageTranslator(100, 100);
}
