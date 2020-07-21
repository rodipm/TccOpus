import sys
import os
import zipfile
from io import BytesIO

def preparar_arquivos(artifact_id, group_id):
    pom_file = r"""<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">

<modelVersion>4.0.0</modelVersion>

<groupId>com.opus</groupId>
<artifactId>projetotcc</artifactId>
<packaging>jar</packaging>
<version>1.0-SNAPSHOT</version>

<name>A Camel Route</name>

<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <log4j2-version>2.13.3</log4j2-version>
</properties>

<dependencyManagement>
    <dependencies>
    <!-- Camel BOM -->
    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-bom</artifactId>
        <version>3.4.1</version>
        <scope>import</scope>
        <type>pom</type>
    </dependency>
    </dependencies>
</dependencyManagement>

<dependencies>

    <dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-core</artifactId>
    </dependency>
    <dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-main</artifactId>
    </dependency>

    <!-- logging -->
    <dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-slf4j-impl</artifactId>
    <scope>runtime</scope>
    <version>${log4j2-version}</version>
    </dependency>

    <!-- testing -->
    <dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-test</artifactId>
    <scope>test</scope>
    </dependency>
</dependencies>

<build>
    <defaultGoal>install</defaultGoal>

    <plugins>
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
        <source>1.8</source>
        <target>1.8</target>
        </configuration>
    </plugin>
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-resources-plugin</artifactId>
        <version>3.1.0</version>
        <configuration>
        <encoding>UTF-8</encoding>
        </configuration>
    </plugin>

    <!-- Allows the example to be run via 'mvn camel:run' -->
    <plugin>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-maven-plugin</artifactId>
        <version>3.4.1</version>
        <configuration>
        <logClasspath>true</logClasspath>
        <mainClass>com.opus.LaunchApp</mainClass>
        </configuration>
    </plugin>

    </plugins>
</build>

</project>
    """

    log_properties_file = """
appender.out.type = Console
appender.out.name = out
appender.out.layout.type = PatternLayout
appender.out.layout.pattern = [%30.30t] %-30.30c{1} %-5p %m%n
rootLogger.level = INFO
rootLogger.appenderRef.out.ref = out
    """

    sample_route_file = """package %s.routes;

import org.apache.camel.builder.RouteBuilder;

public class SampleRoute extends RouteBuilder {

    @Override
    public void configure() throws Exception {
        // Define Route Here
    }
    
}
    """ % (artifact_id)

    launch_app_file = """package %s;

import org.apache.camel.main.Main;
import %s.routes.SampleRoute;

public class LaunchApp {

    public static void main(String[] args) throws Exception {
        Main main = new Main();
        main.configure().addRoutesBuilder(new SampleRoute());
        main.run(args);
    }
}
    """ % (artifact_id, artifact_id)

    return pom_file, log_properties_file, sample_route_file, launch_app_file

def gerar_projeto(artifact_id, group_id):
    pom_file, log_properties_file, sample_route_file, launch_app_file = preparar_arquivos(
        artifact_id, group_id)

    artifact_id_sep_path = artifact_id.split(".")

    # Gera o arquivo
    # zipf = zipfile.ZipFile('IntegrationProject.zip', 'w', zipfile.ZIP_DEFLATED)
    # mem_zip = BytesIO()
    # with zipfile.ZipFile(mem_zip, 'w', zipfile.ZIP_DEFLATED) as zipf:
    with zipfile.ZipFile('IntegrationProject.zip', 'w', zipfile.ZIP_DEFLATED) as zipf:
        zipf.writestr("pom.xml", pom_file)
        zipf.writestr(os.path.join("src", "main", "resources",
                                "log4j2.properties"), log_properties_file)
        zipf.writestr(os.path.join("src", "main", "java", *
                                   artifact_id_sep_path, "LaunchApp.java"), launch_app_file)
        zipf.writestr(os.path.join("src", "main", "java", *artifact_id_sep_path,
                                "routes", "SampleRoute.java"), sample_route_file)
        zipf.close()
    # mem_zip.seek(0)

    gerar_projeto("br.com.opus", "projetoAutomatico")

