package com.tccopus.TccOpus.routes;

import org.apache.camel.builder.RouteBuilder;

public class SampleRoute extends RouteBuilder {

	@Override
	public void configure() throws Exception {
		from("file:data/input?delete=true")
		.to("file:data/output")
	}
	
}
