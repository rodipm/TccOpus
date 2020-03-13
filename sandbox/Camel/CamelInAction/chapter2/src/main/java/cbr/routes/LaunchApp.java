package cbr.routes;

import javax.jms.ConnectionFactory;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.camel.component.jms.JmsComponent;
import org.apache.camel.main.Main;

public class LaunchApp {

	public static void main(String[] args) throws Exception {
		Main main = new Main();
//		main.bind("jms", JmsComponent.jmsComponentAutoAcknowledge(connectionFactory));
//		main.bind("jms", setupConnectionFactory());
		main.addRoutesBuilder(new OrderRouter());
		main.run();
	}
	
	public static JmsComponent setupConnectionFactory() {
		ConnectionFactory connectionFactory = new ActiveMQConnectionFactory("vm://localhost");
		return JmsComponent.jmsComponentAutoAcknowledge(connectionFactory);
	}
}
