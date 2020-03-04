package com.opus.learning.camel;

import org.apache.camel.builder.RouteBuilder;

public class LearningCamelTest {
    RouteBuilder builder = new RouteBuilder() {
        @Override
        public void configure() throws Exception {
            from("file:data/input?noop=true")
                    .to("file:data/output");
        }
    };
}
