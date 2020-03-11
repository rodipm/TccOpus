package CamelInAction.FirstChapter;

import javax.jms.ConnectionFactory;

import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.jms.JmsComponent;
import org.apache.camel.impl.DefaultCamelContext;

public class FtpToJmsExample {
	public static void main(String[] args) throws Exception {
		CamelContext context = new DefaultCamelContext();
		
		ConnectionFactory connectionFactory = new ActiveMQConnectionFactory("tcp://localhost:61616");
		context.addComponent("jms", JmsComponent.jmsComponentAutoAcknowledge(connectionFactory));
		
		context.addRoutes(new RouteBuilder() {
			
			@Override
			public void configure() throws Exception {
				// from("ftp://rider.com/orders?username=rider&password=secret")
				// Nao pode ser consumido pois nao é um servidor de fato
				from("file:data/input?noop=true") // Substituido por uma entrada em texto
				.log("Arquivo movido para a fila incomingOrders no ActiveMQ")
				.to("jms:queue:incomingOrders");
			}
		});
		
		context.start();
		Thread.sleep(5000);
		context.stop();
		context.close();
	}
}
