package CamelInAction.FirstRide;

import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.impl.DefaultCamelContext;

public class MainApp {
	
	public static void main(String[] args) throws Exception {
		CamelContext context = new DefaultCamelContext();
		
		context.addRoutes(new RouteBuilder() {
			@Override
			public void configure() throws Exception {
				from("file:data/input?noop=true")
				.log("File before transformation: ${body}. Headers: ${headers}")
				.transform(body().regexReplaceAll("(?i)sample", "Amazing"))
				.log("File after transformation: ${body}")
				.to("file:data/output");
			}
		});
		
		context.start();
		Thread.sleep(10000);
		context.stop();
		context.close();
	}
}

