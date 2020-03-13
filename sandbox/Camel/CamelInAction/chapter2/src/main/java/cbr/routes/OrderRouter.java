package cbr.routes;

import javax.jms.ConnectionFactory;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.jms.JmsComponent;
import org.apache.camel.impl.DefaultCamelContext;

public class OrderRouter extends RouteBuilder{

	@Override
	public void configure() throws Exception {
		from("file:data/input?noop=true")
		.choice()
			.when(header("CamelFileName").endsWith(".teste"))
				.log("Recebida mensagem .teste")
				.to("file:outputTeste");
//				.to("jms:queue:testeOrders");
		
	}
	
//	public static void main(String[] args) throws Exception {
//	
//		CamelContext camelContext = new DefaultCamelContext();
//		
////		ConnectionFactory connectionFactory = new ActiveMQConnectionFactory("tcp://localhost:61616");
//		ConnectionFactory connectionFactory = new ActiveMQConnectionFactory("vm://localhost");
//		camelContext.addComponent("jms", JmsComponent.jmsComponentAutoAcknowledge(connectionFactory));
//
//		camelContext.addRoutes(new RouteBuilder() {
//			
//			@Override
//			public void configure() throws Exception {
//				from("file:data/input?noop=true")
//				.choice()
//					.when(header("CamelFileName").endsWith(".teste"))
//						.log("Recebida mensagem .teste")
//						.to("jms:queue:testeOrders");
//
//			}
//		});
//		
//		camelContext.start();
//		Thread.sleep(60000);
//		camelContext.stop();
//		camelContext.close();
//	}

	
}
