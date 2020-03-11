# Camel

## Estudos e testes com o framework

Seguindo o livro Camel In Action (Claus Ibsen) os projetos e conceitos são feitos e armazenados neste diretório.


## Conexão FTP
> ftp://site.com/path?username=name&password=pass
```xml
<!-- Camel-FTP-->
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-ftp</artifactId>
</dependency>
```


## Active MQ
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
</dependency>
```

### Obs

Instalado o ActiveMQ na maquina em C:\src\ActiveMQ\apache-activemq-5.15.11, para roda-lo basta navegar para esta pasta e executar `bin\activemq start` : 

+ URL: http://127.0.0.1:8161/admin/
+ Login: admin
+ Passwort: admin

Para conectar via ActiveMQConnectionFactory para "tcp://localhost:61616"
