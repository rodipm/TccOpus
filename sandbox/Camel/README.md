# Camel

## Estudos e testes com o framework

Seguindo o livro Camel In Action (Claus Ibsen) os projetos e conceitos são feitos e armazenados neste diretório.

## Executar via Maven

Deve ter as configurações corretas no pom.xml para o LaunchApp

> mvn exec:java

## Componentes

### Conexão FTP
> ftp://site.com/path?username=name&password=pass
```xml
<!-- Camel-FTP-->
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-ftp</artifactId>
</dependency>
```


### Active MQ
> jms:queue:queueName
```java
import javax.jms.ConnectionFactory;
import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.camel.component.jms.JmsComponent;

ConnectionFactory connectionFactory = new ActiveMQConnectionFactory("vm://localhost");
context.addComponent("jms", JmsComponent.jmsComponentAutoAcknowledge(connectionFactory));
```

```xml
<!-- ActiveMQ-JMS-->
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-jms</artifactId>
</dependency>
<dependency>
    <groupId>org.apache.activemq</groupId>
    <artifactId>activemq-all</artifactId>
    <version>5.12.2</version> <!-- utiliza essa versao para evitar erros de configuração dos logs-->
</dependency>
```

#### Obs

Instalado o ActiveMQ na maquina em C:\src\ActiveMQ\apache-activemq-5.15.11, para roda-lo basta navegar para esta pasta e executar `bin\activemq start` : 

+ URL: http://127.0.0.1:8161/admin/
+ Login: admin
+ Passwort: admin

Para conectar via ActiveMQConnectionFactory para "tcp://localhost:61616"


## EIP

### Content-Based Router

Seleciona a rota a ser seguida baseado nos conteúdos da mensagem. Formado na DSL java pelos comandos
+ choice()
+ when()
+ stop()
+ end()

```
from("...")
		.choice()
            .when(predicado)
                .to("...")
			.when(predicado)
				.to("...")
            .otherwise()
                .to("...").stop() // para aqui caso encontre
        .end() // finaliza o bloco .choice()
        .to(....);
```

Exemplos predicados:
+ header("CamelFileName").endWith(".txt")
+ header("CamelFileName").regex("...")

### Message Filter

Aplica filtros às mensagens para selecionar apenas as que sejam interessantes para a aplicação
+ filter()

Utiliza xpath, simple e etc, para verificações em arquivos XML.

```
from("...")
.filter(condition)
.to("...")
```

### Multicast

Utilizado para distribuir uma mensagem para mais de um endpoint
+ multicast()
+ parallelProcessing() // Habilida mulitcasting paralelo
+ stopOnException()

```
from("...")
.multicast()
.stopOnException()
.to("...", "...")
```