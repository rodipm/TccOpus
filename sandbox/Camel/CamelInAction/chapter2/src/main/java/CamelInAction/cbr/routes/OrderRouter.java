package CamelInAction.cbr.routes;

import org.apache.camel.builder.RouteBuilder;

public class OrderRouter extends RouteBuilder{

	@Override
	public void configure() throws Exception {
		from("file:data/input?delete=true")
		.choice()
			.when(header("CamelFileName").endsWith(".teste"))
				.log("Arquivo ${header.CamelFileName} recebido")
				.to("jms:queue:testeOrders");
	}
	
}
