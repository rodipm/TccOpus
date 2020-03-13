package CamelInAction.MessageFilter.routes;

import org.apache.camel.builder.RouteBuilder;

public class MessageFilterRoute extends RouteBuilder{

	@Override
	public void configure() throws Exception {
        from("file:data/input?delete=true")
        .filter(xpath("/sampleparent[@test='false']"))
        .log("Arquivo passou no filtro ${header.CamelFileName}")
        .to("jms:queue:testeOrders");
	}
	
}
