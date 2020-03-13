package CamelInAction.MessageFilter;

import javax.jms.ConnectionFactory;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.camel.component.jms.JmsComponent;
import org.apache.camel.main.Main;

import CamelInAction.MessageFilter.routes.MessageFilterRoute;


public class LaunchApp {

	public static void main(String[] args) throws Exception {
		Main main = new Main();
		main.bind("jms", setupConnectionFactory());
		main.addRoutesBuilder(new MessageFilterRoute());
		main.run();
	}

    public static JmsComponent setupConnectionFactory() {
		ConnectionFactory connectionFactory = new ActiveMQConnectionFactory("tcp://localhost:61616");
		return JmsComponent.jmsComponentAutoAcknowledge(connectionFactory);
    }
    
}
